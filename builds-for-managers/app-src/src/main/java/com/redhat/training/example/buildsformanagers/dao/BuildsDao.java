package com.redhat.training.example.buildsformanagers.dao;

import com.redhat.training.example.buildsformanagers.entity.Build;

import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class BuildsDao {

    @PersistenceContext
    private EntityManager em;

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void save(Build build) {
        em.persist(build);
    }

    public List<Build> listAll(){
        return em.createNamedQuery("build.findAll", Build.class).getResultList();
    }
}
