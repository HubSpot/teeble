Package.describe({
    summary: "A tiny table plugin."
});

Package.on_use(function (api, where) {
    where = where || ['client', 'server'];

    api.add_files('dist/teeble.min.js', where);
});