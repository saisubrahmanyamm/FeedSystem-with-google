package com.springs.feedstatus;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;




@Controller
public class MainController {
	 

	// Validating session of user-mail
	@RequestMapping("/")
	protected String homePage(HttpServletRequest req) {
		HttpSession session = req.getSession();
		String email = (String) session.getAttribute("SessionID_Email");
		if (email != null) {
			return "home";
		} else {
			return "index";
		}
	}

	// Login activity
	@RequestMapping(value = "/login", method = RequestMethod.POST)
	@ResponseBody
	protected String userValidation(@RequestBody String loginData, HttpServletRequest req) throws Exception {

		Map<String, String> responseMapObj = new HashMap<String, String>();

		ObjectMapper objectMapper = new ObjectMapper();
		UserDatabase user = objectMapper.readValue(loginData, UserDatabase.class);

		// Sending details for Login validation
		boolean result = SignupAndLogin.loginValidation(user.getEmail(), user.getPassword());
		String userName = SignupAndLogin.gettingUserName(user.getEmail());
		if (result == true) {
			responseMapObj.put("SuccessMsg", "success");
			HttpSession session = req.getSession();
			session.setAttribute("SessionID_Email", user.getEmail());
			session.setAttribute("SessionID_UserName", userName);
			return objectMapper.writeValueAsString(responseMapObj);
		} else {
			responseMapObj.put("SuccessMsg", "failed");
			return objectMapper.writeValueAsString(responseMapObj);
		}

	}

	// Logout and session invalidating
	@RequestMapping(value = "/logout")
	protected String logout(HttpServletRequest req) {
		HttpSession session = req.getSession();
		session.invalidate();
		return "redirect:index";
	}
	@RequestMapping(value = "/index")
	protected String index(HttpServletRequest req) {
	
		return "index";
	}

	// Redirecting Profile page
	@RequestMapping(value = "/profile", method = RequestMethod.GET)
	protected String profile(HttpServletRequest req) {
		HttpSession session = req.getSession();
		String email = (String) session.getAttribute("SessionID_Email");
		if (email != null)
			return "profile";
		else
			return "redirect:index";
	}

	// Redirecting Home page
	@RequestMapping(value = "/home", method = RequestMethod.GET)
	protected String home(HttpServletRequest req) {
		HttpSession session = req.getSession();
		String email = (String) session.getAttribute("SessionID_Email");
		if (email != null)
			return "home";
		else
			return "redirect:index";
	}
	
	// Signup activity
	@RequestMapping(value = "/signup", method = RequestMethod.POST)
	@ResponseBody
	protected String signup(@RequestBody String userData, HttpServletRequest req)
			throws JsonParseException, JsonMappingException, IOException {
		boolean result;
		String response = "";
		ObjectMapper objectMapper = new ObjectMapper();
		Map<String, String> responseMapObj = new HashMap<String, String>();
		UserDatabase user = objectMapper.readValue(userData, UserDatabase.class);

		// Sending details to method for storing
		result = SignupAndLogin.signup(user.getFirstName(), user.getLastName(), user.getEmail(), user.getPassword(),
				user.getGender(), user.getDob(), user.getMobile());
		if (result == true) {
			responseMapObj.put("SuccessMsg", "success");
			responseMapObj.put("Email", user.getEmail());
			HttpSession session = req.getSession();
			session.setAttribute("SessionID_Email", user.getEmail());
			session.setAttribute("SessionID_UserName", user.getFirstName());
			response = objectMapper.writeValueAsString(responseMapObj);
		} else {
			responseMapObj.put("SuccessMsg", "failed");
			response = objectMapper.writeValueAsString(responseMapObj);
		}
		return response;
	}

	@RequestMapping("/loginWithGoogle")
	public ModelAndView loginWithGoogle() {
		return new ModelAndView(
				"redirect:https://accounts.google.com/o/oauth2/auth?redirect_uri=http://localhost:8888/get_code&response_type=code&client_id=1044575489189-rm174ukmro713b6gsbu110h7rfm8a484.apps.googleusercontent.com&approval_prompt=force&scope=email&access_type=online");
			//	"redirect:https://accounts.google.com/o/oauth2/auth?redirect_uri=http://www.feedsys0554.appspot.com/get_code&response_type=code&client_id=1044575489189-rm174ukmro713b6gsbu110h7rfm8a484.apps.googleusercontent.com&approval_prompt=force&scope=email&access_type=online");

	}

