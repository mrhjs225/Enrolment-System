<!-- 과목 등록 query -->
<!DOCTYPE html>

<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<% request.setCharacterEncoding("utf-8"); %>

<!-- 로그인 여부 검사 -->
<%
if (session.getAttribute("id") == null) {
	out.println("<script>alert('로그인을 하지 않았습니다.'); location.href='admin_login.html';</script>;");
}
else if (request.getParameter("course_name") == null) {
	out.println("<script>alert('잘못된 접근입니다!'); location.href='admin_course_registration.jsp';</script>;");
}
else {
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;

	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registration?characterEncoding=UTF-8&serverTimezone=UTC", "root", "root1234");

	// 전송받은 데이터 추출
	String course_name = request.getParameter("course_name");
	
	String course_prof = request.getParameter("course_prof");
	
	String course_number_s = request.getParameter("course_number");
	int course_number = Integer.parseInt(course_number_s);
	
	String course_location = request.getParameter("course_location");
	
	String course_year_s = request.getParameter("course_year");
	int course_year = Integer.parseInt(course_year_s);
	
	String course_grade_s = request.getParameter("course_grade");
	int course_grade = Integer.parseInt(course_grade_s);
	
	String course_time_s = request.getParameter("times");
	int course_time = Integer.parseInt(course_time_s);
	
	String[] days = request.getParameterValues("days");
	String course_days = "";
	for(int i = 0; i < days.length; i++) {
		course_days += days[i];
		if ( i < days.length-1) {
			course_days += ",";
		}
	}
	// table에 tuple 추가하는 부분
	String insert_sql = "INSERT INTO course(name, prof, number, location, year, grade, time, days, reg_count) VALUES(?,?,?,?,?,?,?,?,?);";
	pstmt = conn.prepareStatement(insert_sql);
	pstmt.setString(1, course_name);
	pstmt.setString(2, course_prof);
	pstmt.setInt(3, course_number);
	pstmt.setString(4, course_location);
	pstmt.setInt(5, course_year);
	pstmt.setInt(6, course_grade);
	pstmt.setInt(7, course_time);
	pstmt.setString(8, course_days);
	pstmt.setInt(9, 0);
	pstmt.executeUpdate();
	out.println("<script>alert('등록 완료'); location.href='admin_course_registration.jsp';</script>");

	if(pstmt != null) pstmt.close();
	if(conn != null) conn.close();
}
%>