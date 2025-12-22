package com.example.jboss.model;

/**
 * Model representing an environment variable
 */
public class EnvironmentVariable {
    private String key;
    private String value;

    public EnvironmentVariable() {
    }

    public EnvironmentVariable(String key, String value) {
        this.key = key;
        this.value = value;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
