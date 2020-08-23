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

volumes:
  pgadmin-data:
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
