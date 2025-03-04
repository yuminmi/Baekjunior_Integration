<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.sql.*, javax.naming.*, Baekjunior.db.*" session="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>note_detail_edit</title>
<link rel="stylesheet" href="Baekjunior_css.css">

<script>
/* profile top 위치 */
function updateProfileSelectTopLoc() {
	let profile_div = document.getElementById("profile");
	let myprodiv_div = document.getElementById("myprodiv");
	

	let profile_div_bottom = profile_div.getBoundingClientRect().bottom;
	 myprodiv_div.style.top = profile_div_bottom + "px";
	console.log("top2: " + profile_div_bottom);
	
}

window.addEventListener("DOMContentLoaded", updateProfileSelectTopLoc);
window.addEventListener("resize", updateProfileSelectTopLoc);

//profile에 hover할 때만 실행
let profile_div = document.getElementById("profile");

document.addEventListener("DOMContentLoaded", function () {
    let profile_div = document.getElementById("profile");

    if (profile_div) {
        profile_div.addEventListener("mousemove", (event) => {
            updateProfileSelectTopLoc();
        });
    }
});



function confirmLogout() {
	var result = confirm("정말 로그아웃 하시겠습니까?");
	if (result) {
	    window.location.href = "logout_do.jsp";
		} else {
    	return false;
		}
}

