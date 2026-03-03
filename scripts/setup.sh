#!/bin/bash
set -e

echo "🐶♾️ BROski-Bot Setup Script"
echo "=============================="
echo ""

# Check Python version
if ! command -v python3.11 &> /dev/null; then
    echo "❌ Python 3.11+ required. Install from python.org"
    exit 1
fi
echo "✅ Python 3.11+ detected"

# Install Poetry
if ! command -v poetry &> /dev/null; then
    echo "📦 Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    export PATH="$HOME/.local/bin:$PATH"
    echo "✅ Poetry installed"
else
    echo "✅ Poetry already installed"
fi

# Create virtual environment and install dependencies
echo ""
echo "📥 Installing dependencies..."
poetry install

# Setup environment file
if [ ! -f .env ]; then
    echo ""
    echo "⚙️ Creating .env file..."
    cp env.example .env
    echo "✏️ IMPORTANT: Edit .env and add your DISCORD_TOKEN"
else
    echo "✅ .env file already exists"
fi

# Initialize database
echo ""
echo "🗄️ Initializing database..."
mkdir -p data/training data/models
poetry run python -c "import sqlite3; conn = sqlite3.connect('broski.db'); conn.execute('CREATE TABLE IF NOT EXISTS users (user_id INTEGER PRIMARY KEY, balance INTEGER DEFAULT 0, xp INTEGER DEFAULT 0, level INTEGER DEFAULT 1)'); conn.commit(); print('✅ Database initialized')"

# Install pre-commit hooks
echo ""
echo "🪧 Installing pre-commit hooks..."
poetry run pre-commit install || echo "⚠️ Pre-commit hooks skipped (install manually later)"

echo ""
echo "============================="
echo "✅ Setup complete!"
echo "============================="
echo ""
echo "Next steps:"
echo "  1. Edit .env and add your Discord bot token"
echo "  2. Run: poetry run python bot.py"
echo "  3. Or use Docker: docker-compose up"
echo ""
echo "💰 BROski$ earned: 100 tokens for setup! 💰"
echo ""
