package com.redhat.training.rest;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import com.redhat.training.StateService;
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
        return applicationState.isAlive()
                ? HealthCheckResponse.up(HEALTH_CHECK_NAME)
                : HealthCheckResponse.down(HEALTH_CHECK_NAME);
    }
}
