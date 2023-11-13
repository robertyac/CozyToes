<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Dave & Rob Grocery</title>
<style>
        body {
            font-family: 'Ariel', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #000; /* Set default text color for the body */
        }

        header {
            background-color: #33523b;
            color: #fff;
            text-align: center;
            padding: 1em 0;
        }

        h1 {
            margin: 0;
        }

        nav {
            margin-top: 1em;
        }

        ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
        }

        li {
            display: inline;
            margin-right: 20px;
        }

		a {
            text-decoration: none;
            color: #fff;
            font-weight: bold;
            font-size: 1.2em;
        }

		header ul li a {
            text-decoration: none;
            color: #fff;
            font-weight: bold;
            font-size: 1.2em;
        }

        body a {
            text-decoration: none;
            color:  #0000EE;
            font-weight: bold;
            font-size: 1.2em;
        }

        a:hover {
            color: #FFA500; /* Change link color to orange on hover */
        }
</style>
<header>
    <h1><a href="shop.html" style="color: #fff">Dave & Rob Grocery</a></h1>
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
<h1>Order List</h1>
<%
// Load driver class
try {
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	
	// Connection
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";
	String pw = "304#sa#pw";
	Connection conn = DriverManager.getConnection(url,uid,pw);
	
	// Write query to retrieve all order summary records
	String sql = "SELECT * FROM ordersummary os join customer c on os.customerId = c.customerId";
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery(sql);
	
	// NumberFormat for currency
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	//table for order summary

while(rs.next()) {
	out.println("<table border=\"1\">");
	out.println("<tr><th>Order ID</th><th>Order Date</th><th>Customer ID</th><th>Customer Name</th><th>Total Amount</th></tr>");
    out.println("<tr>");
    out.println("<td>" + rs.getInt("orderId") + "</td>");
    out.println("<td>" + rs.getTimestamp("orderDate") + "</td>");
    out.println("<td>" + rs.getInt("customerId") + "</td>");
    out.println("<td>" + rs.getString("firstName") + " "+ rs.getString("LastName") + "</td>");
    out.println("<td>" + currFormat.format(rs.getDouble("totalAmount")) + "</td>");
    out.println("</tr>");

    //each orders product details
    String sql2 = "SELECT * FROM product p join orderproduct op on p.productId = op.productId WHERE orderId = ?";
	PreparedStatement pstmt = conn.prepareStatement(sql2);
	pstmt.setInt(1, rs.getInt("orderId"));
	ResultSet rs2 = pstmt.executeQuery();

    // Start table for product details
    out.println("<tr><th>Product ID</th><th>Quantity</th><th>Price</th></tr>");
    while(rs2.next()) {
        out.println("<tr>");
        out.println("<td>" + rs2.getInt("productId") + "</td>");
        out.println("<td>" + rs2.getInt("quantity") + "</td>");
        out.println("<td>" + currFormat.format(rs2.getDouble("price")) + "</td>");
        out.println("</tr>");
    }
	rs2.close();
	out.println("<tr style=\"height:25px;\"></tr>");
}
    out.println("</table>");

// table END order summary
out.println("</table>");
	// Close connections
	rs.close();
	stmt.close();
	conn.close();
} catch (SQLException se) {
	out.println("SQLException: " + se);
} catch (Exception e) {
	out.println("Exception: " + e);
}
%>



</body>
</html>
