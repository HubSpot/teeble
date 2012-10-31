class TableFormatters
    value_cell: (value, display) ->
        header: display or value
        template: """<td class="#{value}">{{#{value}}}</td>"""

class TableRenderer
    debug: false
    key: 'rows'
    data: null
    header_template: null
    row_template: null
    table_template: null
    table_template_compiled: null

    _initialize: (options) =>
        @start = Date.now()
        @options = options
        if options.debug
            @debug = options.debug
            @log = []

        if options.key
            @key = options.key

        @_log_time("start")

        if options.partials
            @_log_time("generate partials")
            @update_template(options.partials)

        if options.data
            @render(options.data)

    _parse_data: (data = @data) =>
        if data
            if data[@key]
                @data = data
                return true
            else if data instanceof Array
                new_data = {}
                new_data[@key] = data
                @data = new_data
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
        i = 0

        for partial_name, partial of partials

            header_partial_name = "header#{i}"
            Handlebars.registerPartial(header_partial_name, partial.header)
            header += "<th>{{> #{header_partial_name} }}</th>"

            row_partial_name = "partial#{i}"
            Handlebars.registerPartial(row_partial_name, partial.template)
            row += "{{> #{row_partial_name} }}"

            i++

        @header_template = header
        @row_template = "{{#each #{@key}}}<tr>#{row}</tr>{{/each}}"

        if not @table_template
            @table_template =
                """
                    <table>
                    <thead>#{@header_template}</thead>
                    <tbody>#{@row_template}</tbody>
                    </table>
                """

        @row_template_compiled = Handlebars.compile(@row_template)
        @table_template_compiled = Handlebars.compile(@table_template)
