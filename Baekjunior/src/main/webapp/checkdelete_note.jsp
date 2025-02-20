<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.sql.*, javax.naming.*, Baekjunior.db.*" session="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://kit.fontawesome.com/c9057320ee.js" crossorigin="anonymous"></script>
<link rel="stylesheet" type="text/css" href="MyPagest.css?v=3">
<link rel="stylesheet" type="text/css" href="Baekjunior_css.css?v=3">
</head>
<%
request.setCharacterEncoding("utf-8");
String userId = "none";
HttpSession session = request.getSession(false);
if(session != null && session.getAttribute("login.id") != null) {
	userId = (String) session.getAttribute("login.id");
}
else{
	response.sendRedirect("information.jsp");
    return;
}

// 정렬 순서 정하기
String sortClause = "problem_idx DESC"; // 기본 최신순
if (request.getParameter("latest") != null) {
	sortClause = "problem_idx DESC";	// 최신순
} else if (request.getParameter("earliest") != null) {
	sortClause = "problem_idx";	// 오래된 순
} else if (request.getParameter("ascending") != null) {
	sortClause = "problem_id";	// 문제번호 오름차순
} else if (request.getParameter("descending") != null) {
	sortClause = "problem_id DESC";	// 문제번호 내림차순
}
Connection con = DsCon.getConnection();
PreparedStatement problemPstmt = null;
ResultSet problemRs = null;
PreparedStatement problemCountPstmt = null;
ResultSet countRs = null;
PreparedStatement categoryPstmt = null;
ResultSet categoryRs = null;
PreparedStatement levelPstmt = null;
ResultSet levelRs = null;
%>
<body style="min-height:100vh;">
	<header style="padding:0 100px;">
		<a href="index.jsp" class="logo">Baekjunior</a>
		<%
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if(userId != "none") {
				String sql = "SELECT * FROM users WHERE user_id=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, userId);
				rs = pstmt.executeQuery();
				rs.next();
			}

		%>
		<div>
			<ul onmouseover="opendiv()" onmouseout="closediv()" style="height:130px;">
				<li><img src="img/user.png" style="width:30px;"></li>
				<li><a href="MyPage.jsp"><%=userId %></a></li>
			</ul>
			<div id="myprodiv" onmouseover="opendiv()" onmouseout="closediv()" style="display:none;position:fixed;top: 100px;background: white;padding: 17px;border: 3px solid black;margin-right: 20px;width: 200px;">
				<div id="myprofileimgborder">
					<img id="myprofileimg" src="./upload/<%=rs.getString("savedFileName") %>" alt="profileimg">
				</div>
				<a href="MyPage.jsp" style="position:absolute;top:30px;margin-left:90px;text-decoration: none;color: black;"><%=userId %></a>
				<a href="logout_do.jsp" style="border: 1px solid;width: 90px;display:inline-block;text-align: center;height: 30px;position:absolute;top:60px;margin-left:78px;text-decoration: none;color: black;">로그아웃</a>
			</div>
		</div>
		<%
		pstmt.close();
		rs.close();
		} catch (SQLException e){
			out.print(e);
			return;
		}	
		%>
		<!-- 프로필, 로그아웃 div 띄우기 -->
		<script>
		function opendiv() {
			document.getElementById("myprodiv").style.display = "block";
		}
		function closediv() {
			document.getElementById("myprodiv").style.display = "none";
		}
		</script>
	</header>
	
	<script type="text/javascript">
		window.addEventListener("scroll", function(){
			var header= document.querySelector("header");
			header.classList.toggle("sticky", window.scrollY > 0);
		});
	</script>
	
	<section class="banner">
		<a href="#" class="logo"></a>
	</section>
	<div class="contents">
		<div class="menu">
			<div class="menu_box">
				<ul style="min-width:150px;">
					<li>
						<a href="#">내 활동</a>
					</li>
					<li>
						<a href="editProfile.jsp">프로필 수정</a>
					</li>
				</ul>
			</div>
		</div>
		
		<div class="inner_contents" style="margin-top:35px;">
		<form action="checkdelete_do.jsp" onsubmit="return validateForm()" method="post" name="deletenote">
			<div class="inner_header">
				<h1 style="font-size:30px;">노트</h1>
				<div>
					<button onclick="document.getElementById('deletenoteitem')" name="allCheck" style="width:100px;height:40px;border-radius:40px;">전체선택</button>
					<input type="submit" value="삭제" style="width:100px;height:40px;border-radius:40px;">
				</div>
			</div>
			<div id="list_group" style="padding:0;margin-top:20px;">
				<table>
					<tr>
					  <th>#</th>
					  <th>제목</th>
					  <th></th>
					  <th style="width:100px;"></th>
					</tr>
		 		<%
		 		if (!userId.equals("none")) {
		 			try {
		 				
		 				// 문제 선택
		 				String problemQuery = "SELECT * FROM problems WHERE user_id=? ORDER BY is_fixed DESC, " + sortClause;
		 				problemPstmt = con.prepareStatement(problemQuery);
		 				problemPstmt.setString(1, userId);
		 				problemRs = problemPstmt.executeQuery();
						
		 				// 등록된 문제 수 세기
						String problemCountQuery = "SELECT COUNT(*) FROM problems WHERE user_id=?";
						problemCountPstmt = con.prepareStatement(problemCountQuery);
						problemCountPstmt.setString(1, userId);
						countRs = problemCountPstmt.executeQuery();
		 			
		 				if (countRs.next() && countRs.getInt(1) <= 0) {
		 					%>
		 					<div>
		 						not exist
		 					</div>
		 					<%
		 				} else {
		 					// 고정된 문제 먼저 출력
		 					while (problemRs.next()) {
		 		%>
				  <tr class="table_item">
				    <td style="padding-left: 10px;">
				    	<input type="checkbox" id="deletenoteitem" name="deletenoteitem" value="<%=problemRs.getInt("problem_idx")%>" style="margin-right:10px;">
				    	<a href="note_detail.jsp?problem_idx=<%=problemRs.getInt("problem_idx")%>"><%=problemRs.getInt("problem_id") %></a>
				    </td>
				    <td><a href="note_detail.jsp?problem_idx=<%=problemRs.getInt("problem_idx")%>"><%=problemRs.getString("memo_title") %></a></td>
				    
				    <td>
					    <% if(problemRs.getInt("is_fixed") == 1) { %>
				    			<img class="content_set_a" id="content_set_a_<%= problemRs.getInt("problem_idx") %>" src="img/pin.png" align="right" style="width:15px;">
				    	<% } else { %>
				    			<img class="content_set_a" id="content_set_a_<%= problemRs.getInt("problem_idx") %>" src="img/pin.png" align="right" style="display:none;width:15px;">
				    	<% } %>
			    	</td>
			    	<td style="text-align:right;"></td>
				  </tr>
		 		<%
		 					}			
		 				}
		 			} catch(SQLException e) {
		 				out.print(e);
		 			} finally {
		 				if (con != null) con.close();
						if(problemPstmt != null) problemPstmt.close();
						if(problemRs != null) problemRs.close();
						if(problemCountPstmt != null) problemCountPstmt.close();
						if(countRs != null) countRs.close();
						if(levelPstmt != null) levelPstmt.close();
						if(levelRs != null) levelRs.close();
		 			}
		 		}
		 		%>
				</ul>
			</div>
		</form>
		</div>
	</div>
	
	
</body>
</html>