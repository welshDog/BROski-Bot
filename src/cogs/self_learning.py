"""
Self-Learning Agent Module
Collects user feedback and enables model retraining for better responses
"""
import discord
from discord.ext import commands, tasks
import json
from pathlib import Path
from datetime import datetime
import aiosqlite
import logging

logger = logging.getLogger(__name__)


class SelfLearning(commands.Cog):
    """Self-learning feedback collection and agent improvement system"""

    def __init__(self, bot):
        self.bot = bot
        self.feedback_file = Path("data/training/feedback.json")
        self.feedback_file.parent.mkdir(parents=True, exist_ok=True)
        
        # Initialize feedback file if doesn't exist
        if not self.feedback_file.exists():
            with open(self.feedback_file, 'w') as f:
                json.dump([], f)
        
        self.retrain_check.start()
        logger.info("🧠 Self-Learning module loaded")

    def cog_unload(self):
        self.retrain_check.cancel()

    @commands.hybrid_command(name="feedback")
    async def collect_feedback(self, ctx, rating: int, *, comment: str = None):
        """
        Rate the bot's last response (1-5 stars)
        
        Example: /feedback 5 Great help with focus session!
        """
        if not 1 <= rating <= 5:
            await ctx.send("❌ Rating must be 1-5 stars", ephemeral=True)
            return

        # Get last bot message from history
        last_response = "Unknown"
        async for msg in ctx.channel.history(limit=20):
            if msg.author == self.bot.user and msg.content:
                last_response = msg.content[:500]  # Truncate long messages
                break

        # Save feedback
        feedback = {
            "timestamp": datetime.utcnow().isoformat(),
            "user_id": str(ctx.author.id),  # Convert to string for privacy
            "rating": rating,
            "comment": comment,
            "bot_response": last_response,
            "user_message": ctx.message.content[:500],
            "channel_id": str(ctx.channel.id),
            "guild_id": str(ctx.guild.id) if ctx.guild else None,
        }

        self._save_feedback(feedback)

        # Reward user with BROski$
        async with aiosqlite.connect("broski.db") as db:
            await db.execute(
                "UPDATE users SET balance = balance + ? WHERE user_id = ?",
                (10, ctx.author.id),
            )
            await db.commit()

        # Send confirmation embed
        embed = discord.Embed(
            title="✅ Feedback Received!",
            description=f"Thanks BROski♾️! You earned **10 BROski$** 💰",
            color=discord.Color.green(),
        )
        embed.add_field(name="Rating", value="⭐" * rating, inline=False)
        if comment:
            embed.add_field(name="Comment", value=comment[:100], inline=False)
        embed.set_footer(text="Your feedback helps the bot learn and improve!")

        await ctx.send(embed=embed)
        logger.info(f"📝 Feedback received: {rating} stars from {ctx.author}")

    @commands.hybrid_command(name="feedback_stats")
    async def feedback_stats(self, ctx):
        """View feedback statistics and training progress"""
        try:
            with open(self.feedback_file) as f:
                feedback_data = json.load(f)
        except (FileNotFoundError, json.JSONDecodeError):
            await ctx.send("📭 No feedback data available yet.", ephemeral=True)
            return

        total = len(feedback_data)
        if total == 0:
            await ctx.send("📭 No feedback submitted yet. Use `/feedback` to help improve the bot!", ephemeral=True)
            return

        # Calculate statistics
        ratings = [f["rating"] for f in feedback_data]
        avg_rating = sum(ratings) / len(ratings)
        rating_counts = {i: ratings.count(i) for i in range(1, 6)}

        embed = discord.Embed(
            title="📊 Self-Learning Statistics",
            description="Community feedback helps BROski-Bot improve!",
            color=discord.Color.blue(),
        )
        embed.add_field(name="Total Feedback", value=f"{total} entries", inline=True)
        embed.add_field(name="Average Rating", value=f"{avg_rating:.2f} ⭐", inline=True)
        embed.add_field(
            name="Training Progress",
            value=f"{min(total, 100)}/100 (Next retraining at 100)",
            inline=True,
        )

        # Rating distribution
        rating_dist = "\n".join(
            [f"{i}⭐: {rating_counts.get(i, 0)} ({rating_counts.get(i, 0)/total*100:.1f}%)" for i in range(5, 0, -1)]
        )
        embed.add_field(name="Rating Distribution", value=rating_dist, inline=False)

        if total >= 100:
            embed.add_field(
                name="🔥 Ready for Retraining!",
                value="The bot will learn from your feedback soon.",
                inline=False,
            )

        await ctx.send(embed=embed)

    def _save_feedback(self, feedback):
        """Append feedback to JSON file"""
        try:
            with open(self.feedback_file) as f:
                existing = json.load(f)
        except (FileNotFoundError, json.JSONDecodeError):
            existing = []

        existing.append(feedback)

        with open(self.feedback_file, "w") as f:
            json.dump(existing, f, indent=2)

    @tasks.loop(hours=24)
    async def retrain_check(self):
        """Check if enough feedback collected for retraining (100+ entries)"""
        try:
            with open(self.feedback_file) as f:
                feedback = json.load(f)

            count = len(feedback)
            if count >= 100 and count % 100 == 0:  # Every 100 entries
                logger.info(f"🔥 {count} feedback entries collected. Ready for retraining!")
                # Here you could trigger a webhook to GitHub Actions
                # or send notification to admin channel
        except Exception as e:
            logger.error(f"Error checking feedback: {e}")

    @retrain_check.before_loop
    async def before_retrain_check(self):
        await self.bot.wait_until_ready()


async def setup(bot):
    await bot.add_cog(SelfLearning(bot))
