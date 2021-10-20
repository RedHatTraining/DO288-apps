package com.redhat.training.openshift.todoapi;

import javax.persistence.Entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;

@Entity
public class Item extends PanacheEntity {
    public String description;
    public boolean done;

}
