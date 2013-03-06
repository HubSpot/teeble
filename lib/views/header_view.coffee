class @Teeble.HeaderView extends Backbone.View

    tagName : 'thead'

    initialize: =>
        @renderer = @options.renderer
        @classes = @options.classes
        @collection.bind('destroy', @remove, @);
        @collection.bind('reset', @setSort, @);

    render : =>
        if @renderer
            @$el.html(@renderer.render_header(@options))
            @setSort()
        @

    setSort: =>
        if @collection.sortColumn
            direction = 'desc'

            if @collection.sortDirection
                direction = @collection.sortDirection

            classDirection = "sorted_#{direction}_class"
            @$el.find(".#{@classes.sorting.sortable_class}")
                .removeClass("#{@classes.sorting.sorted_desc_class} #{@classes.sorting.sorted_asc_class}")
                .filter(""".sorting[data-sort="#{@collection.sortColumn}"]""")
                    .addClass("#{@classes.sorting[classDirection]}")