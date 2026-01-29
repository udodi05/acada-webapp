package com.mt.services;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import com.mt.dao.ContactDAO;
import com.mt.models.Contact;
import com.mt.config.EnvConfig;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Display the contact form
        request.getRequestDispatcher("/jsps/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        // Save contact to database
        Contact contact = new Contact(name, email, message);
        ContactDAO contactDAO = new ContactDAO();
        try {
            contactDAO.save(contact);
        } catch (SQLException e) {
            request.setAttribute("error", "Failed to save contact: " + e.getMessage());
            request.getRequestDispatcher("/jsps/contact.jsp").forward(request, response);
            return;
        }

        // Send confirmation email using environment variables
        String smtpHost = EnvConfig.getSmtpHost();
        int smtpPort = EnvConfig.getSmtpPort();
        String smtpUsername = EnvConfig.getSmtpUsername();
        String smtpPassword = EnvConfig.getSmtpPassword();
        String fromEmail = EnvConfig.getSmtpFromEmail();

        Properties props = new Properties();
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", smtpPort);
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUsername, smtpPassword);
            }
        });

        try {
            // Send confirmation email to user
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            msg.setSubject("Thank you for contacting Acada Learning");
            msg.setText("Dear " + name + ",\n\nThank you for your message:\n\n" + message + "\n\nWe will get back to you soon!\n\nBest regards,\nAcada Learning Team");
            Transport.send(msg);

            contact.setEmailConfirmationSent(true);
            contactDAO.update(contact);

            request.setAttribute("success", "Your message has been sent successfully! A confirmation email has been sent to " + email);
        } catch (Exception e) {
            request.setAttribute("error", "Message saved but failed to send confirmation email: " + e.getMessage());
        }
        request.getRequestDispatcher("/jsps/contact.jsp").forward(request, response);
    }
}
