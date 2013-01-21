Package.describe({
    summary: "A tiny table plugin."
});

Package.on_use(function (api, where) {
    where = where || ['client', 'server'];

    api.add_files('teeble.coffee', where);
});