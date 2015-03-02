class @Teeble.RowView extends Backbone.View

    tagName : 'tr'

    initialize: (@options) =>
        @renderer = @options.renderer

    delegateEvents: =>
        super
        @model.bind('change', @render, @)
        @model.bind('destroy', @remove, @)

    undelegateEvents: =>
        super
        @model.unbind('change', @render, @)
        @model.unbind('destroy', @remove, @)

    render : =>
        if @renderer
            @$el.html(@renderer.render_row(
                @model.toJSON(
                    teeble: true
                )
            ))

            if @options.sortColumnIndex?
                @$el.find('td').eq(@options.sortColumnIndex).addClass(@options.sortableClass)

        @
