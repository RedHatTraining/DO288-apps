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

    private boolean once = true;

    @Override
    public HealthCheckResponse call() {
        counter++;
        if (counter >= RETRIES_TO_READY) {
            if (once)  {
                Log.info("Marking service ready after " +counter + "  requests");
                once = false;
            }
            return HealthCheckResponse.up(HEALTH_CHECK_NAME);
        }
        Log.info(counter + " ready requests received");
        return HealthCheckResponse.down(HEALTH_CHECK_NAME);
    }
}
