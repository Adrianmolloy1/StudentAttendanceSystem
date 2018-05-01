<%-- 
    Document   : index
    Author     : Adrian Molloy
--%>
<%@ include file="connection.jsp" %>
<%@page import="java.sql.*"%>
<%@page import="javax.xml.bind.DatatypeConverter"%>
<%@page import="java.security.MessageDigest"%>


<%
//session.invalidate();
    
String email = "";
String password = "";
String email_err = "";
String password_err = "";
PreparedStatement sql;
if(null!=request.getParameter("email")){
    // Check if email is empty
    if(request.getParameter("email") == null || request.getParameter("email").length() == 0){
        email_err = "Please enter your email address";
    } else {
        email = request.getParameter("email");
    }
}
  
if(null!=request.getParameter("password")){
    // Check if password is empty
    if(request.getParameter("password") == null){
        password_err = "Please enter your password";
    } else {
        password = request.getParameter("password");
    }
}
if(null!=request.getParameter("email") && null!=request.getParameter("password")){
    // Validate credentials
    if(email_err.isEmpty() && password_err.isEmpty()){
        try{
            // attempt database connection and create PreparedStatements
            sql = conn.prepareStatement("SELECT ID, Firstname, Lastname, Email, Password "
                                        + "FROM lecturers "
                                        + "WHERE Email = '" + email + "'" );
            
             ResultSet sqlRS = sql.executeQuery();
            if (sqlRS.isBeforeFirst()) {         //if data exists in database
                sqlRS.next();                      
                String ID = sqlRS.getString("ID");
                String firstname = sqlRS.getString("firstname");
                String lastname = sqlRS.getString("lastname");
                
                MessageDigest md = MessageDigest.getInstance("MD5");
                md.update(password.getBytes());
                byte[] digest = md.digest();
                String hashedPassword = DatatypeConverter.printHexBinary(digest).toUpperCase();
                
                
                if(hashedPassword.equals(sqlRS.getString("Password"))){
                    session.setAttribute("ID", ID);
                    session.setAttribute("email", email);
                    session.setAttribute("firstname", firstname);
                    session.setAttribute("lastname", lastname);
                    // Redirect to home page
                    response.sendRedirect("home.jsp");  
                }else{
                    password_err = "The password you entered was not valid";
                }
            }else{
                email_err = "No account found with that email"; 
            }
            sqlRS.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}
%>           
<%@page contentType="text/html" pageEncoding="UTF-8"%>         
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Sign In</title>
        <link rel="stylesheet" href="styling.css"> 
    </head>
    <body>
        <form action="index.jsp" method="post">
            <div class="login_box"> 
                <div>  
                    <a href="home.jsp">
                        <img src="Images/GMITLogoBig.png" alt="GMIT Logo" width="600" height="200">
                    </a>
		<div class="title"style="color:#2980b9">Room 506</div>
                     <input type="text" name="email" class="login_txtbox" placeholder="Email" value="<%=email%>">
                <span class="help-block"><%=email_err%></span>

                <input type="password" name="password" class="login_txtbox" placeholder="Password" value="<%=password%>">
                <span class="help-block"><%=password_err%></span>

                    <input type="submit" class="login_btn" value="Sign In">
                    <a href="register.jsp"><div class="login_btn2">Sign Up</div></a>
                </div>
            </div>
        </form>    
    </body>
</html>