
var model = undefined;

exports.context = function(server, path, itemsModel) {
    if (!server)
        done('has to provide a restify server object');
        
    var context = "/items";
    if (path)
        context = path + context;
        
    server.get(context + '/', this.list);
    server.get(context + '/:id', this.read);
    server.get(context + '-count', this.count);
    server.post(context + '/', this.save);
    server.del(context + '/:id', this.destroy);
    
    model = itemsModel;
};

exports.list = function(req, res, next) {
    var page_no = req.query.page || 1;
    var sortField = req.query.sortFields || "id";
    var sortDirection = req.query.sortDirections || "asc";

    model.listAll(page_no, sortField, sortDirection, function(err, items) {
        if (err) {
            res.send(err);
        }
        else {
            if (items) {
                model.countAll(function(err, n) {
                    if (err) {
                        res.send(err);
                    }
                    else {
                        if (n) {
                            var page = { 
                                "currentPage" : page_no,
                                "list" : items,
                                "pageSize" : 10,
                                "sortDirections" : sortDirection,
                                "sortFields" : sortField,
                                "totalResults" : n
                            };
                            res.json(page);
                            next();
                        }
                    }
                });
            }
            else {
                res.send(err);
            }
        }
    })
};

exports.read = function(req, res, next) {
    var key = req.params.id;
    model.read(key, function(err, item) {
        if (err) {
            res.send(err);
        }
        else {
            if (item) {
                res.json(item);
                next();
            }
            else {
                res.send(err);
            }
        }
    })
};


exports.count = function(req, res, next) {
    model.countAll(function(err, n) {
        if (err) {
            res.send(err);
        } 
        else {
            var page = { 
              count: n
            };
            res.json(page)
            next();
        }
    })
};


exports.save = function(req, res, next) {
    if (req.params.id) {
        model.update(req.params.id, req.params.description, req.params.done, function(err, item) {
            if (err) {
                res.send(err);
            }
            else {
                res.json(item);
                next();
            }
        });
    }
    else {
        model.create(req.params.description, req.params.done, function(err, item) {
            if (err) {
                res.send(err);
            }
            else {
                res.json(item);
                next();
            }
        });
    }
};


exports.destroy = function(req, res, next) {
    if (req.params.id) {
        model.destroy(req.params.id, function(err, item) {
            if (err) {
                res.send(err);
            }
            else {
                res.json(item);
            }
        });
    }
}
