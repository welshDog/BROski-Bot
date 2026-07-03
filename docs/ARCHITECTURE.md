# 🏛️ BROski-Bot Architecture

Deep-dive into the system design of BROski-Bot v3.0.

## 📊 High-Level Overview

```
┌───────────────────┐
│   Discord User     │
└────────┬─────────┘
         │
         v
┌────────┴─────────┐
│   Bot Core (bot.py)│ ─ Main entry point
└────────┬─────────┘
         │
    ┌────┼────┐
    v         v
┌──────────┐ ┌───────────┐
│   Cogs    │ │  Database  │
│ (Modules) │ │  (SQLite)  │
└────┬─────┘ └───────────┘
     │
     v
┌──────────┐
│ AI Agent  │ ─ llmcord/Ollama
└──────────┘
```

## 📦 Directory Structure

```
BROski-Bot/
├── src/
│   ├── bot.py              # Main bot entry point
│   ├── cogs/               # Feature modules (Cogs)
│   │   ├── economy.py      # Token economy system
│   │   ├── focus_engine.py # Pomodoro focus sessions
│   │   ├── quests.py       # Quest system
│   │   └── self_learning.py # AI feedback collection
│   ├── models/             # Data models
│   │   ├── user.py
│   │   └── transaction.py
│   └── utils/              # Helper functions
│       ├── database.py
│       └── logger.py
├── tests/                  # Test suite
├── scripts/                # Automation scripts
├── data/                   # Runtime data
│   ├── training/           # AI training data
│   └── models/             # Saved AI models
└── docs/                   # Documentation
```

## 🧱 Core Components

### 1. Bot Core (`bot.py`)

**Responsibilities**:
- Initialize Discord client
- Load cogs (modules)
- Handle events (on_ready, on_message, etc.)
- Manage database connections

**Key Code**:
```python
class BROskiBot(commands.Bot):
    def __init__(self):
        intents = discord.Intents.all()
        super().__init__(command_prefix="/", intents=intents)

    async def setup_hook(self):
        # Load all cogs
        await self.load_extension("src.cogs.economy")
        await self.load_extension("src.cogs.focus_engine")
        # ...
```

### 2. Cogs (Modules)

Cogs are modular feature containers. Each cog is independent.

**Example: Economy Cog**
```python
class Economy(commands.Cog):
    @commands.hybrid_command()
    async def balance(self, ctx, user: discord.Member = None):
        # Check balance logic
        pass
```

**Available Cogs**:
- **economy.py**: Token balance, daily rewards, gifts, leaderboards
- **focus_engine.py**: Pomodoro timers, hyperfocus tracking
- **quests.py**: Challenge system, achievements
- **self_learning.py**: User feedback collection for AI training

### 3. Database Layer

**Technology**: SQLite3 (aiosqlite for async)

**Schema**:

```sql
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    balance INTEGER DEFAULT 0,
    xp INTEGER DEFAULT 0,
    streak_days INTEGER DEFAULT 0,
    last_daily TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    amount INTEGER,
    type TEXT,  -- 'daily', 'focus', 'quest', 'gift'
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE focus_sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    project TEXT,
    duration INTEGER,  -- minutes
    reward INTEGER,
    started_at TEXT,
    ended_at TEXT
);
```

### 4. AI Integration

**Technology**: llmcord (Ollama) or OpenAI API

**Use Cases**:
- Natural language commands
- Quest generation
- User feedback analysis (self-learning)

**Flow**:
```
User message → llmcord → Ollama/OpenAI → Response → Discord
```

## 🧠 Self-Learning System

### Data Collection

1. User rates bot response: `/feedback 5 "Great!"`
2. Feedback saved to `data/training/feedback.json`
3. Includes: rating, comment, bot response, user message

### Training Pipeline

```
Feedback JSON → Preprocessing → Model Training → Evaluation → Deployment
```

**Trigger**: Manual or automated (GitHub Actions weekly)

### Model Storage

- **Location**: `data/models/`
- **Format**: `.pkl` (pickle) or `.pt` (PyTorch)
- **Versioning**: Timestamped filenames (`model_20260303_120000.pkl`)

## 🔄 Event Flow Examples

### Daily Reward Claim

```
1. User types: /daily
2. Bot checks last claim time (database)
3. If >24h, award tokens + increment streak
4. Update database
5. Send embed confirmation
```

### Focus Session

```
1. User types: /focus "My Project"
2. Bot records start time
3. User works (timer running)
4. User types: /focusend
5. Bot calculates duration
6. Awards tokens (200 base + bonuses)
7. Saves session to database
```

## 🔒 Security Considerations

- **Environment variables**: Never commit `.env` (use `.env.example`)
- **Database**: No PII exposed in logs
- **Rate limiting**: Prevent spam (1 command per 3 seconds per user)
- **Input validation**: Sanitize all user inputs

## 🚀 Scalability

### Current (v3.0)
- **Users**: Up to 10,000 per bot instance
- **Database**: SQLite (single-file)

### Future (v4.0+)
- **Users**: 100,000+
- **Database**: PostgreSQL (distributed)
- **Caching**: Redis for session data
- **Load balancing**: Multiple bot instances

## 📊 Monitoring

**Metrics Tracked** (Prometheus):
- Commands executed per minute
- Response latency
- Active focus sessions
- Token transactions per hour

**Dashboards**: Grafana (view at `http://localhost:3001`)

## 🔧 Development Tools

- **Linting**: Ruff
- **Formatting**: Black
- **Type Checking**: mypy
- **Testing**: pytest
- **CI/CD**: GitHub Actions
- **Deployment**: Docker + systemd

## 📚 Further Reading

- [Discord.py Documentation](https://discordpy.readthedocs.io/)
- [SQLite Async Best Practices](https://aiosqlite.omnilib.dev/)
- [llmcord GitHub](https://github.com/jakobdylanc/llmcord)

---

**Questions? Open an issue or discussion on GitHub! 🐶♾️**
