<!-- 과목 삭제 query -->
<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<% request.setCharacterEncoding("utf-8"); %>

<!-- 로그인 여부 검사 -->
<%
if (session.getAttribute("id") == null) {
	out.println("<script>alert('로그인을 하지 않았습니다.'); location.href='admin_login.html';</script>;");
}
else if (request.getParameter("id") == null) {
	out.println("<script>alert('잘못된 접근입니다!'); location.href='admin_course_registration.jsp';</script>;");
}
else {
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rset = null;

	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registration?characterEncoding=UTF-8&serverTimezone=UTC", "root", "root1234");

	String id_s = request.getParameter("id");
	int id = Integer.parseInt(id_s);

	// delete query
	String select_sql = "DELETE FROM course where id=?";
	pstmt = conn.prepareStatement(select_sql);
	pstmt.setInt(1, id);
	pstmt.executeUpdate();

	if(rset != null) rset.close();
	if(pstmt != null) pstmt.close();
	if(conn != null) conn.close();

	out.println("<script>alert('삭제 완료.'); location.href='admin_course_registration.jsp';</script>");
}
%>