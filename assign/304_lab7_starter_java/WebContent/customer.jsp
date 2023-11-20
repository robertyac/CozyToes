<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

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

<table class="vertical-header">
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

    out.println("<tr><th>ID</th><td>" + id + 
    "</td><th>First Name</th><td>" + firstName + 
    "</td><td>" + lastName + 
    "</td><td>" + email + 
    "</td><td>" + phone + 
    "</td><td>" + address + 
    "</td><td>" + city + 
    "</td><td>" + state + 
    "</td><td>" + postalCode + 
    "</td><td>" + country + 
    "</td><td>" + userId + "</td></tr>");
}
%>
</table>

<%
closeConnection();
%>

</body>
</html>














