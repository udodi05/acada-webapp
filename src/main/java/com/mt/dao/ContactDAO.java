package com.mt.dao;

import com.mt.models.Contact;
import com.mt.config.EnvConfig;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO {
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

    public void save(Contact contact) throws SQLException {
        String sql = "INSERT INTO contacts (name, email, message, created_at, email_confirmation_sent) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, contact.getName());
            stmt.setString(2, contact.getEmail());
            stmt.setString(3, contact.getMessage());
            stmt.setTimestamp(4, Timestamp.valueOf(contact.getCreatedAt()));
            stmt.setBoolean(5, contact.isEmailConfirmationSent());
            stmt.executeUpdate();
            
            // Retrieve the generated ID and set it on the contact object
            ResultSet generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                contact.setId(generatedKeys.getLong(1));
            }
        }
    }

    public void update(Contact contact) throws SQLException {
        String sql = "UPDATE contacts SET name=?, email=?, message=?, email_confirmation_sent=? WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, contact.getName());
            stmt.setString(2, contact.getEmail());
            stmt.setString(3, contact.getMessage());
            stmt.setBoolean(4, contact.isEmailConfirmationSent());
            stmt.setLong(5, contact.getId());
            stmt.executeUpdate();
        }
    }

    public Contact findById(Long id) throws SQLException {
        String sql = "SELECT * FROM contacts WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToContact(rs);
            }
        }
        return null;
    }

    public List<Contact> findAll() throws SQLException {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts ORDER BY created_at DESC";
        try (Connection conn = getConnection(); Statement stmt = conn.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                contacts.add(mapResultSetToContact(rs));
            }
        }
        return contacts;
    }

    public List<Contact> findByEmail(String email) throws SQLException {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts WHERE email=? ORDER BY created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                contacts.add(mapResultSetToContact(rs));
            }
        }
        return contacts;
    }

    private Contact mapResultSetToContact(ResultSet rs) throws SQLException {
        Contact contact = new Contact();
        contact.setId(rs.getLong("id"));
        contact.setName(rs.getString("name"));
        contact.setEmail(rs.getString("email"));
        contact.setMessage(rs.getString("message"));
        contact.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        contact.setEmailConfirmationSent(rs.getBoolean("email_confirmation_sent"));
        return contact;
    }
}
