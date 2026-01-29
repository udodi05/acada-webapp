<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.mt.models.Employee" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Details - Acada Learning</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f8f9fa; margin: 0; padding: 20px; }
        .navbar { background: #222; color: #fff; padding: 15px; border-radius: 5px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { margin: 0; }
        .navbar a { color: #fff; text-decoration: none; margin-left: 20px; }
        .navbar a:hover { text-decoration: underline; }
        .container { max-width: 1000px; margin: 0 auto; }
        .section { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); }
        .section h2 { margin-top: 0; color: #333; }
        .error { color: red; padding: 10px; background: #f8d7da; border: 1px solid #f5c6cb; border-radius: 4px; margin-bottom: 15px; }
        table { width: 100%; border-collapse: collapse; }
        table th, table td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        table th { background: #f8f9fa; font-weight: 600; color: #333; }
        table tr:hover { background: #f8f9fa; }
        .no-data { text-align: center; color: #999; padding: 20px; }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>Employee Details</h1>
        <div>
            <a href="${pageContext.request.contextPath}/">Home</a>
            <a href="${pageContext.request.contextPath}/admin">Admin Panel</a>
            <a href="${pageContext.request.contextPath}/contact">Contact Me</a>
        </div>
    </div>

    <div class="container">
        <div class="section">
            <%
                List<Employee> employees = (List<Employee>) request.getAttribute("employees");
                String error = (String) request.getAttribute("error");

                if (error != null) {
            %>
                <div class="error"><%= error %></div>
            <%
                }

                if (employees == null || employees.isEmpty()) {
            %>
                <div class="no-data">
                    <p>No employees found.</p>
                    <p><a href="/web-app/admin">Add employees in Admin Panel</a></p>
                </div>
            <%
                } else {
            %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Department</th>
                            <th>Phone</th>
                            <th>Position</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Employee emp : employees) {
                        %>
                            <tr>
                                <td><%= emp.getId() %></td>
                                <td><%= emp.getName() %></td>
                                <td><%= emp.getEmail() %></td>
                                <td><%= emp.getDepartment() %></td>
                                <td><%= emp.getPhone() != null ? emp.getPhone() : "N/A" %></td>
                                <td><%= emp.getPosition() != null ? emp.getPosition() : "N/A" %></td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>
