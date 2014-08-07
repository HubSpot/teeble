class @Teeble.EmptyView extends Backbone.View

    initialize: (@options) =>
        @renderer = @options.renderer

    render : =>
        if @renderer
            @el = @renderer.render_empty(@options)
        @
