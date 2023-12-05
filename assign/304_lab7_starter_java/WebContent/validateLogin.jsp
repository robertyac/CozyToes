<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	 String authenticatedUser = null;
    session = request.getSession(true);

    try
    {
        authenticatedUser = validateLogin(out,request,session);
    }
    catch(IOException e)
    {   System.err.println(e); }

    if(authenticatedUser != null) {
        // Get the redirect URL from the request
        String redirectURL = request.getParameter("redirect");

        // If the redirect URL is not null, redirect the user to that URL
        if (redirectURL != null) {
            response.sendRedirect(redirectURL);
        } else {
            // If the redirect URL is null, redirect the user to a default page
            response.sendRedirect("index.jsp");
        }
    } else {
        // Failed login - redirect back to login page with a message 
        response.sendRedirect("login.jsp");
    }
%>

<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		try 
		{
			getConnection();
			
			// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			retStr = "";	
			
			// Check if userId and password match some customer account. If so, set retStr to be the username.
			String sql = "SELECT * FROM customer WHERE userid = ? AND password = ?";
			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, username);
			stmt.setString(2, password);
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				retStr = username;
			} else {
				retStr = null;
			}
        
        closeConnection();		
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
		}
		else
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");

		return retStr;
	}
%>

