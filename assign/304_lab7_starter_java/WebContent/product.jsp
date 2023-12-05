<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>


<html>
<head>
<title>CozyToes - Product Information</title>

<style>
    body {
        font-family: 'Arial', sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f8f8f8;
        color: #333;
    }

    header {
        background-color: #33523b;
        color: #fff;
        text-align: center;
        padding: 1em 0;
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
<header>
    <h1><a href="index.jsp" style="color: #fff">CozyToes</a></h1>
    <nav>
        <ul>
            <li><a href="listprod.jsp">Product Search</a></li>
            <li><a href="listorder.jsp">List Orders</a></li>
            <li><a href="showcart.jsp">Shopping Cart</a></li>
        </ul>
    </nav>
</header>
<%-- <link href="css/bootstrap.min.css" rel="stylesheet"> --%>
</head>
<body>

<%-- <%@ include file="header.jsp" %> --%>

<%
// Get product name to search for
String productId = request.getParameter("id");
// Use PreparedStatement to retrieve and display product information by id
String sql = "SELECT * FROM product WHERE productId = ?";

getConnection();
PreparedStatement stmt = con.prepareStatement(sql);
stmt.setString(1, productId);
ResultSet rs = stmt.executeQuery();

if (rs.next()) {
    String productName = rs.getString("productName");
    int pId = rs.getInt("productId");
    String productPrice = rs.getString("productPrice");
    String productImageURL = rs.getString("productImageURL");
    Blob productImage = rs.getBlob("productImage");

    // Display product name
    out.println("<h2>" + productName + "</h2>");

    // If there is a productImageURL, display using IMG tag
    if (productImageURL != null )
        out.println("<img src='img/" + pId + ".jpg'>");
    // Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
    if (productImage != null)
        out.println("<img src='displayImage.jsp?id=" + pId + "'>");
    
    // Display product id and price
    out.println("<h2>" + "Id: " + pId + "</h2>");
    out.println("<h2>" + "Price $" + productPrice + "</h2>");

    // For each product create a link of the form addcart.jsp?id=productId&name=productName&price=productPrice
    String link = "addcart.jsp?id=" + pId + "&name=" + productName+ "&price=" + productPrice;
    // Add links to Add to Cart and Continue Shopping
    out.println("<h3><a href=\"" + link + "\">Add to cart</a></h3>");
    out.println("<h3><a href='listprod.jsp'>Continue Shopping</a></h3>");

    rs.close();
}
    closeConnection();
    stmt.close();
%>

</body>
</html>

