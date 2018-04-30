<%@ include file="connection.jsp" %>
<%@page import="java.sql.*"%>

<%
// Grab the variables from the form.

if(session.getAttribute("email") == null || session.getAttribute("email") == ""){
    response.sendRedirect("index.jsp");
} 

String classname = "";
String lecturer_id = session.getAttribute("ID").toString() ;

String classname_err = "";

PreparedStatement sql;

if(null!=request.getParameter("classname")){
    // Validate classname
    if(request.getParameter("classname") == null || request.getParameter("classname").length() == 0){
        classname_err = "Please enter a class name";
    } else if(request.getParameter("classname").length() < 3){
        classname_err = "Class name must have at least 3 characters";
    } else {
        classname = request.getParameter("classname");
 try{
            // attempt database connection and create PreparedStatements
            sql = conn.prepareStatement("SELECT ID "
                                        + "FROM classes "
                                        + "WHERE ClassName = '" + classname + "'" );

            ResultSet sqlRS = sql.executeQuery();

            if(sqlRS.next()) {   
                classname_err = "Class already entered.";
            }else {
                classname = request.getParameter("classname");
            }
            sqlRS.close();

        }catch(Exception e){
            e.printStackTrace();
        }
    }
}  
if(null!=request.getParameter("classname")){ 
    // Check input errors before inserting in database
    if(classname_err.isEmpty()){

        try{
            // attempt database connection and create PreparedStatements
            sql = conn.prepareStatement("INSERT INTO classes (classname, lecturer_id) VALUES ('" + classname + "','"+ lecturer_id +"')");

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

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Add Class</title>
        <link rel="stylesheet" href="styling.css">    
    </head>
    <body>
        <form action="add_class.jsp" method="post"> 
            <div class="login_box">  

                <a href="home.jsp">
                    <img src="Images/GMITLogoBig.png" alt="GMIT Logo" width="600" height="200">
                </a>

                <input type="text" name="classname" class="login_txtbox" placeholder="Class Name" value="<%=classname%>">
                <span class="help-block"><%=classname_err%></span>
                
                <input type="submit" class="login_btn" value="Submit">
                <input type="reset" class="login_btn2" value="Reset">

            </div> 
        </form>          
    </body>	
</html>
