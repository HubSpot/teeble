(function (collections, model, Teeble) {

    collections.PaginatedCollection = Teeble.ClientCollection.extend({
        model: model,

        paginator_core: {
            // the type of the request (GET by default)
            type: 'GET',

            // the type of reply (jsonp by default)
            dataType: 'jsonp',

            // the URL (or base URL) for the service
            url: 'http://odata.netflix.com/v2/Catalog/Titles?&'
        },

        paginator_ui: {
            // the lowest page index your API allows to be accessed
            firstPage: 1,

            // which page should the paginator start from
            // (also, the actual page the paginator is on)
            currentPage: 1,

            // how many items per page should be shown
            perPage: 3,

            // a default number of total pages to query in case the API or
            // service you are using does not support providing the total
            // number of pages for us.
            // 10 as a default in case your service doesn't return the total
            totalPages: 10,

            pagesInRange: 3
        },

        server_api: {
            // the query field in the request
            '$filter': 'substringof(\'america\',Name)',

            // number of items to return per request/page
            '$top': function() { return this.totalPages * this.perPage; },

            // how many results the request should skip ahead to
            // customize as needed. For the Netflix API, skipping ahead based on
            // page * number of results per page was necessary.
            '$skip': function() { return this.totalPages * this.perPage; },

            // field to sort by
            'orderby': 'ReleaseYear',

            // what format would you like to request results in?
            '$format': 'json',

            // custom parameters
            '$inlinecount': 'allpages',
            '$callback': '?'
        },

        parse: function (response) {
            // Be sure to change this based on how your results
            // are structured
            var tags = response.d.results;
            return tags;
        }

    });

})( app.collections, app.models.Item, Teeble);