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

                app.views.table = new app.views.NetflixTable({
                    compile: Handlebars.compile,
                    collection: app.collections.paginatedItems,
                    pagination: true,
                    table_class: 'table table-bordered',
                    partials: [
                        {
                            header: '<th class="sorting" data-sort="Name">Title</th>',
                            cell: "<td>{{Name}}</td>"
                        },
                        {
                            header: '<th class="sorting" data-sort="Runtime">Runtime</th>',
                            cell: "<td>{{RuntimeMinutes}}</td>"
                        },
                        {
                            header: '<th class="sorting" data-sort="ReleaseYear">Release Year</th>',
                            cell: "<td>{{ReleaseYear}}</td>"
                        }
                    ]
                });

                $('#content').html(app.views.table.render().el);
            }
        });

    });

})();

