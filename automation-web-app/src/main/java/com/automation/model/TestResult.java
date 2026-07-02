package com.automation.model;

import java.time.LocalDateTime;

public class TestResult {
    private int id;
    private String className;
    private String testCaseName;
    private String status;
    private String testCase;
    private String moduleName;
    private String suiteName;
    private String operatingBrowser;
    private String buildNo;
    private double timeInSeconds;
    private String environment;
    private LocalDateTime testDate;
    private String toolName;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }
    public String getTestCaseName() { return testCaseName; }
    public void setTestCaseName(String testCaseName) { this.testCaseName = testCaseName; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getTestCase() { return testCase; }
    public void setTestCase(String testCase) { this.testCase = testCase; }
    public String getModuleName() { return moduleName; }
    public void setModuleName(String moduleName) { this.moduleName = moduleName; }
    public String getSuiteName() { return suiteName; }
    public void setSuiteName(String suiteName) { this.suiteName = suiteName; }
    public String getOperatingBrowser() { return operatingBrowser; }
    public void setOperatingBrowser(String operatingBrowser) { this.operatingBrowser = operatingBrowser; }
    public String getBuildNo() { return buildNo; }
    public void setBuildNo(String buildNo) { this.buildNo = buildNo; }
    public double getTimeInSeconds() { return timeInSeconds; }
    public void setTimeInSeconds(double timeInSeconds) { this.timeInSeconds = timeInSeconds; }
    public String getEnvironment() { return environment; }
    public void setEnvironment(String environment) { this.environment = environment; }
    public LocalDateTime getTestDate() { return testDate; }
    public void setTestDate(LocalDateTime testDate) { this.testDate = testDate; }
    public String getToolName() { return toolName; }
    public void setToolName(String toolName) { this.toolName = toolName; }
}