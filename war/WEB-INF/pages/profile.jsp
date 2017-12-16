<%response.setHeader("Cache-control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", -1); %>
<html>
<head>
<title>Profile</title>
<link type="text/css" rel="stylesheet" href="/images/pages.css" />
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script>
$(document).ready(function() {
	$('#password').val("");
	$('#userEmail').hide();
	$('#passwordSpan').hide();
	$('#updatedPassword').hide();

	$('#updated').hide();
	var updatedPasswordModal = document.getElementById('updatedPassword');
	window.onclick = function(event) {
		if (event.target == updatedPasswordModal) {
			updatedPasswordModal.style.display = "none";
			$("#password").val("");
		}
	}

});
function changePasswordClicked(){
	var pwdRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$/;
	var password = $('#password').val();
	var email = $('#userEmail').val();
console.log(email);
	if (password == null || password == ""
		|| !pwdRegex.test(password)) {
	
	$("#passwordSpan").show().fadeOut(1500);

}
	else{
		var userPassword = {
				"password" : password,
				"email": email,
		};
		$.ajax({
			url : "/updatingPassword",
			type : "post",
			contentType : "application/json",
			dataType : "json",
			data : JSON.stringify(userPassword),
			success : function(responseObj) {
		
				if (responseObj.SuccessMsg == "success") {
					$('#updated').show();
				}
	}
	});	
}
}

</script>

</head>
<body>
<%
			String userEmail = (String) session.getAttribute("SessionID_Email");
		%>
	<div class="heading">
		<b>Feed Status</b>
		<span
				id='userEmail1'><%=userEmail%></span>
				<input type="email" value= <%=userEmail%> id ="userEmail">

		<p style="font-family: cursive; font-size: 20px; text-align: left">

			<a href="home">Home</a>
			<button id="signup-button"
				style="padding: 5.2px 7px; background-color: #B3008E; a: hover: none">My
				Profile</button>
			
			<a href="logout">Log out </a>
			<button id="signup-button"  style="padding: 5.2px 7px; a: hover: none"
				onclick="document.getElementById('updatedPassword').style.display='block'"
				style="width: auto;">Change Password</button>
			
	<div id="updatedPassword" class="modal">
		<div class="modal-content">
			<div class="imgcontainer">
				<h1 align="center"
					style="font-family: cursive; color: #b1c0cc; margin-top: -0.62cm; font-size: 30px" >Change Password</h1>
				<span
					onclick="document.getElementById('updatedPassword').style.display='none'"
					class="close" title="Close Login">&times;</span>
			</div>
			<table align="center" cellspacing="3" cellpadding="4">
			<tr >
				<td>Set New Password</td>
				<td><input type="password" size="40" id = "password"></td>
				<td><p style="font-size: 14px;">
						*Must contain at least 1 number <br> & 1 uppercase & 1
						lowercase letter,<br> & at least 6 or more characters"
					</p></td>
			</tr>
			<tr>
				<td id="td"></td>
				<td id="td"><span id='passwordSpan'>Password didn't
						match above criteria</span></td>
			</tr>
			<tr>
				<td id="td"></td>
				
				<td><input type="button" value="Save" class="submit" id="save"
					 onclick='changePasswordClicked()'></td>
			</tr>
			<tr><td id="td"></td>
				<td id="td"><span id='updated'>Your password has been changed</span></td></tr>
				</table>
				<div id="loginbody" style="background-color: #f1f1f1"></div>
				</div>
				</div>
				
				
		</p>
	</div>
	<div>
		<p style="text-align: left; font-family: cursive; font-size: 22px; color: #3e74a0; margin-left: 1cm">Hello,
			This is your profile and this is your image.</p>
	</div>
	<div style="margin: 2cm 0cm 0cm 3cm">
		<img alt="userpicture" src="/images/userpicture.jpg" width="300px"
			height="300px">
	</div>
</body>
</html>