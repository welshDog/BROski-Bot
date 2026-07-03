# 📚 BROski-Bot API Reference

Complete command reference for BROski-Bot v3.0.

## 💰 Economy Commands

### `/balance [@user]`

Check BROski$ token balance.

**Parameters**:
- `user` (optional): Check another user's balance

**Examples**:
```
/balance
/balance @JohnDoe
```

**Response**:
```
💰 Your Balance
BROski$: 1,250
XP: 3,450
Rank: Diamond
Streak: 7 days 🔥
```

---

### `/daily`

Claim daily BROski$ reward.

**Cooldown**: 24 hours

**Rewards**:
- Base: 50 BROski$
- Streak bonus: +10 BROski$ per consecutive day (max 200)

**Examples**:
```
/daily
```

**Response**:
```
🎉 Daily Reward Claimed!
Earned: 120 BROski$ (50 base + 70 streak)
Current Streak: 7 days 🔥
Next claim available in: 23h 45m
```

---

### `/give @user <amount>`

Gift BROski$ to another user.

**Parameters**:
- `user`: Recipient (@mention)
- `amount`: Token amount (min 1, max your balance)

**Examples**:
```
/give @JaneDoe 100
```

**Response**:
```
🎁 Transfer Complete!
You sent 100 BROski$ to @JaneDoe
Your new balance: 950 BROski$
```

---

### `/leaderboard [category]`

View top 10 users by tokens, XP, or streak.

**Parameters**:
- `category` (optional): `tokens`, `xp`, or `streak` (default: tokens)

**Examples**:
```
/leaderboard
/leaderboard xp
/leaderboard streak
```

**Response**:
```
🏆 Top 10 - BROski$ Leaderboard

1️⃣ @Alice - 5,000 BROski$
2️⃣ @Bob - 4,200 BROski$
3️⃣ @Charlie - 3,800 BROski$
...
```

---

## ⏱️ Focus & Productivity Commands

### `/focus <project>`

Start a hyperfocus session (Pomodoro timer).

**Parameters**:
- `project`: Project name/description

**Rewards**:
- Start bonus: 50 BROski$
- End bonus: 200 BROski$ (base) + duration bonuses

**Examples**:
```
/focus "Building BROski-Bot features"
/focus "Learning Python"
```

**Response**:
```
🔥 Hyperfocus Session Started!
Project: Building BROski-Bot features
Start bonus: +50 BROski$

Focus time! Come back and use /focusend when done.
```

---

### `/focusend`

End your active focus session.

**Examples**:
```
/focusend
```

**Response**:
```
✅ Hyperfocus Session Complete!

Project: Building BROski-Bot features
Duration: 45 minutes
Base reward: 200 BROski$
Duration bonus: +90 BROski$ (2x per minute)
Total earned: 290 BROski$

Streak: 3 sessions today 🔥
Keep going, BROski! 🐶♾️
```

---

## 🧠 Self-Learning Commands

### `/feedback <rating> [comment]`

Rate the bot's last response to help it learn.

**Parameters**:
- `rating`: 1-5 stars
- `comment` (optional): Additional feedback

**Rewards**: 10 BROski$ per feedback

**Examples**:
```
/feedback 5
/feedback 4 "Great, but could be faster"
/feedback 2 "Response was unclear"
```

**Response**:
```
✅ Feedback Received!

Thanks BROski♾️! You earned 10 BROski$ 💰

Rating: ⭐⭐⭐⭐⭐
Comment: Great, but could be faster

Your feedback helps me get smarter!
```

---

## 🎯 Quest Commands (Coming Soon)

### `/quests`

View available quests.

### `/quest start <id>`

Start a quest.

### `/achievements`

View unlocked achievements.

---

## ⚙️ Admin Commands

### `/admin give @user <amount>`

**Permission**: Administrator only

Grant BROski$ to a user (bypasses balance checks).

### `/admin reset @user`

**Permission**: Administrator only

Reset a user's balance and stats.

---

## 📊 Response Codes

| Code | Meaning |
|------|----------|
| ✅ | Success |
| ❌ | Error (invalid input) |
| ⚠️ | Warning (cooldown active) |
| 🔒 | Permission denied |
| ⌛ | Processing... |

---

## 🛠️ Rate Limits

- **Standard commands**: 1 per 3 seconds per user
- **Daily claim**: Once per 24 hours
- **Focus sessions**: 1 active session at a time

---

**Need help? Type `/help` in Discord or check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)!**
