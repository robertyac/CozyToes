<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Dave & Rob Grocery</title>
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
    <h1><a href="index.jsp" style="color: #fff">Dave & Rob Grocery</a></h1>
    <nav>
        <ul>
            <li><a href="listprod.jsp">Product Search</a></li>
            <li><a href="listorder.jsp">List Orders</a></li>
            <li><a href="showcart.jsp">Shopping Cart</a></li>
        </ul>
    </nav>
</header>
</head>
<body>
<% 
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
if (custId == null || custId.isEmpty()) {
    out.println("Invalid customer ID.");
    return;
}

try {
    Integer.parseInt(custId);
} catch (NumberFormatException e) {
    out.println("Invalid customer ID.");
    return;
}

// Determine if there are products in the shopping cart
if (productList == null || productList.isEmpty()) {
    out.println("Your shopping cart is empty.");
    return;
}

try{// Load driver class
Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

// Connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
Connection conn = DriverManager.getConnection(url, uid, pw);

// Validate customer id in database
String firstName, lastName;
String sql = "SELECT * FROM customer WHERE customerId = ?";
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setInt(1, Integer.parseInt(custId));
ResultSet rs = pstmt.executeQuery();
if (!rs.next() || rs.getInt(1) == 0) {
    out.println("Customer ID does not exist.");
    return;
}else{
    firstName = rs.getString("firstName");
    lastName = rs.getString("LastName");
}

// insert into ordersummary table and retrieving auto-generated id
String sql2 = "INSERT INTO ordersummary (OrderDate, customerId) VALUES (GETDATE(), ?)";
pstmt = conn.prepareStatement(sql2, Statement.RETURN_GENERATED_KEYS);
pstmt.setInt(1, Integer.parseInt(custId));
pstmt.executeUpdate();
rs = pstmt.getGeneratedKeys();
rs.next();
int orderId = rs.getInt(1);

// Traverse through productList and insert into OrderProduct table
double totalAmount = 0;
Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
while (iterator.hasNext()) {
    Map.Entry<String, ArrayList<Object>> entry = iterator.next();
    ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
    String productId = (String) product.get(0);
    double price = Double.parseDouble((String) product.get(2));
    int quantity = (Integer) product.get(3);

    pstmt = conn.prepareStatement("INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)");
    pstmt.setInt(1, orderId);
    pstmt.setString(2, productId);
    pstmt.setInt(3, quantity);
	pstmt.setDouble(4, price);
    pstmt.executeUpdate();

    totalAmount += price * quantity;
}
//for updating total amount for the order in OrderSummary table
String sql4 = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
pstmt = conn.prepareStatement(sql4);
pstmt.setDouble(1, totalAmount);
pstmt.setInt(2, orderId);
pstmt.executeUpdate();


// For displaying the order information including all ordered items
Iterator<Map.Entry<String, ArrayList<Object>>> iterator2 = productList.entrySet().iterator();
out.println("<h1>Your Order Summary</h1>");
out.println("<table border=\"1\" style=\"font-size: 20px;\">"); // Increase the font size
out.println("<tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
while (iterator2.hasNext()) {
    Map.Entry<String, ArrayList<Object>> entry = iterator2.next();
    ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
    String productId = (String) product.get(0);
    String productName = (String) product.get(1);
    double price = Double.parseDouble((String) product.get(2));
    int quantity = (Integer) product.get(3);
    out.println("<tr>");
    out.println("<td>" + productId + "</td>");
    out.println("<td>" + productName + "</td>"); 
    out.println("<td>" + quantity + "</td>"); 
    out.println("<td>" + currFormat.format(price) + "</td>");
    out.println("<td>" + currFormat.format(price*quantity) + "</td>");
    out.println("</tr>");
}
out.println("</table>");
out.println("<h2>Order Total: " + currFormat.format(totalAmount) + "</h2>");

//h3
out.println("<h3>Order placed successfully. Will be shipped soon...</h3>");
out.println("<h3>Your order reference number is: " + orderId + "</h3>");
out.println("<h3>Shipping to customer: " + custId + "</h3>");
out.println("<h3>Name: " + firstName + " " + lastName + "</h3>");
 
//clear their shopping cart
session.removeAttribute("productList");

// Close connection
rs.close();
pstmt.close();
conn.close();
}
catch (java.lang.ClassNotFoundException e){
out.println("ClassNotFoundException: " +e);
} catch (SQLException se) {
out.println("SQLException: " + se);
}

%>
</body>
</HTML>
