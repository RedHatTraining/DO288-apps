package com.redhat.training;

import jakarta.annotation.PostConstruct;
import jakarta.enterprise.context.ApplicationScoped;
import java.util.Collections;
import java.util.HashMap;
import java.util.Set;
import java.util.UUID;


@ApplicationScoped
public class ExpenseService {
    private Set<Expense> expenses = Collections.newSetFromMap(Collections.synchronizedMap(new HashMap<>()));

    @PostConstruct
    void init() {
        expenses.add(new Expense("Quarkus for Spring Developers", Expense.PaymentMethod.DEBIT_CARD, "10.00"));
        expenses.add(new Expense("OpenShift for Developers, Second Edition", Expense.PaymentMethod.DEBIT_CARD, "15.00"));
    }

    public Set<Expense> list() {
        return expenses;
    }

    public Expense create(Expense expense) {
        expenses.add(expense);
        return expense;
    }

   public boolean delete(UUID uuid) {
        return expenses.removeIf(expense -> expense.getUuid().equals(uuid));
    }

    public void update(Expense expense) {
        delete(expense.getUuid());
        create(expense);
    }

    public boolean exists(UUID uuid) {
        return expenses.stream().anyMatch(exp -> exp.getUuid().equals(uuid));
    }
}