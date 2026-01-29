package com.mt.models;

public class Employee {
    private Long id;
    private String name;
    private String email;
    private String department;
    private String phone;
    private String position;

    public Employee() {}

    public Employee(String name, String email, String department, String phone, String position) {
        this.name = name;
        this.email = email;
        this.department = department;
        this.phone = phone;
        this.position = position;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
}
