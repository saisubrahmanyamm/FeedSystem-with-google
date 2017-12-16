
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">


<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>Feed Status</title>

<link type="text/css" rel="stylesheet" href="/images/pages.css" />
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
<link rel="icon" href="/favicon.ico" type="image/x-icon" />
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>


<script>
	$(document).ready(function() {
		$('#signuperrorSpan').hide();
		$('#loginerrorSpan').hide();
		$('#userNameSpan').hide();
		$('#passwordSpan').hide();
		$('#emailSpan').hide();
		$("#mobileSpan").hide();
		$("#dobSpan").hide();
		$("#genderSpan").hide();
		$(".loader").hide();

		$('.heading').mouseenter(function() {
			$(this).fadeTo('fast', 0.9);
		});
		$('.heading').mouseleave(function() {
			$(this).fadeTo('fast', 1);
		});
		$('input').focus(function() {
			$(this).css('outline-color', '#B3008E');
		});
		$('#submit').click(function() {
			$(this).fadeIn(3000);
		});
		$('button').mouseenter(function() {
			$(this).fadeIn('slow');
		});

		//When the user clicks anywhere outside of the modal, close it
		var loginModal = document.getElementById('loginbody');
		var signupModal = document.getElementById('signupbody');
		window.onclick = function(event) {
			if (event.target == loginModal) {
				loginModal.style.display = "none";
				$("#inputemail").val("");
				$("#inputpassword").val("");
			} else if (event.target == signupModal) {
				signupModal.style.display = "none";
				$("#FirstName").val("");
				$("#LastName").val("");
				$("#Email").val("");
				$("#Password").val("");
				$(".Gender").prop('checked', false);
				$("#DOB").val("");
				$("#Mobile").val("");
				$(".loader").hide();

			}
		}
	});
	
	//Reset sign up form
	function reset() {
		$("#FirstName").val("");
		$("#LastName").val("");
		$("#Email").val("");
		$("#Password").val("");
		$(".Gender").prop('checked', false);
		$("#DOB").val("");
		$("#Mobile").val("");
		$(".loader").hide();
	}

	//On clicking sign up button ajax call
	function signUpClicked() {
		$(".loader").hide();
		
		var FirstName = $("#FirstName").val();
		var LastName = $("#LastName").val();
		var Email = $("#Email").val();
		var Password = $("#Password").val();
		var Gender = $("input[name='Gender']:checked").val();
		var DOB = $("#DOB").val();
		var Mobile = $("#Mobile").val();

		var emailRegex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
		var pwdRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$/;
		var mobRegex = /^(7|8|9)\d{9}$/;
		if (FirstName == null || FirstName == "") {
			$("#userNameSpan").show().fadeOut(1500);
			$("#emailSpan").hide();
			$("#passwordSpan").hide();
			$("#mobileSpan").hide;
			$("#dobSpan").hide();
			$("#genderSpan").hide();
		}

		else if (Email == null || Email == "" || !emailRegex.test(Email)) {
			$("#userNameSpan").hide();
			$("#emailSpan").show().fadeOut(1500);
			$("#passwordSpan").hide();
			$("#mobileSpan").hide;
			$("#dobSpan").hide();
			$("#genderSpan").hide();

		} else if (Password == null || Password == ""
				|| !pwdRegex.test(Password)) {
			$("#userNameSpan").hide();
			$("#emailSpan").hide();
			$("#passwordSpan").show().fadeOut(1500);
			$("#mobileSpan").hide;
			$("#dobSpan").hide();
			$("#genderSpan").hide();
		}

		else if (Gender == null || Gender == "") {
			$("#userNameSpan").hide();
			$("#emailSpan").hide();
			$("#passwordSpan").hide();
			$("#mobileSpan").hide;
			$("#dobSpan").hide();
			$("#genderSpan").show().fadeOut(1500);

		} else if (DOB == null || DOB == "") {
			$("#userNameSpan").hide();
			$("#emailSpan").hide();
			$("#passwordSpan").hide();
			$("#mobileSpan").hide;
			$("#dobSpan").show().fadeOut(1500);
			$("#genderSpan").hide();

		} else if (Mobile == null || Mobile == "" || !mobRegex.test(Mobile)) {
			$("#mobileSpan").show().fadeOut(1500);
			$("#dobSpan").hide();
			$("#genderSpan").hide();
			$("#userNameSpan").hide();
			$("#emailSpan").hide();
			$("#passwordSpan").hide();

		} else {
			var userData = {
				"firstName" : FirstName,
				"lastName" : LastName,
				"email" : Email,
				"password" : Password,
				"gender" : Gender,
				"dob" : DOB,
				"mobile" : Mobile
			};
			$(".submit").hide();
			$(".loader").show();
		
			$.ajax({
				url : "/signup",
				type : "post",
				contentType : "application/json",
				dataType : "json",
				data : JSON.stringify(userData),
				success : function(responseObj) {
					$("#errorSpan").html("");
					if (responseObj.SuccessMsg == "success") {
						location.href = "/home";
						
					} else {
						$(".loader").hide();
						$(".submit").show();
						$("#signuperrorSpan").show().fadeOut(1500);

					}

				}
			});
		}

	}
	
	//On clicking login button ajax call
	function loginClicked() {
		var Email = $("#inputemail").val();
		var Password = $("#inputpassword").val();
		var loginData = {
			"email" : Email,
			"password" : Password
		};
		$(".submit").hide();
		$(".loader").show();
		//	console.log(loginData);
		$.ajax({
			url : "/login",
			type : "post",
			contentType : "application/json",
			dataType : "json",
			data : JSON.stringify(loginData),
			success : function(responseObj) {
				$("#errorSpan").html("");
				//	console.log("  responseFromServer  :: " + responseObj.SuccessMsg);
				
				if (responseObj.SuccessMsg == "success") {
					location.href = "/home";
				} else {
					$(".loader").hide();
					$(".submit").show();
					$("#loginerrorSpan").show().fadeOut(1500);
				}
			}

		});
	}
