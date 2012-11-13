class @TableFormatters
    value_cell: (value, display) ->
        header: """<th>#{display}</th>"""
        template: """<td class="#{value}">{{#{value}}}</td>"""
    sortable_cell: (value, display, sorting_class) ->
        header: """<th class="#{sorting_class}" data-sort="#{value}">#{display}</th>"""
        template: """<td class="#{value}">{{#{value}}}</td>"""

class @TableRenderer
    debug: false
    log: []
    key: 'rows'
    hasFooter: false
    data: null
    header_template: null
    row_template: null
    table_class: null
    table_template: null
    table_template_compiled: null

    _initialize: (options) =>
        @start = Date.now()
        @options = options

        validOptions = [
            'table_class'
            'debug'
            'key'
            'partials'
            'data'
            'hasFooter'
        ]

        for option in validOptions
            if @options[option]
                @[option] = @options[option]

        @_log_time("start")

        if @partials
            @_log_time("generate partials")
            @update_template(@partials)

        if @data
            @render(@data)

    _parse_data: (data) =>
        if data
            if Backbone and data instanceof Backbone.Collection
                new_data = {}
                new_data[@key] = data.toJSON()
                @data = new_data

            else if data[@key]
                @data = data

            else if data instanceof Array
                new_data = {}
                new_data[@key] = data
                @data = new_data

        if @data
            return true

        console.log('could not parse data')
        return false

    _render: (template) =>
        if not template
            console.log 'no compiled template'
            return false
        if not @data
            console.log 'no data'
            return false
        else
            @_log_time("start compile: #{@data[@key].length}")
            @rendered = template(@data)
            @_log_time("end compile")
            @rendered

    constructor: (options) ->
        @_initialize(options)
        @

    _log_time: (label) =>
        if @debug
            @log.push("#{Date.now() - @start}ms: #{label}")

    print_log: =>
        console.log(@log)

    render: (data) =>
        if @_parse_data(data)
            @_render(@table_template_compiled)

    render_rows: (data) =>
        if @_parse_data(data)
            @_render(@row_template_compiled)

    update_template: (partials) =>
        @_log_time("generate master template")
        header = ""
        row = ""
        footer = ""
        i = 0

        for partial_name, partial of partials

            if partial.header
                header_partial_name = "header#{i}"
                Handlebars.registerPartial(header_partial_name, partial.header)
                header += "{{> #{header_partial_name} }}"

            if partial.footer
                footer_partial_name = "footer#{i}"
                Handlebars.registerPartial(footer_partial_name, partial.footer)
                footer += "{{> #{footer_partial_name} }}"

            row_partial_name = "partial#{i}"
            Handlebars.registerPartial(row_partial_name, partial.template)
            row += "{{> #{row_partial_name} }}"

            i++

        @header_template = header
        @footer_template = footer
        @row_template = "{{#each #{@key}}}<tr>#{row}</tr>{{/each}}"

        if not @table_template
            @table_template =
                """
                    <table class="#{@table_class}">
                    <thead>#{@header_template}</thead>
                    <tbody>#{@row_template}</tbody>
                    {{#if #{@hasFooter}}}
                    <tfoot>#{@footer_template}</tfoot>
                    {{/if}}
                    </table>
                """

        @row_template_compiled = Handlebars.compile(@row_template)
        @table_template_compiled = Handlebars.compile(@table_template)
