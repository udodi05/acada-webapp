package com.mt.config;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class EnvConfig {
    private static final Map<String, String> envMap = new HashMap<>();

    static {
        loadEnvFile();
    }

    private static void loadEnvFile() {
        // Priority: 1) ENV_FILE_PATH environment variable, 2) /etc/acada/.env, 3) ./.env
        String envFilePath = System.getenv("ENV_FILE_PATH");
        if (envFilePath == null) {
            envFilePath = "/etc/acada/.env";
        }
        
        java.io.File envFile = new java.io.File(envFilePath);
        if (!envFile.exists()) {
            // Try fallback to relative path
            envFilePath = ".env";
            envFile = new java.io.File(envFilePath);
            if (!envFile.exists()) {
                System.err.println("Warning: .env file not found at /etc/acada/.env or .env");
                return;
            }
        }
        
        try (BufferedReader reader = new BufferedReader(new FileReader(envFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                // Skip comments and empty lines
                if (line.isEmpty() || line.startsWith("#")) {
                    continue;
                }
                // Parse key=value pairs
                if (line.contains("=")) {
                    String[] parts = line.split("=", 2);
                    String key = parts[0].trim();
                    String value = parts[1].trim();
                    // Remove surrounding quotes if present
                    if (value.startsWith("\"") && value.endsWith("\"")) {
                        value = value.substring(1, value.length() - 1);
                    }
                    envMap.put(key, value);
                }
            }
            System.out.println("EnvConfig: Loaded configuration from " + envFile.getAbsolutePath());
        } catch (IOException e) {
            System.err.println("Warning: Could not load .env file from " + envFilePath + ": " + e.getMessage());
        }
    }

    public static String get(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value == null) {
            value = envMap.get(key);
        }
        return value != null ? value : defaultValue;
    }

    public static String get(String key) {
        String value = System.getenv(key);
        if (value == null) {
            value = envMap.get(key);
        }
        return value;
    }

    // SMTP Configuration
    public static String getSmtpHost() {
        return get("SMTP_HOST", "smtp.gmail.com");
    }

    public static int getSmtpPort() {
        String port = get("SMTP_PORT", "587");
        try {
            return Integer.parseInt(port);
        } catch (NumberFormatException e) {
            return 587;
        }
    }

    public static String getSmtpUsername() {
        return get("SMTP_USERNAME");
    }

    public static String getSmtpPassword() {
        return get("SMTP_PASSWORD");
    }

    public static String getSmtpFromEmail() {
        return get("SMTP_FROM_EMAIL");
    }

    // Database Configuration
    public static String getDbHost() {
        return get("DB_HOST", "acada-postgres");
    }

    public static int getDbPort() {
        String port = get("DB_PORT", "5432");
        try {
            return Integer.parseInt(port);
        } catch (NumberFormatException e) {
            return 5432;
        }
    }

    public static String getDbName() {
        return get("DB_NAME", "acada_db");
    }

    public static String getDbUsername() {
        return get("DB_USERNAME");
    }

    public static String getDbPassword() {
        return get("DB_PASSWORD");
    }

    // Admin Configuration
    public static String getAdminUsername() {
        return get("ADMIN_USERNAME");
    }

    public static String getAdminPassword() {
        return get("ADMIN_PASSWORD");
    }
}
