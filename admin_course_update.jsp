<!-- 과목 수정 페이지 -->
<!DOCTYPE html>

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
%>

<html>
	<head>
		<title>course update page</title>
		<style>
			section {
				margin-top: 10px;
				padding: 10px;
			}
			section table {
				border: 1px solid black;
				margin:	20px auto;
			}
			section table caption {
				text-align: center;
				font-weight: bold;
				font-size: 20px;
			}
			section table th, section table td {
				padding: 5px 10px;
			}
		</style>
	</head>
	<body>
		<%
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registration?characterEncoding=UTF-8&serverTimezone=UTC", "root", "root1234");

		String id_s = request.getParameter("id");
		int id = Integer.parseInt(id_s);

		String select_sql = "SELECT * FROM course where id=?";
		pstmt = conn.prepareStatement(select_sql);
		pstmt.setInt(1, id);
		rset = pstmt.executeQuery();
		rset.next();	// 불러온 데이터에서 첫 줄 선택

		String name = rset.getString("name");
		String prof = rset.getString("prof");
		int number = rset.getInt("number");
		String location = rset.getString("location");
		int year = rset.getInt("year");
		int grade = rset.getInt("grade");
		int time = rset.getInt("time");
		String day = rset.getString("days");
		String[] days = day.split(",");
		%>
		<section>
			<form action="course_update.jsp" method="POST">
				<input type="hidden" name="id" value="<%= id %>">
				<table>
					<caption>
						수정할 항목
					</caption>
					<tr>
						<td>강의명:</td>
						<td><input type="text" size="15" name="course_name" value="<%= name %>"></td>
					</tr>
					<tr>
						<td>강사명:</td>
						<td><input type="text" size="15" name="course_prof" value="<%= prof %>"></td>
					</tr>
					<tr>
						<td>수강인원:</td>
						<td><input type="text" size="15" name="course_number" value="<%= number %>"></td>
					</tr>
					<tr>
						<td>강의실</td>
						<td><input type="text" size="15" name="course_location" value="<%= location %>"></td>
					</tr>
					<tr>
						<td>수강대상학년</td>
						<td><input type="text" size="15" name="course_year" value="<%= year %>"></td>
					</tr>
					<tr>
						<td>학점</td>
						<td><input type="text" size="15" name="course_grade" value="<%= grade %>"></td>
					</tr>
					<tr>
						<td>수업시간:</td>
                        <td>
                            <select name ="times">
                            	<%
								if (time == 1)
									out.print("<option value='1' selected>1교시</option>");
								else
									out.print("<option value='1'>1교시</option>");
								%>
                            	<%
								if (time == 2)
									out.print("<option value='2' selected>2교시</option>");
								else
									out.print("<option value='2'>2교시</option>");
								%>
                            	<%
								if (time == 3)
									out.print("<option value='3' selected>3교시</option>");
								else
									out.print("<option value='3'>3교시</option>");
								%>
                            	<%
								if (time == 4)
									out.print("<option value='4' selected>4교시</option>");
								else
									out.print("<option value='4'>4교시</option>");
								%>
                            	<%
								if (time == 5)
									out.print("<option value='5' selected>5교시</option>");
								else
									out.print("<option value='5'>5교시</option>");
								%>
                            	<%
								if (time == 6)
									out.print("<option value='6' selected>6교시</option>");
								else
									out.print("<option value='6'>6교시</option>");
								%>
                            </select>
                        </td>
					</tr>
					<tr>
						<td>수업날짜:</td>
						<td>
							<%
							// 월요일
							int checked = 0;
							for(int i=0; i<days.length; i++) {
								if (days[i].equals("Mon")) {
									checked = 1;
									out.print("<input type='checkbox' name='days' value='Mon' checked>월요일");
									break;
								}
							}
							if (checked == 0)
								out.print("<input type='checkbox' name='days' value='Mon'>월요일");

							// 화요일
							checked = 0;
							for(int i=0; i<days.length; i++) {
								if (days[i].equals("Tue")) {
									checked = 1;
									out.print("<input type='checkbox' name='days' value='Tue' checked>화요일<br>");
									break;
								}
							}
							if (checked == 0)
								out.print("<input type='checkbox' name='days' value='Tue'>화요일<br>");

							// 수요일
							checked = 0;
							for(int i=0; i<days.length; i++) {
								if (days[i].equals("Wen")) {
									checked = 1;
									out.print("<input type='checkbox' name='days' value='Wen' checked>수요일");
									break;
								}
							}
							if (checked == 0)
								out.print("<input type='checkbox' name='days' value='Wen'>수요일");

							// 목요일
							checked = 0;
							for(int i=0; i<days.length; i++) {
								if (days[i].equals("Thu")) {
									checked = 1;
									out.print("<input type='checkbox' name='days' value='Thu' checked>목요일<br>");
									break;
								}
							}
							if (checked == 0)
								out.print("<input type='checkbox' name='days' value='Thu'>목요일<br>");

							// 금요일
							checked = 0;
							for(int i=0; i<days.length; i++) {
								if (days[i].equals("Fri")) {
									checked = 1;
									out.print("<input type='checkbox' name='days' value='Fri' checked>금요일");
									break;
								}
							}
							if (checked == 0)
								out.print("<input type='checkbox' name='days' value='Fri'>금요일");
							%>
						</td>
					</tr>
					<tr style="text-align: center;">
						<td><input type="submit" value="수정하기"></td>
						<td><input type="button" value="돌아가기" onclick="javascript:location.href='admin_course_registration.jsp';"></td>
					</tr>
				</table>
			</form>
		</section>
	</body>
</html>
<%
}
%>