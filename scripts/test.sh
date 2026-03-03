#!/bin/bash
# Run all tests with coverage

set -e

echo "🧪 Running BROski-Bot test suite..."
echo ""

poetry run pytest tests/ -v \
    --cov=src \
    --cov-report=term \
    --cov-report=html \
    --cov-report=xml

echo ""
echo "✅ Tests complete!"
echo "📊 Coverage report: htmlcov/index.html"
