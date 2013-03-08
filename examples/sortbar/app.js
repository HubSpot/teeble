(function(){

    window.app = {};
    app.collections = {};
    app.models = {};
    app.views = {};
    app.mixins = {};

    // Defer initialization until doc ready.
    $(function(){
        app.collections.paginatedItems = new app.collections.PaginatedCollection();
        app.collections.paginatedItems.fetch({
            success: function(){
                app.collections.paginatedItems.pager();
                app.views.table = new app.views.BrowserTableView({
                    collection: app.collections.paginatedItems,
                    subviews: {
                        renderer: Teeble.SortbarRenderer
                    },
                    pagination: true,
                    table_class: 'table table-bordered',
                    partials: [
                        {
                            header: '<th class="sorting" data-sort="name">Name</th>',
                            cell: "<td><%= name %></td>"
                        }
                    ]
                });

                $('#content').html(app.views.table.render().el);
            }
        });

    });

})();

