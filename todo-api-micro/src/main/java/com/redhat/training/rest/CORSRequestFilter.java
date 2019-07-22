package com.redhat.training.rest;
 
import java.io.IOException;
import java.util.logging.Logger;

import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.container.ContainerRequestFilter;
import javax.ws.rs.container.PreMatching;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.Provider;
 
@Provider
@PreMatching
public class CORSRequestFilter implements ContainerRequestFilter {
 
    private final static Logger log = Logger.getLogger(CORSRequestFilter.class.getName());
 
    @Override
    public void filter(ContainerRequestContext requestCtx) throws IOException {
        log.fine("Executing REST request filter");
 
        // When HttpMethod comes as OPTIONS, just acknowledge that it accepts...
        if (requestCtx.getRequest().getMethod().equals( "OPTIONS" )) {
            log.fine("HTTP Method (OPTIONS) - Detected!");
 
            // Just send a OK signal back to the browser
            requestCtx.abortWith(Response.status(Response.Status.OK).build());
        }
    }
}
