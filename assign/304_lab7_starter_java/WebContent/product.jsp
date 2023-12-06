<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>


<html>
<head>
<title>CozyToes - Product Information</title>
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


<%-- <%@ include file="header.jsp" %> --%>

<%
// Get product name to search for
String productId = request.getParameter("id");
// Use PreparedStatement to retrieve and display product information by id
String sql = "SELECT * FROM product WHERE productId = ?";

getConnection();
PreparedStatement stmt = con.prepareStatement(sql);
stmt.setString(1, productId);
ResultSet rs = stmt.executeQuery();

if (rs.next()) {
    String productName = rs.getString("productName");
    int pId = rs.getInt("productId");
    String productPrice = rs.getString("productPrice");
    String productImageURL = rs.getString("productImageURL");
    Blob productImage = rs.getBlob("productImage");

    // Display product name
    out.println("<h2>" + productName + "</h2>");

    // If there is a productImageURL, display using IMG tag
    if (productImageURL != null )
        out.println("<img src='img/" + pId + ".jpg'>");
    // Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
    if (productImage != null)
        out.println("<img src='displayImage.jsp?id=" + pId + "'>");
    
    // Display product id and price
    out.println("<h2>" + "Id: " + pId + "</h2>");
    out.println("<h2>" + "Price $" + productPrice + "</h2>");

    // For each product create a link of the form addcart.jsp?id=productId&name=productName&price=productPrice
    String link = "addcart.jsp?id=" + pId + "&name=" + productName+ "&price=" + productPrice;
    // Add links to Add to Cart and Continue Shopping
    out.println("<h3><a href=\"" + link + "\">Add to cart</a></h3>");
    out.println("<h3><a href='listprod.jsp'>Continue Shopping</a></h3>");

    rs.close();
}
    closeConnection();
    stmt.close();
%>

<!-- Add a form for the review -->
<h3>Leave a Review</h3>
<form id="reviewForm" action="submitReview.jsp" method="post" onsubmit="return validateReview()">
    <input type="hidden" name="productId" value="<%=productId%>">
    <label for="rating">Rating (1-5):</label><br>
    <input type="number" id="rating" name="rating" min="1" max="5" required><br>
    <label for="review">Review:</label><br>
    <textarea id="review" name="review" required></textarea><br>
    <input type="submit" value="Submit Review">
</form>

<script>
    function validateReview() {
        var rating = document.getElementById('rating').value;
        var review = document.getElementById('review').value;

        // Check if rating is a number between 1 and 5
        if (isNaN(rating) || rating < 1 || rating > 5) {
            alert('Please enter a valid rating between 1 and 5.');
            return false;
        }

        // Check if the review is not empty
        if (review.trim() === '') {
            alert('Please enter a review.');
            return false;
        }

        // You can add more specific validation logic here if needed

        return true;
    }
</script>

<%
//PreparedStatement
String reviewSql = "SELECT * FROM review WHERE productId = ? ORDER BY reviewDate DESC";
String avgRatingSql = "SELECT AVG(reviewRating) as avgRating FROM review WHERE productId = ?";

getConnection();

//average rating
PreparedStatement avgRatingStmt = con.prepareStatement(avgRatingSql);
avgRatingStmt.setString(1, productId);
ResultSet avgRatingRs = avgRatingStmt.executeQuery();

if (avgRatingRs.next()) {
    double avgRating = avgRatingRs.getDouble("avgRating");
    out.println("<h3>Average Rating: " + avgRating + "</h3>");
}

avgRatingRs.close();
avgRatingStmt.close();

//reviews
PreparedStatement reviewStmt = con.prepareStatement(reviewSql);
reviewStmt.setString(1, productId);
ResultSet reviewRs = reviewStmt.executeQuery();

out.println("<h3>Reviews:</h3>");
out.println("<table>");
out.println("<tr><th>Rating</th><th>Date</th><th>Review</th></tr>");

while (reviewRs.next()) {
    String reviewRating = reviewRs.getString("reviewRating");
    Date reviewDate = reviewRs.getDate("reviewDate");
    String reviewComment = reviewRs.getString("reviewComment");
    out.println("<tr>");
    out.println("<td>" + reviewRating + "</td>");
    out.println("<td>" + reviewDate + "</td>");
    out.println("<td>" + reviewComment + "</td>");
    out.println("</tr>");
}

out.println("</table>");

reviewRs.close();
closeConnection();
reviewStmt.close();
%>

</body>
</html>

