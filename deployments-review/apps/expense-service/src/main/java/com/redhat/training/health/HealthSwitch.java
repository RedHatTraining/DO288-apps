package com.redhat.training.health;

import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class HealthSwitch {
    private boolean isUp = true;

    public void switchState() {
        this.isUp = !this.isUp;
    }

    public boolean getState() {
        return this.isUp;
    }
}
