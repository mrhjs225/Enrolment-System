<!-- 과목 삭제 query -->
<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<% request.setCharacterEncoding("utf-8"); %>

<!-- 로그인 여부 검사 -->
<%
if (session.getAttribute("id") == null) {
	out.println("<script>alert('로그인을 하지 않았습니다.'); location.href='student_login.html';</script>;");
}
else if ((request.getParameter("student_id") == null) || (request.getParameter("course_id") == null)) {
	out.println("<script>alert('잘못된 접근입니다!'); location.href='student_wishlist.jsp';</script>;");
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

	// delete query
	String delete_sql = "DELETE FROM sugang where student_id=? AND course_id=?";
	pstmt = conn.prepareStatement(delete_sql);
	pstmt.setString(1, student_id);
	pstmt.setInt(2, course_id);
	pstmt.executeUpdate();

	// 수강 인원 감소시키기
	String sql= "SELECT * FROM course WHERE id=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, course_id);
	rset = pstmt.executeQuery();
	rset.next();
	int reg_count = rset.getInt("reg_count");
	int grade = rset.getInt("grade");
	reg_count -= 1;

	sql = "UPDATE course SET reg_count=? WHERE id=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, reg_count);
	pstmt.setInt(2, course_id);
	pstmt.executeUpdate();

	// 수강 가능 학점 업데이트
	sql = "SELECT * FROM student WHERE student_id =?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, student_id);
	rset = pstmt.executeQuery();
	rset.next();
	int valid_grade = rset.getInt("valid_grade");
	valid_grade += grade;

	sql = "UPDATE student SET valid_grade=? WHERE student_id=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, valid_grade);
	pstmt.setString(2, student_id);
	pstmt.executeUpdate();

	if(rset != null) rset.close();
	if(pstmt != null) pstmt.close();
	if(conn != null) conn.close();

	out.println("<script>alert('삭제 완료'); location.href='student_wishlist.jsp';</script>");
}
%>