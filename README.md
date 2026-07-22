# 🤖 BROski Bot v4.0

> 🟢 ACTIVE — Part of the [WelshDog Toolbox](https://github.com/welshDog/HyperFocus-Zone-Portal#-everyday-toolbox) | [HyperFocus Zone](https://github.com/welshDog/HyperFocus-Zone-Portal)

[![Python 3.11+](https://img.shields.io/badge/python-3.11+-blue.svg)](https://www.python.org/)
[![discord.py](https://img.shields.io/badge/discord.py-2.x-5865F2)](https://discordpy.readthedocs.io/)
[![FastAPI](https://img.shields.io/badge/FastAPI-economy_API-green)](https://fastapi.tiangolo.com/)
[![Docker](https://img.shields.io/badge/docker-ready-blue)](https://www.docker.com/)
[![Built in Wales](https://img.shields.io/badge/Built%20in-Wales%20🏴-red)](https://github.com/welshDog)

> *Your ADHD-first Discord companion. Ride or die. BROski♾️*

---

## 🥔 Who this is for

**You, if any of these are true:**
- You have a Discord server and your community needs structure + fun without it feeling corporate
- You’re neurodivergent (ADHD/dyslexic/autistic) and need external dopamine hits to stay on task
- You want a token economy that rewards real activity — focus sessions, daily check-ins, missions
- You want hyperfocus tracking, leaderboards, and achievements that actually mean something

BROski Bot is the community companion for Hyperfocus Zone — built specifically for ND brains.

---

## ⚡ One-Command Run

```bash
# Clone and install
git clone https://github.com/welshDog/BROski-Bot.git
cd BROski-Bot
pip install poetry && poetry install

# Configure
cp .env.example .env
# Add: DISCORD_TOKEN, DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD

# Run database migrations
poetry run alembic upgrade head

# Launch the bot
python -m src.main run
```

**Docker (recommended for servers):**
```bash
docker-compose up -d
docker-compose logs -f broski-bot
```

---

## 🖥️ What you see when it works

```
[Discord] /focus deep-work
→ BROski: 🔥 Hyperfocus session ACTIVATED! Focus on: deep-work
           Timer started. Type /focusend when done. You got this BROski! ⚡

[30 mins later...]
/focusend
→ BROski: 🏆 SESSION COMPLETE! +200 BROski$ + 50XP earned!
           Streak: 3 days 🔥 | Level: BROski Agent (250/500 XP)

/leaderboard
→ 🏆 Top BROskis This Week:
   1. WelshDog — 1,250 coins | Level 5 Commander
   2. ...
```

---

## 🎮 Commands

### 💰 Economy
| Command | What it does |
|---|---|
| `/balance [@user]` | Check BROski$ coin balance |
| `/daily` | Claim daily reward (streak bonus!) |
| `/give @user amount` | Gift coins to a BROski |
| `/leaderboard` | Top earners this week |

### ⏱️ Focus & Productivity
| Command | What it does |
|---|---|
| `/focus [project]` | Start hyperfocus session (+50 coins on start) |
| `/focusend` | End session (+200 coins base reward!) |

### 🎯 Quests & Achievements
| Command | What it does |
|---|---|
| `/quests` | View active quests |
| `/achievements` | Your unlocked achievements |

---

## 💰 BROski$ Economy

| Action | Coins | XP |
|---|---|---|
| Daily login | +5 | — |
| Start focus session | +50 | — |
| End focus session | +200 | +100 |
| Complete a quest | varies | varies |
| Unlock achievement | varies | varies |

**Levels:** Recruit → Cadet → Agent → Operator → Commander → Architect → **Legend ♾️**

---

## 🔗 How it connects to Hyperfocus Zone

| Connection | Detail |
|---|---|
| 💜 PostgreSQL | BROski$ economy runs on the same Postgres stack as HyperCode-V2.4 |
| 🏢 FastAPI | REST API at `:8000` — economy endpoints usable by any HyperFocus agent |
| 📊 Prometheus | Bot metrics exported for Grafana observability dashboard |
| 🤖 HyperCode-V2.4 | BROski$ awards flow from the core `/economy/award-dev-xp` endpoint |
| 💬 Community | The official BROski Discord server runs this bot | 
| 🏠 Ecosystem | Part of the WelshDog Toolbox — [HyperFocus Zone Portal](https://github.com/welshDog/HyperFocus-Zone-Portal) |

---

## 🛠️ Tech Stack

- **Runtime:** Python 3.11+
- **Bot Framework:** discord.py 2.x
- **API:** FastAPI + SQLAlchemy + AsyncPG
- **Database:** PostgreSQL (managed by Alembic)
- **Monitoring:** Prometheus + Grafana
- **Deps:** Poetry

---

<div align="center">

**Part of the WelshDog Toolbox — Built with 🧠 + ❤️ in Llanelli, Wales 🏴󠁧󠁢󠁷󠁬󠁳󠁥**

*by [@welshDog](https://github.com/welshDog) — Lyndz Williams*

[🊪 Back to HyperFocus Zone Portal](https://github.com/welshDog/HyperFocus-Zone-Portal) · [💙 Sponsor](https://github.com/sponsors/welshDog) · [🛒 Shop](https://welshdog.shop)

</div>