	@RequestMapping(value = "/get_code")
	public ModelAndView get_code1(@RequestParam String code, HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		// code for getting authorization_code
		System.out.println("Getting Authorization.");
		String auth_code = code;
		System.out.println(auth_code);

		// code for getting access token

		URL url = new URL("https://www.googleapis.com/oauth2/v3/token?"
				+ "client_id=1044575489189-rm174ukmro713b6gsbu110h7rfm8a484.apps.googleusercontent.com"
				+ "&client_secret=NfqNp1WWPJNunOrBpJvThueT&" + "redirect_uri=http://localhost:8888/get_code&"
				+ "grant_type=authorization_code&" + "code=" + auth_code);
//		URL url = new URL("https://www.googleapis.com/oauth2/v3/token?"
//				+ "client_id=1044575489189-rm174ukmro713b6gsbu110h7rfm8a484.apps.googleusercontent.com"
//				+ "&client_secret=NfqNp1WWPJNunOrBpJvThueT&" + "redirect_uri=http://www.feedsys0554.appspot.com/get_code&"
//				+ "grant_type=authorization_code&" + "code=" + auth_code);
		HttpURLConnection connect = (HttpURLConnection) url.openConnection();
		connect.setRequestMethod("POST");
		connect.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
		connect.setDoOutput(true);
		BufferedReader in = new BufferedReader(new InputStreamReader(connect.getInputStream()));
		String inputLine;
		String response = "";
		while ((inputLine = in.readLine()) != null) {
			response += inputLine;
		}
		in.close();
		System.out.println(response.toString());

		JSONParser jsonParser = new JSONParser();
		JSONObject jsonAccessToken = null;
		try {
			jsonAccessToken = (JSONObject) jsonParser.parse(response);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String access_token = (String) jsonAccessToken.get("access_token");
		System.out.println("Access token =" + access_token);
		System.out.println("access token caught");

		URL obj1 = new URL("https://www.googleapis.com/oauth2/v3/userinfo?access_token=" + access_token);
		HttpURLConnection conn = (HttpURLConnection) obj1.openConnection();
		BufferedReader in1 = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		String inputLine1;
		String responsee = "";
		while ((inputLine1 = in1.readLine()) != null) {
			responsee += inputLine1;
		}
		in1.close();
		System.out.println(responsee.toString());
		JSONObject json_user_details = null;
		try {
			json_user_details = (JSONObject) jsonParser.parse(responsee);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String userMail = (String) json_user_details.get("email");
		String userName = (String) json_user_details.get("name");
		String lastName = (String) json_user_details.get("family_name");
		String gender = (String) json_user_details.get("gender");

		SignupAndLogin.signup(userName, lastName, userMail, null, gender, null, null);

		System.out.println(userMail);
		System.out.println(userName);

		HttpSession session = req.getSession();
		session.setAttribute("SessionID_UserName", userName);
		session.setAttribute("SessionID_Email", userMail);
//return new ModelAndView("redirect:http://www.feedsys0554.appspot.com/home");
		return new ModelAndView("redirect:http://localhost:8888/home");
	}

	// Updating the feeds
	@RequestMapping(value = "/updatefeed", method = RequestMethod.POST)
	@ResponseBody
	protected String update(@RequestBody String update) throws IOException {

		String response = "";
		ObjectMapper objectMapper = new ObjectMapper();
		Map<String, Object> responseMapObj = new HashMap<String, Object>();
		long updateTime = System.currentTimeMillis();
		FeedsDatabase feeds = objectMapper.readValue(update, FeedsDatabase.class);
		@SuppressWarnings("unused")
		boolean result = SignupAndLogin.feedSaving(feeds.getUserName(), feeds.getFeed(), feeds.getUserMail(),
				updateTime);
		// Setting the feeds for user
		responseMapObj.put("Email", feeds.getUserMail());
		responseMapObj.put("UserName", feeds.getUserName());
		responseMapObj.put("Feed", feeds.getFeed());
		responseMapObj.put("Time", updateTime);
		response = objectMapper.writeValueAsString(responseMapObj);
		return response;
	}

	// Fetching update details from table

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/fetchUpdates")
	@ResponseBody
	public String fetchUpdates(@RequestBody String fetch) throws IOException {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		 ObjectMapper objectMapper = new ObjectMapper();
		Query q = pm.newQuery("select from " + FeedsDatabase.class.getName() + " order by date desc");
		List<FeedsDatabase> feeds = null;
		feeds = (List<FeedsDatabase>) q.execute();
		if (!(feeds == null) && !feeds.isEmpty()) {
			return objectMapper.writeValueAsString(feeds);
		}
		pm.close();
		q.closeAll();
		return null;
	}

}
