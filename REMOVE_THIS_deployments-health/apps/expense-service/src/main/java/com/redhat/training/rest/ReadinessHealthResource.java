package com.redhat.training.rest;

import jakarta.enterprise.context.ApplicationScoped;

import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.Readiness;

@Readiness
@ApplicationScoped
public class ReadinessHealthResource implements HealthCheck {

    private final String HEALTH_CHECK_NAME = "Readiness";

    private int counter = 0;

    @Override
    public HealthCheckResponse call() {
        return ++counter >= 10
                ? HealthCheckResponse.up(HEALTH_CHECK_NAME)
                : HealthCheckResponse.down(HEALTH_CHECK_NAME);
    }
}
