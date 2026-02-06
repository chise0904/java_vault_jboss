package com.example.jboss.rest;

import com.example.jboss.model.EnvironmentVariable;
import com.example.jboss.util.ConfigUtil;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * REST API for environment variables
 * 展示多種環境變數讀取方式
 */
@Path("/environment")
@Produces(MediaType.APPLICATION_JSON)
public class EnvironmentResource {

    /**
     * Get all environment variables
     * @return JSON response with all environment variables
     */
    @GET
    @Path("/all")
    public Response getAllEnvironmentVariables() {
        Map<String, String> env = System.getenv();

        List<EnvironmentVariable> variables = env.entrySet().stream()
                .map(entry -> new EnvironmentVariable(entry.getKey(), entry.getValue()))
                .sorted((a, b) -> a.getKey().compareTo(b.getKey()))
                .collect(Collectors.toList());

        return Response.ok(variables).build();
    }

    /**
     * Get specific environment variable by key
     * @return JSON response with specific environment variable
     */
    @GET
    @Path("/custom")
    public Response getCustomEnvironmentVariables() {
        List<EnvironmentVariable> customVars = new ArrayList<>();

        // Read common custom environment variables
        addIfExists(customVars, "APP_NAME");
        addIfExists(customVars, "APP_VERSION");
        addIfExists(customVars, "APP_ENVIRONMENT");
        addIfExists(customVars, "DATABASE_URL");
        addIfExists(customVars, "API_KEY");

        return Response.ok(customVars).build();
    }

    /**
     * Health check endpoint
     */
    @GET
    @Path("/health")
    @Produces(MediaType.TEXT_PLAIN)
    public Response health() {
        return Response.ok("Environment API is running on WildFly").build();
    }

    /**
     * 展示使用 ConfigUtil 智能讀取環境變數
     * 會依序嘗試: JNDI → 系統環境變數 → System Properties → 預設值
     */
    @GET
    @Path("/smart")
    public Response getSmartConfig() {
        Map<String, String> configs = new HashMap<>();

        // 使用 ConfigUtil 智能讀取
        configs.put("APP_NAME", ConfigUtil.getConfig("APP_NAME", "未設定"));
        configs.put("APP_VERSION", ConfigUtil.getConfig("APP_VERSION", "未設定"));
        configs.put("APP_ENVIRONMENT", ConfigUtil.getConfig("APP_ENVIRONMENT", "未設定"));
        configs.put("DATABASE_URL", ConfigUtil.getConfig("DATABASE_URL", "未設定"));
        configs.put("API_KEY", ConfigUtil.getConfig("API_KEY", "未設定"));

        List<EnvironmentVariable> variables = configs.entrySet().stream()
                .map(entry -> new EnvironmentVariable(entry.getKey(), entry.getValue()))
                .collect(Collectors.toList());

        return Response.ok(variables).build();
    }

    /**
     * 展示不同讀取方式的對比
     */
    @GET
    @Path("/methods")
    public Response getReadMethods() {
        String key = "APP_NAME";
        Map<String, Object> result = new HashMap<>();

        result.put("key", key);
        result.put("systemEnv", ConfigUtil.getFromSystemEnv(key));
        result.put("jndi", ConfigUtil.getFromJNDI("java:global/env/" + key));
        result.put("systemProperty", ConfigUtil.getFromSystemProperty(key));
        result.put("smart", ConfigUtil.getConfig(key, "預設值"));

        return Response.ok(result).build();
    }

    private void addIfExists(List<EnvironmentVariable> list, String key) {
        String value = System.getenv(key);
        if (value != null) {
            list.add(new EnvironmentVariable(key, value));
        }
    }
}
