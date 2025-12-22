package com.example.jboss.util;

import javax.naming.InitialContext;
import javax.naming.NamingException;

/**
 * 配置工具類 - 提供多種環境變數讀取方式
 */
public class ConfigUtil {

    /**
     * 方法 1: 從系統環境變數讀取 (目前使用的方式)
     */
    public static String getFromSystemEnv(String key) {
        return System.getenv(key);
    }

    /**
     * 方法 2: 從 JNDI 讀取 (類似 Tomcat context.xml)
     * 需要在 standalone.xml 中設定 JNDI bindings
     */
    public static String getFromJNDI(String jndiName) {
        try {
            InitialContext ctx = new InitialContext();
            return (String) ctx.lookup(jndiName);
        } catch (NamingException e) {
            System.err.println("無法從 JNDI 讀取: " + jndiName + " - " + e.getMessage());
            return null;
        }
    }

    /**
     * 方法 3: 從 Java System Properties 讀取
     * 可在啟動 WildFly 時使用 -D 參數設定
     */
    public static String getFromSystemProperty(String key) {
        return System.getProperty(key);
    }

    /**
     * 智能讀取 - 依序嘗試多種方式
     * 1. JNDI
     * 2. 系統環境變數
     * 3. System Properties
     * 4. 預設值
     */
    public static String getConfig(String key, String defaultValue) {
        // 嘗試從 JNDI 讀取
        String jndiName = "java:global/env/" + key;
        String value = getFromJNDI(jndiName);
        if (value != null) {
            return value;
        }

        // 嘗試從環境變數讀取
        value = getFromSystemEnv(key);
        if (value != null) {
            return value;
        }

        // 嘗試從 System Properties 讀取
        value = getFromSystemProperty(key);
        if (value != null) {
            return value;
        }

        // 返回預設值
        return defaultValue;
    }
}
