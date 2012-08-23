# Teeble: a teeny table plugin

class Teeble

    constructor: (options) ->
        @options = options

    data: (newData) ->
        if newData?
            @data = newData

        return @data

    add: (data) ->
        @data += data

    create: ->
        # Build the table

    draw: ->
        # Draw/redraw the table

    destroy: (target) ->
