package com.redhat.vertx_site;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpServer;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;

public class MainVerticle extends AbstractVerticle {

    @Override
    public void start() {
        // Create an HTTP server
        HttpServer server = vertx.createHttpServer();

        // Create a router to handle the HTTP requests
        Router router = Router.router(vertx);

        // Define the route for the root path
        router.get("/").handler(this::handleRoot);

        // Start the server and listen on port 8080
        server.requestHandler(router).listen(8080);
    }

    private void handleRoot(RoutingContext routingContext) {
        HttpServerResponse response = routingContext.response();

        // Set the content type header
        response.putHeader("Content-Type", "text/html");

        // Send HTML content as the response
        response.end("<html><body><h1>Welcome to your Vert.x v1.0 application!</h1></body></html>");
    }

    public static void main(String[] args) {
        Vertx vertx = Vertx.vertx();
        vertx.deployVerticle(new MainVerticle());
    }
}
