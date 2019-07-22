package com.redhat.training.example.todoapi.rest;

import org.wildfly.swarm.Swarm;
import org.wildfly.swarm.datasources.DatasourcesFraction;

public class Main {
    public static void main(String[] args) throws Exception {
        String host = System.getenv("HOST");
        new Swarm()
                .fraction(new DatasourcesFraction()
                        .jdbcDriver("mysql", (d) -> {
                            d.driverClassName("com.mysql.cj.jdbc.Driver");
                            d.xaDatasourceClass("com.mysql.jdbc.jdbc2.optional.MysqlXADataSource");
                            d.driverModuleName("com.mysql");
                        })
                        .dataSource("MySQLDS", (ds) -> {
                            ds.driverName("mysql");
                            ds.connectionUrl("jdbc:mysql://"+host+":8889/todo");
                            ds.userName("root");
                            ds.password("root");
                        }))
                .start()
                .deploy();
    }
}
