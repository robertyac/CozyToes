<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% 
// Get product name to search for
// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!
String name = request.getParameter("productName");
if(name == null) name = "";
		
//Note: Forces loading of SQL Server driver
try{// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	// Connection
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";
	String pw = "304#sa#pw";
	Connection conn = DriverManager.getConnection(url,uid,pw);

	String query = "SELECT * FROM product WHERE productName LIKE ?";
    PreparedStatement pstmt = conn.prepareStatement(query);
    pstmt.setString(1, "%" + name + "%");
    ResultSet rs = pstmt.executeQuery();

	// NumberFormat for currency
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	// Print out the ResultSet
	out.println("<table>");
	out.println("<tr> <th></th> <th>Product Name</th> <th>Price</th> </tr>");
    while(rs.next()){
        String productName = rs.getString("productName");
        String productPrice = currFormat.format(rs.getDouble("productPrice"));
		double productPriceDouble = rs.getDouble("productPrice");
        int productId = rs.getInt("productId");


		// For each product create a link of the form addcart.jsp?id=productId&name=productName&price=productPrice
        String link = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPriceDouble;
        out.println("<tr><td><a href=\"" + link + "\">Add to cart</a></td><td>" + productName + "</td><td>" + productPrice + "</td></tr>");
    }
    out.println("</table>");

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

</body>
</html>