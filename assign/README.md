# CozyToes Website COSC 304 Project

## Initial Steps

1. Setup your local development environment ([instructions](setup/)). 

2. Create the tables and load the sample data into your SQL Server database.  The file `WebContent/loaddata.jsp` will load the database using the `WebContent/ddl/SQLServer_orderdb.ddl` script. You can run this file by using the URL: `http://localhost/shop/loaddata.jsp`.

3. **SQL Server is not supported on the Apple M1 chip.** However, there is an alternate version that is. In the `docker-compose.yml` file, change:
`image: mcr.microsoft.com/mssql/server:2019-latest` to this: `image: mcr.microsoft.com/azure-sql-edge` .
