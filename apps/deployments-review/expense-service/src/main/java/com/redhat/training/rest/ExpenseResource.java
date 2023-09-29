package com.redhat.training.rest;

import java.util.List;

import jakarta.transaction.Transactional;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.DELETE;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.PUT;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.DefaultValue;

import com.redhat.training.model.Expense;

import io.quarkus.hibernate.orm.panache.PanacheQuery;
import io.quarkus.panache.common.Page;
import io.quarkus.panache.common.Sort;

@Path("/expenses")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class ExpenseResource {

    @GET
    public List<Expense> list(@DefaultValue("5") @QueryParam("pageSize") int pageSize,
            @DefaultValue("1") @QueryParam("pageNum") int pageNum) {
        PanacheQuery<Expense> expenseQuery = Expense.findAll(
                Sort.by("amount").and("associateId"));

        return expenseQuery.page(Page.of(pageNum - 1, pageSize)).list();
    }

    @POST
    @Transactional
    public Expense create(final Expense expense) {
        Expense newExpense = Expense.of(expense.name, expense.paymentMethod,
                expense.amount.toString(), expense.associateId);
        newExpense.persist();

        return newExpense;
    }

    @DELETE
    @Path("{uuid}")
    @Transactional
    public void delete(@PathParam("uuid") final String uuid) {
        long numExpensesDeleted = Expense.delete("uuid", uuid);

        if (numExpensesDeleted == 0) {
            throw new WebApplicationException(Response.Status.NOT_FOUND);
        }
    }

    @PUT
    @Transactional
    public void update(final Expense expense) {
        try {
            Expense.update(expense);
        } catch (RuntimeException e) {
            throw new WebApplicationException(Response.Status.NOT_FOUND);
        }
    }
}