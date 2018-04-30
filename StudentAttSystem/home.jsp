<%-- 
    Document   : home
    Author     : Adrian
--%>
<%@ include file="connection.jsp" %>
<%@page import="java.sql.*"%>


<%
// Grab the variables from the form.
if(session.getAttribute("email") == null || session.getAttribute("email") == "" || session.getAttribute("firstname") == null || session.getAttribute("lastname") == null){
    response.sendRedirect("index.jsp");
}
PreparedStatement sql;
%>



<html>
    <head>
        <meta charset="UTF-8">
        <title>Home</title>
        <link rel="stylesheet" href="styling.css"> 
    </head>

    <body>
        <div class="box">

            <a href="home.jsp">
                <img src="Images/GMITLogoBig.png" alt="GMIT Logo" width="600" height="200">
            </a>
	    <div class="title"style="color:#2980b9">Room 508</div>
            <p class="signout"><a href="signout.jsp" style="color:#2980b9">Sign Out</a></p>
	   <a href="student_report.jsp" style="color:#2980b9">Student Reports</a>

            <div class="title" style="margin-bottom:10px;">Lecturer: <%= session.getAttribute("firstname")%> <%= session.getAttribute("lastname")%></div>
            <div style="margin: 0px 20px 10px;">
                <%
               try{
                    // attempt database connection and create PreparedStatements
                    sql = conn.prepareStatement("SELECT ID, ClassName "
                                                    + "FROM classes "
                                                    + "WHERE Lecturer_ID = " + session.getAttribute("ID"));
                    ResultSet sqlRS = sql.executeQuery();
                    if (sqlRS.isBeforeFirst()) {    
                        out.print("<table><tr><th>Classes</th></tr>");
                        while(sqlRS.next()){
                            out.print("<tr><td><a style='color:#000000; text-decoration:none' href='class.jsp?id="+ sqlRS.getString("ID") + "&name=" + sqlRS.getString("ClassName") +"'>" + sqlRS.getString("ClassName") + "</td></tr>");                    
                        }
                        out.print("</table>");
                    } else {
                        out.print("0 Classes Added");
                    }
                    sqlRS.close();
                
                }catch(Exception e){
                   e.printStackTrace();
                }
            %>
      </div>

            <a href="add_class.jsp">
                 <div class="btn">Add New Class</div>
            </a>

        </div>
    </body>
</html>