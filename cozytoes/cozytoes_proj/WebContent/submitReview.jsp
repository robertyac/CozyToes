<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<style>
    body {
        font-family: 'Arial', sans-serif;
        margin: 0;
        padding: 0;
        background-color: #2c3e2a;
        color: #ffff;
    }
    a {
        color: #fff; 
        text-decoration: none;
    }
    a:hover {
        color: #FFA500; 
    }
        
</style>

<%--Based off of checkout.jsp--%>
<%
String userName = (String) session.getAttribute("authenticatedUser");

String productId = request.getParameter("productId");
String rating = request.getParameter("rating");
String review = request.getParameter("review");
if (userName == null) {
    // If the user is not authenticated, redirect to the login page with the checkout URL parameter
    String productLink = "product.jsp?id=" + productId;
    response.sendRedirect("login.jsp?redirect=" + URLEncoder.encode(productLink, "UTF-8"));
} else {
    getConnection();
    int customerId = 0; //customer ID based on the logged-in user
        try {
            String sql = "SELECT customerId FROM customer WHERE userid = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, userName);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                customerId = rs.getInt("customerId");
            }
        } catch (SQLException ex) {
            out.println(ex);
        } finally {
            closeConnection();
        }

            //Checking if A) the user has purchased and B) if they already left a review
            String checkPurchaseSql = "SELECT * FROM ordersummary os join orderproduct op on os.orderId = op.orderId WHERE customerId = ? AND productId = ?";
            getConnection();
            PreparedStatement checkPurchaseStmt = con.prepareStatement(checkPurchaseSql);
            checkPurchaseStmt.setInt(1, customerId);
            checkPurchaseStmt.setString(2, productId);
            ResultSet checkPurchaseRst = checkPurchaseStmt.executeQuery();

            //check if user has already purchased the item.
            if (!checkPurchaseRst.next()) {
            out.println("You must purchase this product before reviewing it.");
            out.println("<h3><a href='product.jsp?id=" + productId + "'>Go Back</a></h3>");
            } else {
                String checkReviewSql = "SELECT * FROM review WHERE customerId = ? AND productId = ?";
                PreparedStatement checkReviewStmt = con.prepareStatement(checkReviewSql);
                checkReviewStmt.setInt(1, customerId);
                checkReviewStmt.setString(2, productId);
                ResultSet checkReviewRst = checkReviewStmt.executeQuery();
                    if (checkReviewRst.next()) {
                    out.println("You have already reviewed this product.");
                    out.println("<h3><a href='product.jsp?id=" + productId + "'>Go Back</a></h3>");
                } else {
                    String sql = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, GETDATE(), ?, ?, ?)";
                    PreparedStatement stmt = con.prepareStatement(sql);
                    stmt.setString(1, rating);
                    stmt.setInt(2, customerId);
                    stmt.setString(3, productId);
                    stmt.setString(4, review);
                    stmt.executeUpdate();
                    stmt.close();
                    response.sendRedirect("product.jsp?id=" + productId); // Auto-Redirect back to the product page
                }
            closeConnection();
            }
   
}
System.out.println("End of submitReview.jsp");
%>

