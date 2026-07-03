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
echo "📥 Installing dependencies..."
poetry install

# Setup environment file
if [ ! -f .env ]; then
    echo "⚙️ Creating .env file..."
    cp .env.example .env
    echo "✏️ IMPORTANT: Edit .env and add your DISCORD_TOKEN"
else
    echo "✅ .env file already exists"
fi

# Initialize database
echo "🗄️ Initializing database..."
mkdir -p data
poetry run python -c "from src.utils.database import init_db; init_db()" 2>/dev/null || echo "⚠️ Database init will run on first bot start"

# Install pre-commit hooks
if [ -f .pre-commit-config.yaml ]; then
    echo "🪝 Installing pre-commit hooks..."
    poetry run pre-commit install
    echo "✅ Pre-commit hooks installed"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Edit .env and add your Discord bot token"
echo "  2. Run: poetry run python src/bot.py"
echo "  3. Or use Docker: docker-compose up"
echo ""
echo "BROski$ earned: 100 tokens for setup! 💰"
echo "🔥 HYPERFOCUS MODE READY 🔥"
