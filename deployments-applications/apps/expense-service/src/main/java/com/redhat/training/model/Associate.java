package com.redhat.training.model;

import io.quarkus.hibernate.orm.panache.PanacheEntity;

import jakarta.json.bind.annotation.JsonbCreator;
import jakarta.json.bind.annotation.JsonbTransient;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.OneToMany;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Associate extends PanacheEntity {
    public String name;

    @JsonbTransient
    @OneToMany(mappedBy = "associate", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    public List<Expense> expenses = new ArrayList<>();

    public Associate() {
    }

    public Associate(String name) {
        this.name = name;
    }

    @JsonbCreator
    public static Associate of(String name) {
        return new Associate(name);
    }
}