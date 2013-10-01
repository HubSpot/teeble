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
                    compile: Handlebars.compile,
                    collection: app.collections.paginatedItems,
                    pagination: true,
                    table_class: 'table table-bordered',
                    partials: [
                        {
                            sortable: 'Name',
                            header: {
                                template: "Title"
                            },
                            cell: {
                                template: "{{Name}}"
                            }
                        },
                        {
                            sortable: 'Runtime',
                            header: {
                                template: "Runtime"
                            },
                            cell: {
                                template: "{{RuntimeMinutes}}",
                                attributes: {
                                    'data-run-time': "{{RuntimeMinutes}}"
                                }
                            }
                        },
                        {
                            sortable: 'ReleaseYear',
                            header: {
                                template: "Release Year",
                                attributes: {
                                    class: ["release-year", "release-year-header"]
                                }
                            },
                            cell: {
                                template: "{{ReleaseYear}}",
                                attributes: {
                                    class: "release-year",
                                    'data-release-year': "{{ReleaseYear}}"
                                }
                            }
                        }
                    ]
                });

                $('#content').html(app.views.table.render().el);
            }
        });

    });

})();

