# PgBouncer Docker Image

A secure Docker image for PgBouncer.

## Features

- 🐧 **Alpine Linux base** - Minimal, secure, and lightweight
- 🔒 **Security hardened** - Non-root user, minimal attack surface
- ⚙️ **Environment-driven configuration** - No config files needed
- 🚀 **Multi-architecture support** - AMD64 and ARM64
- 🔄 **Automated builds** - GitHub Actions with security scanning
- 📊 **Health checks** - Built-in health monitoring
- 🏷️ **Version tagging** - Docker tags match PgBouncer versions

## Quick Start

### Basic Usage

```bash
docker run -d \
  --name pgbouncer \
  -e PGBOUNCER_DB_HOST=postgres.example.com \
  -e PGBOUNCER_DB_USER=myuser \
  -e PGBOUNCER_DB_PASSWORD=mypassword \
  -p 6432:6432 \
  ghcr.io/starttoaster/pgbouncer:latest
```

### With Docker Compose

```yaml
version: '3.8'
services:
  pgbouncer:
    image: ghcr.io/starttoaster/pgbouncer:latest
    environment:
      PGBOUNCER_DB_HOST: postgres
      PGBOUNCER_DB_USER: myuser
      PGBOUNCER_DB_PASSWORD: mypassword
      PGBOUNCER_POOL_MODE: transaction
      PGBOUNCER_MAX_CLIENT_CONN: 100
    ports:
      - "6432:6432"
    depends_on:
      - postgres
```

## Configuration

All configuration is done through environment variables. See [Environment Variables](examples/environment-variables.md) for a complete list.

### Essential Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PGBOUNCER_DB_HOST` | `localhost` | PostgreSQL server hostname |
| `PGBOUNCER_DB_PORT` | `5432` | PostgreSQL server port |
| `PGBOUNCER_DB_NAME` | `postgres` | Default database name |
| `PGBOUNCER_DB_USER` | `postgres` | Database username |
| `PGBOUNCER_DB_PASSWORD` | (empty) | Database password |
| `PGBOUNCER_POOL_MODE` | `session` | Pooling mode (session/transaction/statement) |
| `PGBOUNCER_MAX_CLIENT_CONN` | `100` | Maximum client connections |
| `PGBOUNCER_DEFAULT_POOL_SIZE` | `20` | Default pool size per database |

### Pooling Modes

- **session** (default): One server connection per client connection
- **transaction**: One server connection per transaction
- **statement**: One server connection per statement (most aggressive)

## Examples

### Production Configuration

```bash
docker run -d \
  --name pgbouncer \
  --restart unless-stopped \
  -e PGBOUNCER_DB_HOST=postgres-cluster.internal \
  -e PGBOUNCER_DB_PORT=5432 \
  -e PGBOUNCER_DB_NAME=myapp \
  -e PGBOUNCER_DB_USER=app_user \
  -e PGBOUNCER_DB_PASSWORD=secure_password \
  -e PGBOUNCER_POOL_MODE=transaction \
  -e PGBOUNCER_MAX_CLIENT_CONN=500 \
  -e PGBOUNCER_DEFAULT_POOL_SIZE=50 \
  -e PGBOUNCER_MIN_POOL_SIZE=10 \
  -e PGBOUNCER_RESERVE_POOL_SIZE=10 \
  -e PGBOUNCER_SERVER_LIFETIME=3600 \
  -e PGBOUNCER_SERVER_IDLE_TIMEOUT=600 \
  -e PGBOUNCER_LOG_CONNECTIONS=1 \
  -e PGBOUNCER_LOG_DISCONNECTIONS=1 \
  -e PGBOUNCER_ADMIN_USERS=admin \
  -e PGBOUNCER_STATS_USERS=monitoring \
  -p 6432:6432 \
  ghcr.io/starttoaster/pgbouncer:latest
```

### Kubernetes Deployment

See [kubernetes-deployment.yaml](examples/kubernetes-deployment.yaml) for a complete Kubernetes example.

