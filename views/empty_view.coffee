class @Teeble.EmptyView extends Backbone.View

    initialize: =>
        @renderer = @options.renderer
        @collection.bind('destroy', @remove, @);

    render : =>
        if @renderer
            @el = @renderer.render_empty(@options)
        @

