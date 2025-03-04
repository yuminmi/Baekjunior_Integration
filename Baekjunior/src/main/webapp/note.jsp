<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.sql.*, javax.naming.*, Baekjunior.db.*" session="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>note</title>
<link rel="stylesheet" href="Baekjunior_css.css">
<script src="https://kit.fontawesome.com/c9057320ee.js" crossorigin="anonymous"></script>

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

<style>
a{
	text-decoration: none;
	color:black;
}

 @-webkit-keyframes takent {
      0% {
         flex: 0;
      }
      100% {
         flex: 3;
      }
   }
   @keyframes takent {
      0% {
         flex: 0;
      }
      100% {
         flex: 3;
      }
   }
   @-webkit-keyframes outnt {
      0% {
         flex: 3;
      }
      100% {
         flex: 0;
      }
   }
   @keyframes outnt {
      0% {
         flex: 3;
      }
      100% {
         flex: 0;
      }
   }
   .outnote {
      animation-name: outnt;
      animation-duration: 2s;
   }
</style>

</head>



<%
request.setCharacterEncoding("utf-8");
String userId = "none";
HttpSession session = request.getSession(false);

if(session != null && session.getAttribute("login.id") != null) {
	userId = (String) session.getAttribute("login.id");
} else {
	response.sendRedirect("information.jsp");
    return;
}
int problemIdx = Integer.parseInt(request.getParameter("problem_idx"));

String algorithmSort = request.getParameter("algoname");


