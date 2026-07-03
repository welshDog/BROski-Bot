# BROski-Bot Makefile
# Quick commands for common tasks

.PHONY: help install test lint format clean docker-build docker-up docker-down deploy

help:
	@echo "🐶♾️ BROski-Bot Makefile Commands"
	@echo "=============================="
	@echo "install       - Install dependencies with Poetry"
	@echo "test          - Run test suite with coverage"
	@echo "lint          - Run linting (Ruff + Black check)"
	@echo "format        - Auto-format code (Black + Ruff fix)"
	@echo "clean         - Remove build artifacts and cache"
	@echo "docker-build  - Build Docker image"
	@echo "docker-up     - Start bot with Docker Compose"
	@echo "docker-down   - Stop Docker containers"
	@echo "deploy        - Deploy to production"
	@echo "train         - Run self-learning training pipeline"

install:
	@echo "📦 Installing dependencies..."
	poetry install
	@echo "✅ Dependencies installed!"

test:
	@echo "🧪 Running tests..."
	poetry run pytest tests/ -v --cov=src --cov-report=term --cov-report=html
	@echo "✅ Tests complete!"

lint:
	@echo "🔍 Linting code..."
	poetry run ruff check src/ tests/
	poetry run black --check src/ tests/
	@echo "✅ Linting complete!"

format:
	@echo "✨ Formatting code..."
	poetry run black src/ tests/
	poetry run ruff check --fix src/ tests/
	@echo "✅ Code formatted!"

clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf __pycache__ .pytest_cache .coverage htmlcov dist build *.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Cleaned!"

docker-build:
	@echo "🐳 Building Docker image..."
	docker-compose build
	@echo "✅ Docker image built!"

docker-up:
	@echo "▶️ Starting BROski-Bot..."
	docker-compose up -d
	@echo "✅ Bot is running! View logs: docker-compose logs -f"

docker-down:
	@echo "🛑 Stopping containers..."
	docker-compose down
	@echo "✅ Containers stopped!"

deploy:
	@echo "🚀 Deploying to production..."
	./scripts/deploy.sh

train:
	@echo "🧠 Running training pipeline..."
	poetry run python scripts/train_agent.py
