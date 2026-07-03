# BROski-Bot Windows Setup Script
# Run with: .\scripts\setup.ps1

Write-Host "🐶♾️ BROski-Bot Auto Setup Script" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check Python version
Write-Host "🐍 Checking Python version..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    if ($pythonVersion -match "Python (\d+\.\d+)") {
        $version = [version]$matches[1]
        if ($version -lt [version]"3.11") {
            Write-Host "❌ Python 3.11+ required. Current: $pythonVersion" -ForegroundColor Red
            Write-Host "Download from: https://www.python.org/downloads/" -ForegroundColor Yellow
            exit 1
        }
    }
    Write-Host "✅ Python version OK" -ForegroundColor Green
} catch {
    Write-Host "❌ Python not found. Install from python.org" -ForegroundColor Red
    exit 1
}

# Install Poetry
Write-Host "📦 Checking Poetry installation..." -ForegroundColor Yellow
try {
    poetry --version | Out-Null
    Write-Host "✅ Poetry already installed" -ForegroundColor Green
} catch {
    Write-Host "📥 Installing Poetry..." -ForegroundColor Yellow
    (Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -
    $env:Path += ";$env:APPDATA\Python\Scripts"
    Write-Host "✅ Poetry installed" -ForegroundColor Green
}

# Install dependencies
Write-Host "📥 Installing dependencies..." -ForegroundColor Yellow
poetry install --with dev
Write-Host "✅ Dependencies installed" -ForegroundColor Green

# Setup environment file
if (-not (Test-Path .env)) {
    Write-Host "⚙️ Creating .env file..." -ForegroundColor Yellow
    Copy-Item env.example .env
    Write-Host "✏️  IMPORTANT: Edit .env and add your DISCORD_TOKEN" -ForegroundColor Yellow
} else {
    Write-Host "✅ .env file already exists" -ForegroundColor Green
}

# Initialize database directories
Write-Host "🗄️ Initializing database..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path data/training, data/models | Out-Null
'[]' | Out-File -FilePath data/training/feedback.json -Encoding UTF8
Write-Host "✅ Database directories created" -ForegroundColor Green

# Install pre-commit hooks
if (Test-Path .pre-commit-config.yaml) {
    Write-Host "🪝 Installing pre-commit hooks..." -ForegroundColor Yellow
    poetry run pre-commit install
    Write-Host "✅ Pre-commit hooks installed" -ForegroundColor Green
}

# Final instructions
Write-Host ""
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Next steps:" -ForegroundColor Cyan
Write-Host "  1. Edit .env and add your Discord bot token"
Write-Host "     notepad .env" -ForegroundColor Yellow
Write-Host ""
Write-Host "  2. Run the bot:"
Write-Host "     poetry run python bot.py" -ForegroundColor Yellow
Write-Host ""
Write-Host "  3. Or use Docker:"
Write-Host "     docker-compose up -d" -ForegroundColor Yellow
Write-Host ""
Write-Host "  4. Run tests:"
Write-Host "     poetry run pytest" -ForegroundColor Yellow
Write-Host ""
Write-Host "💰 BROski$ earned: 100 tokens for setup!" -ForegroundColor Magenta
Write-Host ""