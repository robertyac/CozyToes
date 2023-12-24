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
        background-color: #33523b;
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
    
</header>
</head>
<body>

<h1>Customer Profile</h1>

<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>

<%
getConnection();
String sql = "UPDATE customer SET firstName=?, lastName=?, email=?, phonenum=?, address=?, city=?, state=?, postalCode=?, country=? WHERE userid=?";
PreparedStatement pstmt = con.prepareStatement(sql);
%>

<%
try {
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");
    String userId = request.getParameter("userId");

    pstmt.setString(1, firstName);
    pstmt.setString(2, lastName);
    pstmt.setString(3, email);
    pstmt.setString(4, phone);
    pstmt.setString(5, address);
    pstmt.setString(6, city);
    pstmt.setString(7, state);
    pstmt.setString(8, postalCode);
    pstmt.setString(9, country);
    pstmt.setString(10, userId);

    pstmt.executeUpdate();

    response.sendRedirect("customer.jsp");

} catch (Exception e) {
    e.printStackTrace();
} finally {
    closeConnection();
}
%>

<%
closeConnection();
%>

</body>
</html>



