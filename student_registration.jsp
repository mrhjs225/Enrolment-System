<!-- 학생 등록 query -->
<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<% request.setCharacterEncoding("utf-8"); %>

<!-- 로그인 여부 검사 -->
<%
if (session.getAttribute("id") == null) {
	out.println("<script>alert('로그인을 하지 않았습니다.'); location.href='admin_login.html';</script>;");
}
else if (request.getParameter("student_id") == null) {
	out.println("<script>alert('잘못된 접근입니다!'); location.href='admin_student_registration.jsp';</script>;");
}
else {
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rset = null;

	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registration?characterEncoding=UTF-8&serverTimezone=UTC", "root", "root1234");

	// 전송받은 데이터 추출
	String student_id = request.getParameter("student_id");
	String student_pw = request.getParameter("student_pw");
	String student_name = request.getParameter("student_name");
	String student_year_s = request.getParameter("student_year");
	int student_year = Integer.parseInt(student_year_s);
	String student_credit_s = request.getParameter("student_credit");
	int student_credit = Integer.parseInt(student_credit_s);

	// 중복 학번 체크
	String select_sql = "SELECT * FROM student WHERE student_id=?";
	pstmt = conn.prepareStatement(select_sql);
	pstmt.setString(1, student_id);
	rset = pstmt.executeQuery();

	if(!rset.next()) {
		// table에 tuple 추가하는 부분
		String insert_sql = "INSERT INTO student VALUES(?,?,?,?,?,?);";
		pstmt = conn.prepareStatement(insert_sql);
		pstmt.setString(1, student_id);
		pstmt.setString(2, student_pw);
		pstmt.setString(3, student_name);
		pstmt.setInt(4, student_year);
		pstmt.setInt(5, student_credit);
		pstmt.setInt(6, student_credit);
		pstmt.executeUpdate();
		out.println("<script>alert('등록 완료'); location.href='admin_student_registration.jsp';</script>");
	}
	else {
		out.println("<script>alert('이미 등록한 학생입니다.'); location.href='admin_student_registration.jsp';</script>");
	}

	if(rset != null) rset.close();
	if(pstmt != null) pstmt.close();
	if(conn != null) conn.close();
}
%>