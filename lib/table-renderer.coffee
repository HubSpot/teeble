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
    table_template: null
    table_template_compiled: null
    empty_message: "No data to display"

    classes:
        sorting:
            sortable_class: 'sorting'
        pagination:
            pagination_class: 'pagination'
            pagination_active: 'active'
            pagination_disabled: 'disabled'

    _now: ->
        if not Date.now
            return +(new Date)
        else
            return Date.now()


    _initialize: (options) =>
        @start = @_now()
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
            'classes'
            'collection'
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
            @log.push("#{@_now() - @start}ms: #{label}")

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

    _get_template_attributes: (type, partial, i) ->
        sortable = partial.sortable
        section = partial[type]
        wrap = false

        if typeof section is 'string'
            template = section

        else
            wrap = true
            if section.template
                template = section.template

            if not section.attributes
                section.attributes = {}

            if sortable
                section.attributes['data-sort'] = sortable

                if not section.attributes.class
                    section.attributes.class = [@classes.sorting.sortable_class]
                else
                    if typeof section.attributes.class is 'string'
                        section.attributes.class = [section.attributes.class]
                    section.attributes.class.push(@classes.sorting.sortable_class)

            attributes = []
            for attribute, value of section.attributes
                if value instanceof Array
                    value = value.join(' ')
               attributes.push
                    name: attribute
                    value: value

        if template
            partial_name = "#{@cid}-#{type}#{i}"
            Handlebars.registerPartial(partial_name, template)

            attributes: attributes
            name: partial_name
            wrap: wrap
        else
            return undefined

    _generate_template: (name, columns, wrap) ->
        str = ""
        if columns
            if wrap
                str += "<#{wrap}>"
            for column_name, column of columns
                section = column[name]
                if section
                    if section.wrap
                        str += '<td '
                        if section.attributes?.length
                            for attribute, value in section.attributes
                                str += """#{attribute}="#{value}" """
                        str += '>'

                    str += "{{> #{section.name} }}"

                    if section.wrap
                        str += '</td>'

            if wrap
                str += "</#{wrap}>"
        str

    update_template: (partials = @partials) =>
        @_log_time("generate master template")
        i = 0

        columns = []
        for partial_name, partial of partials
            column = {}

            ### Header ###
            if partial.header
                column.header = @_get_template_attributes('header', partial, i)

            ### Footer ###
            if partial.footer
                column.footer = @_get_template_attributes('footer', partial, i)

            ### Cell ###
            if partial.cell
                column.cell = @_get_template_attributes('cell', partial, i)

            columns.push column

            i++

        @header_template = @_generate_template('header', columns, 'tr')
        @footer_template = @_generate_template('footer', columns, 'tr')
        @row_template = @_generate_template('cell', columns)
        @rows_template = "{{#each #{@key}}}<tr>#{@row_template}</tr>{{/each}}"

        @table_empty_template = """<td valign="top" colspan="#{i}" class="teeble_empty">{{message}}</td>"""

        if not @table_template
            @table_template =
                """
                    <table class="#{@table_class}">
                    <thead><tr>#{@header_template}</tr></thead>
                    <tbody>#{@row_template}</tbody>
                    {{#if #{@hasFooter}}}
                    <tfoot><tr>#{@footer_template}</tr><tfoot>
                    {{/if}}
                    </table>
                """

        @table_template_compiled = Handlebars.compile(@table_template)
        @table_template_compiled = null
        @rows_template_compiled = null
        @row_template_compiled = null
        @header_template_compiled = null
        @footer_template_compiled = null
        @table_empty_template_compiled = null


    pagination_template_compiled: null
    pagination_template: =>
        """
        <div class="{{pagination_class}}">
            <ul>
                <li><a href="#" class="pagination-previous previous {{#if prev_disabled}}#{@classes.pagination.pagination_disabled}{{/if}}">Previous</a></li>
                {{#each pages}}
                <li><a href="#" class="pagination-page {{#if active}}#{@classes.pagination.pagination_active}{{/if}}" data-page="{{number}}">{{number}}</a></li>
                {{/each}}
                <li><a href="#" class="pagination-next next {{#if next_disabled}}#{@classes.pagination.pagination_disabled}{{/if}}">Next</a></li>
            </ul>
        </div>
        """

    render_pagination: (options) =>
        if not @pagination_template_compiled
            @pagination_template_compiled = Handlebars.compile(@pagination_template())

        return @pagination_template_compiled(options)





