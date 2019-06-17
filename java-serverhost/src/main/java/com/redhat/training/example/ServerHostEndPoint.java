package com.redhat.training.example.swarmhelloworld.rest;


import javax.ws.rs.Path;
import javax.ws.rs.core.Response;
import javax.ws.rs.GET;
import javax.ws.rs.Produces;
import java.net.InetAddress;


@Path("/")
public class ServerHostEndPoint {

	@GET
	@Produces("text/plain")
	public Response doGet() throws Exception {
		String host = InetAddress.getLocalHost().getHostName();
		return Response.ok("I am running on server "+host+" Version 1.0 \n").build();
	}
}
