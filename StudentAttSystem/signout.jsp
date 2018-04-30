<%-- 
    Document   : signout
    Author     : Adrian
--%>

<%
session.setAttribute("email", null);
session.invalidate();
response.sendRedirect("index.jsp");
%>
