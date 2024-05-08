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

        HealthCheckResponse resp;

        try {
            agroalDataSource.isHealthy(false);
            resp = HealthCheckResponse.up("Database is live");
        } catch (SQLException e) {
            resp = HealthCheckResponse.down("Database is down");
        }

        return resp;
    }
}