### Multiple Databases

```bash
docker run -d \
  --name pgbouncer \
  -e PGBOUNCER_DB_HOST=postgres.example.com \
  -e PGBOUNCER_DB_USER=myuser \
  -e PGBOUNCER_DB_PASSWORD=mypassword \
  -e PGBOUNCER_USERLIST="\"user1\" \"md5hash1\"\n\"user2\" \"md5hash2\"" \
  -p 6432:6432 \
  ghcr.io/starttoaster/pgbouncer:latest
```

## Security

### Security Features

- **Non-root user**: Runs as `pgbouncer` user (UID 1000)
- **Minimal base image**: Alpine Linux with only necessary packages
- **Security scanning**: Automated vulnerability scanning with Trivy
- **Read-only filesystem**: Configuration files are generated at runtime
- **No shell access**: Container runs without shell access

### Best Practices

1. **Use secrets management** for database passwords
2. **Enable TLS** for encrypted connections
3. **Restrict network access** to necessary ports only
4. **Regular updates** - New images are built for each PgBouncer release
5. **Monitor logs** for suspicious activity

### TLS Configuration

```bash
docker run -d \
  --name pgbouncer \
  -e PGBOUNCER_DB_HOST=postgres.example.com \
  -e PGBOUNCER_DB_USER=myuser \
  -e PGBOUNCER_DB_PASSWORD=mypassword \
  -e PGBOUNCER_TLS_CERT_FILE=/etc/ssl/certs/server.crt \
  -e PGBOUNCER_TLS_KEY_FILE=/etc/ssl/private/server.key \
  -e PGBOUNCER_TLS_CA_FILE=/etc/ssl/certs/ca.crt \
  -v /path/to/certs:/etc/ssl/certs:ro \
  -v /path/to/private:/etc/ssl/private:ro \
  -p 6432:6432 \
  ghcr.io/starttoaster/pgbouncer:latest
```

## Monitoring

### Health Checks

The container includes built-in health checks:

```bash
# Check container health
docker inspect --format='{{.State.Health.Status}}' pgbouncer

# View health check logs
docker inspect --format='{{range .State.Health.Log}}{{.Output}}{{end}}' pgbouncer
```

### Admin Interface

Connect to the admin interface for monitoring:

```bash
# Connect to admin interface
psql -h localhost -p 6432 -U admin pgbouncer

# Show statistics
SHOW STATS;

# Show pools
SHOW POOLS;

# Show clients
SHOW CLIENTS;
```

### Logging

Logs are written to `/var/log/pgbouncer/pgbouncer.log` inside the container:

```bash
# View logs
docker logs pgbouncer

# Follow logs
docker logs -f pgbouncer
```

## Development

### Building Locally

```bash
# Build the image
docker build -t pgbouncer:local .

# Run locally
docker run -d \
  --name pgbouncer-local \
  -e PGBOUNCER_DB_HOST=localhost \
  -e PGBOUNCER_DB_USER=postgres \
  -e PGBOUNCER_DB_PASSWORD=password \
  -p 6432:6432 \
  pgbouncer:local
```

### Testing

```bash
# Test connection
pg_isready -h localhost -p 6432

# Test with psql
psql -h localhost -p 6432 -U postgres -d postgres
```

## Versioning

Docker image tags correspond to PgBouncer versions:

- `latest` - Latest stable version
- `1.21.0` - Specific PgBouncer version
- `1.21` - Major.minor version
- `1` - Major version only

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📖 [Documentation](examples/)
- 🐛 [Issue Tracker](https://github.com/starttoaster/pgbouncer/issues)
- 💬 [Discussions](https://github.com/starttoaster/pgbouncer/discussions)

## Changelog

### v1.21.0
- Initial release with PgBouncer 1.21.0
- Alpine Linux 3.19 base image
- Environment variable configuration
- Multi-architecture support
- Security hardening
- Automated builds and security scanning
