package com.redhat.training.openshift.todoapi;


import io.quarkus.hibernate.orm.rest.data.panache.PanacheEntityResource;
import io.quarkus.rest.data.panache.MethodProperties;
import io.quarkus.rest.data.panache.ResourceProperties;


@ResourceProperties(path = "/todo/api/items")
public interface ItemResource extends PanacheEntityResource<Item, Long> {
    @MethodProperties(exposed = false)
    Item add(Item item);

    @MethodProperties(exposed = false)
    Item update(Long id, Item existingItem);

    @MethodProperties(exposed = false)
    boolean delete(Long id);
}