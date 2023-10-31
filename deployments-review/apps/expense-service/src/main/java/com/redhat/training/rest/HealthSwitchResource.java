package com.redhat.training.rest;

import com.redhat.training.health.HealthSwitch;

import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;

@Path("/healthSwitch")
public class HealthSwitchResource {

    @Inject
    HealthSwitch healthSwitch;
    
    @GET
    public void switchState() {
        healthSwitch.switchState();
    }
}
