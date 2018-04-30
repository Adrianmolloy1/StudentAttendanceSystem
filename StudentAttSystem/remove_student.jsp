<%-- 
    Document   : remove_student
    Author     : Adrian
--%>
<%@ include file="connection.jsp" %>
<%@page import="java.sql.*"%>

<%
// Grab the variables from the form.

if(session.getAttribute("email") == null || session.getAttribute("email") == ""){
    response.sendRedirect("index.jsp");
} 

String students_id = request.getParameter("sid");
String class_id = request.getParameter("id");
String class_name = request.getParameter("name");

PreparedStatement sql;

try{
    // attempt database connection and create PreparedStatements
    sql = conn.prepareStatement("DELETE FROM class_students WHERE class_id = '" + class_id + "' AND students_id ='" + students_id + "'");
    sql.executeUpdate();

    // Redirect to home page
    response.sendRedirect("class.jsp?id=" + class_id + "&name=" + class_name); 

    sql.close();

}catch(Exception e){
    e.printStackTrace();
}

%>
