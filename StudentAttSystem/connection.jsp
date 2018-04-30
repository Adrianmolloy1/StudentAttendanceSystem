<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>

<%
    String host = "jdbc:mysql://localhost:3306/StudentAttSystem";
    String uname = "root";
    String pword = "adrian";
    
    Connection conn;
    
    Class.forName( "com.mysql.jdbc.Driver" );
    conn = DriverManager.getConnection(host, 
            uname, 
            pword);
%>