package com.redhat.training.example.buildsformanagers.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@NamedQueries({
        @NamedQuery(name = "build.findAll",
        query = "SELECT b from Build b order by b.developersName")
})
public class Build implements Serializable, Comparable<Build>{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String developersName;
    private Date date;
    private String project;
    private String gitUrl;


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDevelopersName() {
        return developersName;
    }

    public void setDevelopersName(String name) {
        this.developersName = name;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getProject() {
        return project;
    }

    public void setProject(String project) {
        this.project = project;
    }

    public String getGitUrl() {
        return gitUrl;
    }

    public void setGitUrl(String gitUrl) {
        this.gitUrl = gitUrl;
    }

    @Override
    public int compareTo(Build o) {
        return this.getDevelopersName().toLowerCase().compareTo(o.getDevelopersName().toLowerCase());
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Build)) return false;

        Build build = (Build) o;

        if (!getDevelopersName().equals(build.getDevelopersName())) return false;
        return getDate().equals(build.getDate());
    }

    @Override
    public int hashCode() {
        int result = getDevelopersName().hashCode();
        result = 31 * result + getDate().hashCode();
        return result;
    }
}
