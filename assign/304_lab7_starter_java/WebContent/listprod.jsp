<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>CozyToes</title>
<style>
    body {
        font-family: 'Arial', sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f8f8f8;
        color: #333;
    }

    header {
        background-color: #2c3e2a;
        color: #fff;
        text-align: center;
        padding: 1em 0;
    }

    h1 a {
        text-decoration: none;
        color: #fff;
        font-weight: bold;
        font-size: 1.2em;
        transition: color 0.5s ease;
    }

    h1 a:hover {
        color: #FFA500;
        animation: color 0.5s ease;
    }

    nav ul {
        list-style-type: none;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
    }

    nav li {
        margin-right: 20px;
    }

    nav a {
        text-decoration: none;
        color: #fff;
        font-weight: bold;
        font-size: 1.2em;
        transition: color 0.3s ease;
    }

    nav a:hover {
        color: #FFA500;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    table, th, td {
        border: 1px solid #ddd;
    }

    th, td {
        padding: 12px;
        text-align: left;
    }

    tr:nth-child(even) {
        background-color: #f2f2f2;
    }
        
</style>
<header style="display: flex; justify-content: space-between; align-items: center;">
    <h1 style="padding-left: 20px;"><a href="index.jsp">CozyToes</a></h1>
    <nav>
        <ul>
            <li><a href="listprod.jsp">Product Search</a></li>
            <li><a href="listorder.jsp">List Orders</a></li>
            <li><a href="showcart.jsp">Shopping Cart</a></li>
        </ul>
    </nav>
    <div style="padding-right: 20px;">
        <% 
            String userName = (String) session.getAttribute("authenticatedUser");
            if (userName != null)
                out.println("<h3>Hello, " + userName + "</h3>");
        %>
    </div>
</header>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
    <input type="text" name="productName" size="50" placeholder="Product Name">
    
    <!-- Dropdown menu for filtering by category -->
    <select name="categoryId">
        <option value="">All Categories</option>
        <% 
        try {
            // Load driver class
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            // Connection
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String uid = "sa";
            String pw = "304#sa#pw";
            Connection conn = DriverManager.getConnection(url,uid,pw);

            // Query to fetch categories
            String categoryQuery = "SELECT * FROM category";
            PreparedStatement categoryStmt = conn.prepareStatement(categoryQuery);
            ResultSet categoryRs = categoryStmt.executeQuery();

            // Populate dropdown with categories
            while(categoryRs.next()){
                int categoryId = categoryRs.getInt("categoryId");
                String categoryName = categoryRs.getString("categoryName");
                out.println("<option value=\"" + categoryId + "\">" + categoryName + "</option>");
            }

            // Close category-related resources
            categoryRs.close();
            categoryStmt.close();
            
            // Close connection
            conn.close();
        } catch (java.lang.ClassNotFoundException | SQLException e) {
            out.println("Exception: " + e);
        }
        %>
    </select>

    <input type="submit" value="Submit">
    <input type="reset" value="Reset"> (Leave blank for all products)
</form>


<% 
// Get product name to search for
// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!
String name = request.getParameter("productName");
if(name == null) name = "";
		
//Note: Forces loading of SQL Server driver
try{// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	// Connection
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";
	String pw = "304#sa#pw";
	Connection conn = DriverManager.getConnection(url,uid,pw);

    String categoryId = request.getParameter("categoryId");
	String query = "SELECT * FROM product p JOIN category c ON p.categoryId = c.categoryId WHERE productName LIKE ?";
    if (categoryId != null && !categoryId.isEmpty()) {
    query += " AND p.categoryId = ?";
    }
    PreparedStatement pstmt = conn.prepareStatement(query);
    pstmt.setString(1, "%" + name + "%");
    // Set category parameter if selected
    if (categoryId != null && !categoryId.isEmpty()) {
        pstmt.setString(2, categoryId);
    }
    ResultSet rs = pstmt.executeQuery();

	// NumberFormat for currency
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	// Print out the ResultSet
	out.println("<table>");
	 out.println("<tr> <th></th> <th>Product Name</th> <th>Category</th> <th>Price</th> </tr>");
    while(rs.next()){
        String productName = rs.getString("productName");
        String productCategory = rs.getString("categoryName");
        String productPrice = currFormat.format(rs.getDouble("productPrice"));
		double productPriceDouble = rs.getDouble("productPrice");
        int productId = rs.getInt("productId");

		// For each product create a link of the form addcart.jsp?id=productId&name=productName&price=productPrice
        String link = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPriceDouble;

        String productLink = "product.jsp?id=" + productId;
        out.println("<tr><td><a href=\"" + link + "\">Add to cart</a></td><td><a href=\"" + productLink + "\">" + productName + "</a></td><td>" + productCategory + "</td><td>" + productPrice + "</td></tr>");
    }
    out.println("</table>");

    // Close connection
    rs.close();
    pstmt.close();
    conn.close();
}catch (java.lang.ClassNotFoundException e){
	out.println("ClassNotFoundException: " +e);
}catch (SQLException se) {
	out.println("SQLException: " + se);
} 

%>

</body>
</html>