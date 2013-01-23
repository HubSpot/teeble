class @Teeble.HeaderView extends Backbone.View

    tagName : 'thead'

    initialize: =>
        @renderer = @options.renderer
        @collection.bind('destroy', @remove, @);

    render : =>
        if @renderer
            @$el.html(@renderer.render_header(@options))
        @