<!-- 수업 시간표 페이지 -->
<!DOCTYPE html>

<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<% request.setCharacterEncoding("utf-8"); %>

<!-- 로그인 여부 검사 -->
<%
if (session.getAttribute("id") == null) {
	out.println("<script>alert('로그인을 하지 않았습니다.'); location.href='student_login.html';</script>;");
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
				border: 1px solid black;
				margin-top: 10px;
				padding: 10px;
			}
			section table {
				margin:	20px auto;
			}
			#time_scheduler {
				border: 1px solid black;
				border-collapse: collapse;
				background:#eeeeee;
				text-align: center;
				font-weight: bold;
			}
			#time_scheduler td, #time_scheduler th {
				padding: 5px 10px;
				border: 1px solid black;
				width: 100px;
				height: 50px;
				text-align: center;
			}
            #time_scheduler th {
                background-color: #bebebe;
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
        <div class = "wrap">
            <header>
                수강신청 홈페이지 - 시간표 페이지
            </header>
            <nav>
                <ul>
                    <li><a href="student_wishlist.jsp">책가방</a></li>
                    <li><a href="student_course_list.jsp">수업 목록</a></li>
                    <li><a class="active" href="student_time.jsp">시간표</a></li>
                </ul>
            </nav>
            <p class ="logout_bar">
			    <%
				//세션 id를 통해 접속한 학생의 이름 띄우기
				Class.forName("com.mysql.jdbc.Driver");                
		        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registration?characterEncoding=UTF-8&serverTimezone=UTC", "root", "root1234"); 
		        PreparedStatement pstmt = null;
				ResultSet rset = null;
				ResultSet course_set = null;

				String sql = "SELECT * FROM student WHERE student_id =?";
				String id_to_name = (String)session.getAttribute("id");
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,id_to_name);
				rset = pstmt.executeQuery();
					
				rset.next();
				String name = rset.getString("name");
				out.print(name);
			    %>님 환영합니다!
		        <button onclick="location.href='student_logout.jsp'">로그아웃</button>
            </p>
			<%
			String Mon_1 = ""; String Mon_2 = ""; String Mon_3 = ""; String Mon_4 = ""; String  Mon_5 = ""; String Mon_6 = ""; String Tue_1 = ""; String Tue_2 = ""; String Tue_3 = ""; String Tue_4 = ""; String Tue_5 = ""; String Tue_6 = ""; String Wen_1 = ""; String Wen_2 = ""; String Wen_3 = ""; String Wen_4 = ""; String Wen_5 = ""; String Wen_6 = ""; String Thu_1 = ""; String Thu_2 = ""; String Thu_3 = ""; String Thu_4 = ""; String Thu_5 = ""; String Thu_6 = ""; String Fri_1 = ""; String Fri_2 = ""; String Fri_3 = ""; String Fri_4 = ""; String Fri_5 = ""; String Fri_6 = "";
			// 수강신청이 완료된 과목 추출
			String select_sql= "SELECT * FROM sugang WHERE student_id=? AND isRegister=1";
			pstmt = conn.prepareStatement(select_sql);
			pstmt.setString(1, id_to_name);
			rset = pstmt.executeQuery();

			while(rset.next()) {
				int course_id = rset.getInt("course_id");
				select_sql= "SELECT * FROM course WHERE id=? ";
				pstmt = conn.prepareStatement(select_sql);
				pstmt.setInt(1, course_id);
				course_set = pstmt.executeQuery();
				course_set.next();
				int time = course_set.getInt("time");
				String days = course_set.getString("days");			
				String[] split_day = days.split(",");
				String course_name = course_set.getString("name");
				for (int i = 0; i < split_day.length; i++) {
					if(time == 1) {
						if("Mon".equals(split_day[i]))
							Mon_1 = course_name;
						else if("Tue".equals(split_day[i]))
							Tue_1 = course_name;
						else if("Wen".equals(split_day[i]))
							Wen_1 = course_name;
						else if("Thu".equals(split_day[i]))
							Thu_1 = course_name;
						else if("Fri".equals(split_day[i]))
							Fri_1 = course_name;
					}
					else if (time == 2) {
						if("Mon".equals(split_day[i]))
							Mon_2 = course_name;
						else if("Tue".equals(split_day[i]))
							Tue_2 = course_name;
						else if("Wen".equals(split_day[i]))
							Wen_2 = course_name;
						else if("Thu".equals(split_day[i]))
							Thu_2 = course_name;
						else if("Fri".equals(split_day[i]))
							Fri_2 = course_name;
					}
					else if (time == 3) {
						if("Mon".equals(split_day[i]))
							Mon_3 = course_name;
						else if("Tue".equals(split_day[i]))
							Tue_3 = course_name;
						else if("Wen".equals(split_day[i]))
							Wen_3 = course_name;
						else if("Thu".equals(split_day[i]))
							Thu_3 = course_name;
						else if("Fri".equals(split_day[i]))
							Fri_3 = course_name;
					}
					else if (time == 4) {
						if("Mon".equals(split_day[i]))
							Mon_4 = course_name;
						else if("Tue".equals(split_day[i]))
							Tue_4 = course_name;
						else if("Wen".equals(split_day[i]))
							Wen_4 = course_name;
						else if("Thu".equals(split_day[i]))
							Thu_4 = course_name;
						else if("Fri".equals(split_day[i]))
							Fri_4 = course_name;
					}
					else if (time == 5) {
						if("Mon".equals(split_day[i]))
							Mon_5 = course_name;
						else if("Tue".equals(split_day[i]))
							Tue_5 = course_name;
						else if("Wen".equals(split_day[i]))
							Wen_5 = course_name;
						else if("Thu".equals(split_day[i]))
							Thu_5 = course_name;
						else if("Fri".equals(split_day[i]))
							Fri_5 = course_name;
					}
					else if (time == 6) {
						if("Mon".equals(split_day[i]))
							Mon_6 = course_name;
						else if("Tue".equals(split_day[i]))
							Tue_6 = course_name;
						else if("Wen".equals(split_day[i]))
							Wen_6 = course_name;
						else if("Thu".equals(split_day[i]))
							Thu_6 = course_name;
						else if("Fri".equals(split_day[i]))
							Fri_6 = course_name;
					}
				}
			}
			%>
            <section>
				<p class = "subtitle">
					시간표
				</p>
            	<table id="time_scheduler">
                    <tr>
						<th>교시</th>
						<th>월</th>
						<th>화</th>
						<th>수</th>
						<th>목</th>
						<th>금</th>
					</tr>
					<tr>
						<td>1교시</td>
						<td><%=Mon_1%></td>
						<td><%=Tue_1%></td>
						<td><%=Wen_1%></td>
						<td><%=Thu_1%></td>
						<td><%=Fri_1%></td>
					</tr>
					<tr>
						<td>2교시</td>
						<td><%=Mon_2%></td>
						<td><%=Tue_2%></td>
						<td><%=Wen_2%></td>
						<td><%=Thu_2%></td>
						<td><%=Fri_2%></td>
					</tr>
					<tr>
						<td>3교시</td>
						<td><%=Mon_3%></td>
						<td><%=Tue_3%></td>
						<td><%=Wen_3%></td>
						<td><%=Thu_3%></td>
						<td><%=Fri_3%></td>
					</tr>
					<tr>
						<td>4교시</td>
						<td><%=Mon_4%></td>
						<td><%=Tue_4%></td>
						<td><%=Wen_4%></td>
						<td><%=Thu_4%></td>
						<td><%=Fri_4%></td>
					</tr>
					<tr>
						<td>5교시</td>
						<td><%=Mon_5%></td>
						<td><%=Tue_5%></td>
						<td><%=Wen_5%></td>
						<td><%=Thu_5%></td>
						<td><%=Fri_5%></td>
					</tr>
					<tr>
						<td>6교시</td>
						<td><%=Mon_6%></td>
						<td><%=Tue_6%></td>
						<td><%=Wen_6%></td>
						<td><%=Thu_6%></td>
						<td><%=Fri_6%></td>
                    </tr>
                </table>
				<%
            	if(course_set != null) course_set.close();
            	if(rset != null) rset.close();
				if(pstmt != null) pstmt.close();
            	if(conn != null) conn.close();
				%>                 
            </section>
        </div>
	</body>
</html>