package com.redhat.training.health;

import java.sql.SQLException;

import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.Readiness;

import io.agroal.api.AgroalDataSource;
import jakarta.inject.Inject;

@Readiness
public class ReadinessCheck implements HealthCheck {

    @Inject
    AgroalDataSource agroalDataSource;

    @Override
    public HealthCheckResponse call() {

        boolean isHealthy = true;

        try {
            agroalDataSource.isHealthy(false);
        } catch (SQLException e) {
            isHealthy = false;
        }

        if (isHealthy) {
            return HealthCheckResponse
                .up("Database is live");
        }

        return HealthCheckResponse
            .down("Database is down"); 
    }
}
