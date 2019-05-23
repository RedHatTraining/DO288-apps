package com.redhat.training.example.buildsformanagers.rest;


import com.redhat.training.example.buildsformanagers.dao.BuildsDao;
import com.redhat.training.example.buildsformanagers.entity.Build;

import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.Date;


@Path("/builds")
@Stateless
public class BuildsResource {

	@EJB
	private BuildsDao dao;

	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public Response listAll() {
		return Response.ok(dao.listAll()).build();
	}

	@POST
	public Response save(@FormParam("developer") String name, @FormParam("git") String git, @FormParam("project") String project){
		if (name!= null && !"".equals(name.trim())){
			Build build = new Build();
			build.setDevelopersName(name);
			build.setDate(new Date());
			build.setGitUrl(git);
			build.setProject(project);
			dao.save(build);
			return Response.ok().entity("Build persisted").build();
		}else{
			return Response.status(Response.Status.BAD_REQUEST).entity("Name is required").build();
		}
	}

}