package com.redhat.training.health;

import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.Liveness;

import jakarta.inject.Inject;

@Liveness
public class LivenessCheck implements HealthCheck {

    @Inject
    HealthSwitch healthSwitch;

    @Override
    public HealthCheckResponse call() {
        
        HealthCheckResponse resp = HealthCheckResponse.down("Application is down");

        if (healthSwitch.isUp() ) {
            resp = HealthCheckResponse.up("Application is live");
        }

        return resp;
    }
}
