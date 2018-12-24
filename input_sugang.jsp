<!-- 수강 신청 query -->
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
	ResultSet sugang_set = null;
	ResultSet extract_set = null;

	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/registration?characterEncoding=UTF-8&serverTimezone=UTC", "root", "root1234");

	// 전송받은 데이터 추출
	String student_id = request.getParameter("student_id");
	String course_id_s = request.getParameter("course_id");
	int course_id = Integer.parseInt(course_id_s);
	String days = request.getParameter("days");
	String[] split_day = days.split(",");
	String time_s = request.getParameter("time");
	int time = Integer.parseInt(time_s);

	// table의 isRegister 값 변경 및 중복확인
	String select_sql = "SELECT * FROM sugang WHERE student_id=? AND course_id=?";
	pstmt = conn.prepareStatement(select_sql);
	pstmt.setString(1, student_id);
	pstmt.setInt(2, course_id);
	rset = pstmt.executeQuery();
	rset.next();
	int register = rset.getInt("isRegister");		

	if(register == 0) {
		// 신청한 과목의 학점, 총인원 및 현재인원 추출
		select_sql= "SELECT * FROM course WHERE id=?";
		pstmt = conn.prepareStatement(select_sql);
		pstmt.setInt(1, course_id);
		extract_set = pstmt.executeQuery();
		extract_set.next();
		int grade = extract_set.getInt("grade");
		int number = extract_set.getInt("number");
		int reg_count = extract_set.getInt("reg_count");

		// 신청한 학생의 남은학점 추출
		select_sql= "SELECT * FROM student WHERE student_id=?";
		pstmt = conn.prepareStatement(select_sql);
		pstmt.setString(1, student_id);
		extract_set = pstmt.executeQuery();
		extract_set.next();
		int valid_credit = extract_set.getInt("valid_grade");

		// 수강신청이 완료된 과목 추출
		select_sql= "SELECT * FROM sugang WHERE student_id=? AND isRegister=1";
		pstmt = conn.prepareStatement(select_sql);
		pstmt.setString(1, student_id);
		rset = pstmt.executeQuery();
		
		// 수강인원이 가득 찼을 경우
		if (number == reg_count) {
			out.println("<script>alert('인원이 꽉 찼습니다.'); location.href='student_wishlist.jsp';</script>");
		}
		else if (valid_credit - grade < 0) {
			out.println("<script>alert('학점이 모자랍니다.'); location.href='student_wishlist.jsp';</script>");
		}
		else {
			// 수강신청된 과목이 있는 경우
			if(rset.next()) {
				String course_sql = "SELECT * FROM sugang WHERE student_id=? AND isRegister=1";
				pstmt = conn.prepareStatement(course_sql);
				pstmt.setString(1, student_id);
				rset = pstmt.executeQuery();	
				int sugang_time;
				String sugang_days;
				String[] split_sugang_days;
				int is_collision = 0;
				while(rset.next()) {
					// 과목 시간 중복 처리
					int sugang_course_id = rset.getInt("course_id");
					String time_sql = "SELECT * FROM course WHERE id=?";
					pstmt = conn.prepareStatement(time_sql);
					pstmt.setInt(1, sugang_course_id);
					sugang_set = pstmt.executeQuery();
					sugang_set.next();
					sugang_time = sugang_set.getInt("time");
					sugang_days = sugang_set.getString("days");
					split_sugang_days = sugang_days.split(",");

					for (int i = 0; i < split_day.length; i++) {
						for (int j = 0; j < split_sugang_days.length; j++) {
							if (split_day[i].equals(split_sugang_days[j])) {
								is_collision = 1;
								break;
							}
						}
						if (is_collision == 1)
							break;
					}


					if(time==sugang_time && is_collision == 1) {
						out.println("<script>alert('수업시간에 다른 수업이 있습니다'); location.href='student_wishlist.jsp';</script>");
						break;
					}

					// 시간이 겹치는 수업이 없다면 수강신청 처리
					if(rset.isLast()) {
						// 책가방 isRegister 업데이트		
						String sql="UPDATE sugang SET isRegister=1 WHERE student_id =? AND course_id=?";	
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, student_id);
						pstmt.setInt(2, course_id);
						pstmt.executeUpdate();
				
						reg_count += 1;
						sql="UPDATE course SET reg_count=? WHERE id=?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, reg_count);
						pstmt.setInt(2, course_id);
						pstmt.executeUpdate();

						// 잔여 수강 학점 업데이트
						sql = "SELECT * FROM student WHERE student_id =?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, student_id);
						rset = pstmt.executeQuery();
						rset.next();
						int valid_grade = rset.getInt("valid_grade");

						valid_grade -= grade;
						sql="UPDATE student SET valid_grade=? WHERE student_id=?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, valid_grade);
						pstmt.setString(2, student_id);
						pstmt.executeUpdate();

						out.println("<script>alert('수강신청 완료'); location.href='student_wishlist.jsp';</script>");
					}
				}
			}
			// 수강신청 칸이 비어있는 경우
			else {
				// 책가방 isRegister 업데이트		
				String sql="UPDATE sugang SET isRegister=1 WHERE student_id =? AND course_id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, student_id);
				pstmt.setInt(2, course_id);
				pstmt.executeUpdate();
				
				reg_count += 1;
				sql="UPDATE course SET reg_count=? WHERE id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, reg_count);
				pstmt.setInt(2, course_id);
				pstmt.executeUpdate();

				// 잔여 수강 학점 업데이트
				sql = "SELECT * FROM student WHERE student_id =?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, student_id);
				rset = pstmt.executeQuery();
				rset.next();
				int valid_grade = rset.getInt("valid_grade");

				valid_grade -= grade;
				sql="UPDATE student SET valid_grade=? WHERE student_id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, valid_grade);
				pstmt.setString(2, student_id);
				pstmt.executeUpdate();

				out.println("<script>alert('수강신청 완료'); location.href='student_wishlist.jsp';</script>");				
			}
		}
	}
	else if(register==1) {
		out.println("<script>alert('이미 수강신청이 완료된 강의입니다'); location.href='student_wishlist.jsp';</script>");
	}
			
	if(rset != null) rset.close();
	if(sugang_set != null) sugang_set.close();
	if(extract_set != null) extract_set.close();
	if(pstmt != null) pstmt.close();
	if(conn != null) conn.close();
}
%>