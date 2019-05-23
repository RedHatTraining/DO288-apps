package com.redhat.training.example.buildsformanagers.configuration;


import org.h2.tools.Server;
import org.wildfly.swarm.Swarm;
import org.wildfly.swarm.datasources.DatasourcesFraction;

import java.sql.Connection;
import java.sql.DriverManager;

public class Main {

    public static void main(String[] args) {
        Server server = null;

        try {
            server = Server.createTcpServer("-tcpPort","8081","-tcpAllowOthers").start();
            Class.forName("org.h2.Driver");
            Connection connection = DriverManager.getConnection("jdbc:h2:mem:builds","sa","");


            Swarm swarm = new Swarm();
            swarm.fraction(new DatasourcesFraction()
                .jdbcDriver("h2driver", (d) -> {
                    d.driverClassName("org.h2.Driver");
                    d.xaDatasourceClass("org.h2.jdbcx.JdbcDataSource");
                    d.driverModuleName("com.h2database.h2");
                })
                .dataSource("BuildDS", (ds) ->{
                    ds.driverName("h2");
                    ds.connectionUrl("jdbc:h2:mem:builds");
                    ds.userName("sa");

                })
            ).start().deploy();

        }catch (Exception e){
            e.printStackTrace();
        }


    }
}
