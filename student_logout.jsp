<!-- 로그아웃 후 페이지 이동 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%
session.invalidate();
response.sendRedirect("student_login.html");		
%>