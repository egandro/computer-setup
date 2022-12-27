# MSSQL

```
# https://hub.docker.com/_/microsoft-mssql-server

docker pull mcr.microsoft.com/mssql/server:2019-latest

docker run --name mssql \
           -d \
	   -e "ACCEPT_EULA=Y" \
	   -e "MSSQL_SA_PASSWORD=Secret#1234" \
           -p 1433:1433 \
            mcr.microsoft.com/mssql/server:2019-latest


docker exec -it mssql \
	   /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Secret#1234

--------
docker-compose.yaml:

#https://github.com/microsoft/mssql-docker/issues/668#issuecomment-812530180
version: "3.9"
services:
  mssql:
    image: mcr.microsoft.com/mssql/server:2019-latest
    container_name: mssql
    volumes:
      - events_mssql:/var/opt/mssql
      - ./setup.sql:/usr/config/setup.sql
    ports:
      - 1433:1433
    environment:
      - ACCEPT_EULA=Y
      - MSSQL_SA_PASSWORD=Secret#1234
      - MSSQL_PID=Developer
      - MSSQL_DB=mydb
      - MSSQL_USER=myuser
      - MSSQL_PASSWORD=Secret#1234
      - MSSQL_DB_AUDIT_LOG=events_service_audit_log

volumes:
  events_mssql:
------
setup.sql
CREATE DATABASE $(MSSQL_DB);
CREATE DATABASE $(MSSQL_DB_AUDIT_LOG);
GO
USE $(MSSQL_DB);
GO
CREATE LOGIN $(MSSQL_USER) WITH PASSWORD = '$(MSSQL_PASSWORD)';
GO
CREATE USER $(MSSQL_USER) FOR LOGIN $(MSSQL_USER);
GO
ALTER SERVER ROLE sysadmin ADD MEMBER [$(MSSQL_USER)];
GO
------
Makefile:
up:
        docker-compose up -d

tail:
        docker-compose logs -f mssql

down:
        docker-compose down -v

```
