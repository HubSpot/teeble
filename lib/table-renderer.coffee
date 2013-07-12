class @Teeble.TableRenderer
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

    compile: _.template

    _initialize: =>
        validOptions = [
            'table_class'
            'partials'
            'hasFooter'
            'empty_message'
            'cid'
            'classes'
            'compile'
        ]

        for option in validOptions
            if @options[option]
                @[option] = @options[option]

        if @partials
            @update_template(@partials)

    _getExtraData: =>
        {}

    _render: (template, data) =>
        if not template
            console.log 'no compiled template'
            return false
        if not data
            console.log 'no data'
            return false
        else
            data = _.extend {}, @_getExtraData(), data
            return template(data)

    constructor: (@options) ->
        @_initialize()
        @

    render_row: (data) =>
        if not @row_template_compiled
            @row_template_compiled = @compile(@row_template)
        if data
            @_render(@row_template_compiled, data)

    render_header: (data) =>
        if not @header_template_compiled
            @header_template_compiled = @compile(@header_template)
        if data
            @_render(@header_template_compiled, data)


    render_footer: (data) =>
        if not @footer_template_compiled
            @footer_template_compiled = @compile(@footer_template)
        if data
            @_render(@footer_template_compiled, data)

    render_empty: (data) =>
        if not @table_empty_template_compiled
            @table_empty_template_compiled = @compile(@table_empty_template)
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
            attributes: attributes
            wrap: wrap
            partial: template
        else
            attributes: {}
            wrap: wrap
            partial: ''

    _generate_template: (name, columns, wrap, td = 'td') ->
        str = ""
        if columns
            for column_name, column of columns
                section = column[name]
                if section
                    column_template = "#{section.partial}"

                    if section.wrap
                        attributes = ''
                        if section.attributes?.length
                            for attribute in section.attributes
                                attributes += """#{attribute.name}="#{attribute.value}" """

                        column_template = "<#{td} #{attributes}>#{column_template}</#{td}>"

                    str += column_template

            if wrap
                str = "<#{wrap}>#{str}</#{wrap}>"
        str

    generate_columns: (partials = @partials, clear = false) =>
        if @columns and not clear
            return @columns
        else
            i = 0
            @columns = []
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

                @columns.push column

                i++
            return @columns


    update_template: (partials = @partials) =>
        columns = @generate_columns()

        @header_template = @_generate_template('header', columns, 'tr', 'th')
        @footer_template = @_generate_template('footer', columns, 'tr')
        @row_template = @_generate_template('cell', columns)
        @table_empty_template = """<td valign="top" colspan="#{columns.length}" class="teeble_empty">{{message}}</td>"""






