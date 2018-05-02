<%-- 
    Document   : edit_student
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

String firstname = "";
String lastname = "";
String email = "";
String student_id = "";
String RFID = "";

String firstname_err = "";
String lastname_err = "";
String email_err = "";
String student_id_err = "";
String RFID_err = "";

PreparedStatement sql;

try{
    // attempt database connection and create PreparedStatements
    sql = conn.prepareStatement("SELECT S.Firstname, S.Lastname, S.Email, S.Student_ID, S.RFID "
                                + "FROM students S "
                                + "WHERE S.ID = " + students_id);

    ResultSet sqlRS = sql.executeQuery();    
    
    if (sqlRS.isBeforeFirst()) { 
        sqlRS.next();
        
        firstname = sqlRS.getString("Firstname");
        lastname = sqlRS.getString("Lastname");
        email = sqlRS.getString("Email");
        student_id = sqlRS.getString("Student_ID");
        RFID = sqlRS.getString("RFID");
    }
    sqlRS.close();

}catch(Exception e){
    e.printStackTrace();
}

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
        email_err = "Please enter your email address.";
    } else {
        email = request.getParameter("email");

        try{
            // attempt database connection and create PreparedStatements
            sql = conn.prepareStatement("SELECT ID "
                                        + "FROM lecturers "
                                        + "WHERE Email = '" + email + "'" );

            ResultSet sqlRS = sql.executeQuery();

            if(sqlRS.next()) {   
                email_err = "This email is already taken.";
            }else {
                email = request.getParameter("email");
            }
            sqlRS.close();

        }catch(Exception e){
            e.printStackTrace();
        }
    }
}

if(null!=request.getParameter("student_id")){
    // Validate lastname
    if(request.getParameter("student_id").length() == 0){
        student_id_err = "Please enter a student ID.";     
    } else if(request.getParameter("student_id").length() < 9){
        student_id_err = "Student ID must have at least 9 characters.";
    } else{
        student_id = request.getParameter("student_id");
    }
}

if(null!=request.getParameter("RFID")){
    // Validate lastname
    if(request.getParameter("RFID").length() == 0){
        RFID_err = "Please scan a new student card.";     
    } else{
        RFID = request.getParameter("RFID");
    }
}

if(null!=request.getParameter("firstname") && null!=request.getParameter("lastname") && null!=request.getParameter("email") && null!=request.getParameter("student_id") && null!=request.getParameter("RFID")){ 
    // Check input errors before inserting in database
    if(firstname_err.isEmpty() && lastname_err.isEmpty() && email_err.isEmpty() && student_id_err.isEmpty() && RFID_err.isEmpty()){
        try{
            // attempt database connection and create PreparedStatements
            sql = conn.prepareStatement("UPDATE students SET firstname = '" + firstname + "', lastname = '" + lastname + "', email = '" + email + "', student_id = '" + student_id + "', RFID = '" + RFID + "' WHERE ID = "+ students_id);
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

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Edit Student</title>
        <link rel="stylesheet" href="styling.css">    
    </head>
    <body>
        <form action="edit_student.jsp?id=<%=class_id%>&name=<%=class_name%>&sid=<%=students_id%>" method="post">      
            <div class="login_box">  

                <a href="home.php">
                    <img src="Images/GMITLogoBig.png" alt="GMIT Logo" width="600" height="200">
                </a>

                 <input type="text" name="firstname" class="login_txtbox" placeholder="First Name" value="<%=firstname%>">
                <span class="help-block"><%=firstname_err%></span>

                <input type="text" name="lastname" class="login_txtbox" placeholder="Last Name" value="<%=lastname%>">
                <span class="help-block"><%=lastname_err%></span>

                <input type="text" name="email" class="login_txtbox" placeholder="Email" value="<%=email%>">
                <span class="help-block"><%=email_err%></span>

                <input type="text" name="student_id" class="login_txtbox" placeholder="Student ID" value="<%=student_id%>">
                <span class="help-block"><%=student_id_err%></span>

                <input type="text" name="RFID" class="login_txtbox" placeholder="Scan New Student Card" value="<%=RFID%>">
                <span class="help-block"><%=RFID_err%></span>
                
                <input type="submit" class="login_btn" value="Submit">
                <input type="reset" class="login_btn2" value="Reset">

            </div>
        </form>          
    </body>
</html>


