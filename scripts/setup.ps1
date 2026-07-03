# BROski-Bot Windows Setup Script
Write-Host "🐶♾️ BROski-Bot Setup Script" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

# Check Python version
Write-Host "Checking Python version..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    if ($pythonVersion -match "Python 3\.(1[1-9]|[2-9]\d)") {
        Write-Host "✅ $pythonVersion detected" -ForegroundColor Green
    } else {
        Write-Host "❌ Python 3.11+ required. Download from python.org" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Python not found. Install from python.org" -ForegroundColor Red
    exit 1
}

# Install Poetry
Write-Host ""
Write-Host "Checking Poetry installation..." -ForegroundColor Yellow
try {
    poetry --version | Out-Null
    Write-Host "✅ Poetry already installed" -ForegroundColor Green
} catch {
    Write-Host "📦 Installing Poetry..." -ForegroundColor Yellow
    (Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -
    $env:Path += ";$env:APPDATA\Python\Scripts"
    Write-Host "✅ Poetry installed" -ForegroundColor Green
}

# Install dependencies
Write-Host ""
Write-Host "📥 Installing dependencies..." -ForegroundColor Yellow
poetry install

# Setup environment file
Write-Host ""
if (!(Test-Path .env)) {
    Write-Host "⚙️ Creating .env file..." -ForegroundColor Yellow
    Copy-Item env.example .env
    Write-Host "✏️ IMPORTANT: Edit .env and add your DISCORD_TOKEN" -ForegroundColor Magenta
} else {
    Write-Host "✅ .env file already exists" -ForegroundColor Green
}

# Initialize database
Write-Host ""
Write-Host "🗄️ Initializing database..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path data\training, data\models | Out-Null
poetry run python -c "import sqlite3; conn = sqlite3.connect('broski.db'); conn.execute('CREATE TABLE IF NOT EXISTS users (user_id INTEGER PRIMARY KEY, balance INTEGER DEFAULT 0, xp INTEGER DEFAULT 0, level INTEGER DEFAULT 1)'); conn.commit(); print('✅ Database initialized')"

# Install pre-commit hooks
Write-Host ""
Write-Host "🪧 Installing pre-commit hooks..." -ForegroundColor Yellow
try {
    poetry run pre-commit install
} catch {
    Write-Host "⚠️ Pre-commit hooks skipped (install manually later)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=============================" -ForegroundColor Cyan
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Edit .env and add your Discord bot token"
Write-Host "  2. Run: poetry run python bot.py"
Write-Host "  3. Or use Docker: docker-compose up"
Write-Host ""
Write-Host "💰 BROski$ earned: 100 tokens for setup! 💰" -ForegroundColor Yellow
Write-Host ""
