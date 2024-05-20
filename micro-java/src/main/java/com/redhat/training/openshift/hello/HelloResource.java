package com.redhat.training.openshift.hello;

import java.util.Optional;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.eclipse.microprofile.config.inject.ConfigProperty;

@Path("/api")
@Produces(MediaType.TEXT_PLAIN)
@Consumes(MediaType.TEXT_PLAIN)
public class HelloResource {

    @ConfigProperty(name = "HOSTNAME", defaultValue = "unknown")
    String hostname;
    @ConfigProperty(name = "APP_MSG")
    Optional<String> message;

    @GET
    @Path("/hello")
    public String hello() {
        String response = "";

      	if (!message.isPresent()) {
      	  response = "Hello world from host " + hostname + "\n";
      	} else {
      	  response = "Hello world from host [" + hostname + "].\n";
      	  response += "Message received = " + message.get() + "\n";
        }
        return response;
    }
}