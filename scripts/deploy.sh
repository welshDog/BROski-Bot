#!/bin/bash
# Production deployment script

set -e

echo "🚀 BROski-Bot Production Deployment"
echo "===================================="
echo ""

# Pull latest changes
echo "📥 Pulling latest changes..."
git pull origin main

# Backup database
echo "💾 Backing up database..."
cp broski.db broski.db.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true

# Rebuild Docker containers
echo "🐳 Rebuilding Docker containers..."
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml build --no-cache
docker-compose -f docker-compose.prod.yml up -d

# Wait for startup
echo "⏳ Waiting for bot to start..."
sleep 5

# Check status
echo "🔍 Checking container status..."
docker-compose -f docker-compose.prod.yml ps

# Show logs
echo ""
echo "📜 Recent logs:"
docker-compose -f docker-compose.prod.yml logs --tail=20

echo ""
echo "✅ Deployment complete!"
echo "💰 BROski$ earned: 200 tokens for successful deployment!"
