package com.redhat.training.rest;

import java.net.InetAddress;
import java.net.UnknownHostException;

import javax.ejb.Stateless;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.redhat.training.model.Host;

@Stateless
@Path("host")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class HostService {
	  
    @GET
    public Host getHostInfo() throws UnknownHostException {
    	InetAddress address = InetAddress.getLocalHost();
    	Host host = new Host(address.getHostAddress(), address.getHostName());
    	return host;
    }
}

