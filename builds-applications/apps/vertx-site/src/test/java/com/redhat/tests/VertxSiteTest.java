package com.redhat.tests;

import com.redhat.vertx_site.MainVerticle;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpClient;
import io.vertx.core.http.HttpClientResponse;
import io.vertx.core.http.HttpMethod;
import io.vertx.ext.unit.TestContext;
import io.vertx.ext.unit.junit.VertxUnitRunner;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;


@RunWith(VertxUnitRunner.class)
public class VertxSiteTest {
    private Vertx vertx;

    @Before
    public void setUp(TestContext context) {
        vertx = Vertx.vertx();
        vertx.deployVerticle(new MainVerticle(), context.asyncAssertSuccess());
    }

    @After
    public void tearDown(TestContext context) {
        vertx.close(context.asyncAssertSuccess());
    }

    @Test
    public void testHomePage(TestContext context) {
        final HttpClient client = vertx.createHttpClient();

        client.request(HttpMethod.GET, 8080, "localhost", "/")
          .compose(request -> request.send().compose(HttpClientResponse::body))
          .onComplete(context.asyncAssertSuccess(buffer -> {
              context.assertTrue(buffer.toString().contains("Welcome to your Vert.x"));
              client.close();
          }));
    }

}
