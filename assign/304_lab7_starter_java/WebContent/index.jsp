<!DOCTYPE html>
<html>
<head>
    	<title>Cozy Toes</title>
    <style>
        body {
            background-color: #33523b;
            color: white; /* Set text color to white */
            font-family: 'Ariel', sans-serif;
        }
        a {
            color: #FFD700; /* Set link color to gold */
            text-decoration: none; /* Remove underline */
        }
        a:hover {
            color: #FFA500; /* Change link color to orange on hover */
        }
    </style>
</head>
<body>
<h1 align="center">Welcome to CozyToes</h1>
<h2 align="center">Happy feet, happy life with CozyToes on your toes!</h2>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
	if (userName != null)
		out.println("<h3 align=\"center\">Signed in as: "+userName+"</h3>");
%>

<h4 align="center"><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4>

<h4 align="center"><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4>

</body>
</head>


