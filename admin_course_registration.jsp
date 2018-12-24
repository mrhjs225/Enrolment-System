<!-- 과목 등록 페이지 -->
<!DOCTYPE html>

<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<% request.setCharacterEncoding("utf-8"); %>

<!-- 로그인 여부 검사 -->
<%
if (session.getAttribute("id") == null) {
	out.println("<script>alert('로그인을 하지 않았습니다.'); location.href='admin_login.html';</script>");
}
%>

<html>
	<head>
		<title>수업 관리</title>
		<style>
			.wrap {
				padding : 1% 5% 2% 5%;
			}
			header {
				margin: 0;
				padding: 20px;
				text-align: center;
				font-size: 30px;
				font-weight: bold;
				color: #e3e3e3;
				background-color: #034ea2;
			}

			nav ul {
				list-style-type: none;
				margin: 0;
				padding: 0;
				overflow: hidden;
    			background-color: #151515;
			}
			nav ul li {
				float: left;
			}
			nav ul li a {
				display: block;
				padding: 14px 50px;
				text-decoration: none;
				text-align: center;
				font-size: 15px;
				font-weight: bold;
				color: white;
			}
			nav ul li a:hover:not(.active) {
				background-color: #4da9e1;
			}
			nav ul a.active {
				color: #ead0b8;
				background-color: #287bc1;
			}

			section {
				padding : 10px;
			}
			section table {
				margin:	20px auto;
			}
			#course_registration th, section table td {
				padding: 5px 10px;
			}
			#course_list {
				border: 1px solid black;
				border-collapse: collapse;
				background:#eeeeee;
				text-align: center;
				width: 100%;
			}
            #course_list th {
                background-color: #bebebe;
            }
			#course_list th, section table td {
				padding: 5px 10px;
			}
			.logout_bar {
                text-align: right;
            }
			.subtitle {
				text-align: center;
				font-size: 2em;
				font-weight: bold;
				margin: 1em 0 1em 0;
			}
			tr td a:link, tr td a:visited {color:#088A08; text-decoration:none;}
			tr td a:hover {text-decoration: underline;}
		</style>
	</head>
	<body>
	<!-- 수업 정보: 강의명, 강사명, 수강인원, 강의실, 수강대상학년, 학점 -->
		<div class="wrap">
			<header>
				수강신청 홈페이지 - 수업 등록 페이지
			</header>
			<nav>
				<ul>
					<li><a href="admin_student_registration.jsp">학생 등록</a></li>
					<li><a class="active" href="admin_course_registration.jsp">수업 등록</a></li>
					<li><a href="admin_course_list.jsp">수업 목록</a></li>
				</ul>
			</nav>
			<p class ="logout_bar">
				관리자님 환영합니다!
				<button onclick="location.href='admin_logout.jsp'">로그아웃</button>
			</p>
			<section>
				<p class = "subtitle">
					수업 등록
				</p>
				<form action="course_registration.jsp" method="POST">
					<table id="course_registration">
						<tr>
							<td>강의명:</td>
							<td><input type="text" size="15" name="course_name" required></td>
						</tr>
						<tr>
							<td>강사명:</td>
							<td><input type="text" size="15" name="course_prof" required></td>
						</tr>
						<tr>
							<td>수강인원:</td>
							<td><input type="text" size="15" name="course_number" required placeholder="숫자만 적어주세요."></td>
						</tr>
						<tr>
							<td>강의실:</td>
							<td><input type="text" size="15" name="course_location" required></td>
						</tr>
						<tr>
							<td>수강대상학년:</td>
							<td><input type="text" size="15" name="course_year" required placeholder="숫자만 적어주세요."></td>
						</tr>
						<tr>
							<td>학점:</td>
							<td><input type="text" size="15" name="course_grade" required placeholder="숫자만 적어주세요."></td>
						</tr>
						<tr>
							<td>수업시간:</td>
                            <td>
                                <select name ="times">
                                    <option value="1">1교시</option>
                                    <option value="2">2교시</option>
                                    <option value ="3">3교시</option>
                                    <option value ="4">4교시</option>
                                    <option value ="5">5교시</option>
                                    <option value ="6">6교시</option>
                                </select>
                            </td>
						</tr>
						<tr>
							<td>수업날짜:</td>
							<td>
								<input type="checkbox" name="days" value="Mon">월요일
								<input type="checkbox" name="days" value="Tue">화요일<br>
								<input type="checkbox" name="days" value="Wen">수요일
								<input type="checkbox" name="days" value="Thu">목요일<br>
								<input type="checkbox" name="days" value="Fri">금요일
							</td>
						</tr>
						<tr style="text-align: center;">
							<td colspan="2"><input type="submit" value="등록하기"></td>
						</tr>
					</table>
				</form>

				<%
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = null;
				PreparedStatement pstmt = null;
				ResultSet rset = null;

				conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registration?characterEncoding=UTF-8&serverTimezone=UTC", "root", "root1234");

				// table에 있는 tuple 불러오기
				String select_sql = "SELECT * FROM course";
				pstmt = conn.prepareStatement(select_sql);
				rset = pstmt.executeQuery();
				%>
				<hr>
				<p class="subtitle">
					수업 목록
				</p>
				<table id="course_list" border="1">
					<tr>
						<th>강의명</th>
						<th>강사명</th>
						<th>수강인원</th>
						<th>강의실</th>
						<th>수강대상학년</th>
						<th>학점</th>
						<th>시간</th>
						<th>요일</th>
						<th>수정</th>
						<th>삭제</th>
					</tr>

				<%
				// select된 tuple들을 table에 추가
				while (rset.next()) {
					int id = rset.getInt("id");
					String name = rset.getString("name");
					String prof = rset.getString("prof");
					int number = rset.getInt("number");
					String location = rset.getString("location");
					int year = rset.getInt("year");
					int grade = rset.getInt("grade");
					int time = rset.getInt("time");
					String days = rset.getString("days");
				%>
					<tr>
						<td><%= name %></td>
						<td><%= prof %></td>
						<td><%= number %>명</td>
						<td><%= location %></td>
						<td><%= year %>학년</td>
						<td><%= grade %></td>
						<td><%= time %>교시</td>
						<td><%= days %></td>
						<td><a href="admin_course_update.jsp?id=<%= id %>">수정</a></td>
						<td><a href="course_delete.jsp?id=<%= id %>">삭제</a></td>
					</tr>
				<%
				}
				%>
				</table>
				<%
				if(rset != null) rset.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
				%>
			</section>
		</div>
	</body>
</html>