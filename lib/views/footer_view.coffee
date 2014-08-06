class @Teeble.FooterView extends Backbone.View

    tagName : 'tfoot'

    initialize: (@options) =>
        @renderer = @options.renderer
        if @collection.footer
            if @collection.footer instanceof Backbone.Model
                @collection.footer.on('change', =>
                    @render()
                )

            @data = @collection.footer
        else
            @data = @options

        @collection.footer

    render : =>
        if @renderer
            if @data.toJSON
                data = @data.toJSON()
            else
                data = @data

            @$el.html(@renderer.render_footer(data))
        @

    stopListening: =>
        @collection.footer?.off('change')
        super
