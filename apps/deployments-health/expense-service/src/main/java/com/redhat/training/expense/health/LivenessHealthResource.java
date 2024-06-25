package com.redhat.training.expense.health;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.Liveness;

@Liveness
@ApplicationScoped
public class LivenessHealthResource implements HealthCheck {

    private final String HEALTH_CHECK_NAME = "Liveness";

    @Inject
    StateService applicationState;


    @Override
    public HealthCheckResponse call() {
        if (applicationState.isAlive()) {
            return HealthCheckResponse.up(HEALTH_CHECK_NAME);
        }
        return HealthCheckResponse.down(HEALTH_CHECK_NAME);
    }
}
