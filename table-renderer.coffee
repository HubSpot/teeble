class @Teeble.TableRenderer
    debug: false
    log: []
    key: 'rows'
    hasFooter: false
    data: null
    header_template: null
    row_template: null
    rows_template: null
    table_class: null
    sortable_class: 'sorting'
    table_template: null
    table_template_compiled: null
    empty_message: "No data to display"

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
            'pagination_template'
            'empty_message'
            'cid'
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
                data = for item in data
                    if Backbone and item instanceof Backbone.Model
                        item.toJSON()
                    else
                        item
                new_data[@key] = data
                @data = new_data
            else
                new_data = {}
                new_data[@key] = [data]
                @data = new_data

        if @data
            return true

        console.log('could not parse data')
        return false

    _render: (template, data = @data) =>
        if not template
            console.log 'no compiled template'
            return false
        if not data
            console.log 'no data'
            return false
        else
            @_log_time("start compile")
            @rendered = template(data)
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
        if not @rows_template_compiled
            @rows_template_compiled = Handlebars.compile(@rows_template)
        if @_parse_data(data)
            @_render(@rows_template_compiled)

    render_row: (data) =>
        if not @row_template_compiled
            @row_template_compiled = Handlebars.compile(@row_template)
        if data
            @_render(@row_template_compiled, data)

    render_header: (data) =>
        if not @header_template_compiled
            @header_template_compiled = Handlebars.compile(@header_template)
        if data
            @_render(@header_template_compiled, data)


    render_footer: (data) =>
        if not @footer_template_compiled
            @footer_template_compiled = Handlebars.compile(@footer_template)
        if data
            @_render(@footer_template_compiled, data)

    render_empty: (data) =>
        if not @table_empty_template_compiled
            @table_empty_template_compiled = Handlebars.compile(@table_empty_template)
        if data
            if not data.message
                data.message = @empty_message
            @_render(@table_empty_template_compiled, data)

    update_template: (partials) =>
        @_log_time("generate master template")
        header = ""
        row = ""
        footer = ""
        i = 0

        for partial_name, partial of partials

            if partial.header

                header_cell = "<th"
                if not partial.header.attributes
                    partial.header.attributes = {}

                if partial.sortable
                    if partial_name
                        partial.header.attributes['data-sort'] = partial_name

                    if not partial.header.attributes.class
                        partial.header.attributes.class = [@sortable_class]
                    else
                        if typeof partial.header.attributes.class is 'string'
                            partial.header.attributes.class = [partial.header.attributes.class]
                        partial.header.attributes.class.push(@sortable_class)

                for attribute, value of partial.header.attributes
                    if value instanceof Array
                        value = value.join(' ')
                    header_cell += """ #{attribute}="#{value}" """

                if partial.header.template
                    header_partial_name = "#{@cid}-header#{i}"
                    Handlebars.registerPartial(header_partial_name, partial.header.template)
                    header_cell += ">{{> #{header_partial_name} }}"
                else
                    header_cell += ">"

                header_cell += "</th>"
                header += header_cell

            if partial.footer
                footer_cell = "<td"
                if not partial.footer.attributes
                    partial.footer.attributes = {}

                for attribute, value of partial.footer.attributes
                    if value instanceof Array
                        value = value.join(' ')
                    footer_cell += """ #{attribute}="#{value}" """

                if partial.footer.template
                    footer_partial_name = "#{@cid}-footer#{i}"
                    Handlebars.registerPartial(footer_partial_name, partial.footer.template)

                    footer_cell += ">{{> #{footer_partial_name} }}"
                else
                    footer_cell += ">"

                footer_cell += "</td>"
                footer += footer_cell

            if partial.cell

                row_cell = "<td"
                if not partial.cell.attributes
                    partial.cell.attributes = {}

                if partial.sortable
                    if partial_name
                        partial.cell.attributes['data-sort'] = partial_name

                for attribute, value of partial.cell.attributes
                    if value instanceof Array
                        value = value.join(' ')
                    row_cell += """ #{attribute}="#{value}" """

                if partial.cell.template
                    row_partial_name = "#{@cid}-partial#{i}"
                    Handlebars.registerPartial(row_partial_name, partial.cell.template)
                    row_cell += ">{{> #{row_partial_name} }}"
                else
                    row_cell += ">"

                row_cell += "</td>"
                row += row_cell

            i++

        @header_template = header
        @footer_template = footer
        @row_template = row
        @rows_template = "{{#each #{@key}}}<tr>#{@row_template}</tr>{{/each}}"
        @table_empty_template = """<td valign="top" colspan="#{i}" class="teeble_empty">{{message}}</td>"""


        if not @table_template
            @table_template =
                """
                    <table class="#{@table_class}">
                    <thead>#{@header_template}</thead>
                    <tbody>#{@row_template}</tbody>
                    {{#if #{@hasFooter}}}
                    <tfoot>#{@footer_template}<tfoot>
                    {{/if}}
                    </table>
                """

        @table_template_compiled = Handlebars.compile(@table_template)


    pagination_template_compiled: null
    pagination_template: """
        <div class="{{pagination_class}}">
            <ul>
                <li><a href="#" class="pagination-previous previous {{#if prev_disabled}}{{pagination_disabled}}{{/if}}">Previous</a></li>
                {{#each pages}}
                <li><a href="#" class="pagination-page {{#if active}}{{active}}{{/if}}" data-page="{{number}}">{{number}}</a></li>
                {{/each}}
                <li><a href="#" class="pagination-next next {{#if next_disabled}}{{pagination_disabled}}{{/if}}">Next</a></li>
            </ul>
        </div>
    """

    render_pagination: (options) =>
        if not @pagination_template_compiled
            @pagination_template_compiled = Handlebars.compile(@pagination_template)

        return @pagination_template_compiled(options)





