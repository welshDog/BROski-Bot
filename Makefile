# BROski-Bot Makefile
# Quick commands for common tasks

.PHONY: help install test lint format clean run docker-build docker-up docker-down deploy

help:
	@echo "🐶♾️ BROski-Bot Commands"
	@echo "====================="
	@echo ""
	@echo "make install       - Install dependencies"
	@echo "make test          - Run tests with coverage"
	@echo "make lint          - Run linting (Ruff)"
	@echo "make format        - Format code (Black)"
	@echo "make clean         - Remove build artifacts"
	@echo "make run           - Run the bot"
	@echo "make docker-build  - Build Docker image"
	@echo "make docker-up     - Start Docker containers"
	@echo "make docker-down   - Stop Docker containers"
	@echo "make deploy        - Deploy to production"
	@echo ""

install:
	@echo "📦 Installing dependencies..."
	poetry install --with dev
	@echo "✅ Done!"

test:
	@echo "🧪 Running tests..."
	poetry run pytest tests/ -v --cov=src --cov-report=term --cov-report=html
	@echo "✅ Tests complete! Coverage: htmlcov/index.html"

lint:
	@echo "🔍 Running Ruff linter..."
	poetry run ruff check .
	@echo "✅ Linting complete!"

format:
	@echo "🎨 Formatting code with Black..."
	poetry run black .
	@echo "✅ Formatting complete!"

clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf __pycache__ .pytest_cache .coverage htmlcov/ dist/ build/ *.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Clean complete!"

run:
	@echo "🚀 Starting BROski-Bot..."
	poetry run python bot.py

docker-build:
	@echo "🐳 Building Docker image..."
	docker build -t broski-bot:latest .
	@echo "✅ Build complete!"

docker-up:
	@echo "🚀 Starting Docker containers..."
	docker-compose up -d
	docker-compose logs -f

docker-down:
	@echo "🛑 Stopping Docker containers..."
	docker-compose down
	@echo "✅ Containers stopped!"

deploy:
	@echo "🚀 Deploying to production..."
	bash scripts/deploy.sh
	@echo "✅ Deployment complete!"
