<%-- 
    Document   : class
    Author     : Adrian
--%>
<%@ include file="connection.jsp" %>
<%@page import="java.sql.*"%>

<%
// Grab the variables from the form.
if(session.getAttribute("email") == null || session.getAttribute("email") == ""){
    response.sendRedirect("index.jsp");
} 
if(request.getParameter("id") == null || request.getParameter("name") == null){
    response.sendRedirect("home.jsp");
}
String class_id = request.getParameter("id");
String class_name = request.getParameter("name");
PreparedStatement sql;
%>


<html>
    <head>
        <meta charset="UTF-8">
        <title><%=class_name%></title>
        <link rel="stylesheet" href="styling.css"> 
    </head>

    <body>
        <div class="box">
	<p class="homebutton"><a href="home.jsp" style="color:#2980b9">Home</a></p>
            <a href="home.jsp">
                <img src="Images/GMITLogoBig.png" alt="GMIT Logo" width="600" height="200">
            </a>
	    <div class="title"style="color:#2980b9">Room 508</div>
            <p class="signout"><a href="signout.jsp" style="color:#2980b9">Sign Out</a></p>
 	    <a href="student_report.jsp" style="color:#2980b9">Student Reports</a>
            <div class="title" style="margin-bottom:10px;">Lecturer: <%= session.getAttribute("firstname")%> <%= session.getAttribute("lastname")%></div>
           <div class="title">Class: <%=class_name%></div>
            <div style="margin: 0px 20px 10px;">
                
    <%
                try{
                    // attempt database connection and create PreparedStatements
                    sql = conn.prepareStatement("SELECT S.ID, S.Firstname, S.Lastname, S.Student_ID, S.RFID, CS.Attendance FROM students S "
                                                    + "LEFT JOIN class_students CS ON S.ID = CS.Students_ID "
                                                    + "LEFT JOIN classes C ON CS.Class_ID = C.ID "
                                                    + "WHERE C.ID = " + class_id);
                    ResultSet sqlRS = sql.executeQuery();
                    if (sqlRS.isBeforeFirst()) {    
                        out.print("<table><tr><th>Student Name</th><th>Student ID</th><th>RFID Number</th></tr>");
                        while(sqlRS.next()){
                            out.print("<tr>"
                                    + "<td><a style='color:#000000; text-decoration:none' href='attendance.jsp?id=" + sqlRS.getString("ID") + "&students_name=" + sqlRS.getString("Firstname") + " " + sqlRS.getString("Lastname") + "&class_id=" + class_id + "'>"
                                    + sqlRS.getString("Firstname") + " " + sqlRS.getString("Lastname") + "</a></td>"
                                    + "<td>" + sqlRS.getString("Student_ID") + "</td>"
                                    + "<td>" + sqlRS.getString("RFID") + "</td>"
                                    + "<td style='width:10%'><a href='edit_student.jsp?id=" + class_id + "&name="+ class_name +"&sid=" + sqlRS.getString("ID") + "' style='color:#2980b9'>Edit</a></td>"
                                    + "<td style='width:10%'><a href='remove_student.jsp?id=" + class_id + "&name="+ class_name +"&sid=" + sqlRS.getString("ID") + "' style='color:#2980b9'>Remove</a></td>"
                                    + "</tr>");                  
                        }
                        out.print("</table>");
                    } else {
                        out.print("0 Students Added");
                    }
                    sqlRS.close();
                
                }catch(Exception e){
                   e.printStackTrace();
                }
            %>  
       
            </div>			

            <a href='add_new_student.jsp?id=<%=class_id%>&name=<%=class_name%>'>
                <div class="btn">Add New Student</div>
            </a>
            <a href='add_existing_student.jsp?id=<%=class_id%>&name=<%=class_name%>'>
                <div class="btn2">Add Existing Student</div>
            </a>

        </div>	
    </body>
</html>