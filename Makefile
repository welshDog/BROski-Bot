.PHONY: help install test lint format clean run docker-up docker-down

.DEFAULT_GOAL := help

help: ## Show this help message
	@echo '🐶♾️ BROski-Bot Makefile Commands'
	@echo '================================'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies with Poetry
	@echo "📦 Installing dependencies..."
	poetry install
	@echo "✅ Done!"

test: ## Run all tests
	@echo "🧪 Running tests..."
	poetry run pytest tests/ -v --cov=src

lint: ## Run linting (Ruff + Black check)
	@echo "🔍 Running linters..."
	poetry run ruff check .
	poetry run black --check .

format: ## Auto-format code with Black
	@echo "✨ Formatting code..."
	poetry run black .
	poetry run ruff check --fix .
	@echo "✅ Code formatted!"

clean: ## Clean cache and build files
	@echo "🧹 Cleaning..."
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	rm -rf .pytest_cache .coverage htmlcov
	@echo "✅ Cleaned!"

run: ## Run bot locally
	@echo "🚀 Starting BROski-Bot..."
	poetry run python bot.py

docker-up: ## Start Docker containers
	@echo "🐳 Starting Docker containers..."
	docker-compose up -d
	@echo "✅ Containers running!"

docker-down: ## Stop Docker containers
	@echo "🛑 Stopping Docker containers..."
	docker-compose down
	@echo "✅ Containers stopped!"

docker-logs: ## View Docker logs
	docker-compose logs -f broski-bot

db-init: ## Initialize database
	@echo "🗄️ Initializing database..."
	mkdir -p data/training data/models
	poetry run python -c "import sqlite3; conn = sqlite3.connect('broski.db'); conn.execute('CREATE TABLE IF NOT EXISTS users (user_id INTEGER PRIMARY KEY, balance INTEGER DEFAULT 0, xp INTEGER DEFAULT 0, level INTEGER DEFAULT 1)'); conn.commit(); print('✅ Database initialized')"
