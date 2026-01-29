package com.mt.dao;

import com.mt.models.Employee;
import com.mt.config.EnvConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {
    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private Connection getConnection() throws SQLException {
        String url = "jdbc:postgresql://" + EnvConfig.getDbHost() + ":" + EnvConfig.getDbPort() + "/" + EnvConfig.getDbName();
        return DriverManager.getConnection(url, EnvConfig.getDbUsername(), EnvConfig.getDbPassword());
    }

    public void save(Employee employee) throws SQLException {
        String sql = "INSERT INTO employees (name, email, department, phone, position) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, employee.getName());
            stmt.setString(2, employee.getEmail());
            stmt.setString(3, employee.getDepartment());
            stmt.setString(4, employee.getPhone());
            stmt.setString(5, employee.getPosition());
            stmt.executeUpdate();
        }
    }

    public void update(Employee employee) throws SQLException {
        String sql = "UPDATE employees SET name=?, email=?, department=?, phone=?, position=? WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, employee.getName());
            stmt.setString(2, employee.getEmail());
            stmt.setString(3, employee.getDepartment());
            stmt.setString(4, employee.getPhone());
            stmt.setString(5, employee.getPosition());
            stmt.setLong(6, employee.getId());
            stmt.executeUpdate();
        }
    }

    public void delete(Long id) throws SQLException {
        String sql = "DELETE FROM employees WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        }
    }

    public Employee findById(Long id) throws SQLException {
        String sql = "SELECT * FROM employees WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToEmployee(rs);
            }
        }
        return null;
    }

    public List<Employee> findAll() throws SQLException {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT * FROM employees ORDER BY id DESC";
        try (Connection conn = getConnection(); Statement stmt = conn.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                employees.add(mapResultSetToEmployee(rs));
            }
        }
        return employees;
    }

    private Employee mapResultSetToEmployee(ResultSet rs) throws SQLException {
        Employee emp = new Employee();
        emp.setId(rs.getLong("id"));
        emp.setName(rs.getString("name"));
        emp.setEmail(rs.getString("email"));
        emp.setDepartment(rs.getString("department"));
        emp.setPhone(rs.getString("phone"));
        emp.setPosition(rs.getString("position"));
        return emp;
    }
}