</script>


</head>

<body>

	<div class="heading">
		<b>Feed Status</b>
		<p style="font-family: cursive; font-size: 20px; text-align: left">

			
			<button id=signup-button
				onclick="document.getElementById('signupbody').style.display='block'"
				style="width: auto;">SignUp</button>
			<button id=login-button
				onclick="document.getElementById('loginbody').style.display='block'"
				style="width: auto;">Login</button>
			<button id= googlelogin-button onclick= "window.location.href= '/loginWithGoogle'"> Login with Google</button>
		</p>
	</div>
	<div id="loginbody" class="modal">
		<div class="modal-content">
			<div class="imgcontainer">
				<h1 align="center"
					style="font-family: cursive; color: #b1c0cc; margin-top: -0.62cm">Login</h1>
				<span
					onclick="document.getElementById('loginbody').style.display='none'"
					class="close" title="Close Login">&times;</span>
			</div>
			<table align="center" cellspacing="3" cellpadding="4">
				<tr>
					<td>E-mail</td>
					<td><input type="email" name="email" id="inputemail"></td>
				</tr>
				<tr>
					<td>Password &nbsp;&nbsp;</td>
					<td><input type="password" name="password" id="inputpassword"
						required></td>
				</tr>
				<tr>
					<td id="td"></td>
					<td id="td"><span id='loginerrorSpan'>Provided
							credintials are wrong</span></td>
				</tr>
				<td></td>
				<td><input type="button" value="Login" class="submit"
					onclick='loginClicked()'><div class="loader"></div></td>
					<td id= "forgetPassword"> <a href= forgetPassword> <u>Forget password?</u></a> </td>

			</table>
			<div id="loginbody" style="background-color: #f1f1f1"></div>
		</div>

	</div>



	<div id="signupbody" class="modal">
		<div class="modal-content1">

			<div class="imgcontainer">
				<h1 align="center"
					style="font-family: cursive; color: #b1c0cc; margin-top: -0.62cm">Sign
					up Form</h1>
				<span
					onclick="document.getElementById('signupbody').style.display='none'"
					class="close" title="Close Signup">&times;</span>
			</div>

			<table align="center" cellspacing="3" cellpadding="4">
				<tr>
					<td>First Name</td>
					<td><input type="text" name="FirstName"
						placeholder="Enter your first name" id="FirstName"></td>
				</tr>
				<tr>
					<td id="td"></td>
					<td id="td"><span id='userNameSpan'>Name can't be left
							empty</span></td>
				</tr>
				<tr>
					<td>Last Name</td>
					<td><input type="text" name="LastName"
						placeholder="Enter your last name" id="LastName"></td>
				</tr>
				<tr>
					<td>E-mail</td>
					<td><input type="email" id="Email" name="Email"
						placeholder="Enter your valid e-mail"></td>
					<td><p style="font-size: 14px;">*Not allowed special
							char's except @ and (.)</p></td>
				</tr>
				<tr>
					<td id="td"></td>
					<td id="td"><span id='emailSpan'>E-mail didn't match
							above criteria</span></td>
				</tr>
				<tr>
					<td id="td"></td>
					<td id="td"><span id='signuperrorSpan'>E-mail already
							exists</span></td>
				</tr>
				<tr>
					<td>Password</td>
					<td><input type="password" id="Password" name="Password"
						placeholder="Enter your password"></td>

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
					<td>Gender</td>
					<td><input type="radio" name="Gender" value="Male" class="Gender">Male
						<input type="radio" name="Gender" value="Female" class="Gender">Female</td>
				</tr>
				<tr>
					<td id="td"></td>
					<td id="td"><span id='genderSpan'>Select any one option</span></td>
				</tr>
				<tr>
					<td>Date of Birth</td>
					<td><input type="date" name="DOB" id="DOB"></td>
				</tr>
				<tr>
					<td id="td"></td>
					<td id="td"><span id='dobSpan'>DOB can't be left blank</span></td>
				</tr>
				<tr>
					<td>Mobile Number</td>
					<td><input type="text" name="Mobile"
						placeholder="Enter 10digit mobile number" id="Mobile"></td>
					<td><p style="font-size: 14px;">*Must start with 7 or 8 or
							9</p></td>
				</tr>
				<tr>
					<td id="td"></td>
					<td id="td"><span id='mobileSpan'>Number didn't match
							above criteria</span></td>
				</tr>
				<td></td>
				<td><input value="Signup" class="submit" type="submit"
					onclick='signUpClicked()'> <input value="Reset" class="submit"
					type="reset" onclick='reset()'><div class="loader"></div></td>
					
			</table>
			<div id="signupbody" style="background-color: #f1f1f1"></div>
			
		</div>
	</div>
</body>
</html>
