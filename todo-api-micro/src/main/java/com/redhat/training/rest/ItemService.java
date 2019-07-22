package com.redhat.training.rest;

import com.redhat.training.model.Item;
import com.redhat.training.ui.PaginatedListWrapper;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.TypedQuery;
import javax.ws.rs.*;
import javax.ws.rs.core.Application;
import javax.ws.rs.core.MediaType;

import java.util.List;

@Stateless
@Path("items")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class ItemService extends Application {
	
    @PersistenceContext
    private EntityManager entityManager;

    private Integer countItems() {
        Query query = entityManager.createQuery("SELECT COUNT(i.id) FROM Item i");
        return ((Long) query.getSingleResult()).intValue();
    }

    private List<Item> findItems(int startPosition, int maxResults, String sortFields, String sortDirections) {
        TypedQuery<Item> query =
                entityManager.createQuery("SELECT i FROM Item i ORDER BY i." + sortFields + " " + sortDirections, 
                		Item.class);
        query.setFirstResult(startPosition);
        query.setMaxResults(maxResults);
        return query.getResultList();
    }

    private PaginatedListWrapper findItems(PaginatedListWrapper wrapper) {
        wrapper.setTotalResults(countItems());
        int start = (wrapper.getCurrentPage() - 1) * wrapper.getPageSize();
        wrapper.setList(findItems(start,
                                    wrapper.getPageSize(),
                                    wrapper.getSortFields(),
                                    wrapper.getSortDirections()));
        return wrapper;
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public PaginatedListWrapper listItems(@DefaultValue("1")
                                            @QueryParam("page")
                                            Integer page,
                                            @DefaultValue("id")
                                            @QueryParam("sortFields")
                                            String sortFields,
                                            @DefaultValue("asc")
                                            @QueryParam("sortDirections")
                                            String sortDirections) {
        PaginatedListWrapper paginatedListWrapper = new PaginatedListWrapper();
        paginatedListWrapper.setCurrentPage(page);
        paginatedListWrapper.setSortFields(sortFields);
        paginatedListWrapper.setSortDirections(sortDirections);
        paginatedListWrapper.setPageSize(10);
        return findItems(paginatedListWrapper);
    }

    @GET
    @Path("{id}")
    public Item getitem(@PathParam("id") Long id) {
        return entityManager.find(Item.class, id);
    }

    @POST
    public Item saveItem(Item item) {
        if (item.getId() == null) {
            Item itemToSave = new Item();
            itemToSave.setDescription(item.getDescription());
            itemToSave.setDone(item.isDone());
            entityManager.persist(item);
        } else {
            Item itemToUpdate = getitem(item.getId());
            itemToUpdate.setDescription(item.getDescription());
            itemToUpdate.setDone(item.isDone());
            item = entityManager.merge(itemToUpdate);
        }

        return item;
    }

    @DELETE
    @Path("{id}")
    public void deleteItem(@PathParam("id") Long id) {
        entityManager.remove(getitem(id));
    }
}
