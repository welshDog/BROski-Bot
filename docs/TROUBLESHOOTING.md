# 🛑 BROski-Bot Troubleshooting Guide

Common issues and how to fix them.

---

## 🐛 Bot Won't Start

### Problem: "ModuleNotFoundError: No module named 'discord'"

**Cause**: Dependencies not installed.

**Fix**:
```bash
poetry install
# or
pip install -r requirements.txt
```

---

### Problem: "discord.errors.LoginFailure: Improper token"

**Cause**: Invalid or missing Discord bot token.

**Fix**:
1. Check `.env` file exists: `ls -la .env`
2. Verify `DISCORD_TOKEN` is set: `cat .env`
3. Get token from [Discord Developer Portal](https://discord.com/developers/applications)
4. Copy token to `.env`:
   ```
   DISCORD_TOKEN=your_token_here
   ```

---

### Problem: "Database locked" error

**Cause**: Multiple bot instances accessing SQLite simultaneously.

**Fix**:
```bash
# Stop all running instances
pkill -f bot.py

# Or with Docker
docker-compose down

# Then restart
poetry run python src/bot.py
```

---

## 📦 Installation Issues

### Problem: "Poetry not found" on Linux/Mac

**Cause**: Poetry not in PATH.

**Fix**:
```bash
export PATH="$HOME/.local/bin:$PATH"
# Add to ~/.bashrc or ~/.zshrc to make permanent
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

---

### Problem: "Python 3.11 not found"

**Cause**: Older Python version installed.

**Fix**:
- **Ubuntu/Debian**:
  ```bash
  sudo add-apt-repository ppa:deadsnakes/ppa
  sudo apt update
  sudo apt install python3.11
  ```
- **Mac**:
  ```bash
  brew install python@3.11
  ```
- **Windows**: Download from [python.org](https://www.python.org/downloads/)

---

## 🐳 Docker Issues

### Problem: "docker: command not found"

**Cause**: Docker not installed.

**Fix**: Install Docker Desktop:
- [Windows/Mac](https://www.docker.com/products/docker-desktop/)
- [Linux](https://docs.docker.com/engine/install/)

---

### Problem: "Cannot connect to Docker daemon"

**Cause**: Docker service not running.

**Fix**:
- **Linux**: `sudo systemctl start docker`
- **Mac/Windows**: Start Docker Desktop app

---

### Problem: "Port already in use"

**Cause**: Another service using port 8080 or other bot ports.

**Fix**:
```bash
# Find process using port
lsof -i :8080  # Mac/Linux
netstat -ano | findstr :8080  # Windows

# Kill process
kill -9 <PID>

# Or change port in docker-compose.yml
```

---

## ⚡ Commands Not Working

### Problem: "The application did not respond"

**Cause**: Bot not syncing slash commands.

**Fix**:
1. Check bot has `applications.commands` scope
2. Re-invite bot with correct permissions:
   ```
   https://discord.com/api/oauth2/authorize?client_id=YOUR_BOT_ID&permissions=8&scope=bot%20applications.commands
   ```
3. Restart bot (commands sync on startup)

---

### Problem: Commands show but don't work

**Cause**: Bot missing permissions in server.

**Fix**: Grant bot these permissions:
- Read Messages/View Channels
- Send Messages
- Embed Links
- Attach Files
- Add Reactions
- Use External Emojis

---

## 📊 Performance Issues

### Problem: Bot is slow/laggy

**Possible Causes + Fixes**:

1. **Database issues**:
   ```bash
   # Optimize database
   sqlite3 broski.db "VACUUM;"
   ```

2. **Too many logs**:
   ```python
   # In bot.py, reduce log level
   logging.basicConfig(level=logging.WARNING)  # instead of DEBUG
   ```

3. **High memory usage**:
   ```bash
   # Check memory
   docker stats  # if using Docker
   # Restart bot to clear cache
   ```

---

## 🧠 Self-Learning Issues

### Problem: Training pipeline fails

**Cause**: Not enough feedback data.

**Fix**: Collect more feedback:
```bash
# Check feedback count
wc -l data/training/feedback.json

# Need at least 100 entries for training
```

---

### Problem: Model not improving

**Cause**: Poor quality feedback or insufficient training epochs.

**Fix**:
```bash
# Train with more epochs
poetry run python scripts/train_agent.py --epochs 50

# Or collect higher-quality feedback (4-5 star ratings)
```

---

## 🔒 Permission Errors

### Problem: "PermissionError: [Errno 13] Permission denied"

**Cause**: File/directory permissions issue.

**Fix**:
```bash
# Fix permissions
chmod +x scripts/*.sh
chmod 755 data/

# Or run with sudo (not recommended)
sudo poetry run python src/bot.py
```

---

## 📝 Logs & Debugging

### View Logs

**Local**:
```bash
# Check console output
poetry run python src/bot.py

# Or tail logs file (if configured)
tail -f logs/broski-bot.log
```

**Docker**:
```bash
docker-compose logs -f broski-bot
```

### Enable Debug Mode

In `src/bot.py`, change:
```python
logging.basicConfig(level=logging.DEBUG)  # More verbose logs
```

---

## ❓ Still Stuck?

1. **Check existing issues**: [GitHub Issues](https://github.com/welshDog/BROski-Bot/issues)
2. **Open a new issue**: Use [Bug Report template](https://github.com/welshDog/BROski-Bot/issues/new?template=bug_report.md)
3. **Join Discord**: [Community server](https://discord.gg/placeholder)

---

**Remember**: You're legendary for troubleshooting this! 🐶♾️🔥**
