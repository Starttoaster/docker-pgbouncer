# PgBouncer Environment Variables

This document lists all available environment variables for configuring the PgBouncer Docker image.

## Database Connection

| Variable | Default | Description |
|----------|---------|-------------|
| `PGBOUNCER_DB_HOST` | `localhost` | PostgreSQL server hostname |
| `PGBOUNCER_DB_PORT` | `5432` | PostgreSQL server port |
| `PGBOUNCER_DB_NAME` | `postgres` | Default database name |
| `PGBOUNCER_DB_USER` | `postgres` | Database username |
| `PGBOUNCER_DB_PASSWORD` | (empty) | Database password |

## PgBouncer Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `PGBOUNCER_LISTEN_ADDR` | `0.0.0.0` | Address to listen on |
| `PGBOUNCER_LISTEN_PORT` | `6432` | Port to listen on |
| `PGBOUNCER_POOL_MODE` | `session` | Pooling mode (session, transaction, statement) |
| `PGBOUNCER_MAX_CLIENT_CONN` | `100` | Maximum client connections |
| `PGBOUNCER_DEFAULT_POOL_SIZE` | `20` | Default pool size per database |
| `PGBOUNCER_MIN_POOL_SIZE` | `0` | Minimum pool size per database |
| `PGBOUNCER_RESERVE_POOL_SIZE` | `0` | Reserve pool size |
| `PGBOUNCER_RESERVE_POOL_TIMEOUT` | `5` | Reserve pool timeout in seconds |
| `PGBOUNCER_MAX_DB_CONNECTIONS` | `0` | Maximum connections per database (0 = unlimited) |
| `PGBOUNCER_MAX_USER_CONNECTIONS` | `0` | Maximum connections per user (0 = unlimited) |
| `PGBOUNCER_SERVER_ROUND_ROBIN` | `0` | Enable round-robin server selection |
| `PGBOUNCER_IGNORE_STARTUP_PARAMETERS` | `extra_float_digits` | Parameters to ignore |
| `PGBOUNCER_DISABLE_PQEXEC` | `0` | Disable PQexec |
| `PGBOUNCER_APPLICATION_NAME_ADD_HOST` | `1` | Add host to application name |

## Authentication

| Variable | Default | Description |
|----------|---------|-------------|
| `PGBOUNCER_AUTH_TYPE` | `md5` | Authentication type (md5, plain, scram-sha-256, cert, hba, pam) |
| `PGBOUNCER_AUTH_FILE` | `/etc/pgbouncer/userlist.txt` | Path to userlist file |
| `PGBOUNCER_AUTH_QUERY` | (empty) | Query to get user information |
| `PGBOUNCER_USERLIST` | (empty) | Userlist content (overrides auth_file) |

## Logging

| Variable | Default | Description |
|----------|---------|-------------|
| `PGBOUNCER_LOG_CONNECTIONS` | `1` | Log connections (0/1) |
| `PGBOUNCER_LOG_DISCONNECTIONS` | `1` | Log disconnections (0/1) |
| `PGBOUNCER_LOG_POOLER_ERRORS` | `1` | Log pooler errors (0/1) |
| `PGBOUNCER_LOGFILE` | `/var/log/pgbouncer/pgbouncer.log` | Log file path |
| `PGBOUNCER_PIDFILE` | `/var/run/pgbouncer/pgbouncer.pid` | PID file path |

## Timeouts

| Variable | Default | Description |
|----------|---------|-------------|
| `PGBOUNCER_SERVER_LIFETIME` | `3600` | Server lifetime in seconds |
| `PGBOUNCER_SERVER_IDLE_TIMEOUT` | `600` | Server idle timeout in seconds |
| `PGBOUNCER_SERVER_CONNECT_TIMEOUT` | `15` | Server connect timeout in seconds |
| `PGBOUNCER_SERVER_LOGIN_RETRY` | `15` | Server login retry delay in seconds |
| `PGBOUNCER_QUERY_TIMEOUT` | `0` | Query timeout in seconds (0 = disabled) |
| `PGBOUNCER_QUERY_WAIT_TIMEOUT` | `120` | Query wait timeout in seconds |
| `PGBOUNCER_CLIENT_IDLE_TIMEOUT` | `0` | Client idle timeout in seconds (0 = disabled) |
| `PGBOUNCER_CLIENT_LOGIN_TIMEOUT` | `60` | Client login timeout in seconds |
| `PGBOUNCER_AUTODB_IDLE_TIMEOUT` | `3600` | Auto-database idle timeout in seconds |

## DNS Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `PGBOUNCER_DNS_NXDOMAIN_TTL` | `15` | DNS NXDOMAIN TTL in seconds |
| `PGBOUNCER_DNS_ZONE_CHECK_PERIOD` | `0` | DNS zone check period in seconds |
| `PGBOUNCER_DNS_MAX_TTL` | `0` | Maximum DNS TTL in seconds |

## TLS Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `PGBOUNCER_TLS_CERT_FILE` | (empty) | TLS certificate file path |
| `PGBOUNCER_TLS_KEY_FILE` | (empty) | TLS private key file path |
| `PGBOUNCER_TLS_CA_FILE` | (empty) | TLS CA certificate file path |
| `PGBOUNCER_TLS_PROTOCOLS` | `secure` | Allowed TLS protocols |
| `PGBOUNCER_TLS_CIPHERS` | `fast` | TLS cipher suite |
| `PGBOUNCER_TLS_ECDHCURVE` | `auto` | ECDH curve |
| `PGBOUNCER_TLS_DHEPARAMS` | `auto` | DHE parameters |

## Example Usage

```bash
docker run -d \
  --name pgbouncer \
  -e PGBOUNCER_DB_HOST=postgres.example.com \
  -e PGBOUNCER_DB_PORT=5432 \
  -e PGBOUNCER_DB_NAME=myapp \
  -e PGBOUNCER_DB_USER=myuser \
  -e PGBOUNCER_DB_PASSWORD=mypassword \
  -e PGBOUNCER_POOL_MODE=transaction \
  -e PGBOUNCER_MAX_CLIENT_CONN=200 \
  -e PGBOUNCER_DEFAULT_POOL_SIZE=50 \
  -p 6432:6432 \
  ghcr.io/starttoaster/pgbouncer:latest
```
