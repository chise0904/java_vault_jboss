package com.example.jboss.config;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

/**
 * JAX-RS Application Configuration
 * Defines the base URI for all REST endpoints
 */
@ApplicationPath("/api")
public class JaxrsApplication extends Application {
    // No additional configuration needed
    // All JAX-RS resources will be automatically discovered
}
