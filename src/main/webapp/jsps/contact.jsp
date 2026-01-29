<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Me - Acada Learning</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f8f9fa; margin: 0; padding: 20px; }
        .navbar { background: #222; color: #fff; padding: 15px; border-radius: 5px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { margin: 0; }
        .navbar a { color: #fff; text-decoration: none; margin-left: 20px; }
        .navbar a:hover { text-decoration: underline; }
        .container { max-width: 500px; margin: 0 auto; background: #fff; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); padding: 32px 24px; }
        h2 { text-align: center; margin-top: 0; }
        form { display: flex; flex-direction: column; gap: 16px; }
        label { font-weight: 500; }
        input, textarea { padding: 8px; border-radius: 4px; border: 1px solid #ccc; }
        button { background: #007bff; color: #fff; border: none; padding: 10px; border-radius: 4px; font-size: 1em; cursor: pointer; }
        button:hover { background: #0056b3; }
        .success { color: green; text-align: center; }
        .error { color: red; text-align: center; }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>Contact Me</h1>
        <div>
            <a href="${pageContext.request.contextPath}/">Home</a>
            <a href="${pageContext.request.contextPath}/admin">Admin Panel</a>
            <a href="${pageContext.request.contextPath}/services/employee/getEmployeeDetails">Employee Details</a>
        </div>
    </div>
    <div class="container">
        <h2>Contact Me</h2>
        <form method="post" action="contact">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
            <label for="message">Message:</label>
            <textarea id="message" name="message" rows="5" required></textarea>
            <button type="submit">Send Message</button>
        </form>
        <% if (request.getAttribute("success") != null) { %>
            <div class="success"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
    </div>
</body>
</html>
