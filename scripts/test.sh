#!/bin/bash
# Run all tests with coverage

set -e

echo "🧪 Running BROski-Bot test suite..."
echo ""

# Run tests with coverage
poetry run pytest tests/ -v --cov=src --cov-report=term --cov-report=html

echo ""
echo "✅ All tests passed!"
echo "📄 Coverage report: htmlcov/index.html"
echo "BROski$ earned: 50 tokens for testing! 💰"
