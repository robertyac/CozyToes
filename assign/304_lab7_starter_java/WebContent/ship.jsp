<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Dave and Rob Grocery Shipment Processing</title>
</head>
<body>

<%
getConnection();

// TODO: Get order id
String orderId = request.getParameter("orderId");

// TODO: Check if valid order id in database
String sql = "SELECT * FROM ordersummary WHERE orderId = ?";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setInt(1, Integer.parseInt(orderId));
ResultSet rs = pstmt.executeQuery();
if (!rs.next() || rs.getInt(1) == 0) {
out.println("Order ID does not exist.");
return;
}

// TODO: Start a transaction (turn-off auto-commit)
con.setAutoCommit(false);

// TODO: Retrieve all items in order with given id
String sql2 = "SELECT * FROM orderproduct WHERE orderId = ?";
PreparedStatement pstmt2 = con.prepareStatement(sql2);
pstmt2.setInt(1, Integer.parseInt(orderId));
ResultSet rs2 = pstmt2.executeQuery();

// TODO: Create a new shipment record.
String sql5 = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (?, ?, ?)";
PreparedStatement pstmt5 = con.prepareStatement(sql5);
pstmt5.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
pstmt5.setString(2, "Shipment for order " + orderId);
pstmt5.setInt(3, 1); // warehouseId 1
pstmt5.executeUpdate();

while(rs2.next()) {
    // Get the product ID and quantity for each item in the order
    int productId = rs2.getInt("productId");
    int quantity = rs2.getInt("quantity");

    // Check if there is enough inventory for each item in the warehouse
    String sql3 = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = 1";
    PreparedStatement pstmt3 = con.prepareStatement(sql3);
    pstmt3.setInt(1, productId);
    ResultSet rs3 = pstmt3.executeQuery();

	// TODO: For each item verify sufficient quantity available in warehouse 1.
    if(rs3.next()) {
        int availableQuantity = rs3.getInt("quantity");
        if(availableQuantity < quantity) {
            // TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
            out.println("Shipment not done. Insufficient inventory for product ID: " + productId);
            con.rollback();
            return;
        } else {
            // If there is enough inventory, update the inventory for each item
			out.print("Ordered product: " + productId);
			out.print(" Qty: " + quantity);
			out.print(" Previous inventory: " + availableQuantity);
			out.print(" New inventory: " + (availableQuantity - quantity) + "<br>");
            String sql4 = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ? AND warehouseId = 1";
            PreparedStatement pstmt4 = con.prepareStatement(sql4);
            pstmt4.setInt(1, quantity);
            pstmt4.setInt(2, productId);
            pstmt4.executeUpdate();
        }
    } else {
        // If the product ID is not found in the warehouse, cancel the transaction and rollback
        out.println("Product ID: " + productId + " not found in warehouse 1");
        con.rollback();
        return;
    }
}
out.print("Shipment successfully processed.");
// Commit the transaction
con.commit();
// TODO: Auto-commit should be turned back on
con.setAutoCommit(true);







// Close connection
closeConnection();
%>


<h2><a href="index.jsp">Back to Main Page</a></h2>


</body>
</html>

