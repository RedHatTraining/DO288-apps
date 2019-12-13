package com.redhat.movies;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/")
public class MoviesController {

    private List<Movie> movies;
    private String status = "OK";

    @GetMapping("/movies")
    public List<Movie> getAllMovies() {

        //Generate fake static data
        movies = new ArrayList<Movie>();
        movies.add(new Movie(1,"The Godfather","Crime/Thriller"));
        movies.add(new Movie(2,"Star Wars","Sci-Fi"));
        movies.add(new Movie(3,"The Mask","Comedy"));
        movies.add(new Movie(4,"Die Hard","Action"));
        movies.add(new Movie(5,"The Exorcist","Horror"));
        movies.add(new Movie(6,"The Silence of the Lambs","Drama"));

        return movies;
    }

    @GetMapping("/status")
    public String getStatus() {
        return status;
    }

}
