#!/bin/bash
# Production deployment script

set -e

echo "🚀 BROski-Bot Deployment Script"
echo "=============================="
echo ""

# Check if on main branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" != "main" ]; then
    echo "⚠️ Warning: Not on main branch (currently on $BRANCH)"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Pull latest changes
echo "📥 Pulling latest changes..."
git pull origin main

# Build Docker image
echo "🐳 Building Docker image..."
docker-compose -f docker-compose.prod.yml build

# Stop old container
echo "🛑 Stopping old container..."
docker-compose -f docker-compose.prod.yml down

# Start new container
echo "▶️ Starting new container..."
docker-compose -f docker-compose.prod.yml up -d

# Health check
echo "🩺 Health check..."
sleep 5
if docker ps | grep broski-bot; then
    echo "✅ Deployment successful!"
    echo "🔥 BROski-Bot is now running"
else
    echo "❌ Deployment failed - container not running"
    docker-compose -f docker-compose.prod.yml logs --tail=50
    exit 1
fi

echo ""
echo "View logs: docker-compose -f docker-compose.prod.yml logs -f"
echo "BROski$ earned: 200 tokens for deployment! 💰"
