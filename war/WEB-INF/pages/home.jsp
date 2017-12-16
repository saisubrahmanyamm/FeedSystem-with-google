
<%
	response.setHeader("Cache-control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
//  	if(session.getAttribute("SessionID_Email")!=null)
//  	      response.sendRedirect("home");
%>
<html>
<head>
<title>Home</title>
<link type="text/css" rel="stylesheet" href="/images/pages.css" />
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script type="text/javascript">
//window.onbeforeunload = function() { return "Your work will be lost."; };

	$(document).ready(
			function() {
				//Fetching details of old updates
				$(".loader").hide();
				$(".homeloader").show();
				$("#updateSpan").hide();
				$.ajax({
					url : '/fetchUpdates',
					datatype : 'json',
					type : 'get',
					contentType : 'application/json',
					success : function(updatefeedsObj) {
						
						
						$(".homeloader").hide();
						var parsingResponse = JSON.parse(updatefeedsObj);
						for (var i = 0; i < parsingResponse.length; i++) {
							var istDate = (new Date(parsingResponse[i].date))
									.toUTCString();
							var date = new Date(istDate);
							var newIstDate = date.toString();
							newIstDate = newIstDate.split(' ').slice(0, 5)
									.join(' ');
							$("#container").append(
									"<div class='feeds'>" + "<div id = 'user'>"
											+ parsingResponse[i].userName
											+ " ("
											+ parsingResponse[i].userMail
											+ ")<div id ='time'>" + newIstDate
											+ "</div> </div>"
											+ "<p id ='feedstyle'>"
											+ parsingResponse[i].feed
											+ "</p><div>");
						
							}
						
					}
				});
				//When the user clicks anywhere outside of the modal, close it
				var feedboxModal = document.getElementById('feedbox');
				window.onclick = function(event) {
					if (event.target == feedboxModal) {
						feedboxModal.style.display = "none";
					}
				}
			});
	
	//Updating Feed on clicking UPDATE button
	function buttonClick() {
		$("#button_update").hide();
		$(".loader").show();
		var feed = $("#feedTextId").val();
		var userMail = $("#userEmail").text();
		var userName = $("#userName").text();
		if (feed != "" && userMail != null && !(userMail === "")) {
			var data = {
				"feed" : feed,
				"userMail" : userMail,
				"userName" : userName
			};
			$.ajax({
				url : '/updatefeed',
				type : 'post',
				dataType : 'json',
				contentType : "application/json",
				data : JSON.stringify(data),

				success : function(feedObj) {

					var userName = feedObj.UserName;
					var userEmail = feedObj.Email;
					var feed = feedObj.Feed;
					var istDate = (new Date(Number(feedObj.Time)))
							.toUTCString();
					var date = new Date(istDate);
					var newIstDate = date.toString();
					newIstDate = newIstDate.split(' ').slice(0, 5).join(' ');
					$("#container").prepend(
							"<div class='feeds'>" + "<div id = 'user'>"
									+ userName + " (" + userEmail
									+ ")<div id = 'time'>" + newIstDate
									+ "</div></div>" + "<p id ='feedstyle'>"
									+ feed + "</p><div>");
					$("#feedTextId").val("");
					$("#feedbox").hide();
					$("#button_update").show();
					$(".loader").hide();

				}
			});
		} else {
			$(".loader").hide();
			$("#button_update").show();
			$("#updateSpan").show().fadeOut(1500);
		}
	}
</script>

</head>
<body>
	<div class="heading">
		<b>Feed Status</b>

		<p style="font-family: cursive; font-size: 20px; text-align: left">
			<button id="signup-button"
				style="padding: 5.2px 7px; margin-left: 0.5cm; background-color: #B3008E; a: hover: none">Home</button>
			<a href="profile">My Profile </a> <a href="logout">Log out </a>
		</p>

	</div>
	<div>
		<%
			String userEmail = (String) session.getAttribute("SessionID_Email");
		%>
		<%
			String userName = (String) session.getAttribute("SessionID_UserName");
		%>

		<p></p>
		<p
			style="text-align: left; color: #3e74a0; font-family: cursive; font-size: 22px; margin-left: 1cm">
			Hello Welcome <strong id='userName'><%=userName%></strong> (<span
				id='userEmail'><%=userEmail%></span>)<br> You Have successfully
			logged in
		</p>
		<button id=feedbutton
			onclick="document.getElementById('feedbox').style.display='block'"
			style="width: auto;">Update a feed?</button>
		<div id="feedbox" class="modal">
			<div class="modal-content">
				<div class="imgcontainer">
					<h1 align="center"
						style="font-family: cursive; color: #b1c0cc; margin-top: -0.62cm">Feed
						Update</h1>
					<span
						onclick="document.getElementById('feedbox').style.display='none'"
						class="close" title="Close feedbox">&times;</span>
				</div>
				<table class="feedTable">
					<tr>
						<td><textarea id="feedTextId" name="feedText" rows="2"
								cols="50" placeholder="Hi, you can update feeds here.."></textarea></td>
					</tr>
					<tr>
						<td><input type="button" id="button_update"
							value="UpdateFeed" onclick='buttonClick()'>
							<div class="loader"></div></td>
					</tr>
					<tr>
						<td><span id='updateSpan'>Feed should not empty</span></td>
					</tr>
				</table>
			</div>
		</div>
		<h1 id="allUpdates">All Updates</h1>
		<div class="homeloader"></div>
		<div id="container"></div>
	</div>
</body>
</html>