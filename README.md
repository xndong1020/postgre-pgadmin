1. Dockerfile-postgresql will create a custom image, and run init db scripts when it is being built

```Dockerfile
FROM postgres

COPY ./db_scripts/ /docker-entrypoint-initdb.d/

EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
# VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

CMD ["postgres"]

```

Note:
If you updated the database init scripts in ./db_scripts/, remember to rebuild the custom postgresql docker image

2. docker-compose.yml, to run our custom postgresql image, and dpage/pgadmin4:4.25 side by side

```yml
version: "3.7"

services:
  db:
    container_name: my_db
    build:
      context: .
      dockerfile: ./Dockerfile-postgresql
    restart: always
    environment:
      POSTGRES_DB: nicoledb
      POSTGRES_USER: isdance
      POSTGRES_PASSWORD: secret
    ports:
      - "5432:5432"

  pgadmin:
    image: dpage/pgadmin4:4.25
    restart: always
    environment:
      PGADMIN_DEFAULT_EMAIL: test@test.com
      PGADMIN_DEFAULT_PASSWORD: secret
      PGADMIN_LISTEN_PORT: 80
    ports:
      - "80:80"
    volumes:
      - pgadmin-data:/var/lib/pgadmin
    links:
      - "db:pgsql-server"

  redis:
    image: bitnami/redis
    container_name: redis-server
    hostname: redis
    restart: always
    environment:
      ALLOW_EMPTY_PASSWORD: "true"
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/bitnami/redis/data

  redis-commander:
    container_name: redis-commander
    hostname: redis-commander
    image: rediscommander/redis-commander:latest
    restart: always
    environment:
      - REDIS_HOSTS=local:redis:6379
    ports:
      - "8080:8081"

volumes:
  pgadmin-data:
  redis-data:
```

To run

```
docker-compose up -d
```

To stop

```
docker-compose down
```

referece:
[Set up a PostgreSQL server and pgAdmin with Docker](https://linuxhint.com/postgresql_docker/)
