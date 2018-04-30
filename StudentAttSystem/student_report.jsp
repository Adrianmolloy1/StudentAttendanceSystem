<%-- 
    Document   : student_report
    Author     : Adrian
--%>
<%@ include file="connection.jsp" %>
<%@page import="java.sql.*"%>

<%
// Grab the variables from the form.
if(session.getAttribute("email") == null || session.getAttribute("email") == ""){
    response.sendRedirect("index.jsp");
} 
PreparedStatement sql;
%>


<html>
    <head>
        <meta charset="UTF-8">
        <title>Student Reports</title>
        <link rel="stylesheet" href="styling.css"> 
    </head>

    <body>
        <div class="box">
	<p class="homebutton"><a href="home.jsp" style="color:#2980b9">Home</a></p>
            <a href="home.jsp">
                <img src="Images/GMITLogoBig.png" alt="GMIT Logo" width="600" height="200">
            </a>
	    <p class="signout"><a href="signout.jsp" style="color:#2980b9">Sign Out</a></p>
	    <div class="title"style="color:#2980b9">Room 508</div>
 	   <div class="title"> Students Reports</div>
            
            <div style="margin: 0px 20px 10px;">
                
    <%
                try{
                    // attempt database connection and create PreparedStatements
			
                    sql = conn.prepareStatement("SELECT T.FirstName, T.LastName, T.Student_ID, COUNT(*) AS DaysAttended "
                                                    + "FROM ( "
						    + "		SELECT COUNT(A.ID), DATE(A.Datetime) AS Date, A.Students_ID, S.FirstName, S.LastName, S.Student_ID "
						    + "		FROM attendance A "
						    + "		LEFT JOIN students S ON A.Students_ID = S.ID "
						    + "		GROUP BY Date, Students_ID "
						    + ")T "
						    + "GROUP BY T.FirstName ");
                    ResultSet sqlRS = sql.executeQuery();
                    if (sqlRS.isBeforeFirst()) {    
                        out.print("<table><tr><th>Student Name</th><th>Student ID</th><th>Attended</th></tr>");
                        while(sqlRS.next()){
                            out.print("<tr>"
                                    + "<td>" + sqlRS.getString("Firstname") + " " + sqlRS.getString("Lastname") + "</td>"
                                    + "<td>" + sqlRS.getString("Student_ID") + "</td>"
                    		    + "<td style='width:20%'>" + sqlRS.getString("DaysAttended") + "</td>"
                                    + "</tr>");                  
                        }
                        out.print("</table>");
                    } else {
                        out.print("0 Reports Found");
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
