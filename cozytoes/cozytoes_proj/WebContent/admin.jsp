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

out.println("<h2 align=\"center\">CozyToes Customers</h2>");

%>

<form action="<%= request.getRequestURI() %>" method="post">
    <label for="searchTerm">Search for Customer by First/Last Name or by Customer ID:</label>
    <input type="text" id="searchTerm" name="searchTerm">
    <button type="submit">Search</button>
</form>

<%

String searchTerm = request.getParameter("searchTerm");
String sql2 = "SELECT * FROM customer WHERE firstName LIKE ? OR lastName LIKE ? OR customerId LIKE ?";
PreparedStatement stmt2 = con.prepareStatement(sql2);
stmt2.setString(1, "%" + searchTerm + "%");
stmt2.setString(2, "%" + searchTerm + "%");
stmt2.setString(3, "%" + searchTerm + "%");
ResultSet rs2 = stmt2.executeQuery();
%>

<table border='1'>
<%
while (rs2.next()) {
    int id = rs2.getInt("customerId");
    String firstName = rs2.getString("firstName");
    String lastName = rs2.getString("lastName");
    String email = rs2.getString("email");
    String phone= rs2.getString("phonenum");
    String address = rs2.getString("address");
    String city = rs2.getString("city");
    String state = rs2.getString("state");
    String postalCode = rs2.getString("postalCode");
    String country = rs2.getString("country");
    String userId = rs2.getString("userid");

    out.println("<tr><th>ID</th><td>" + id + "</td></tr>");
    out.println("<tr><th>First Name</th><td>" + firstName + "</td></tr>");
    out.println("<tr><th>Last Name</th><td>" + lastName + "</td></tr>");
    out.println("<tr><th>Email</th><td>" + email + "</td></tr>");
    out.println("<tr><th>Phone</th><td>" + phone + "</td></tr>");
    out.println("<tr><th>Address</th><td>" + address + "</td></tr>");
    out.println("<tr><th>City</th><td>" + city + "</td></tr>");
    out.println("<tr><th>State</th><td>" + state + "</td></tr>");
    out.println("<tr><th>Postal Code</th><td>" + postalCode + "</td></tr>");
    out.println("<tr><th>Country</th><td>" + country + "</td></tr>");
    out.println("<tr><th>User ID</th><td>" + userId + "</td></tr>");
}
out.println("</table>");
closeConnection();
%>

</body>
</html>