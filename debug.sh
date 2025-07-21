#!/bin/bash
# Debug script for secure-api-gateway

echo "🔍 Starting Debug Process..."
echo "================================"

echo "1. Checking Docker status..."
docker --version
docker-compose --version

echo ""
echo "2. Checking if Docker daemon is running..."
docker ps > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Docker is running"
else
    echo "❌ Docker is not running. Please start Docker Desktop."
    echo "   On Windows: Start Docker Desktop application"
    exit 1
fi

echo ""
echo "3. Stopping any existing containers..."
docker-compose down

echo ""
echo "4. Building and starting services..."
docker-compose up -d --build

echo ""
echo "5. Checking service status..."
sleep 10
docker-compose ps

echo ""
echo "6. Checking logs for any errors..."
echo "Kong logs:"
docker-compose logs kong | tail -20

echo ""
echo "Backend API logs:"
docker-compose logs backend-api | tail -20

echo ""
echo "7. Testing endpoints..."
echo "Testing Kong Admin API:"
curl -s http://localhost:8001/status | jq . || echo "Kong Admin not responding"

echo ""
echo "Testing Backend API directly:"
curl -s http://localhost:5000/health | jq . || echo "Backend API not responding"

echo ""
echo "Testing through Kong proxy:"
curl -s http://localhost:8000/public | jq . || echo "Kong proxy not responding"

echo ""
echo "🎯 Debug complete! Check the output above for any issues."
