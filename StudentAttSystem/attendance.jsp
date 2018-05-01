
<%-- 
    Document   : attendance
    Author     : Adrian
--%>


<%@ include file="connection.jsp" %>
<%@page import="java.sql.*"%>

<%
// Grab the variables from the form.
if(session.getAttribute("email") == null || session.getAttribute("email") == "" || session.getAttribute("firstname") == null || session.getAttribute("lastname") == null){
    response.sendRedirect("index.jsp");
}
if(request.getParameter("id") == null || request.getParameter("class_id") == null){
    response.sendRedirect("home.jsp");
}
String students_id = request.getParameter("id");
String students_name = request.getParameter("students_name");
String class_id = request.getParameter("class_id");
PreparedStatement sql;
%>
  
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Attendance</title>
        <link rel="stylesheet" href="styling.css"> 
    </head>

    <body>
        <div class="box">
	<p class="homebutton"><a href="home.jsp" style="color:#2980b9">Home</a></p>
            <a href="home.jsp">
                <img src="Images/GMITLogoBig.png" alt="GMIT Logo" width="600" height="200">
            </a>
	    <p class="signout"><a href="signout.jsp" style="color:#2980b9">Sign Out</a></p>
	    <div class="title"style="color:#2980b9">Room 506</div>
            
            <div class="title" style="margin-bottom:10px;">Student: <%=students_name%></div>
	     <div class="title"> Attendance Records</div>
	    <meta http-equiv="refresh" content="2">
            <div style="margin: 0px 20px 10px;">
            <%
               try{
                    // attempt database connection and create PreparedStatements
                    sql = conn.prepareStatement("SELECT ID, DATE_FORMAT(Datetime, '%W, %e %M %Y') Date, DATE_FORMAT(Datetime, '%T') Time "
                                                    + "FROM attendance "
                                                    + "WHERE Students_ID = " + students_id 
                                                    
                                                );
                    
                    ResultSet sqlRS = sql.executeQuery();
                    if (sqlRS.isBeforeFirst()) {    
                        out.print("<table><tr><th>Date</th><th>Time</th></tr>");
                        while(sqlRS.next()){
                            out.print("<tr>"
                                 + "<td>" + sqlRS.getString("Date") + "</td>"
                                 + "<td style='width:30%'>" + sqlRS.getString("Time") + "</td>"
                                 + "</tr>"); 
                        }
                        out.print("</table>");
                    } else {
                        out.print("0 records");
                    }
                    sqlRS.close();
                
                }catch(Exception e){
                   e.printStackTrace();
                }
            %>
                
            </div>

        </div>
    </body>
</html>