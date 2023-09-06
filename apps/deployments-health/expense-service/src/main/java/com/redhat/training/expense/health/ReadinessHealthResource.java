package com.redhat.training.expense.health;

import jakarta.enterprise.context.ApplicationScoped;

import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.Readiness;
import io.quarkus.logging.Log;
@Readiness
@ApplicationScoped
class ReadinessHealthResource implements HealthCheck {

    public static final int RETRIES_TO_READY = 3;
    private final String HEALTH_CHECK_NAME = "Readiness";

    private int counter = 0;

    @Override
    public HealthCheckResponse call() {
        counter++;
        Log.info( counter + " ready requests received");
        if (counter >= RETRIES_TO_READY) {
            return HealthCheckResponse.up(HEALTH_CHECK_NAME);
        }
        return HealthCheckResponse.down(HEALTH_CHECK_NAME);
    }
}
