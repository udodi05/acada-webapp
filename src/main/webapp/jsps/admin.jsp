<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.mt.dao.EmployeeDAO" %>
<%@ page import="com.mt.models.Employee" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel - Employee Management</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f8f9fa; margin: 0; padding: 20px; }
        .navbar { background: #222; color: #fff; padding: 15px; border-radius: 5px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { margin: 0; }
        .navbar a { color: #fff; text-decoration: none; margin-left: 20px; }
        .navbar a:hover { text-decoration: underline; }
        .container { max-width: 1000px; margin: 0 auto; }
        .form-section { background: #fff; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); }
        .form-section h2 { margin-top: 0; }
        .form-group { display: flex; flex-direction: column; gap: 8px; margin-bottom: 15px; }
        .form-group label { font-weight: 500; }
        .form-group input, .form-group textarea { padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        button { background: #007bff; color: #fff; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 1em; }
        button:hover { background: #0056b3; }
        .danger { background: #dc3545; }
        .danger:hover { background: #c82333; }
        .success { color: green; padding: 10px; background: #d4edda; border: 1px solid #c3e6cb; border-radius: 4px; margin-bottom: 15px; }
        .error { color: red; padding: 10px; background: #f8d7da; border: 1px solid #f5c6cb; border-radius: 4px; margin-bottom: 15px; }
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.07); }
        table th, table td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        table th { background: #f8f9fa; font-weight: 600; }
        table tr:hover { background: #f8f9fa; }
        .action-buttons { display: flex; gap: 5px; }
        .edit { background: #28a745; font-size: 0.9em; padding: 5px 10px; }
        .edit:hover { background: #218838; }
        .delete { background: #dc3545; font-size: 0.9em; padding: 5px 10px; }
        .delete:hover { background: #c82333; }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>Admin Panel</h1>
        <div>
            <a href="${pageContext.request.contextPath}/admin">Dashboard</a>
            <a href="${pageContext.request.contextPath}/">Home</a>
        </div>
    </div>

    <div class="container">
        <%
            EmployeeDAO employeeDAO = new EmployeeDAO();
            String message = request.getParameter("success") != null ? request.getParameter("success") : "";
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage == null) errorMessage = "";

            List<Employee> employees = new ArrayList<>();
            try {
                employees = employeeDAO.findAll();
            } catch (Exception e) {
                errorMessage = "Failed to load employees: " + e.getMessage();
            }
        %>

        <% if (!message.isEmpty()) { %>
            <div class="success"><%= message %></div>
        <% } %>
        <% if (!errorMessage.isEmpty()) { %>
            <div class="error"><%= errorMessage %></div>
        <% } %>

        <div class="form-section">
            <h2>Add New Employee</h2>
            <form method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-group">
                    <label for="name">Name:</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="department">Department:</label>
                    <input type="text" id="department" name="department" required>
                </div>
                <div class="form-group">
                    <label for="phone">Phone:</label>
                    <input type="tel" id="phone" name="phone">
                </div>
                <div class="form-group">
                    <label for="position">Position:</label>
                    <input type="text" id="position" name="position">
                </div>
                <button type="submit">Add Employee</button>
            </form>
        </div>

        <div class="form-section">
            <h2>Employee List</h2>
            <% if (employees.isEmpty()) { %>
                <p>No employees found.</p>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Department</th>
                            <th>Phone</th>
                            <th>Position</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Employee emp : employees) { %>
                            <tr>
                                <td><%= emp.getId() %></td>
                                <td><%= emp.getName() %></td>
                                <td><%= emp.getEmail() %></td>
                                <td><%= emp.getDepartment() %></td>
                                <td><%= emp.getPhone() %></td>
                                <td><%= emp.getPosition() %></td>
                                <td>
                                    <div class="action-buttons">
                                        <form method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= emp.getId() %>">
                                            <button type="submit" class="delete" onclick="return confirm('Are you sure?')">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>

</body>
</html>
