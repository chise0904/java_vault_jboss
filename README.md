# JBoss Demo Project

A standard JBoss/WildFly demo application that demonstrates environment variable access via REST API.

## 📋 Features

- **Standard JBoss Project Structure**: Follows Jakarta EE 10 conventions
- **REST API**: JAX-RS endpoints to display environment variables
- **DevContainer Support**: Full development environment in VS Code
- **Docker Compose Deployment**: Easy deployment to WildFly 26.1.3
- **Environment Variables**: Custom environment variable injection and display

## 🏗️ Project Structure

```
jboss-demo/
├── .devcontainer/               # VS Code DevContainer configuration
│   ├── devcontainer.json
│   └── docker-compose.yml
├── src/
│   └── main/
│       ├── java/
│       │   └── com/example/jboss/
│       │       ├── config/
│       │       │   └── JaxrsApplication.java    # JAX-RS configuration
│       │       ├── model/
│       │       │   └── EnvironmentVariable.java # Data model
│       │       └── rest/
│       │           └── EnvironmentResource.java # REST endpoints
│       └── webapp/
│           ├── WEB-INF/
│           │   └── beans.xml                    # CDI configuration
│           └── index.html                       # Welcome page
├── pom.xml                      # Maven configuration
├── docker-compose.yml           # Docker Compose for deployment
├── Dockerfile                   # Multi-stage Docker build
├── build.sh                     # Build script
├── deploy.sh                    # Deployment script
└── README.md                    # This file
```

## 🚀 Quick Start

### Option 1: Using DevContainer (Recommended)

1. **Open in VS Code**:
   ```bash
   code .
   ```

2. **Reopen in Container**:
   - Press `F1` or `Cmd+Shift+P`
   - Select "Dev Containers: Reopen in Container"
   - Wait for the container to build

3. **Build the project** (inside DevContainer):
   ```bash
   mvn clean package
   ```

4. **Deploy** (from your host machine):
   ```bash
   ./deploy.sh
   ```

### Option 2: Local Development

1. **Prerequisites**:
   - JDK 17
   - Maven 3.6+
   - Docker and Docker Compose

2. **Build**:
   ```bash
   ./build.sh
   # or
   mvn clean package
   ```

3. **Deploy**:
   ```bash
   ./deploy.sh
   # or
   docker-compose up -d
   ```

## 📡 API Endpoints

Once deployed, access these endpoints:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/jboss-demo/` | GET | Homepage with API documentation |
| `/jboss-demo/api/environment/health` | GET | Health check endpoint |
| `/jboss-demo/api/environment/all` | GET | Get all environment variables (JSON) |
| `/jboss-demo/api/environment/custom` | GET | Get custom environment variables (JSON) |
| `/jboss-demo/api/environment/smart` | GET | Smart config reading with fallback strategies |
| `/jboss-demo/api/environment/methods` | GET | Compare different reading methods |

### Example Requests

```bash
# Health check
curl http://localhost:8080/jboss-demo/api/environment/health

# Get all environment variables
curl http://localhost:8080/jboss-demo/api/environment/all | jq

# Get custom environment variables
curl http://localhost:8080/jboss-demo/api/environment/custom | jq
```

## 🔧 Configuration

### Environment Variables

There are **multiple ways** to configure environment variables in JBoss/WildFly:

#### Method 1: docker-compose.yml (Current approach - Recommended for containers)

Custom environment variables are defined in [docker-compose.yml](docker-compose.yml):

```yaml
environment:
  - APP_NAME=JBoss Demo Application
  - APP_VERSION=1.0.0
  - APP_ENVIRONMENT=production
  - DATABASE_URL=jdbc:postgresql://localhost:5432/demodb
  - API_KEY=demo-api-key-12345
```

#### Method 2: standalone.conf (Traditional JBoss/WildFly approach)

For traditional deployments, you can use `bin/standalone.conf`:

```bash
# In wildfly-config/standalone.conf
export APP_NAME="JBoss Demo Application"
export APP_VERSION="1.0.0"

# Or using System Properties
JAVA_OPTS="$JAVA_OPTS -DAPP_NAME='JBoss Demo Application'"
```

To use standalone.conf with Docker:
1. Uncomment the volume mount in `docker-compose.yml`:
   ```yaml
   volumes:
     - ./wildfly-config/standalone.conf:/opt/jboss/wildfly/bin/standalone.conf
   ```
2. Edit `wildfly-config/standalone.conf`
3. Redeploy: `docker-compose down && docker-compose up -d`

**📖 Detailed Guide**: See [STANDALONE_CONF說明.md](STANDALONE_CONF說明.md) for complete documentation.

#### Adding New Variables

1. Edit `docker-compose.yml` or `wildfly-config/standalone.conf`
2. Add variables to the appropriate section
3. Optionally update `EnvironmentResource.java` to display them
4. Rebuild and redeploy

## 🛠️ Development

### Build WAR file

```bash
mvn clean package
```

The WAR file will be created at: `target/jboss-demo.war`

### Run Tests

```bash
mvn test
```

### Clean Build

```bash
mvn clean
```

## 🐳 Docker Commands

### Start Application

```bash
docker-compose up -d
```

### View Logs

```bash
docker-compose logs -f
```

### Stop Application

```bash
docker-compose down
```

### Rebuild and Deploy

```bash
mvn clean package && docker-compose up -d --force-recreate
```

## 📦 Building with Dockerfile

Alternative deployment using multi-stage Dockerfile:

```bash
# Build image
docker build -t jboss-demo:latest .

# Run container
docker run -d \
  -p 8080:8080 \
  -p 9990:9990 \
  -e APP_NAME="My App" \
  -e APP_VERSION="2.0.0" \
  --name jboss-demo \
  jboss-demo:latest
```

## 🔍 Troubleshooting

### Port Already in Use

If port 8080 is already in use:

1. Stop the conflicting service
2. Or change the port in `docker-compose.yml`:
   ```yaml
   ports:
     - "8081:8080"  # Use 8081 instead
   ```

### WAR File Not Found

```bash
# Rebuild the project
mvn clean package

# Verify WAR file exists
ls -lh target/jboss-demo.war
```

### Container Won't Start

```bash
# Check logs
docker-compose logs

# Remove old containers
docker-compose down -v

# Rebuild
docker-compose up -d --force-recreate
```

## 🏷️ Technology Stack

- **Jakarta EE 10**: Enterprise Java standard
- **JAX-RS**: RESTful web services
- **CDI**: Contexts and Dependency Injection
- **WildFly 26.1.3**: Application server
- **JDK 17**: Java runtime
- **Maven**: Build tool
- **Docker**: Containerization

## 📝 License

This is a demo project for educational purposes.

## 🤝 Contributing

This is a demo project. Feel free to fork and modify for your needs.

## 📧 Support

For issues or questions, please check the troubleshooting section above.