function confirmDeletion(problemIdx) {
    var result = confirm("정말 삭제하시겠습니까?");
    if (result) {
        window.location.href = "note_delete_do.jsp?problem_idx=" + problemIdx;
    } else {
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
int problemIdx = Integer.parseInt(request.getParameter("problem_idx"));

Connection con = DsCon.getConnection();
PreparedStatement pstmt = null;
ResultSet rs = null;
%>



<body>	
	<header>
		<a href="index.jsp" class="logo">Baekjunior</a>
		<%
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
	<%
		try {
			String sql = "SELECT * FROM problems WHERE problem_idx=?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, problemIdx);
			rs = pstmt.executeQuery();
			if(rs.next()){
	%>
	<section class="banner">
		<a href="index.jsp" class="logo"></a>
	</section>
	
	
	<!-- bookmark_star에 대한 SCRIPT -->
	<script>
		document.addEventListener('DOMContentLoaded', function() {
		    const bookmarkStars = document.querySelectorAll('.bookmark_star');
	
		    bookmarkStars.forEach(function(star) {
		        star.addEventListener('click', function() {
		            const currentSrc = this.getAttribute('src');
		            let isChecked = 0;
	
		            if (currentSrc === 'img/star_on.png') {
		                this.setAttribute('src', 'img/star_off.png');
		                isChecked = 0;
		            } else {
		                this.setAttribute('src', 'img/star_on.png');
		                isChecked = 1;
		            }
		            
		            /* 북마크의 상태를 서버로 보냄 */
		            const xhr = new XMLHttpRequest();
	                xhr.open("POST", "updateBookmark.jsp", true);
	                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	                xhr.onreadystatechange = function () {
	                    if (xhr.readyState === 4 && xhr.status === 200) {
	                        console.log(xhr.responseText);  
	                    }
	                };
	                xhr.send("problem_idx=<%=problemIdx%>&is_checked=" + isChecked);
		        });
		    });
		});
	</script>
	
	
	<div style="margin-top:20px;">
		<div style="width:80%; margin:0 auto;">
			<div>
				<div>
					<div style="font-size:30px; font-weight:bold; margin-bottom:40px;">Edit Mode</div>
					<div style="display:inline; width:80%; font-size:25px; font-weight:bold;">
						#<span><%=rs.getInt("problem_id") %></span> : <span><%=rs.getString("problem_title") %></span>
						<!-- is_checked가 1이면 북마크 상태, 아니면 북마크되지 않은 상태 -->
						<% if(rs.getInt("is_checked") == 1) { %> 
						<span><img class="bookmark_star" src="img/star_on.png" style="width:18px;cursor:pointer;"></span>
						<% } else { %>
						<span><img class="bookmark_star" src="img/star_off.png" style="width:18px;cursor:pointer;"></span>
						<% } %>
					</div>
					<div style="float:right; font-size:15px; padding:10px;">
						Submit Date : <span><%=rs.getDate("submitDate") %></span>
					</div>
				</div>
				
				<div style="font-weight:bold; font-size:18px; margin-top:15px; margin-left:20px;">
					<!-- 티어 -->
					<div style="display:inline; margin-right:50px;">
						<%
						String tierName = rs.getString("tier_name"); 
						int tierNum = rs.getInt("tier_num");
						%>
						<span><img src="img/star_<%=tierName.toLowerCase()%>.png" height="15px"></span>
						<span> <%=tierName.toUpperCase()%> <%=tierNum %></span>
					</div>
					<!-- 알고리즘 종류 나열 -->
					<div style="display:inline; margin-right:25px;">
						<%
						String problemSortStr = rs.getString("problem_sort");
						String[] algorithmList = problemSortStr.split(",");
	                   	if(problemSortStr != null && !problemSortStr.trim().isEmpty()) {
	                   		for (String algo : algorithmList) {
	                           	if (!algo.isEmpty()) {
						%>
						<span style="margin-right:25px;"><img src="img/dot1.png" style="width:15px;"><span> <%=algo %></span></span>
						<%
	                           	}
	                   		}
	                   	}
							else {
						%>
						<span style="margin-right:25px;"><img src="img/dot1.png" style="width:15px;"></span><span> default sort</span>
						<% } %>
					</div>
					<!-- 언어 종류 -->
					<div style="display:inline;">
						<span style="margin-right:50px;"><%=rs.getString("language") %></span>
					</div>
					<div style="height:10px;"></div>
					<div style="display:inline;">
						<span>link <img src="img/link.png" style="height:17px;"> | <a href="<%=rs.getString("problem_url") %>" target="_blank" style="color:#4169E1; text-decoration:underline"><%=rs.getString("problem_url") %></a></span>
					</div> 
				</div>
			</div>	
			
			<script>
			document.addEventListener('DOMContentLoaded', function() {
			    const addButton = document.getElementById('add_btn');
			    const container = document.getElementById('container');

			    addButton.addEventListener('click', function(event) {
			        event.preventDefault(); // 링크 기본 동작 방지
			        
			        // 새로운 div 요소 생성
			        const newDiv = document.createElement('div');
			        newDiv.className = 'submemo_div';

			        // div 내부 HTML 설정
			        newDiv.innerHTML = `
			        	<span class="icon">
				            <img src="img/arrow3.png" alt="arrow">
				        </span>
			            <input type="text" name="sub_memo" class="input_field" value="">
			            <img class="delete_btn" src="img/x.png" alt="delete">
			        `;

			        // X 버튼 클릭 이벤트 리스너 추가
			        newDiv.querySelector('.delete_btn').addEventListener('click', function(event) {
			            event.preventDefault(); // 링크 기본 동작 방지
			            container.removeChild(newDiv); // div 제거
			        });

			        // 컨테이너에 새로운 div 추가
			        container.appendChild(newDiv);
			    });

			    // 기존의 X 버튼 클릭 이벤트 리스너 추가
			    container.addEventListener('click', function(event) {
			        if (event.target.classList.contains('delete_btn')) {
			            event.preventDefault(); // 링크 기본 동작 방지
			            const divToRemove = event.target.closest('.submemo_div'); // 클릭한 X 버튼이 포함된 div 찾기
			            container.removeChild(divToRemove); // div 제거
			        }
			    });
			});
			</script>
			<form method="POST" action="note_detail_edit_do.jsp">
			<input type="hidden" name="problem_idx" value="<%=problemIdx %>">
			<div class="sub_note" style="font-weight:bold; font-size:20px; border:3px solid black; background:#5F99EB; padding:30px; margin-top:50px; vertical-align:middle; ">
				<%
					String subMemoStr = rs.getString("sub_memo");
					String[] subMemos = subMemoStr != null ? subMemoStr.split("\n") : new String[]{};
				%>
				<div id="container">
				<% for (String memo : subMemos) { %>
		        	
		        	
		        	<div class="submemo_div">
				        <span class="icon">
				            <img src="img/arrow3.png" alt="arrow">
				        </span>
				        <input type="text" name="sub_memo" class="input_field" value="<%=memo%>">
				        <img class="delete_btn" src="img/x.png" alt="delete">
				    </div>
		        <% } %>
		        </div>
		        
		        <div style="padding:10px 5px 5px 5px; margin-bottom:20px;">
		            <a id="add_btn" href="#" style="padding:0px; margin:0px;"><img src="img/plus.png" style="height:20px;"></a>
		        </div>
			</div>
			
			<div style="display: grid; margin-top: 50px; grid-template-columns: 5fr 2fr; column-gap: 30px;">
		        <div style="column-gap: 10px; border: 3px solid black; background: white; padding: 10px;">
		            <div id="code-editor" style="display: grid; grid-template-columns: 1fr 17fr; border: none;">
		                <textarea class="notes" id="lineNumbers" rows="10" wrap="off" style="font-size:15px; overflow:auto; text-align:center; padding-bottom:0px;" readonly></textarea>
		                <textarea class="notes" name="code_note" id="code_note" rows="10" placeholder="Enter your code here..." wrap="off" style="font-size:15px; overflow-x:auto; padding-bottom:60px;"><%=Util.nullChk(rs.getString("code"), "") %></textarea>
            </div>
        </div>
        

        <div style="column-gap: 10px; border: 3px solid black; background: white; padding: 10px;">
            <div id="code-editor" style="border: none;">
                <textarea class="notes" name="main_memo" id="note_detail" rows="10" placeholder="Enter your note here..." wrap="off" style="font-size:15px; overflow-x:auto; padding-bottom:60px;"><%=Util.nullChk(rs.getString("main_memo"), "") %></textarea>
            </div>
        </div>
    	</div>		
	
	<!-- lineNumbers 설정 -->	
	<script>
    const textarea = document.getElementById('code_note');
    const lineNumbers = document.getElementById('lineNumbers');
			
    function updateLineNumbers() {
        const numberOfLines = textarea.value.split('\n').length;
        let lineNumberString = '';

        for (let i = 1; i <= numberOfLines; i++) {
            lineNumberString += i + '\n'
            console.log("DDD: " + i);
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

    function submitcode_note() {
        const code = textarea.value;
        console.log("Submitted Code:", code);

        // 서버에 코드를 전송하거나 WebAssembly로 처리하는 로직을 여기에 추가합니다.
    }
</script>
    	
	    	<div style="float:right; margin-top:50px">
	    		<button type="submit" style="font-size:15px; font-weight:bold;  background:white; border:3px solid black; padding:5px 20px; cursor:pointer;">Save</button>
			</div>
			</form>
			
			<!-- 아래 여백 만드는 용도 -->
			<div style="height:200px;"></div>
			
		</div>
		
		
		
	</div>
	
	

	<footer></footer>

</body>
</html>
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