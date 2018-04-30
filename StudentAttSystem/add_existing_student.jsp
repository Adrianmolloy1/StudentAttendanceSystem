<%-- 
    Document   : add_existing_student
    Author     : Adrian
--%>

<%@ include file="connection.jsp" %>
<%@page import="java.sql.*"%>

<%
// Grab the variables from the form.

if(session.getAttribute("email") == null || session.getAttribute("email") == ""){
    response.sendRedirect("index.jsp");
} 

String class_id = request.getParameter("id");
String class_name = request.getParameter("name");

String students_id = "";
String students_id_err = "";

PreparedStatement sql;


if(null!=request.getParameter("student")){
   
    if(request.getParameter("student").length() == 0){
        students_id_err = "Please select a student";
    } else {
        students_id = request.getParameter("student");
   
    }
}
    
if(null!=request.getParameter("student")){ 
    // Check input errors before inserting in database
    if(students_id_err.isEmpty() ){

        try{
            // attempt database connection and create PreparedStatements
            sql = conn.prepareStatement("INSERT INTO class_students (class_id, students_id) VALUES ('" + class_id + "', '" + students_id + "')");
           
            sql.executeUpdate();
            // Redirect to home page
            response.sendRedirect("class.jsp?id=" + class_id + "&name=" + class_name);  

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
        <title>Add Existing Student</title>
        <link rel="stylesheet" href="styling.css">    
    </head>
    <body>
        <form action="add_existing_student.jsp?id=<%=class_id%>&name=<%=class_name%>" method="post"> 
            <div class="login_box">  

                <a href="home.jsp">
                    <img src="Images/GMITLogoBig.png" alt="GMIT Logo" width="600" height="200">
                </a>

                <%
                    try{
                        // attempt database connection and create PreparedStatements
                        sql = conn.prepareStatement("SELECT ID, Firstname, Lastname, Student_ID FROM students ");

                        ResultSet sqlRS = sql.executeQuery();
                        if (sqlRS.isBeforeFirst()) {    

                            out.print("<select name='student' class='dropdownbox'>");
                            out.print("<option value=null selected disabled>Select a student</option>");
                            
                            while(sqlRS.next()){
                                out.print("<option value='" + sqlRS.getString("ID") + "'>" + sqlRS.getString("Firstname") + " " + sqlRS.getString("Lastname") + " (" + sqlRS.getString("Student_ID") + ")</option>");                    
                            }

                            out.print("</select>");
                        } else {
                            out.print("");
                        }

                        sqlRS.close();
                    }catch(Exception e){
                        e.printStackTrace();
                    }
                %>
                <span class="help-block"><%=students_id_err%></span>
                
                <input type="submit" class="login_btn" value="Submit">
                <input type="reset" class="login_btn2" value="Reset">

            </div>
        </form>          
    </body>	
</html>
