<!-- 수업 검색 페이지 -->
<!DOCTYPE html>

<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<% request.setCharacterEncoding("utf-8"); %>

<!-- 로그인 여부 검사 -->
<%
if (session.getAttribute("id") == null) {
	out.println("<script>alert('로그인을 하지 않았습니다.'); location.href='admin_login.html';</script>;");
}
%>

<html>
	<head>
		<title>수업 검색</title>
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
			#registration_course th, section table td {
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
		</style>
	</head>
	<body>
    <!-- 수업 정보: 강의명, 강사명, 수강인원, 강의실, 수강대상학년, 학점 -->
        <div class = "wrap">
            <header>
                수강신청 홈페이지 - 수업 목록 페이지
            </header>
            <nav>
                <ul>
                    <li><a href="admin_student_registration.jsp">학생 등록</a></li>
                    <li><a href="admin_course_registration.jsp">수업 등록</a></li>
                    <li><a class="active" href="admin_course_list.jsp">수업 목록</a></li>
                </ul>
            </nav>
            <p class ="logout_bar">
                관리자님 환영합니다!
                <button onclick="location.href='admin_logout.jsp'">로그아웃</button>
            </p>
            <section>
                <form method="POST">
                    <p class = "subtitle">
                        수업 검색
                    </p>
                    <table id="registration_course">
                        <tr>
                            <td>
                                <select name ="options" id="option">
                                    <option value="title">수업명</option>
                                    <option value="prof">강사</option>
                                    <option value ="year">수강대상학년</option>
                                </select>
                            </td>
                            <td><input type="text" size="15" name="query"></td>
                            <td><input type="submit" value="검색"></td>
                        </tr>

                        <tr style="text-align: center;">
                            
                        </tr>
                    </table>
                </form>
                <%
                String query = request.getParameter("query");
                String option = request.getParameter("options");
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registration?characterEncoding=UTF-8&serverTimezone=UTC", "root", "root1234"); 
                Statement stmt = conn.createStatement();
                String sqlStr = "";
                if (option == null) {
                    sqlStr = "SELECT * FROM course ";
                }
                else {      
                    if (option.equals("title")) {
                        sqlStr = "SELECT * FROM course WHERE name LIKE ";
                    }
                    else if (option.equals("prof")) {
                        sqlStr = "SELECT * FROM course WHERE prof LIKE ";
                    }
                    else {
                        sqlStr = "SELECT * FROM course WHERE year LIKE ";
                    }
                    sqlStr += "'%" + query + "%'";
                }
                sqlStr += "ORDER BY name ASC";
                ResultSet rset = stmt.executeQuery(sqlStr);
                %>
                <hr>
                <p class = "subtitle">
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
                        <th>신청인원</th>
                        <th>신청상태</th>

                    </tr>
                    <%
                    while (rset.next()) {
                        String name = rset.getString("name");
                        String prof = rset.getString("prof");
                        int number = rset.getInt("number");
                        String location = rset.getString("location");
                        int year = rset.getInt("year");
                        int grade = rset.getInt("grade");
                        int time = rset.getInt("time");
                        String days = rset.getString("days");
                        int reg_count = rset.getInt("reg_count");
                        String state = "";
                        if (reg_count <= 5) state = "폐강";
                        else if (reg_count == number) state = "신청종료";
                        else state = "진행중";
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
                        <td><%= reg_count %>명</td>
                        <td><%= state %></td>
                    </tr>
                    <%
                    }
                    %>
                </table>
                <%
                if(rset != null) rset.close();
                if(stmt != null) stmt.close();
                if(conn != null) conn.close();
                %>
            </section>
        </div>
	</body>
</html>