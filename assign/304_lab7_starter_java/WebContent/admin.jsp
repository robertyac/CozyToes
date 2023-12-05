<%@ page import="java.text.NumberFormat" %>
<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>

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
</head>
<body>


<%-- // TODO: Include files auth.jsp and jdbc.jsp --%>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<%
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
out.println("<h2 align=\"center\">Administrator Sales Report by Day</h2>");
getConnection();
// Write SQL query that prints out total order amount by day
String sql = "SELECT CAST(orderDate AS DATE), SUM(totalAmount) FROM ordersummary GROUP BY CAST(orderDate AS DATE)";
PreparedStatement stmt = con.prepareStatement(sql);
ResultSet rs = stmt.executeQuery();

out.println("<table border=\"1\">");
out.println("<tr> <th>Order Date</th> <th>Total Order Amount</th> </tr>");
while (rs.next()) {
    Date date = rs.getDate(1);
    double totalSales = rs.getDouble(2);
    out.println("<tr><td>" + date + "</td><td>" + currFormat.format(totalSales) + "</td></tr>");
}
out.println("</table>");


closeConnection();
%>

</body>
</html>

