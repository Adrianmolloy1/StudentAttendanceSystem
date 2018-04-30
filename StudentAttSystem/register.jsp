<%-- 
    Document   : register
    Author     : Adrian
--%>
<%@ include file="connection.jsp" %>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.*"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="javax.xml.bind.DatatypeConverter"%>

<%
String firstname = "";
String lastname = "";
String email = "";
String password = "";
String confirm_password = "";

String firstname_err = "";
String lastname_err = "";
String email_err = "";
String password_err = "";
String confirm_password_err = "";


PreparedStatement sql;

if(null!=request.getParameter("firstname")){
   
    // Validate firstname
    if(request.getParameter("firstname").length() == 0){
        firstname_err = "Please enter your firstname.";     
    } else if(request.getParameter("firstname").length() < 3){
        firstname_err = "First name must have at least 3 characters.";
    } else{
        firstname = request.getParameter("firstname");
    }
}

if(null!=request.getParameter("lastname")){
    // Validate lastname
    if(request.getParameter("lastname").length() == 0){
        lastname_err = "Please enter your lastname.";     
    } else if(request.getParameter("lastname").length() < 3){
        lastname_err = "Last name must have at least 3 characters.";
    } else{
        lastname = request.getParameter("lastname");
    }
}
  
if(null!=request.getParameter("email")){
    // Validate email
    if(request.getParameter("email").length() == 0){
        email_err = "Please enter your email address";
    } else {
        email = request.getParameter("email");

        try{
            // attempt database connection and create PreparedStatements
            sql = conn.prepareStatement("SELECT ID "
                                        + "FROM lecturers "
                                        + "WHERE Email = '" + email + "'" );

            ResultSet sqlRS = sql.executeQuery();

            if(sqlRS.next()) {   
                email_err = "This email is already taken";
            }else {
                email = request.getParameter("email");
            }
            sqlRS.close();

        }catch(Exception e){
            e.printStackTrace();
        }
    }
}

if(null!=request.getParameter("password")){
    // Validate password
    if(request.getParameter("password").length() == 0){
        password_err = "Please enter your password";
    } else if(request.getParameter("password").length() < 6) {
        password_err = "Password must have at least 6 characters";
    } else {
        password = request.getParameter("password");
    }
}
 
if(null!=request.getParameter("confirm_password")){
    // Validate confirm password
    if(request.getParameter("confirm_password").length() == 0){
        confirm_password_err = "Please confirm password";
    } else {
        confirm_password = request.getParameter("confirm_password");
        if(!password.equals(confirm_password)){
            confirm_password_err = "Passwords did not match";
        }
    }
}


if(null!=request.getParameter("firstname") && null!=request.getParameter("lastname") && null!=request.getParameter("email") && null!=request.getParameter("password") && null!=request.getParameter("confirm_password")){

  if(firstname_err.isEmpty() && lastname_err.isEmpty() && email_err.isEmpty() && password_err.isEmpty() && confirm_password_err.isEmpty()){
      
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(password.getBytes());
        byte[] digest = md.digest();
        String hashedPassword = DatatypeConverter.printHexBinary(digest).toUpperCase();
        try{
            // attempt database connection and create PreparedStatements
            sql = conn.prepareStatement("INSERT INTO lecturers (firstname, lastname, email, password) VALUES ('" + firstname+ "','" + lastname + "','" + email + "','" + hashedPassword + "')");    
            sql.executeUpdate(); 
            
            // Redirect to home page
            response.sendRedirect("home.jsp");  
            
            sql.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }   
}



%>


<!DOCTYPE html>
<html lang="en">
    <head> 
        <meta charset="UTF-8">
        <title>Sign Up</title> 
        <link rel="stylesheet" href="styling.css"> 
    </head>
    <body>
        <form action="register.jsp" method="post"> 
            <div class="login_box">  

                <a href="home.jsp">
                   <img src="Images/GMITLogoBig.png" alt="GMIT Logo" width="600" height="200">
                </a>
                <input type="text" name="firstname" class="login_txtbox" placeholder="First Name" value="<%=firstname%>">
                <span class="help-block"><%=firstname_err%></span>

                <input type="text" name="lastname" class="login_txtbox" placeholder="Last Name" value="<%=lastname%>">
                <span class="help-block"><%=lastname_err%></span>

                <input type="text" name="email" class="login_txtbox" placeholder="Email" value="<%=email%>">
                <span class="help-block"><%=email_err%></span>

                <input type="password" name="password" class="login_txtbox" placeholder="Password" value="<%=password%>">
                <span class="help-block"><%=password_err%></span>

                <input type="password" name="confirm_password" class="login_txtbox" placeholder="Confirm Password" value="<%=confirm_password%>">
                <span class="help-block"><%=confirm_password_err%></span>
               
        
                <input type="submit" class="login_btn" value="Submit">
                <input type="reset" class="login_btn2" value="Reset">

            </div>
        </form>          
    </body>		
</html>