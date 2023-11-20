<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
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

<%
closeConnection();
%>

</body>
</html>














