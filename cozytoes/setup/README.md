# CozyToes - Local Setup

This will setup a development environment using Docker on your computer.

## Steps

1. Open a command line window and navigate to the directory of `CozyToes`

2. Type the following command in your terminal and press enter:

    ```
    docker-compose up -d
    ```

    This will setup the JSP runtime and Microsoft SQL server on your system. Please note that you will need at least 500MB of space on your hard drive.

3. Create the tables and load the sample data into your SQL Server database.  The file `WebContent/loaddata.jsp` will load the database using the `WebContent/ddl/SQLServer_orderdb.ddl` script. You can run this file by using the URL: [http://localhost/shop/loaddata.jsp](http://localhost/shop/loaddata.jsp).

4. Open your preferred web browser and navigate to the following URL: [http://localhost/shop/index.jsp](http://localhost/shop/index.jsp). If all went well with the above steps, you should see the shop opening page.

## Shutting Down the Development Server

Press `Ctrl + C` in the terminal instance that you ran `docker-compose up` in.

## Credits
COSC 304 WT1 2023 - Dr. Ramon Lawrence