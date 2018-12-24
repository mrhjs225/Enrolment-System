<!-- admin인지 확인 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%
String id = request.getParameter("admin_id");
String pass = request.getParameter("admin_pw");

if(id.equals("admin") && pass.equals("1234")){
	session.setAttribute("id", id);
	session.setAttribute("pw", pass);
	out.println("<script>location.href='admin_student_registration.jsp';</script>");
}
else {
	out.println("<script>alert('ID 또는 PW를 잘못 입력했습니다.'); location.href='admin_login.html';</script>");
}		
%>