# Teeble: a teeny table plugin

class Backbone.Teeble extends Backbone.View

    initialize: ->
        # Render the table when the data changes. We could use a backbone model here in the future.
        @onUpdate = @render

        _setOptions()
        @data = _.extend {}, @initialData

        if @pagination
            @data.page = parseInt(@data.page) or @page ? 1
            @data.size = parseInt(@data.size) or @size ? 10

        return @

    _setOptions: ->
        for key, val in @options
            @[key] = val

    data: (newData) ->
        if newData?
            @data = newData

        return @data

    filter: (input) ->

    create: ->
        # Build the table

    draw: ->
        # Draw/redraw the table

    destroy: (target) ->


# Usage

MOCK_DATA = $.getJSON('mock.json')

class MyTable extends Backbone.Teeble

    title: 'My Awesome Table'
    data: MOCK_DATA

    columns:
        platform:
            header: "Platform"
            template: handlebar_template
        name:
            header: "Name"
            template: handlebar_template
        os:
            header: "Operating System"
            template: handlebar_template

        version:
            header: "Version"
            template: handlebar_template

        grade:
            header: "Grade"
            template: handlebar_template





