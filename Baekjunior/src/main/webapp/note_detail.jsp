<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.sql.*, javax.naming.*, Baekjunior.db.*" session="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>create_note</title>
<link rel="stylesheet" href="Baekjunior_css.css">
</head>
<%
request.setCharacterEncoding("utf-8");
String userId = "none";
HttpSession session = request.getSession(false);
if(session != null && session.getAttribute("login.id") != null) {
	userId = (String) session.getAttribute("login.id");
}
int problemIdx = Integer.parseInt(request.getParameter("problem_idx"));

Connection con = DsCon.getConnection();
PreparedStatement pstmt = null;
ResultSet rs = null;
%>
<script type="text/javascript">
    function confirmDeletion(problemIdx) {
        var result = confirm("정말 삭제하시겠습니까?");
        if (result) {
            window.location.href = "note_delete_do.jsp?problem_idx=" + problemIdx;
        } else {
            return false;
        }
    }
</script>
<body>	
	<header>
		<a href="0_Baekjunior.jsp" class="logo">Baekjunior</a>
		<div id="main_menu">
			<ul>
				<li class="main_menu_Storage"><a href="#">Storage</a>
					<ul>
						<li><a href="#">storage1</a></li>
						<li><a href="#">storage2</a></li>
						<li><a href="#">storage3</a></li>
						<li><a href="#">storage4</a></li>
					</ul>
				</li>				
				<li class="main_menu_Friend"><a href="#">Friend</a>
					<ul>
						<li><a href="#">friend1</a></li>
						<li><a href="#">friend2</a></li>
						<li><a href="#">friend3</a></li>
					</ul>
				</li>
				<li class="main_menu_Group"><a href="#">Group</a>
					<ul>
						<li><a href="#">group1</a></li>
						<li><a href="#">group2</a></li>
					</ul>
				</li>
				<li class="main_menu_MyPage"><a href="#">MyPage</a>
					<ul>
						<li><a href="#">mypage1</a></li>
						<li><a href="#">mypage2</a></li>
						<li><a href="#">mypage3</a></li>
						<li><a href="#">mypage4</a></li>
					</ul>
				</li>
				<li class="main_menu_Setting"><a href="#">Setting</a>
					<ul>
						<li><a href="#">setting1</a></li>
						<li><a href="#">setting2</a></li>
						<li><a href="#">setting3</a></li>
					</ul>
				</li>
			</ul>
		</div>
		<ul>
			<li><img src="img/user.png" style="width:30px;"></li>
			<li><a href="MyPage.jsp"><%=userId %></a></li>
		</ul>
	</header>

	<script type="text/javascript">
		window.addEventListener("scroll", function(){
			var header= document.querySelector("header");
			header.classList.toggle("sticky", window.scrollY > 0);
		});
	</script>
	<%
		try {
			String sql = "SELECT * FROM problems WHERE problem_idx=?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, problemIdx);
			rs = pstmt.executeQuery();
			if(rs.next()){
				
	%>
	<section class="banner">
		<a href="#" class="logo"></a>
	</section>
	
	
	<!-- bookmark_star에 대한 SCRIPT -->
	<script>
		document.addEventListener('DOMContentLoaded', function() {
		    const bookmarkStars = document.querySelectorAll('.bookmark_star');
	
		    bookmarkStars.forEach(function(star) {
		        star.addEventListener('click', function() {
		            const currentSrc = this.getAttribute('src');
	
		            if (currentSrc === 'img/star_on.png') {
		                this.setAttribute('src', 'img/star_off.png');
		            } else {
		                this.setAttribute('src', 'img/star_on.png');
		            }
		        });
		    });
		});
	</script>
	
	<div style="margin-top:20px;">
		<div style="width:80%; margin:0 auto;">
			<div>
				<div>
					<div style="display:inline; width:80%; font-size:30px; font-weight:bold;">
						#<span><%=rs.getInt("problem_id") %></span> : <span><%=rs.getString("problem_title") %></span> <span><img class="bookmark_star" src="img/star_on.png" style="width:18px;"></span>
					</div>
					<div style="float:right; font-size:15px; padding:10px;">
						Submit Date : <span><%=rs.getDate("submitDate") %></span>
					</div>
				</div>
				
				<div style="font-weight:bold; font-size:18px; margin-top:15px; margin-left:20px;">
					<div style="display:inline;">
					<%
						String problemSortStr = rs.getString("problem_sort");
						String[] algorithmList = problemSortStr.split(",");
                    	if(problemSortStr != null && !problemSortStr.trim().isEmpty()) {
                    		for (String algo : algorithmList) {
                            	if (!algo.isEmpty()) {
					%>
						<span><img src="img/dot1.png" style="width:15px; margin-left:25px;"></span> <span><%=algo %></span>
					<%
                            	}
                    		}
                    	}
					%>
						<span style="margin-right:50px;"></span>
						<span style="margin-right:50px;"><%=rs.getString("language") %></span>
						Friends who solved : <span style="background:lightgray; font-size:15px; padding:3px 20px; border-radius:20px;">Dodam</span> <span style="background:lightgray; font-size:15px; padding:3px 20px; border-radius:20px;">Dam</span>
					</div>
					<div style="float:right; font-size:15px; padding:10px;">
						<a href="note_detail_edit.jsp?problem_idx=<%=rs.getInt("problem_idx") %>" style="color:black;">Edit</a>
						<a onclick="confirmDeletion('<%=rs.getInt("problem_idx") %>')" style="color:black;">Delete</a>
					</div>
				</div>
			</div>	
			
			<div style="font-weight:bold; font-size:20px; border:3px solid black; background:#5F99EB; padding:30px; margin-top:50px; vertical-align:middle; ">
				<%
					String subMemoStr = rs.getString("sub_memo");
					String[] subMemos = subMemoStr != null ? subMemoStr.split("\n") : new String[]{};
				%>
				<% for (String memo : subMemos) { %>
					<div style="padding:5px;">
						<img src="img/star_red.png" style="width:13px;"> <span><%=memo %></span>
					</div>
		        <% } %>
			</div>
			
			<div style="display: grid; margin-top: 50px; grid-template-columns: 5fr 2fr; column-gap: 30px;">
		        <div style="column-gap: 10px; border: 3px solid black; background: white; padding: 10px;">
		            <div id="code-editor" style="display: grid; grid-template-columns: 1fr 17fr; border: none;">
		                <textarea class="notes" id="lineNumbers" rows="10" wrap="off" style="font-size:15px; overflow:auto; text-align:center; padding-bottom:0px;" readonly></textarea>
		                <textarea class="notes" id="cppCode" rows="10" placeholder="Enter your code here..." wrap="off" style="font-size:15px; overflow-x:auto; padding-bottom:60px;" readonly><%=rs.getString("code") %></textarea>
		            </div>
		        </div>
        

        <div style="column-gap: 10px; border: 3px solid black; background: white; padding: 10px;">
            <div id="code-editor" style="border: none;">
                <textarea class="notes" id="note_detail" rows="10" placeholder="Enter your note here..." wrap="off" style="font-size:15px; overflow-x:auto; padding-bottom:60px;" readonly><%=rs.getString("main_memo") %></textarea>
            </div>
        </div>
    	</div>
		<%
			}
			con.close();
			pstmt.close();
			rs.close();
		} catch(SQLException e) {
 			out.print(e);
 			return;
 		}
		%>
		
		<script>
	        const textarea = document.getElementById('cppCode');
	        const lineNumbers = document.getElementById('lineNumbers');
					
	        function updateLineNumbers() {
	            const numberOfLines = textarea.value.split('\n').length;
	            let lineNumberString = '';
	
	            for (let i = 1; i <= numberOfLines; i++) {
	                lineNumberString += i + '\n'
	            }
	
	            lineNumbers.value = lineNumberString;
	        }
	
	        function adjustHeight(element) {
	            element.style.height = 'auto'; // Reset height to auto to measure scrollHeight
	            element.style.height = element.scrollHeight + 'px'; // Adjust height to fit content
	        }
	
	        // Function to sync heights between textareas
	        function syncHeights() {
	            const maxScrollHeight = Math.max(textarea.scrollHeight, lineNumbers.scrollHeight);
	            textarea.style.height = maxScrollHeight + 'px';
	            lineNumbers.style.height = maxScrollHeight + 'px';
	        }
	
	        // 초기 라인 번호 및 높이 업데이트
	        updateLineNumbers();
	        syncHeights();
	
	        // 사용자가 텍스트를 입력하거나 줄을 변경할 때 라인 번호 및 높이 업데이트
	        textarea.addEventListener('input', () => {
	            updateLineNumbers();
	            syncHeights();
	        });
	
	        // Scroll the line numbers to match the code textarea
	        textarea.addEventListener('scroll', () => {
	            lineNumbers.scrollTop = textarea.scrollTop;
	        });
	
	        function submitCppCode() {
	            const code = textarea.value;
	            console.log("Submitted C++ Code:", code);
	
	            // 서버에 코드를 전송하거나 WebAssembly로 처리하는 로직을 여기에 추가합니다.
	        }
    	</script>
		</div>
			
	</div>
	
	<br><br>

	<footer></footer>

</body>
</html> 