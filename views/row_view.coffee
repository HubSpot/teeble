class @Teeble.RowView extends Backbone.View

    tagName : 'tr'

    initialize: =>
        @renderer = @options.renderer
        @model.bind('change', @render, @);
        @model.bind('destroy', @remove, @);

    render : =>
        if @renderer
            @$el.html(@renderer.render_row(
                @model.toJSON(
                    teeble: true
                )
            ))
        @