<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cozy Toes</title>
 <style>
    body {
        background-color: #2c3e2a; 
        color: #fff;
        font-family: 'Arial', sans-serif;
        margin: 0;
        padding: 0;
        text-align: center;
    }

    h1 {
        margin-top: 50px;
    }

    h2 {
        margin: 20px 0;
    }

    a {
        color: #ffd700; 
        text-decoration: none;
        font-weight: bold;
        transition: color 0.3s ease;
    }

    a:hover {
        color: #ffa500; 
    }

    h3 {
        margin: 10px 0;
    }

    h4 {
        margin: 5px 0;
    }

    .user-info {
        margin-bottom: 30px;
    }

    nav {
        background-color: #1a1a1a;
        padding: 10px 0;
        position: sticky;
        top: 0;
        z-index: 100;
    }

    nav a {
        margin: 0 20px;
    }

    .user-info span {
        margin-right: 20px;
    }

    .test-ship-box {
        background-color: #001f3f; 
        padding: 10px;
        margin: 20px auto;
        width: 80%;
        border-radius: 5px;
    }

    .test-ship-box h4 {
        margin: 5px 10px;
        display: inline-block;
        color: #fff;
        border-radius: 5px;
    }

    .featured-products {
        background-color: #1a1a1a;
        padding: 20px;
        margin: 20px auto;
        width: 80%;
        grid-template-columns: repeat(3, 1fr);
        gap: 20px; 
        border-radius: 5px;
    }

    .featured-products h3 {
        color: #ffd700; 
    }

    .featured-products p {
        color: #fff; 
    }

    .featured-product-box {
        background-color: #3a3a3a;
        padding: 10px;
        margin: 10px 0;
        border-radius: 5px;
        height: 100px;
        max-width: 300px;
        text-align: center;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center; 
    }
    .featured-product-box img {
        max-height: 105px;
        width: auto;
        margin-right: 20px;
        border-radius: 5px;
    }
    .featured-product-box a {
        color: #ffd700;
        text-decoration: none;
        display: flex; 
        align-items: center; 
        margin: 10px auto;
        border-radius: 5px;
    }
    .featured-product-box a:hover {
        color: #ffa500;
    }
</style>

</head>

<body>
    <nav>
        <a href="listprod.jsp">Begin Shopping</a>
        <a href="listorder.jsp">List All Orders</a>
        <a href="customer.jsp">Customer Info</a>
        <a href="admin.jsp">Administrators</a>
            <% String userName = (String) session.getAttribute("authenticatedUser");
            if (userName != null)
                out.println("<span>Hello, " + userName + "</span>");
            if (userName == null) { %>
                <a href="login.jsp">Login</a>
            <% } else { %>
                <a href="logout.jsp">Log out</a>
            <% } %>

    </nav>

    <h1>Welcome to CozyToes</h1>
    <h2>Happy feet, happy life with CozyToes socks on your toes!</h2>

    <div class="test-ship-box">
        <h4><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4>
        <h4><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4>
    </div>


<div class="featured-products" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
 <h3 style="grid-column: span 3;">Featured Products</h3>
    <p style="grid-column: span 3;">Take a look at our most popular products!</p>

    <div class="featured-product-box">
        <a href="product.jsp?id=1">
            <img src='img/1.jpg'>
            Wool Blend Boot Socks (Pack of 2)
        </a>
    </div>

    <div class="featured-product-box">
        <a href="product.jsp?id=5">
            <img src='img/5.jpg'>
            Flamingo Crew Socks
        </a>
    </div>

    <div class="featured-product-box">
        <a href="product.jsp?id=3">
            <img src='img/3.jpg'>
            High Performance Ski Socks 
        </a>
    </div>

    <div class="featured-product-box">
        <a href="product.jsp?id=1">
            <img src='img/placeholder.jpg'>
            Placeholder
        </a>
    </div>

    <div class="featured-product-box">
        <a href="product.jsp?id=5">
            <img src='img/placeholder.jpg'>
            Placeholder
        </a>
    </div>

    <div class="featured-product-box">
        <a href="product.jsp?id=3">
             <img src='img/placeholder.jpg'>
            Placeholder
        </a>
    </div>
</div>

</body>

</html>

