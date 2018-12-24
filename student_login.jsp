<!-- student인지 확인 -->

<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<% request.setCharacterEncoding("utf-8"); %>

<!-- 디비에 있는지 검사 -->
<%
String id = request.getParameter("student_id");
String pass = request.getParameter("student_pw");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rset = null;

Class.forName("com.mysql.jdbc.Driver");
conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registration?characterEncoding=UTF-8&serverTimezone=UTC", "root", "root1234");

String sqlStr = "SELECT * FROM student WHERE student_id= ?";
pstmt = conn.prepareStatement(sqlStr);
pstmt.setString(1, id);
rset = pstmt.executeQuery();

if(rset.next() == false) {
	out.println("<script>alert('ID가 존재하지 않습니다.'); location.href='student_login.html';</script>");
} else {
	String password;
	password = rset.getString("password");

	if(password.equals(pass)) {
		session.setAttribute("id", id);
		session.setAttribute("pw", pass);
		out.println("<script>location.href='student_wishlist.jsp';</script>");
	}
	else {
		out.println("<script>alert('PW를 잘못 입력했습니다.'); location.href='student_login.html';</script>");
	}
}

if(rset != null) rset.close();
if(pstmt != null) pstmt.close();
if(conn != null) conn.close();
%>