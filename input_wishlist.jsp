<!-- 과목 삭제 query -->
<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<% request.setCharacterEncoding("utf-8"); %>

<!-- 로그인 여부 검사 -->
<%
if (session.getAttribute("id") == null) {
	out.println("<script>alert('로그인을 하지 않았습니다.'); location.href='admin_login.html';</script>;");
}
else if ((request.getParameter("student_id") == null) || (request.getParameter("course_id") == null)) {
	out.println("<script>alert('잘못된 접근입니다!'); location.href='admin_course_registration.jsp';</script>;");
}
else {
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rset = null;

	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registration?characterEncoding=UTF-8&serverTimezone=UTC", "root", "root1234");

	// 전송받은 데이터 추출
	String student_id = request.getParameter("student_id");
	String course_id_s = request.getParameter("course_id");
	int course_id = Integer.parseInt(course_id_s);

	// table에 tuple 추가하는 부분 및 중복확인
	String sql = "SELECT * FROM sugang WHERE student_id =? && course_id=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, student_id);
	pstmt.setInt(2, course_id);
	rset = pstmt.executeQuery();

	if(!rset.next()) {
		String insert_sql = "INSERT INTO sugang VALUES(?,?,?);";
		pstmt = conn.prepareStatement(insert_sql);
		pstmt.setString(1, student_id);
		pstmt.setInt(2, course_id);
		pstmt.setInt(3, 0);
		pstmt.executeUpdate();
		out.println("<script>alert('담기 완료'); location.href='student_course_list.jsp';</script>");
	}
	else {
		out.println("<script>alert('이미 담은 강의입니다'); location.href='student_course_list.jsp';</script>");
	}
	
	if(rset != null) rset.close();
	if(pstmt != null) pstmt.close();
	if(conn != null) conn.close();
}
%>