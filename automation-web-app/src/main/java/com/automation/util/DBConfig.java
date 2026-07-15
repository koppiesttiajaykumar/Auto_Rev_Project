package com.automation.util;

public class DBConfig {
    // Private properties for database credentials
    private final String url = "jdbc:mysql://localhost:3306/automation_rev?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
    private final String username = "ajay";
    private final String password = "Ajay@123";

    // Public getters to access the credentials securely
    public String getUrl() {
        return url;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }
}