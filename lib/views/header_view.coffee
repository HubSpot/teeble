class @Teeble.HeaderView extends Backbone.View

    events:
        'click .sorting': 'sort'

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

    _sort: (e, direction) =>
        e.preventDefault()

        $this = @$(e.target)
        if not $this.hasClass(@classes.sorting.sortable_class)
            $this = $this.parents(".#{@classes.sorting.sortable_class}")

        currentSort = $this.attr('data-sort')

        @collection.setSort(currentSort, direction)

    sort: (e) =>
        $this = @$(e.currentTarget)
        if $this.hasClass(@classes.sorting.sorted_desc_class)
            @_sort(e, 'asc')
        else
            @_sort(e, 'desc')

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