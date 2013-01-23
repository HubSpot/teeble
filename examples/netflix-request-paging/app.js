(function(){

    window.app = {};
    app.collections = {};
    app.models = {};
    app.views = {};

    // Defer initialization until doc ready.
    $(function(){
        app.collections.paginatedItems = new app.collections.PaginatedCollection();
        app.collections.paginatedItems.fetch({
            success: function(){
                app.collections.paginatedItems.pager();

                app.views.table = new app.views.NetflixTable({
                    collection: app.collections.paginatedItems,
                    pagination: true,
                    table_class: 'table table-bordered',
                    partials: {
                        Name: {
                            sortable: true,
                            header: {
                                template: "Title"
                            },
                            cell: {
                                template: "{{Name}}"
                            }
                        },
                        Runtime: {
                            sortable: true,
                            header: {
                                template: "Runtime"
                            },
                            cell: {
                                template: "{{RuntimeMinutes}}"
                            }
                        },
                        ReleaseYear: {
                            sortable: true,
                            header: {
                                template: "Release Year"
                            },
                            cell: {
                                template: "{{ReleaseYear}}"
                            }
                        }
                    }
                });

                $('#content').html(app.views.table.render().el);
            }
        });

    });

})();