Connection con = DsCon.getConnection();
PreparedStatement pstmt = null;;
PreparedStatement pstmt2 = null;
PreparedStatement memoPstmt = null;
ResultSet rs = null;
ResultSet rs2 = null;
ResultSet memoRs = null;
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
	
	
	<div style="display:flex;">
	
	<!-- 알고리즘 노트 보는 div -->
	<%if(algorithmSort != null){ %>
	<div id="algonote" style="display:block;margin-top: 20px;flex:3; animation-name:takent;animation-duration:2s;">
         <div style="width: 80%; margin-left:auto;">
            <div class="algorithm_name" style="display: flex;align-items: center;justify-content: space-between;">
               <div>
                  <img src="img/dot1.png" style="width: 15px;height:15px;">
                  <h1 style="display: inline;font-size: 30px;margin-left: 10px;"><%=algorithmSort %></h1>
               </div>
               <i class="fa-solid fa-xmark fa-xl" id="x" onclick="closealgont()" style="margin-right:4;cursor:pointer;"></i>
            </div>
            <script>
            function closealgont() {
               document.getElementById("algonote").classList.remove("outnote");
               document.getElementById("algonote").classList.add("outnote");
               location.href="note.jsp?problem_idx=<%=rs.getInt("problem_idx")%>";
            }
            </script>
            <div class="memo" style="margin-top:20px;">
               <div class="memo_box" contenteditable="true" id="editablememo" style="min-height:600px;padding:30px;background:white;border-radius:10px;border:3px solid black;">
                  <%
                  	String memoSql = "SELECT * FROM algorithm_memo WHERE user_id=? AND algorithm_name=?";
                  
                  	memoPstmt = con.prepareStatement(memoSql);
                  	memoPstmt.setString(1, userId);
                  	memoPstmt.setString(2, algorithmSort);
                  	
                  	memoRs = memoPstmt.executeQuery();
                  	if(memoRs.next()) {
                  %>
                  <%=Util.nullChk(memoRs.getString("algorithm_memo"), "")%>
                  <% } %>
               </div>
               <!-- editablememo 내용 수정할때마다 받아오기 -->
               <script>
                  const editablememo = document.getElementById('editablememo');
                  
                  // 텍스트가 수정될 때마다 발생하는 이벤트 리스너 추가
                  editablememo.addEventListener('input', function() {
                     //변경된 텍스트 받아오기
                     const editedtext = this.innerText;
                     console.log('변경된 텍스트: ', editedtext);
                  })
                  editablememo.addEventListener('focusout', function() {
                      console.log('포커스를 잃었습니다.');
                      // 사용자가 메모box를 벗어나면 db에 저장
                      
	                  const xhr = new XMLHttpRequest();
	                  const userId = '<%= userId %>'; // 세션에서 가져온 사용자 ID
	                  const algorithmSort = '<%= algorithmSort %>'; // 문제의 알고리즘 분류
	                  const editedtext = editablememo.innerText	; // 현재 수정된 텍스트
	
	                  xhr.open("POST", "algorithm_note_modify.jsp", true);
	                  xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	                  xhr.onreadystatechange = function () {
	                      if (xhr.readyState === 4 && xhr.status === 200) {
	                          console.log("Response from server: ", xhr.responseText);
	                       }
	                  };
	
	                  // 파라미터로 userId, algorithmSort, 수정된 메모를 전송
	                  xhr.send("user_id=" + encodeURIComponent(userId) + "&algorithm_name=" + encodeURIComponent(algorithmSort) + "&algorithm_memo=" + encodeURIComponent(editedtext));
	                  });
                  
               </script>
            </div>
         </div>
   </div>   
   <%} %>
	
	
	
	
	
	<!-- bookmark_star에 대한 SCRIPT -->
	<script>
		document.addEventListener('DOMContentLoaded', function() {
		    const bookmarkStars = document.querySelectorAll('.bookmark_star');
	
		    bookmarkStars.forEach(function(star) {
		        star.addEventListener('click', function() {
		            const currentSrc = this.getAttribute('src');
	
		            if (currentSrc === 'img/star_on.png') {
		                this.setAttribute('src', 'img/star_off.png');
		                isChecked = 0;
		            } else {
		                this.setAttribute('src', 'img/star_on.png');
		                isChecked = 1;
		            }
		            
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
	
	
	
	
	
	

	<div style="margin-top:20px; <%= (algorithmSort != null) ? "width:70%; flex:7;" : "width:100%;" %>">
		<div style="width:80%; margin:0 auto;">
			<div>
				<div>
					<div style="display:inline; width:80%; font-size:30px; font-weight:bold;">
						#<span><%=rs.getInt("problem_id") %></span> : <span><%=rs.getString("problem_title") %></span> 
						<% if(rs.getInt("is_checked") == 1) { %> 
							<span><img class="bookmark_star" src="img/star_on.png" style="width:25px;cursor:pointer;"></span>
						<% } else { %>
							<span><img class="bookmark_star" src="img/star_off.png" style="width:25px;cursor:pointer;"></span>
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
						<span style="margin-right:25px;"><img src="img/dot1.png" style="width:15px;"><a href="note.jsp?problem_idx=<%=rs.getInt("problem_idx")%>&algoname=<%=algo %>"> <%=algo %></a></span>
						<%
	                           	}
	                   		}
	                   	}
							else {
						%>
						<span style="margin-right:25px;"><img src="img/dot1.png" style="width:15px;"> default sort</span>
						<% } %>
					</div>
					<!-- 언어 종류 -->
					<div style="display:inline;">
						<span style="margin-right:50px;"><%=rs.getString("language") %></span>
					</div> 
					<div style="height:10px;"></div>
					<div style="display:inline;">
						<span>link <img src="img/link.png" style="height:17px;"> | <a href="<%=rs.getString("problem_url") %>" target="_blank" style="color:#4169E1; text-decoration:underline;"><%=rs.getString("problem_url") %></a></span>
					</div> 
					<div style="height:10px;"></div>
					<div style="display:inline;">
						Friends who solved :
						<%
						try {
							String sql2 = "SELECT * FROM problems WHERE problem_id = ? AND user_id != ? GROUP BY user_id LIMIT 3";
							
							pstmt2 = con.prepareStatement(sql2);
							pstmt2.setInt(1, rs.getInt("problem_id"));
							pstmt2.setString(2, userId);
							rs2 = pstmt2.executeQuery();
							while(rs2.next()){
						%>
						<span style="background:lightgray; font-size:15px; padding:3px 20px; border-radius:20px;"><%=rs2.getString("user_id") %></span>
						<%
							}							
						} catch(SQLException e) {
				 			out.print(e);
				 			return;
				 		}
						%>
						<span style="background:lightgray; font-size:15px; padding:3px 20px; border-radius:20px;">
							<a href="friend_note.jsp?problem_id=<%=rs.getInt("problem_id") %>"><img src="img/list.png" style="height:13px;"></a>
						</span>
					</div>
					<div style="float:right; font-size:15px;">
						<a href="note_detail_edit.jsp?problem_idx=<%=rs.getInt("problem_idx") %>" style="color:black; text-decoration:underline; padding-right:5px;">Edit</a>
						<a onclick="confirmDeletion('<%=rs.getInt("problem_idx") %>')" href="#" style="color:black; text-decoration:underline;">Delete</a>
					</div>
				</div>
			</div>	
			
			<div style="font-weight:bold; font-size:20px; border:3px solid black; background:#5F99EB; padding:30px; margin-top:50px; vertical-align:middle; ">
				<%
					String subMemoStr = rs.getString("sub_memo");
					String[] subMemos = subMemoStr != null ? subMemoStr.split("\n") : new String[]{};
					
					if(subMemoStr == null){
						%>
						<div></div><%
					}
					else{
				%>
					<% for (String memo : subMemos) { %>
						<div style="padding:5px;">
							<img src="img/arrow3.png" style="height:15px; margin-right:5px;"> <span style="white-space: pre;"><%=memo %></span>
						</div>
		        <% 	   }
					} %>
			</div>
			
			<div style="display: grid; margin-top: 50px; grid-template-columns: 5fr 2fr; column-gap: 30px;">
		        <div style="column-gap: 10px; border: 3px solid black; background: white; padding: 10px;">
		            <div id="code-editor" style="display: grid; grid-template-columns: 1fr 17fr; border: none;">
		                <textarea class="notes" id="lineNumbers" rows="10" wrap="off" style="font-size:15px; overflow:auto; text-align:center; padding-bottom:0px; " readonly></textarea>
		                <textarea class="notes" id="code_note" rows="10" placeholder="Enter your code here..." wrap="off" style="font-size:15px; overflow-x:auto; padding-bottom:60px;" readonly><%=Util.nullChk(rs.getString("code"), "") %></textarea>
		            </div>
		        </div>

       		 	<div style="column-gap: 10px; border: 3px solid black; background: white; padding: 10px;">
		            <div id="code-editor" style="border: none;">
		                <textarea class="notes" id="note_detail" rows="10" placeholder="Enter your note here..." wrap="off" style="font-size:15px; overflow-x:auto; padding-bottom:60px;" readonly><%=Util.nullChk(rs.getString("main_memo"), "") %></textarea>
		            </div>
        		</div>
    		</div>
		<%
			}
			con.close();
			pstmt.close();
			rs.close();
			pstmt2.close();
			rs2.close();
			
			if(algorithmSort != null){
				memoPstmt.close();
				memoRs.close();
			}
			
		} catch(SQLException e) {
 			out.print(e);
 			return;
 		}
		%>
		
		<script>
	        const textarea = document.getElementById('code_note');
	        const lineNumbers = document.getElementById('lineNumbers');
	        
			console.log("AA: " + textarea);
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
	
	        function submitcode_note() {
	            const code = textarea.value;
	            console.log("Submitted Code:", code);
	
	            // 서버에 코드를 전송하거나 WebAssembly로 처리하는 로직을 여기에 추가합니다.
	        }
    	</script>
		</div>
			
	</div></div>
	
	<br><br>

	<footer></footer>

</body>
</html> 