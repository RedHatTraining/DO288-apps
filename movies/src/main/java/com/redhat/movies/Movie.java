package com.redhat.movies;

import java.io.Serializable;

public class Movie implements Serializable {

    private static final long serialVersionUID = -3240337073623122124L;

    private Integer movieId;
    private String name;
    private String genre;

    public Movie(Integer movieId, String name, String genre) {
        this.movieId = movieId;
        this.name = name;
        this.genre = genre;
    }

    public Integer getMovieId() {
        return movieId;
    }

    public void setMovieId(Integer movieId) {
        this.movieId = movieId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

}