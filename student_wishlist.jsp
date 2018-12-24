<!-- 책가방 페이지 -->
<!DOCTYPE html>

<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<% request.setCharacterEncoding("utf-8"); %>

<!-- 로그인 여부 검사 -->
<%
if (session.getAttribute("id") == null) {
	out.println("<script>alert('로그인을 하지 않았습니다'); location.href='student_login.html';</script>;");
}
%>

<html>
	<head>
		<title>수강 신청</title>
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
				color: #D7DF01;
				background-color: #0B3B17;
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
				background-color: #5FB404;
			}
			nav ul a.active {
				color: #FFFF00;
				background-color: #0B6121;
			}

			section {
				padding : 10px;
			}
			section table {
				margin:	20px auto;
			}
			#wish_list, #sugang_list {
				border: 1px solid black;
				border-collapse: collapse;
				background:#eeeeee;
				text-align: center;
				width: 100%;
			}
    		#wish_list th, #sugang_list th {
        		background-color: #bebebe;
    		}
			#wish_list th, section table td, #sugang_list th {
				padding: 5px 10px;
			}
			.logout_bar, #p_grade {
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
			tr td.td_reg a:link, tr td.td_reg a:visited {color:#DF0101;}
		</style>
	</head>
	<body>
	<!-- 수업정보: 강의명, 강사명, 수강인원, 강의실, 수강대상학년, 학점 -->
		<div class="wrap">
			<header>
				수강신청 홈페이지 - 책가방 페이지
			</header>
			<nav>
				<ul>
					<li><a class="active" href="student_wishlist.jsp">책가방</a></li>
					<li><a href="student_course_list.jsp">수업 목록</a></li>
					<li><a href="student_time.jsp">시간표</a></li>
				</ul>
			</nav>
			<p class ="logout_bar">
				<%
				//세션 id를 통해 접속한 학생의 이름 띄우기
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = null;
				PreparedStatement pstmt = null;
				ResultSet rset = null;
				ResultSet inner_rset = null;

				conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registration?characterEncoding=UTF-8&serverTimezone=UTC", "root", "root1234");

				String sql = "SELECT * FROM student WHERE student_id =?";
				String id_to_name = (String)session.getAttribute("id");
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,id_to_name);
				rset = pstmt.executeQuery();				
				rset.next();
				String student_id = rset.getString("student_id");
				String name = rset.getString("name");
				out.print(name);
				%>님 환영합니다!
				<button onclick="location.href='student_logout.jsp'">로그아웃</button>
			</p>
			<section>
				<%
				// table에 있는 tuple 불러오기
				String select_sql = "SELECT * FROM sugang WHERE student_id=?";
				pstmt = conn.prepareStatement(select_sql);
				pstmt.setString(1, student_id);
				rset = pstmt.executeQuery();
				%>
				<p class = "subtitle">
					책가방 담은 목록
				</p>
				<table id="wish_list" border="1">
					<tr>
						<th>강의명</th>
						<th>강사명</th>
						<th>수강인원</th>
						<th>강의실</th>
						<th>수강대상학년</th>
						<th>학점</th>
						<th>시간</th>
						<th>요일</th>
						<th>신청인원</th>
						<th>삭제</th>
						<th>수강신청</th>
					</tr>

					<%
					// select 된 tuple들을 table에 추가
					while (rset.next()) {
        				int id = rset.getInt("course_id");
        				select_sql = "SELECT * FROM course WHERE id=?";
						pstmt = conn.prepareStatement(select_sql);
						pstmt.setInt(1, id);
						inner_rset = pstmt.executeQuery();
						inner_rset.next();
						int time = inner_rset.getInt("time");
						String days = inner_rset.getString("days");
					%>
					<tr>
						<td><%= inner_rset.getString("name") %></td>
						<td><%= inner_rset.getString("prof") %></td>
						<td><%= inner_rset.getString("number") %>명</td>
						<td><%= inner_rset.getString("location") %></td>
						<td><%= inner_rset.getString("year") %>학년</td>
						<td><%= inner_rset.getString("grade") %></td>
						<td><%= inner_rset.getString("time") %>교시</td>
						<td><%= inner_rset.getString("days") %></td>
						<td><%= inner_rset.getString("reg_count") %>명</td>
						<td><a href="wishlist_delete.jsp?student_id=<%= id_to_name %>&course_id=<%= id %>">삭제</a></td>
						<td class="td_reg"><a href="input_sugang.jsp?student_id=<%= id_to_name %>&course_id=<%=id%>&time=<%= time %>&days=<%= days %>">신청</a></td>
					</tr>
					<%
					}
					%>
				</table>
				<hr>
				<%
				// table에 있는 tuple 불러오기
				select_sql = "SELECT * FROM sugang WHERE student_id=? AND isRegister=1";
				pstmt = conn.prepareStatement(select_sql);
				pstmt.setString(1, student_id);
				rset = pstmt.executeQuery();
				%>
				<p class = "subtitle">
					수강 신청 목록
				</p>
				<table id="sugang_list" border="1">
					<tr>
						<th>강의명</th>
						<th>강사명</th>
						<th>수강인원</th>
						<th>강의실</th>
						<th>수강대상학년</th>
						<th>학점</th>
						<th>시간</th>
						<th>요일</th>
						<th>신청인원</th>
						<th>수강취소</th>
					</tr>
					<%
					// select 된 tuple들을 table에 추가
					while (rset.next()) {
	        			int id = rset.getInt("course_id");
	        			select_sql = "SELECT * FROM course WHERE id=?";
						pstmt = conn.prepareStatement(select_sql);
						pstmt.setInt(1, id);
						inner_rset = pstmt.executeQuery();
						inner_rset.next();
					%>
					<tr>
						<td><%= inner_rset.getString("name") %></td>
						<td><%= inner_rset.getString("prof") %></td>
						<td><%= inner_rset.getString("number") %>명</td>
						<td><%= inner_rset.getString("location") %></td>
						<td><%= inner_rset.getString("year") %>학년</td>
						<td><%= inner_rset.getString("grade") %></td>
						<td><%= inner_rset.getString("time") %>교시</td>
						<td><%= inner_rset.getString("days") %></td>
						<td><%= inner_rset.getString("reg_count") %>명</td>
						<td><a href="delete_sugang.jsp?student_id=<%= id_to_name %>&course_id=<%=id%>">취소</a></td>
					</tr>
					<%
					}
					%>
					</table>
					<%
					//수강 가능 학점 표기
					sql = "SELECT * FROM student WHERE student_id =?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1,id_to_name);
					rset = pstmt.executeQuery();				
					rset.next();
					%>
					<p id="p_grade">잔여 수강 가능 학점 : <%= rset.getInt("valid_grade") %></p>
					<%
					if(inner_rset != null) inner_rset.close();
					if(rset != null) rset.close();
					if(pstmt != null) pstmt.close();
					if(conn != null) conn.close();
					%>
			</section>
		</div>
	</body>
</html>