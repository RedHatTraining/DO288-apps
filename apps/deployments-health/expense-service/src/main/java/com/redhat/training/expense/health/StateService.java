package com.redhat.training.expense.health;

import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class StateService {
    private boolean ready = true;
    private boolean alive = true;

    public void ready() {
        ready = true;
    }

    public void setAlive(boolean alive) {
        this.alive = alive;
    }

    public boolean isAlive() {
        return alive;
    }
}
