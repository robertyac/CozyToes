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
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body>

<% 
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
String sql = "SELECT COUNT(*) FROM customer WHERE customerId = ?";
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setInt(1, Integer.parseInt(custId));
ResultSet rs = pstmt.executeQuery();
if (!rs.next() || rs.getInt(1) == 0) {
    out.println("Customer ID does not exist.");
    return;
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

String sql4 = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
pstmt = conn.prepareStatement(sql4);
pstmt.setDouble(1, totalAmount);
pstmt.setInt(2, orderId);
pstmt.executeUpdate();

out.println("Order placed successfully. Order ID: " + orderId + ", Total Amount: " + totalAmount);

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
</BODY>
</HTML>

