package com.redhat.training.expense.health;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@Path("/crash")
@ApplicationScoped
public class CrashResource {
    @Inject
    StateService applicationState;


    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String setCrash() {
        applicationState.setAlive(false);
        return "Service not alive\n";
    }

}
