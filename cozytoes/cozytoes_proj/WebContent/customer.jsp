<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
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
            String user = (String) session.getAttribute("authenticatedUser");
            if (user != null)
                out.println("<h3>Hello, " + user + "</h3>");
        %>
    </div> 
</header>
</head>
<body>

<h1>Customer Profile</h1>

<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>

<%
String userName = (String) session.getAttribute("authenticatedUser");
getConnection();
String sql = "SELECT * FROM customer WHERE userid = ?";
PreparedStatement stmt = con.prepareStatement(sql);
stmt.setString(1, userName);
ResultSet rs = stmt.executeQuery();
%>

<table border='1'>
<%
while (rs.next()) {
    int id = rs.getInt("customerId");
    String firstName = rs.getString("firstName");
    String lastName = rs.getString("lastName");
    String email = rs.getString("email");
    String phone= rs.getString("phonenum");
    String address = rs.getString("address");
    String city = rs.getString("city");
    String state = rs.getString("state");
    String postalCode = rs.getString("postalCode");
    String country = rs.getString("country");
    String userId = rs.getString("userid");

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
%>
</table>
    <a href="editCustomer.jsp">Edit</a>
<%
closeConnection();
%>

</body>
</html>














