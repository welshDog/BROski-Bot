#!/bin/bash
set -e

echo "🐶♾️ BROski-Bot Auto Setup Script"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Python version
echo "🐍 Checking Python version..."
if ! command -v python3.11 &> /dev/null; then
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}❌ Python 3.11+ required. Install from python.org${NC}"
        exit 1
    fi
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
    if (( $(echo "$PYTHON_VERSION < 3.11" | bc -l) )); then
        echo -e "${RED}❌ Python 3.11+ required. Current: $PYTHON_VERSION${NC}"
        exit 1
    fi
    PYTHON_CMD=python3
else
    PYTHON_CMD=python3.11
fi
echo -e "${GREEN}✅ Python version OK${NC}"

# Install Poetry
if ! command -v poetry &> /dev/null; then
    echo "📦 Installing Poetry..."
    curl -sSL https://install.python-poetry.org | $PYTHON_CMD -
    export PATH="$HOME/.local/bin:$PATH"
    echo -e "${GREEN}✅ Poetry installed${NC}"
else
    echo -e "${GREEN}✅ Poetry already installed${NC}"
fi

# Create virtual environment and install dependencies
echo "📥 Installing dependencies..."
poetry install --with dev
echo -e "${GREEN}✅ Dependencies installed${NC}"

# Setup environment file
if [ ! -f .env ]; then
    echo "⚙️ Creating .env file..."
    cp env.example .env
    echo -e "${YELLOW}✏️  IMPORTANT: Edit .env and add your DISCORD_TOKEN${NC}"
else
    echo -e "${GREEN}✅ .env file already exists${NC}"
fi

# Initialize database
echo "🗄️ Initializing database..."
mkdir -p data/training data/models
touch data/training/feedback.json
echo '[]' > data/training/feedback.json
echo -e "${GREEN}✅ Database directories created${NC}"

# Install pre-commit hooks
if [ -f .pre-commit-config.yaml ]; then
    echo "🪝 Installing pre-commit hooks..."
    poetry run pre-commit install
    echo -e "${GREEN}✅ Pre-commit hooks installed${NC}"
fi

# Final instructions
echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo "🚀 Next steps:"
echo "  1. Edit .env and add your Discord bot token"
echo "     ${YELLOW}nano .env${NC}"
echo ""
echo "  2. Run the bot:"
echo "     ${YELLOW}poetry run python bot.py${NC}"
echo ""
echo "  3. Or use Docker:"
echo "     ${YELLOW}docker-compose up -d${NC}"
echo ""
echo "  4. Run tests:"
echo "     ${YELLOW}poetry run pytest${NC}"
echo ""
echo "💰 BROski$ earned: 100 tokens for setup!"
echo ""