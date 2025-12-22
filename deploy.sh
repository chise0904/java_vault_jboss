#!/bin/bash

# JBoss Demo Project Deployment Script
# This script deploys the application to WildFly using Docker Compose

set -e

echo "=========================================="
echo "Deploying JBoss Demo to WildFly"
echo "=========================================="

# Check if WAR file exists
if [ ! -f "target/jboss-demo.war" ]; then
    echo "❌ WAR file not found. Please run ./build.sh first."
    exit 1
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose down

# Start WildFly with the application
echo "🚀 Starting WildFly container..."
docker-compose up -d

# Wait for WildFly to start
echo "⏳ Waiting for WildFly to start..."
sleep 15

# Check if container is running
if docker ps | grep -q jboss-demo-wildfly; then
    echo "✅ Deployment successful!"
    echo ""
    echo "📍 Application URLs:"
    echo "   Homepage:     http://localhost:8080/jboss-demo"
    echo "   Health Check: http://localhost:8080/jboss-demo/api/environment/health"
    echo "   All Env Vars: http://localhost:8080/jboss-demo/api/environment/all"
    echo "   Custom Vars:  http://localhost:8080/jboss-demo/api/environment/custom"
    echo ""
    echo "📊 View logs: docker-compose logs -f"
    echo "🛑 Stop app:  docker-compose down"
else
    echo "❌ Deployment failed. Check logs with: docker-compose logs"
    exit 1
fi
