package com.redhat.movies;

import java.util.List;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = MoviesApplication.class, webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class MoviesApplicationTests {

	@Autowired
	private TestRestTemplate restTemplate;

	@LocalServerPort
	private int port;

	@Test
	public void contextLoads() {
	}

	@Test
	public void testNotNullResponse() {
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<String> entity = new HttpEntity<String>(null, headers);

		ResponseEntity<String> response = restTemplate.exchange("http://localhost:" + port + "/movies", HttpMethod.GET,
				entity, String.class);

		Assert.assertNotNull(response.getBody());
	}

	@Test
	public void testGetAllMovies() {

		ResponseEntity <List<Movie>> response = restTemplate.exchange("http://localhost:" + port + "/movies",
    		HttpMethod.GET, null, new ParameterizedTypeReference <List<Movie>> () {});

		List <Movie> movies = response.getBody();
		Assert.assertNotNull(movies);
		Assert.assertEquals(6, movies.size());
		Assert.assertEquals("The Godfather", movies.get(0).getName());
	}

	@Test
	public void testGetStatus() {
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<String> entity = new HttpEntity<String>(null, headers);

		ResponseEntity<String> response = restTemplate.exchange("http://localhost:" + port + "/status", HttpMethod.GET,
				entity, String.class);

		Assert.assertNotNull(response.getBody());
		Assert.assertEquals("OK", response.getBody());
	}

}
