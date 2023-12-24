# CozyToes Website COSC 304 Project

## Initial Steps

1. Setup your local development environment ([instructions here](setup/)). 

NOTE: **SQL Server is not supported on the Apple M1 chip.** However, there is an alternate version that is. In the `docker-compose.yml` file, change:
`image: mcr.microsoft.com/mssql/server:2019-latest` to this: `image: mcr.microsoft.com/azure-sql-edge` .
