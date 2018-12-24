<!-- 학생 등록 페이지 -->
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
		<title>학생 관리</title>
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
				padding: 10px;
			}
			section table {
				margin:	20px auto;
			}
			#registration_student th, section table td {
				padding: 5px 10px;
			}
			#student_list {
				border: 1px solid black;
				border-collapse: collapse;
				background:#eeeeee;
				text-align: center;
				width: 100%;
			}
            #student_list th {
                background-color: #bebebe;
            }
			#student_list th, section table td {
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
		</style>
	</head>
	<body>
	<!-- 학생정보: 학번, 비밀번호, 이름, 학년, 허용학점 -->
		<div class="wrap">
			<header>
				수강신청 홈페이지 - 학생 등록 페이지
			</header>
			<nav>
				<ul>
					<li><a class="active" href="admin_student_registration.jsp">학생 등록</a></li>
					<li><a href="admin_course_registration.jsp">수업 등록</a></li>
					<li><a href="admin_course_list.jsp">수업 목록</a></li>
				</ul>
			</nav>
			<p class ="logout_bar">
				관리자님 환영합니다!
				<button onclick="location.href='admin_logout.jsp'">로그아웃</button>
			</p>
			<section>
				<form action="student_registration.jsp" method="POST">
					<p class = "subtitle">
						학생 등록
					</p>
					<table id="registration_student">
						<tr>
							<td>학번:</td>
							<td><input type="text" size="15" name="student_id" required></td>
						</tr>
						<tr>
							<td>비밀번호:</td>
							<td><input type="text" size="15" name="student_pw" required></td>
						</tr>
						<tr>
							<td>이름:</td>
							<td><input type="text" size="15" name="student_name" required></td>
						</tr>
						<tr>
							<td>학년:</td>
							<td><input type="text" size="15" name="student_year" required placeholder="숫자만 적어주세요."></td>
						</tr>
						<tr>
							<td>허용학점:</td>
							<td><input type="text" size="15" name="student_credit" required placeholder="숫자만 적어주세요."></td>
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
				String select_sql = "SELECT * FROM student";
				pstmt = conn.prepareStatement(select_sql);
				rset = pstmt.executeQuery();
				%>
				<hr>
				<p class = "subtitle">
					학생 목록
				</p>
				<table id="student_list" border="1">
					<tr>
						<th>학번</th>
						<th>비밀번호</th>
						<th>이름</th>
						<th>학년</th>
						<th>허용학점</th>
					</tr>

				<%
				// select 된 tuple들을 table에 추가
				while (rset.next()) {
					String student_id = rset.getString("student_id");
					String password = rset.getString("password");
					String name = rset.getString("name");
					int year = rset.getInt("year");
					int credit = rset.getInt("credit");
				%>
					<tr>
						<td><%= student_id %></td>
						<td><%= password %></td>
						<td><%= name %></td>
						<td><%= year %></td>
						<td><%= credit %></td>
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