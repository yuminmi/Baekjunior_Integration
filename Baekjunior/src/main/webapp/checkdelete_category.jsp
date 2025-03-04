<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.sql.*, javax.naming.*, Baekjunior.db.*" session="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>checkdelete_category</title>
<script src="https://kit.fontawesome.com/c9057320ee.js" crossorigin="anonymous"></script>
<link rel="stylesheet" type="text/css" href="MyPagest.css?v=3">
<link rel="stylesheet" type="text/css" href="Baekjunior_css.css?v=3">

<script>
//진짜 로그아웃할건지 확인하는 함수
function confirmLogout() {
	var result = confirm("정말 로그아웃 하시겠습니까?");
	if (result) {
	    window.location.href = "logout_do.jsp";
		} else {
    	return false;
		}
}

// 진짜 삭제할건지 확인하는 함수
function confirmDeletion(problemIdx) {
    var result = confirm("정말 삭제하시겠습니까?");
    if (!result) {
    	event.preventDefault();
    	return false;
    }
}
</script>

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
PreparedStatement cateNoteCountPstmt = null;
ResultSet cateNoteRs = null;
PreparedStatement levelPstmt = null;
ResultSet levelRs = null;
%>
<body style="min-height:100vh;">
	<header>
		<a href="index.jsp" class="logo">Baekjunior</a>
		<%
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String profileimg = null;
		try {
			if(userId != "none") {
				String sql = "SELECT * FROM users WHERE user_id=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, userId);
				rs = pstmt.executeQuery();
				rs.next();
				
				// 프로필이미지 설정 전인 경우 기본이미지 뜨도록 처리
				profileimg = rs.getString("savedFileName");
				if(profileimg == null){
					profileimg = "img/user.png";
				}
				else {
					profileimg = "./upload/" + rs.getString("savedFileName");
				}
			}

		%>
				
		<!-- header 프로필 -->
		<div id="profile">
			<ul onmouseover="opendiv()" onmouseout="closediv()" style="height:70px;">
				<li><img src=<%=profileimg %> id="myprofileimg" alt="profileimg" style="width:40px; height:40px;"></li>
				<li><a href="MyPage.jsp"><%=userId %></a></li>
			</ul>
			<!-- header 프로필 hover했을 때 나오는 프로필 -->
			<div id="myprodiv" onmouseover="opendiv()" onmouseout="closediv()" style="display:none; position:fixed; top:100px; background:white; padding:17px; border:3px solid black; margin-right:20px; width:200px;">
				<div id="myprofileimgborder">
					<img id="myprofileimg" src=<%=profileimg %> alt="profileimg">
				</div>
				<a href="MyPage.jsp" style="position:absolute; top:20px; margin-left:90px; text-decoration:none; color:black;"><%=userId %></a>
				<a href="#" onclick="confirmLogout()" style="border:1px solid;width:90px; display:inline-block; text-align:center; height:30px; position:absolute; top:50px; margin-left:78px; text-decoration:none; color:black;">로그아웃</a>
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
		<a href="index.jsp" class="logo"></a>
	</section>
	<div class="contents">
		<script>
			function checkAll() {
				const checkboxes = document.getElementsByName("deletecateitem");
				let allcheck = document.getElementById("allCheck").innerHTML;
				if (allcheck == "전체선택") {
					checkboxes.forEach((checkbox) => {
						let catenotecount = parseInt(checkbox.dataset.catenotecount);
						if(catenotecount==0){
							checkbox.checked = true
						}
					})
					document.getElementById("allCheck").innerHTML = "전체해제";
				}
				else if (allcheck == "전체해제") {
					checkboxes.forEach((checkbox) => {
						checkbox.checked = false
					})
					document.getElementById("allCheck").innerHTML = "전체선택";
				}
			}
		</script>
		<div class="inner_contents" style="margin-top:35px;">
		<form action="checkdelete_cate_do.jsp" onsubmit="return validateForm()" method="post" name="deletecate">
			<div class="inner_header">
				<h1 style="font-size:30px;">CATEGORY</h1>
				<div>
					<button type="button" onclick="checkAll()" id="allCheck" name="allCheck" style="width:100px;height:40px;border-radius:40px;">전체선택</button>
					<input type="submit" onclick="confirmDeletion()" value="삭제" style="width:100px;height:40px;border-radius:40px;cursor:pointer;">
				</div>
			</div>
			<div id="list_group" style="padding:0;margin-top:20px;">
				<table>
					<tr>
					  <th>분류</th>
					  <th>메모</th>
					  <th>노트 수</th>
					  <th style="width:100px;"></th>
					</tr>
		 		<%
		 		if (!userId.equals("none")) {
		 			try {
		 				
		 				// 카테고리 선택
		 				String categoryQuery = "SELECT * FROM algorithm_memo WHERE user_id=?";
		 				categoryPstmt = con.prepareStatement(categoryQuery);
						categoryPstmt.setString(1, userId);
						categoryRs = categoryPstmt.executeQuery();
						
		 				while(categoryRs.next()) {
		 					//해당 카테고리와 관련된 노트 개수
		 					String sql = "SELECT COUNT(*) FROM algorithm_sort WHERE user_id=? AND sort=?";
		 					cateNoteCountPstmt = con.prepareStatement(sql);
		 					cateNoteCountPstmt.setString(1, userId);
		 					cateNoteCountPstmt.setString(2, categoryRs.getString("algorithm_name"));
		 					cateNoteRs = cateNoteCountPstmt.executeQuery();
		 					int catenotecount = 0;
		 					if(cateNoteRs.next()){
		 						catenotecount = cateNoteRs.getInt(1);
		 					}

		 					//알고리즘 메모 내용 불러오기
		 					String algorithmMemo = categoryRs.getString("algorithm_memo");
		 		%>
				  <tr class="table_item">
				    <td style="padding-left: 10px;max-width: 120px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
				    	<input type="checkbox" id="deletecateitem" name="deletecateitem" value="<%=categoryRs.getInt("idx")%>" data-catenotecount="<%=catenotecount %>" style="margin-right:10px;cursor:pointer;"
				    	<%if (catenotecount != 0){%>disabled<%} %>>
				    	<a href="index.jsp?type=category&sort=<%=categoryRs.getString("algorithm_name")%>">
				    		<span><%=categoryRs.getString("algorithm_name") %></span>
				    	</a>
				    </td>
				    <td style="max-width: 200px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;text-align:center;">
				    <% if(algorithmMemo != null) { %>
				    	<%=algorithmMemo%>
				    <%} %>
				    </td>
				    <td style="text-align:center;"><%=catenotecount%></td>
			    	<td style="text-align:right;"></td>
				  </tr>
		 		<%		
		 				}
		 			} catch(SQLException e) {
		 				out.print(e);
		 			} finally {
		 				if (con != null) con.close();
						if(problemPstmt != null) problemPstmt.close();
						if(problemRs != null) problemRs.close();
						if(problemCountPstmt != null) problemCountPstmt.close();
						if(categoryPstmt != null) categoryPstmt.close();
						if(categoryRs != null) categoryRs.close();
						if(cateNoteCountPstmt != null) cateNoteCountPstmt.close();
						if(cateNoteRs != null) cateNoteRs.close();
						if(countRs != null) countRs.close();
						if(levelPstmt != null) levelPstmt.close();
						if(levelRs != null) levelRs.close();
		 			}
		 		}
		 		%>
				</table>
			</div>
		</form>
		</div>
	</div>
	
	
</body>
</html>