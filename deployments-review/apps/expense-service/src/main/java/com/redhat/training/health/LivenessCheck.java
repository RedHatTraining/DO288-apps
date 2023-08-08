package com.redhat.training.health;

import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.Liveness;

import io.agroal.api.AgroalDataSource;
import jakarta.inject.Inject;

@Liveness
public class LivenessCheck implements HealthCheck {

    @Inject
    HealthSwitch healthSwitch;

    @Override
    public HealthCheckResponse call() {

        if (healthSwitch.getState() ) {
            return HealthCheckResponse
                .up("Application is live");
        }

        return HealthCheckResponse
            .down("Application is down"); 
    }
}
