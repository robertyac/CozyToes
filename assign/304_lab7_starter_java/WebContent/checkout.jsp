<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.net.URLEncoder" %>

<%
    String userName = (String) session.getAttribute("authenticatedUser");

    if (userName == null) {
        // If the user is not authenticated, redirect to the login page with the checkout URL parameter
        String checkoutURL = "checkout.jsp"; // Adjust the URL as needed
        response.sendRedirect("login.jsp?redirect=" + URLEncoder.encode(checkoutURL, "UTF-8"));
    } else {
        // Proceed with the checkout logic
        String customerId = ""; // Populate the customer ID based on the logged-in user
        try {
            getConnection();
            String sql = "SELECT customerId FROM customer WHERE userid = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, userName);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                customerId = rs.getString("customerId");
            }
        } catch (SQLException ex) {
            out.println(ex);
        } finally {
            closeConnection();
        }
%>
<!DOCTYPE html>
<html>
<head>
    <title>CozyToes Checkout</title>
    <style>
        body {
            background-color: #33523b;
            color: white; /* Set text color to white */
            font-family: 'Arial', sans-serif;
        }
        .error {
            color: red;
        }
    </style>
    <script>
        function validateForm() {
            var paymentMethod = document.forms["checkoutForm"]["paymentMethod"].value;
            var shippingAddress = document.forms["checkoutForm"]["shippingAddress"].value;
            var creditCard = document.forms["checkoutForm"]["creditCard"].value;
            var cryptoAddress = document.forms["checkoutForm"]["cryptoAddress"].value;

            // Check if payment method is selected
            if (paymentMethod === "") {
                document.getElementById("error-message").innerHTML = "Please select a payment method.";
                return false;
            }

            // Check if shipping address is empty
            if (shippingAddress.trim() === "") {
                document.getElementById("error-message").innerHTML = "Please enter your shipping address.";
                return false;
            }

            // Check if shipping address includes both numbers and letters
            if (!/^(?=.*[0-9])(?=.*[a-zA-Z])/.test(shippingAddress)) {
                document.getElementById("error-message").innerHTML = "Shipping address must include both numbers and letters.";
                return false;
            }


            // Validate credit card if payment method is "creditCard"
            if (paymentMethod === "creditCard") {
                // Check if credit card is empty
                if (creditCard.trim() === "") {
                    document.getElementById("error-message").innerHTML = "Please enter your credit card number.";
                    return false;
                }

                // Check if credit card contains only numbers
                if (!/^\d+$/.test(creditCard)) {
                    document.getElementById("error-message").innerHTML = "Credit card number must contain only numbers and no spaces.";
                    return false;
                }

                // Check if credit card has 16 digits
                if (creditCard.length !== 16) {
                    document.getElementById("error-message").innerHTML = "Credit card number must have 16 digits.";
                    return false;
                }
            }

            // Validate crypto address if payment method is "crypto"
            if (paymentMethod === "crypto") {
                // Check if crypto address is empty
                if (cryptoAddress.trim() === "") {
                    document.getElementById("error-message").innerHTML = "Please enter your crypto address.";
                    return false;
                }
            }

            // Additional validation logic can be added here

            return true;
        }

        // Function to show/hide credit card and crypto address fields based on payment method
        function togglePaymentFields() {
            var paymentMethod = document.forms["checkoutForm"]["paymentMethod"].value;
            var creditCardField = document.getElementById("creditCardField");
            var cryptoAddressField = document.getElementById("cryptoAddressField");

            // Show/hide credit card field based on payment method
            creditCardField.style.display = paymentMethod === "creditCard" ? "block" : "none";

            // Show/hide crypto address field based on payment method
            cryptoAddressField.style.display = paymentMethod === "crypto" ? "block" : "none";
        }
    </script>
</head>
<body>

    <h1>Checkout</h1>

    <form name="checkoutForm" onsubmit="return validateForm()" method="post" action="order.jsp">
        <label for="customerId">Customer ID:</label>
        <input type="text" name="customerId" size="50" value="<%= customerId %>" readonly><br>

        <label for="paymentMethod">Payment Method:</label>
        <select name="paymentMethod" onchange="togglePaymentFields()">
            <option value="" disabled selected>Select Payment Method</option>
            <option value="creditCard">Credit Card</option>
            <option value="crypto">Crypto</option>
            <option value="factoryLabour">Physical Labour in our factories (you make the socks)</option>
        </select><br>

        <!-- Credit Card Field (Initially Hidden) -->
        <div id="creditCardField" style="display: none;">
            <label for="creditCard">Credit Card Number:</label>
            <input type="text" name="creditCard" size="16"><br>
        </div>

        <!-- Crypto Address Field (Initially Hidden) -->
        <div id="cryptoAddressField" style="display: none;">
            <label for="cryptoAddress">Crypto Address (Bitcoin):</label>
            <input type="text" name="cryptoAddress" size="50"><br>
        </div>

        <label for="shippingAddress">Shipping Address:</label>
        <textarea name="shippingAddress" rows="1" cols="50"></textarea><br>

        <input type="submit" value="Place Order">
        <input type="reset" value="Reset">
    </form>

    <p id="error-message" class="error"></p>

</body>
</html>
<%
    }
%>
