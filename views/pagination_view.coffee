class @Teeble.PaginationView extends Backbone.View

    tagName : 'div'

    initialize: =>
        @renderer = @options.renderer
        @collection.bind('destroy', @remove, @);

    render : =>
        if @renderer

            info = @collection.info()
            if info.totalPages > 1
                pages = for page in info.pageSet
                    p =
                        active: if page is info.currentPage then @options.pagination.pagination_active
                        number: page
                    p

                data =
                    pagination_class: @options.pagination.pagination_class
                    pagination_disabled: @options.pagination.pagination_disabled
                    prev_disabled: info.previous is false or info.hasPrevious is false
                    next_disabled: info.next is false or info.hasNext is false
                    pages: pages

                @$el.html(@renderer.render_pagination(data))
        @