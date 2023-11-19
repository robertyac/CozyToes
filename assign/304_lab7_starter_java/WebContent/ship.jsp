<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>YOUR NAME Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%

	try{// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

	// Connection
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";
	String pw = "304#sa#pw";
	Connection conn = DriverManager.getConnection(url, uid, pw);

	// TODO: Get order id
    String orderId = request.getParameter("orderId");

	// TODO: Check if valid order id in database
	String sql = "SELECT * FROM ordersummary WHERE orderId = ?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, Integer.parseInt(orderId));
	ResultSet rs = pstmt.executeQuery();
	if (!rs.next() || rs.getInt(1) == 0) {
    	out.println("Order ID does not exist.");
    	return;
	}
	// TODO: Start a transaction (turn-off auto-commit)
	conn.setAutoCommit(false);
	
	// TODO: Retrieve all items in order with given id
	String sql2 = "SELECT     FROM ordersummary WHERE orderId = ?";
	PreparedStatement pstmt = conn.prepareStatement(sql2);
	pstmt.setInt(1, Integer.parseInt(orderId));
	ResultSet rs2 = stmt.executeQuery(sql);

	// TODO: Create a new shipment record.

	// TODO: For each item verify sufficient quantity available in warehouse 1.
	// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
	
	// TODO: Auto-commit should be turned back on

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

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
