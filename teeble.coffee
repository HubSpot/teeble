# Teeble: a teeny table plugin

safeParseInt = (value) ->
    parseInt value, 10

testPrint = (input) ->
    $('div').html JSON.stringify input


class Backbone.Teeble extends Backbone.View

    initialize: ->
        if not @options.collection?
            throw "Sorry bro, we can't render a table without a collection."

        @setOptions()

        return @

    setOptions: ->
        validOptions = [
            'title'  # Table title
            'collection'  # The canonical data model
            'pagination'  # Boolean
            'page'  # Pagination control
            'size'  # Number of rows to display
        ]

        for option in validOptions
            @[option] = @options[option]

        # @data is the subset of data displayed in the table
        @data = @collection

        if @pagination
            @page ?= 1
            @size ?= 10
            @numPages = _.size(@collection) / @size

        return @

    set: (newData, silent=false) =>
        if newData?
            @data = newData

        # Re-render every time the data changes unless told otherwise
        if not silent
            @render()

        return @

    render: =>
        # Draw/redraw the table
        # marc.render @data

        testPrint @data

    sort: (sortOp) =>
        @set _(@collection).sortBy sortOp

        return @

    toPage: (pageIndex) =>
        if pageIndex < 1
            pageIndex = 0

        @set @collection.slice (pageIndex * @size), (pageIndex + 1) * @size
        @page = pageIndex

    nextPage: =>
        @toPage @page + 1

    prevPage: =>
        if @page > 0
            @toPage @page - 1

    destroy: =>
        # marc.destroy()
        return
