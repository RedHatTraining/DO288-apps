package com.redhat.training.health;

import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class HealthSwitch {
    private boolean up = true;

    public void switchState() {
        this.up = !this.up;
    }

    public boolean isUp() {
        return this.up;
    }
}
