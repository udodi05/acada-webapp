<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>AcadaLearning - Home Page</title>
	<link href="images/DP black.png" rel="icon">
	<style>
		body {
			font-family: 'Segoe UI', Arial, sans-serif;
			background: #f8f9fa;
			margin: 0;
			padding: 0;
			color: #222;
		}
		.container {
			max-width: 800px;
			margin: 40px auto 80px auto;
			background: #fff;
			border-radius: 10px;
			box-shadow: 0 2px 8px rgba(0,0,0,0.07);
			padding: 32px 24px 24px 24px;
		}
		h1, h2, h3 {
			text-align: center;
			margin-top: 0;
		}
		.info {
			display: flex;
			align-items: center;
			justify-content: center;
			gap: 32px;
			margin: 24px 0;
		}
		.info img {
			width: 120px;
			border-radius: 8px;
		}
		.info-details {
			font-weight: 500;
			font-size: 1.1em;
		}
		.service-link {
			text-align: center;
			margin: 24px 0;
		}
		.service-link a {
			color: #007bff;
			text-decoration: none;
			font-weight: bold;
		}
		.service-link a:hover {
			text-decoration: underline;
		}
		.footer {
			text-align: center;
			margin-top: 32px;
			color: #666;
		}
		.scrolling-text {
			position: fixed;
			left: 0;
			bottom: 0;
			width: 100vw;
			background: #222;
			color: #fff;
			font-size: 1.1em;
			padding: 10px 0;
			overflow: hidden;
			z-index: 1000;
		}
		.scrolling-text span {
			display: inline-block;
			padding-left: 100vw;
			white-space: nowrap;
			animation: scroll-left 18s linear infinite;
		}
		@keyframes scroll-left {
			0% { transform: translateX(0); }
			100% { transform: translateX(-100vw); }
		}
	</style>
</head>
<body>
	<div class="container">
		<h1>Welcome to Acada Learning</h1>
		<h2>Calgary, Canada Office</h2>
		<p style="text-align:center; font-size:1.1em;">This is our DevOps Landing page.<br>
		We are developing and supporting quality Software Solutions to millions of clients.<br>
		We offer Training for DevOps with Linux and Cloud, equipping IT Engineers for best performance.<br>
		<b>God Loves you and Kelechi loves you more.</b><br>
		Everyone will be hired with multiple job offers, Amen.<br>
		<b>God Bless You !!!</b></p>
		<hr>
		<h3>Server Side IP Address</h3>
		<div style="text-align:center; font-size:1.1em;">
			<% String ip = "";
			   InetAddress inetAddress = InetAddress.getLocalHost();
			   ip = inetAddress.getHostAddress();
			   out.println("Server Host Name :: "+inetAddress.getHostName()); %><br>
			<% out.println("Server IP Address :: "+ip); %>
		</div>
		<hr>
		<div class="info">
			<img src="images/DP black.png" alt="Acada Learning Logo">
			<div class="info-details">
				Acada Learning,<br>
				Calgary, Alberta, Canada<br>
				+1 587 574 2233<br>
				info@acadalearning.com<br>
				<a href="mailto:info@acadalearning">Mail to Acada Learning</a>
			</div>
		</div>
		<hr>
		<div class="service-link">
			Service: <a href="services/employee/getEmployeeDetails">Get Employee Details</a> |
			<a href="contact">Contact Me</a> |
			<a href="admin">Admin Panel</a>
		</div>
		<hr>
		<div class="footer">
			Acada Learning - Consultant, Training and Software Development<br>
			<small>Copyright &copy; 2026 by <a href="http://acadalearning.com/">Acada Learning</a></small>
		</div>
	</div>
	<div class="scrolling-text">
		<span>Welcome to Acada Learning! Empowering IT Engineers with DevOps, Linux, and Cloud skills. Contact us: info@acadalearning.com &nbsp; | &nbsp; Calgary, Alberta, Canada &nbsp; | &nbsp; +1 587 574 2233 &nbsp; | &nbsp; God Bless You!</span>
	</div>
</body>
</html>
