package com.mt.services;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/jsps/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String message = "";
        String errorMessage = "";

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String department = request.getParameter("department");
            String phone = request.getParameter("phone");
            String position = request.getParameter("position");

            try {
                com.mt.dao.EmployeeDAO employeeDAO = new com.mt.dao.EmployeeDAO();
                com.mt.models.Employee emp = new com.mt.models.Employee(name, email, department, phone, position);
                employeeDAO.save(emp);
                // Redirect to GET to prevent duplicate POST on refresh
                response.sendRedirect(request.getContextPath() + "/admin?success=Employee added successfully");
                return;
            } catch (Exception e) {
                errorMessage = "Failed to add employee: " + e.getMessage();
            }
        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            try {
                com.mt.dao.EmployeeDAO employeeDAO = new com.mt.dao.EmployeeDAO();
                employeeDAO.delete(Long.parseLong(id));
                // Redirect to GET to prevent duplicate POST on refresh
                response.sendRedirect(request.getContextPath() + "/admin?success=Employee deleted successfully");
                return;
            } catch (Exception e) {
                errorMessage = "Failed to delete employee: " + e.getMessage();
            }
        }

        // If we get here, something went wrong, forward with error
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/jsps/admin.jsp").forward(request, response);
    }
}
