#!/bin/bash

# JBoss Demo Project Build Script
# This script builds the WAR file using Maven

set -e

echo "=========================================="
echo "Building JBoss Demo Project"
echo "=========================================="

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven is not installed. Please install Maven first."
    exit 1
fi

# Clean and build
echo "🔨 Cleaning previous builds..."
mvn clean

echo "📦 Building WAR file..."
mvn package

# Check if build was successful
if [ -f "target/jboss-demo.war" ]; then
    echo "✅ Build successful!"
    echo "📁 WAR file location: target/jboss-demo.war"
    echo ""
    echo "Next steps:"
    echo "  1. Run: docker-compose up -d"
    echo "  2. Access: http://localhost:8080/jboss-demo"
    echo "  3. API: http://localhost:8080/jboss-demo/api/environment/all"
else
    echo "❌ Build failed. Please check the errors above."
    exit 1
fi
