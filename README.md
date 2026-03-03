# 🐶♾️ BROski Bot v3.0 - The Legendary Edition

**Neurodivergent-friendly Discord automation empire** built with Python & discord.py

---

## ✨ Features

- 💰 **Token Economy** - BROski$ rewards, daily streaks, leaderboards
- ⏱️ **Focus Sessions** - Pomodoro timer with hyperfocus bonuses (+200 tokens!)
- 🎯 **Quest System** - Treasure hunts, challenges, achievements
- 🤖 **AI Integration** - Natural language commands via llmcord
- 🏆 **Leveling System** - XP, ranks, auto role assignment
- 💎 **Memory Crystals** - Epic rewards (500+ tokens)
- 🔗 **MintMe Integration** - Real blockchain BROski token airdrops

---

## 🚀 Quick Start (5 Minutes)

### 1. Clone & Setup
```bash
git clone https://github.com/welshDog/BROski-Bot.git
cd BROski-Bot
python3.11 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 2. Configuration
```bash
cp .env.example .env
# Edit .env with your Discord bot token
```

### 3. Run
```bash
python bot.py
```

---

## 📋 Commands

### 💰 Economy
- `/balance [@user]` - Check token balance
- `/daily` - Claim daily reward (streak bonus!)
- `/give @user amount` - Gift tokens
- `/leaderboard [tokens|xp|streak]` - Top 10 rankings

### ⏱️ Focus & Productivity
- `/focus project` - Start hyperfocus session (+50 tokens)
- `/focusend` - End session (+200 tokens base reward!)

### 🎯 Quests (Coming Soon)
- `/quests` - View active quests
- `/achievements` - Your unlocked achievements

---

## 🐳 Docker Deployment

```bash
docker-compose up -d
docker-compose logs -f broski-bot
```

---

## 🛠️ Tech Stack

- **Runtime:** Python 3.11+
- **Bot Framework:** discord.py 2.x (hybrid commands)
- **Database:** SQLite3 (aiosqlite)
- **AI:** llmcord + Ollama (local) / OpenAI
- **Deployment:** Docker + systemd
- **Monitoring:** Prometheus + Grafana

---

## 📊 Architecture

```
Discord → Bot Core → Cog Modules → Database
                  ↓
              AI Relay → Agent Army
                  ↓
            MintMe API → Blockchain
```

---

## 🧠 Built for Neurodivergent Developers

This bot is specifically designed with ADHD and dyslexia in mind:

- ✅ Clear visual feedback with embeds
- ✅ Quick wins and dopamine rewards
- ✅ Streak systems for motivation
- ✅ Hyperfocus session tracking
- ✅ No walls of text - bite-sized info

---

## 👨‍💻 Author

**Lyndz Williams** (@welshDog)  
Welsh Indie Developer | Llanelli, Wales 🏴󠁧󠁢󠁷󠁬󠁳󠁿  
Building accessible AI tools for neurodivergent creators

---

## 📝 License

MIT License - Built with 🧠 and ♾️

---

**HYPERFOCUS MODE ACTIVATED** 🔥🐶
