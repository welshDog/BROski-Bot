# BROski-Bot Setup Script (Windows PowerShell)
Write-Host "🐶♾️ BROski-Bot Setup Script" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

# Check Python version
$pythonVersion = python --version 2>&1
if ($pythonVersion -match "Python 3\.(1[1-9]|[2-9]\d)") {
    Write-Host "✅ Python 3.11+ detected: $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Python 3.11+ required. Install from python.org" -ForegroundColor Red
    exit 1
}

# Install Poetry
if (!(Get-Command poetry -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Installing Poetry..." -ForegroundColor Yellow
    (Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -
    $env:Path += ";$env:APPDATA\Python\Scripts"
    Write-Host "✅ Poetry installed" -ForegroundColor Green
} else {
    Write-Host "✅ Poetry already installed" -ForegroundColor Green
}

# Install dependencies
Write-Host "📥 Installing dependencies..." -ForegroundColor Yellow
poetry install

# Setup .env file
if (!(Test-Path .env)) {
    Write-Host "⚙️ Creating .env file..." -ForegroundColor Yellow
    Copy-Item .env.example .env
    Write-Host "✏️ IMPORTANT: Edit .env and add your DISCORD_TOKEN" -ForegroundColor Yellow
} else {
    Write-Host "✅ .env file already exists" -ForegroundColor Green
}

# Initialize database
Write-Host "🗄️ Initializing database..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path data | Out-Null
try {
    poetry run python -c "from src.utils.database import init_db; init_db()"
    Write-Host "✅ Database initialized" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Database init will run on first bot start" -ForegroundColor Yellow
}

# Install pre-commit hooks
if (Test-Path .pre-commit-config.yaml) {
    Write-Host "🪝 Installing pre-commit hooks..." -ForegroundColor Yellow
    poetry run pre-commit install
    Write-Host "✅ Pre-commit hooks installed" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Edit .env and add your Discord bot token"
Write-Host "  2. Run: poetry run python src/bot.py"
Write-Host "  3. Or use Docker: docker-compose up"
Write-Host ""
Write-Host "BROski`$ earned: 100 tokens for setup! 💰" -ForegroundColor Yellow
Write-Host "🔥 HYPERFOCUS MODE READY 🔥" -ForegroundColor Magenta
