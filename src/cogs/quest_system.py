import discord
from discord import app_commands
from discord.ext import commands
import aiosqlite
from datetime import datetime
import logging
import random

logger = logging.getLogger(__name__)

class QuestSystem(commands.Cog):
    """Quest and achievement system for BROski Bot."""
    
    def __init__(self, bot: commands.Bot):
        self.bot = bot
        self.db_path = 'database/broski_main.db'
    
    async def cog_load(self):
        """Initialize quest database tables."""
        async with aiosqlite.connect(self.db_path) as db:
            # Quests table
            await db.execute('''
                CREATE TABLE IF NOT EXISTS quests (
                    quest_id INTEGER PRIMARY KEY AUTOINCREMENT,
                    title TEXT NOT NULL,
                    description TEXT,
                    reward INTEGER DEFAULT 100,
                    difficulty TEXT DEFAULT 'easy',
                    quest_type TEXT DEFAULT 'daily',
                    requirement INTEGER DEFAULT 1,
                    active BOOLEAN DEFAULT 1
                )
            ''')
            
            # User quests progress
            await db.execute('''
                CREATE TABLE IF NOT EXISTS user_quests (
                    user_id INTEGER,
                    quest_id INTEGER,
                    started_at TEXT,
                    completed_at TEXT,
                    progress INTEGER DEFAULT 0,
                    status TEXT DEFAULT 'active',
                    PRIMARY KEY (user_id, quest_id)
                )
            ''')
            
            # Achievements
            await db.execute('''
                CREATE TABLE IF NOT EXISTS achievements (
                    achievement_id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT NOT NULL,
                    description TEXT,
                    icon TEXT DEFAULT '🏆',
                    requirement INTEGER DEFAULT 1,
                    reward INTEGER DEFAULT 50,
                    category TEXT DEFAULT 'general'
                )
            ''')
            
            # User achievements
            await db.execute('''
                CREATE TABLE IF NOT EXISTS user_achievements (
                    user_id INTEGER,
                    achievement_id INTEGER,
                    unlocked_at TEXT,
                    PRIMARY KEY (user_id, achievement_id)
                )
            ''')
            
            await db.commit()
            
            # Add starter quests if none exist
            await self.create_starter_quests(db)
            await self.create_starter_achievements(db)
            
            logger.info("Quest system database initialized")
    
    async def create_starter_quests(self, db):
        """Create default quests."""
        async with db.execute('SELECT COUNT(*) FROM quests') as cursor:
            count = (await cursor.fetchone())[0]
        
        if count == 0:
            starter_quests = [
                ("First Steps", "Complete your first focus session", 100, "easy", "tutorial", 1),
                ("Daily Grind", "Claim daily rewards 3 days in a row", 150, "easy", "daily", 3),
                ("Token Collector", "Earn 500 BROski$ tokens", 200, "medium", "economy", 500),
                ("Focus Master", "Complete 5 focus sessions", 250, "medium", "focus", 5),
                ("Generous Soul", "Give tokens to 3 different users", 300, "medium", "social", 3),
                ("Hyperfocus Legend", "Complete a 60-minute focus session", 500, "hard", "focus", 1),
                ("Token Tycoon", "Reach 2000 BROski$ balance", 1000, "hard", "economy", 2000),
            ]
            
            await db.executemany(
                'INSERT INTO quests (title, description, reward, difficulty, quest_type, requirement) VALUES (?, ?, ?, ?, ?, ?)',
                starter_quests
            )
            await db.commit()
            logger.info("Created starter quests")
    
    async def create_starter_achievements(self, db):
        """Create default achievements."""
        async with db.execute('SELECT COUNT(*) FROM achievements') as cursor:
            count = (await cursor.fetchone())[0]
        
        if count == 0:
            starter_achievements = [
                ("First Blood", "Complete your first quest", "🎯", 1, 50, "quests"),
                ("Token Rookie", "Earn your first 100 tokens", "💰", 100, 50, "economy"),
                ("Focus Beginner", "Complete 1 focus session", "⏱️", 1, 50, "focus"),
                ("Social Butterfly", "Give tokens to 5 users", "🦋", 5, 100, "social"),
                ("Daily Warrior", "Claim daily for 7 days straight", "🔥", 7, 150, "daily"),
                ("Quest Hunter", "Complete 10 quests", "🏹", 10, 200, "quests"),
                ("Focus Pro", "Complete 25 focus sessions", "🧠", 25, 300, "focus"),
                ("Token Master", "Reach 5000 tokens", "💎", 5000, 500, "economy"),
                ("Legendary BROski", "Complete all other achievements", "🐶♾️", 8, 1000, "special"),
            ]
            
            await db.executemany(
                'INSERT INTO achievements (name, description, icon, requirement, reward, category) VALUES (?, ?, ?, ?, ?, ?)',
                starter_achievements
            )
            await db.commit()
            logger.info("Created starter achievements")
    
    @app_commands.command(name="quests", description="View available quests")
    async def quests(self, interaction: discord.Interaction):
        """Display available quests."""
        try:
            async with aiosqlite.connect(self.db_path) as db:
                # Get active quests
                async with db.execute(
                    'SELECT quest_id, title, description, reward, difficulty, quest_type FROM quests WHERE active = 1'
                ) as cursor:
                    quests = await cursor.fetchall()
                
                # Get user's quest progress
                async with db.execute(
                    'SELECT quest_id, status, progress FROM user_quests WHERE user_id = ?',
                    (interaction.user.id,)
                ) as cursor:
                    user_quests = {row[0]: (row[1], row[2]) for row in await cursor.fetchall()}
            
            if not quests:
                await interaction.response.send_message(
                    "🎯 No quests available right now! Check back soon!",
                    ephemeral=True
                )
                return
            
            embed = discord.Embed(
                title="🎯 BROski Quests",
                description="Complete quests to earn BROski$ tokens and unlock achievements!",
                color=discord.Color.purple()
            )
            
            difficulty_colors = {
                'easy': '🟢',
                'medium': '🟡',
                'hard': '🔴'
            }
            
            quest_type_icons = {
                'tutorial': '📚',
                'daily': '📅',
                'economy': '💰',
                'focus': '⏱️',
                'social': '👥',
            }
            
            for quest_id, title, desc, reward, difficulty, quest_type in quests:
                status, progress = user_quests.get(quest_id, ('not_started', 0))
                
                status_emoji = {
                    'not_started': '⚪',
                    'active': '🔵',
                    'completed': '✅'
                }.get(status, '⚪')
                
                type_icon = quest_type_icons.get(quest_type, '🎯')
                diff_color = difficulty_colors.get(difficulty, '⚪')
                
                field_name = f"{status_emoji} {diff_color} {type_icon} {title}"
                field_value = f"{desc}\n**Reward:** {reward} BROski$"
                
                if status == 'active' and progress > 0:
                    field_value += f"\n*Progress: {progress}*"
                
                embed.add_field(
                    name=field_name,
                    value=field_value,
                    inline=False
                )
            
            embed.set_footer(text="Use /startquest <id> to begin a quest!")
            
            await interaction.response.send_message(embed=embed)
            logger.info(f"Quests displayed for {interaction.user.name}")
        
        except Exception as e:
            logger.error(f"Quests command failed: {e}")
            await interaction.response.send_message(
                "❌ Failed to load quests. Please try again.",
                ephemeral=True
            )
    
    @app_commands.command(name="achievements", description="View your unlocked achievements")
    async def achievements(self, interaction: discord.Interaction):
        """Display user achievements."""
        try:
            async with aiosqlite.connect(self.db_path) as db:
                # Get unlocked achievements
                async with db.execute('''
                    SELECT a.name, a.description, a.icon, a.reward, ua.unlocked_at
                    FROM achievements a
                    JOIN user_achievements ua ON a.achievement_id = ua.achievement_id
                    WHERE ua.user_id = ?
                    ORDER BY ua.unlocked_at DESC
                ''', (interaction.user.id,)) as cursor:
                    unlocked = await cursor.fetchall()
                
                # Get total achievements
                async with db.execute('SELECT COUNT(*) FROM achievements') as cursor:
                    total = (await cursor.fetchone())[0]
            
            embed = discord.Embed(
                title=f"🏆 {interaction.user.name}'s Achievements",
                description=f"Unlocked: **{len(unlocked)}/{total}**",
                color=discord.Color.gold()
            )
            
            if not unlocked:
                embed.add_field(
                    name="No achievements yet!",
                    value="Complete quests and use focus sessions to unlock them! 🔥",
                    inline=False
                )
            else:
                for name, desc, icon, reward, unlocked_at in unlocked[:10]:  # Show first 10
                    date_str = unlocked_at[:10] if unlocked_at else "Unknown"
                    embed.add_field(
                        name=f"{icon} {name}",
                        value=f"{desc}\n*Unlocked: {date_str}* • +{reward} tokens",
                        inline=False
                    )
                
                if len(unlocked) > 10:
                    embed.set_footer(text=f"Showing 10 of {len(unlocked)} achievements")
            
            await interaction.response.send_message(embed=embed)
            logger.info(f"Achievements displayed for {interaction.user.name}")
        
        except Exception as e:
            logger.error(f"Achievements command failed: {e}")
            await interaction.response.send_message(
                "❌ Failed to load achievements. Please try again.",
                ephemeral=True
            )
    
    @app_commands.command(name="startquest", description="Start a new quest")
    @app_commands.describe(quest_id="The ID of the quest to start (shown in /quests)")
    async def start_quest(self, interaction: discord.Interaction, quest_id: int):
        """Start a quest."""
        try:
            async with aiosqlite.connect(self.db_path) as db:
                # Check if quest exists
                async with db.execute(
                    'SELECT title, reward, description FROM quests WHERE quest_id = ? AND active = 1',
                    (quest_id,)
                ) as cursor:
                    quest = await cursor.fetchone()
                
                if not quest:
                    await interaction.response.send_message(
                        "❌ Quest not found or not available!",
                        ephemeral=True
                    )
                    return
                
                # Check if already started
                async with db.execute(
                    'SELECT status FROM user_quests WHERE user_id = ? AND quest_id = ?',
                    (interaction.user.id, quest_id)
                ) as cursor:
                    existing = await cursor.fetchone()
                
                if existing and existing[0] == 'completed':
                    await interaction.response.send_message(
                        "✅ You've already completed this quest!",
                        ephemeral=True
                    )
                    return
                
                if existing and existing[0] == 'active':
                    await interaction.response.send_message(
                        "🔵 This quest is already active!",
                        ephemeral=True
                    )
                    return
                
                # Start quest for user
                await db.execute('''
                    INSERT OR REPLACE INTO user_quests (user_id, quest_id, started_at, status, progress)
                    VALUES (?, ?, ?, 'active', 0)
                ''', (interaction.user.id, quest_id, datetime.utcnow().isoformat()))
                await db.commit()
            
            title, reward, desc = quest
            
            embed = discord.Embed(
                title="🎯 Quest Started!",
                description=f"**{title}**\n{desc}",
                color=discord.Color.green()
            )
            embed.add_field(name="💰 Reward", value=f"{reward} BROski$", inline=True)
            embed.set_footer(text="Good luck, BROski♾! 🔥")
            
            await interaction.response.send_message(embed=embed)
            logger.info(f"{interaction.user.name} started quest {quest_id}")
        
        except Exception as e:
            logger.error(f"Start quest failed: {e}")
            await interaction.response.send_message(
                "❌ Failed to start quest. Please try again.",
                ephemeral=True
            )
    
    @app_commands.command(name="completequest", description="Mark a quest as complete (for testing)")
    @app_commands.describe(quest_id="Quest ID to complete")
    async def complete_quest(self, interaction: discord.Interaction, quest_id: int):
        """Complete a quest (testing/manual completion)."""
        try:
            async with aiosqlite.connect(self.db_path) as db:
                # Get quest info
                async with db.execute(
                    'SELECT title, reward FROM quests WHERE quest_id = ?',
                    (quest_id,)
                ) as cursor:
                    quest = await cursor.fetchone()
                
                if not quest:
                    await interaction.response.send_message("❌ Quest not found!", ephemeral=True)
                    return
                
                title, reward = quest
                
                # Mark as completed
                await db.execute('''
                    INSERT OR REPLACE INTO user_quests (user_id, quest_id, started_at, completed_at, status)
                    VALUES (?, ?, COALESCE((SELECT started_at FROM user_quests WHERE user_id = ? AND quest_id = ?), ?), ?, 'completed')
                ''', (interaction.user.id, quest_id, interaction.user.id, quest_id, datetime.utcnow().isoformat(), datetime.utcnow().isoformat()))
                
                # Add reward tokens
                await db.execute(
                    'UPDATE users SET balance = balance + ? WHERE user_id = ?',
                    (reward, interaction.user.id)
                )
                await db.commit()
            
            embed = discord.Embed(
                title="🎉 Quest Completed!",
                description=f"**{title}**\nYou earned **{reward} BROski$**!",
                color=discord.Color.gold()
            )
            
            await interaction.response.send_message(embed=embed)
            logger.info(f"{interaction.user.name} completed quest {quest_id}")
        
        except Exception as e:
            logger.error(f"Complete quest failed: {e}")
            await interaction.response.send_message(
                "❌ Failed to complete quest.",
                ephemeral=True
            )

async def setup(bot: commands.Bot):
    """Add quest system cog to bot."""
    await bot.add_cog(QuestSystem(bot))
