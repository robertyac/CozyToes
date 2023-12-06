<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%-- Remove product from ArrayList aka the cart --%>
<%
String productId = request.getParameter("productId");
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList.containsKey(productId)) {
    productList.remove(productId);
}

response.sendRedirect("showcart.jsp");
%>