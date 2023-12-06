<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

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

    String sql = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, GETDATE(), ?, ?, ?)";
    getConnection();
    PreparedStatement stmt = con.prepareStatement(sql);
    stmt.setString(1, rating);
    stmt.setInt(2, customerId);
    stmt.setString(3, productId);
    stmt.setString(4, review);
    stmt.executeUpdate();

    closeConnection();
    stmt.close();

    response.sendRedirect("product.jsp?id=" + productId); // Redirect back to the product page
}
System.out.println("End of submitReview.jsp");
%>

