
<%
	response.setHeader("Cache-control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", -1);
%>
<html>
<head>
<title>Forger Password</title>
<link type="text/css" rel="stylesheet" href="/images/pages.css" />
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

<script>
	$(document).ready(function() {
		$('#inputemail').val("");
		$('#emailSpan').hide();
		$("#emailnotExistsSpan").hide();
		$('#emailSent').hide();


	});
	function forgetPasswordClicked() {
		var email = $('#inputemail').val();
		
		var emailRegex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
		

		if (email == null || email == "" || !emailRegex.test(email)) {
			$("#emailSpan").show().fadeOut(1500);
		} else {
			var useremail = {
				"email" : email,
			};

			$.ajax({
				url : "/forgetPassword",
				type : "post",
				contentType : "application/json",
				dataType : "json",
				data : JSON.stringify(useremail),
				success : function(responseObj) {
			
					if (responseObj.SuccessMsg == "success") {
						$('#forgetPassword1').hide();
						$('#emailSent').show();
						

					} else {
						$("#emailnotExistsSpan").show().fadeOut(1500);
					}
				}
			});
		}
	}
	
	
</script>

</head>

<body>
	<div class="heading">
		<b>Feed Status</b>
	</div>
	<div>
		<p
			style="text-align: left; font-family: cursive; font-size: 22px; color: #B3008E;">
			Please enter your email to change your password</p>
		<table align="left" cellspacing="3" cellpadding="4">
			<tr>
				<td>E-mail</td>
				<td><input type="email" name="email" id="inputemail" size="40"></td>
				<td><input type="button" value="Forget Password" class="submit"
					id="forgetPassword1" onclick='forgetPasswordClicked()'></td>
			</tr>
			<tr>
				<td id="td"></td>
				<td id="td"><span id='emailnotExistsSpan'> E-mail
						doesn't exists</span></td>
			</tr>
			<tr>
				<td id="td"></td>
				<td id="td"><span id='emailSpan'>E-mail is not vaild</span></td>
			</tr>
			<tr>
				<td id="td"></td>
				<td id="td"><span id='emailSent'>Password has sent to your E-mail address.</span></td>
			</tr>
			</div>
</body>
</html>