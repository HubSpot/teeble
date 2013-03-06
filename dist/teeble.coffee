#! teeble - v0.2.0 - # 2013-03-06
#  https://github.com/HubSpot/teeble
# Copyright (c) 2013 HubSpot, Marc Neuwirth, Jonathan Kim;
# Licensed MIT

@Teeble = {}
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

    update_template: (partials = @partials) =>
        @_log_time("generate master template")
        header = ""
        row = ""
        footer = ""
        i = 0

        for partial_name, partial of partials

            ### Header ###
            if partial.header
                template = undefined
                if typeof partial.header is 'string'
                    template = partial.header
                    header_cell = ''

                else
                    if partial.header.template
                        template = partial.header.template

                    header_cell = "<th"
                    if not partial.header.attributes
                        partial.header.attributes = {}

                    if partial.sortable
                        partial.header.attributes['data-sort'] = partial.sortable

                        if not partial.header.attributes.class
                            partial.header.attributes.class = [@classes.sorting.sortable_class]
                        else
                            if typeof partial.header.attributes.class is 'string'
                                partial.header.attributes.class = [partial.header.attributes.class]
                            partial.header.attributes.class.push(@classes.sorting.sortable_class)

                    for attribute, value of partial.header.attributes
                        if value instanceof Array
                            value = value.join(' ')
                        header_cell += """ #{attribute}="#{value}" """

                    header_cell += ">"

                if template
                    header_partial_name = "#{@cid}-header#{i}"
                    Handlebars.registerPartial(header_partial_name, template)
                    header_cell += "{{> #{header_partial_name} }}"

                if partial.header isnt template
                    header_cell += "</th>"
                header += header_cell

            ### Footer ###
            if partial.footer
                template = undefined
                if typeof partial.footer is 'string'
                    template = partial.footer
                    footer_cell = ""

                else
                    if partial.footer.template
                        template = partial.footer.template

                    footer_cell = "<td"
                    if not partial.footer.attributes
                        partial.footer.attributes = {}

                    for attribute, value of partial.footer.attributes
                        if value instanceof Array
                            value = value.join(' ')
                        footer_cell += """ #{attribute}="#{value}" """

                    footer_cell += ">"

                if template
                    footer_partial_name = "#{@cid}-footer#{i}"
                    Handlebars.registerPartial(footer_partial_name, template)

                    footer_cell += "{{> #{footer_partial_name} }}"

                if partial.footer isnt template
                    footer_cell += "</td>"
                footer += footer_cell


            ### Cell ###
            if partial.cell
                template = undefined
                if typeof partial.cell is 'string'
                    template = partial.cell
                    row_cell = ""

                else
                    if partial.cell.template
                        template = partial.cell.template

                    row_cell = "<td"
                    if not partial.cell.attributes
                        partial.cell.attributes = {}

                    if partial.sortable
                        partial.cell.attributes['data-sort'] = partial.sortable

                    for attribute, value of partial.cell.attributes
                        if value instanceof Array
                            value = value.join(' ')
                        row_cell += """ #{attribute}="#{value}" """

                    row_cell += ">"

                if template
                    row_partial_name = "#{@cid}-partial#{i}"
                    Handlebars.registerPartial(row_partial_name, template)
                    row_cell += "{{> #{row_partial_name} }}"


                if partial.cell isnt template
                    row_cell += "</td>"
                row += row_cell

            i++

        j = 0
        if @collection.sortbarColumns
            for column in @collection.sortbarColumns
                header_cell = """<th><select data-column="#{j}" class="sortbar-column sortbar-column-#{j}">"""
                k = 0
                if @collection.sortbarColumnOptions
                    for value, name of @collection.sortbarColumnOptions
                        selected = ''
                        if value is column
                            selected = "selected"
                            footer_cell = """<td>{{#{value}}}</td>"""
                            row_cell = """<td>{{#{value}}}</td>"""

                        header_cell += """<option value="#{value}" #{selected}>#{name}</option>"""
                        k++

                    header_cell += """</select></th>"""
                    header += header_cell
                    footer += footer_cell
                    row += row_cell
                    j++

        @header_template = "<tr>#{header}</tr>"
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






class @Teeble.EmptyView extends Backbone.View

    initialize: =>
        @renderer = @options.renderer
        @collection.bind('destroy', @remove, @);

    render : =>
        if @renderer
            @el = @renderer.render_empty(@options)
        @


class @Teeble.FooterView extends Backbone.View

    tagName : 'tfoot'

    initialize: =>
        @renderer = @options.renderer
        @collection.bind('destroy', @remove, @);

    render : =>
        if @renderer
            @$el.html(@renderer.render_footer({}))
        @
class @Teeble.HeaderView extends Backbone.View

    tagName : 'thead'

    initialize: =>
        @renderer = @options.renderer
        @classes = @options.classes
        @collection.bind('destroy', @remove, @);
        @collection.bind('reset', @setSort, @);

    render : =>
        if @renderer
            @$el.html(@renderer.render_header(@options))
            @setSort()
        @

    setSort: =>
        if @collection.sortColumn
            direction = 'desc'

            if @collection.sortDirection
                direction = @collection.sortDirection

            classDirection = "sorted_#{direction}_class"
            @$el.find(".#{@classes.sorting.sortable_class}")
                .removeClass("#{@classes.sorting.sorted_desc_class} #{@classes.sorting.sorted_asc_class}")
                .filter(""".sorting[data-sort="#{@collection.sortColumn}"]""")
                    .addClass("#{@classes.sorting[classDirection]}")
class @Teeble.PaginationView extends Backbone.View

    tagName : 'div'

    initialize: =>
        @renderer = @options.renderer
        @collection.bind('destroy', @remove, @);

    render : =>
        if @renderer

            info = @collection.info()
            if info.totalPages > 1
                pages = for page in info.pageSet
                    p =
                        active: if page is info.currentPage then @options.pagination.pagination_active
                        number: page
                    p

                data =
                    pagination_class: @options.pagination.pagination_class
                    pagination_disabled: @options.pagination.pagination_disabled
                    prev_disabled: info.previous is false or info.hasPrevious is false
                    next_disabled: info.next is false or info.hasNext is false
                    pages: pages

                @$el.html(@renderer.render_pagination(data))
        @
class @Teeble.RowView extends Backbone.View

    tagName : 'tr'

    initialize: =>
        @renderer = @options.renderer
        @model.bind('change', @render, @);
        @model.bind('destroy', @remove, @);

    render : =>
        if @renderer
            @$el.html(@renderer.render_row(
                @model.toJSON(
                    teeble: true
                )
            ))
        @
class @Teeble.SortbarView extends Backbone.View

    tagName : 'thead'
    template: """
        <tr>
            <% _.each(partials, function(partial) { %>
                <%= partial.header %>
            <% }); %>
            <% for(var i = 0; i < sortbarColumns; i++) { %>
                <th>
                    <select class="column-<%= i %>" >
                        <% _.each(sortbarColumnOptions, function(name, value) { %>
                            <option value="<%= value %>" ><%= name %></option>
                        <% }); %>
                    </select>
                </th>
            <% } %>
        </tr>
    """

    initialize: =>
        @renderer = @options.renderer
        @collection.bind('destroy', @remove, @);

    render : =>
        if @renderer
            html = _.template @template,
                partials: @options.renderer.partials
                sortbarColumns: @options.collection.sortbarColumns
                sortbarColumnOptions: @options.collection.sortbarColumnOptions
            @$el.html(html)
        @
# =require '/../table-renderer'
# =require './row_view'
# =require './header_view'
# =require './footer_view'
# =require './pagination_view'
# =require './empty_view'

class @Teeble.TableView extends Backbone.View

    tagName : 'div'

    classes:
        sorting:
            sortable_class: 'sorting'
            sorted_desc_class: 'sorting_desc'
            sorted_asc_class: 'sorting_asc'
        pagination:
            pagination_class: 'pagination'
            pagination_active: 'active'
            pagination_disabled: 'disabled'

    subviews:
        header: Teeble.HeaderView
        row: Teeble.RowView
        footer: Teeble.FooterView
        pagination: Teeble.PaginationView
        renderer: Teeble.TableRenderer
        empty: Teeble.EmptyView

    initialize : =>
        @subviews = _.extend {}, @subviews, @options.subviews

        @events = _.extend {}, @events,
            'click a.first': 'gotoFirst'
            'click a.previous': 'gotoPrev'
            'click a.next': 'gotoNext'
            'click a.last': 'gotoLast'
            'click a.pagination-page': 'gotoPage'
            'click .sorting': 'sort'
            'change .sortbar-column': 'sortBarChange'

        @setOptions()

        super

        @collection.on('add', @addOne, @)
        @collection.on('reset', @renderBody, @)
        @collection.on('reset', @renderPagination, @)

        @renderer = new @subviews.renderer
            partials: @options.partials
            collection: @collection
            table_class: @options.table_class
            cid: @cid
            classes: @classes


    setOptions: =>
        @


    render: =>
        @$el.empty().append("<table><tbody></tbody></table")
        @table = @$('table').addClass(@options.table_class)
        @body = @$('tbody')

        @renderHeader()
        @renderBody()
        @renderFooter()
        @renderPagination()
        @trigger('teeble.render', @)
        @

    renderPagination : =>
        if @options.pagination
            @pagination?.remove()
            @pagination = new @subviews.pagination
                renderer: @renderer
                collection: @collection
                pagination: @classes.pagination

            @$el.append(@pagination.render().el)

            @trigger('pagination.render', @)

    renderHeader : =>
        @header?.remove()
        @header = new @subviews.header
            renderer: @renderer
            collection: @collection
            classes: @classes

        @table.prepend(@header.render().el)

        @trigger('header.render', @)

    renderFooter : =>
        if @options.footer
            @footer?.remove()

            if @collection.length > 0
                @footer = new @subviews.footer
                    renderer: @renderer
                    collection: @collection

                @table.append(@footer.render().el)

                @trigger('footer.render', @)

    renderBody : =>
        @body.empty()

        if @collection.length > 0
            @collection.each(@addOne)
        else
            @renderEmpty()

        @trigger('body.render', @)

    renderEmpty : =>
        @empty = new @subviews.empty
            renderer: @renderer
            collection: @collection

        @body.append(@empty.render().el)

        @trigger('empty.render', @)


    addOne : ( item ) =>
        view = new @subviews.row
            model: item
            renderer: @renderer

        @body.append(view.render().el)

        @trigger('row.render', view)

    gotoFirst: (e) =>
        e.preventDefault()
        @collection.goTo(1)

    gotoPrev: (e) =>
        e.preventDefault()
        @collection.previousPage()

    gotoNext: (e) =>
        e.preventDefault()
        @collection.nextPage()

    gotoLast: (e) =>
        e.preventDefault()
        @collection.goTo(this.collection.information.lastPage)

    gotoPage: (e) =>
        e.preventDefault()
        page = @$(e.target).text()
        @collection.goTo(page)

    _sort: (e, direction) =>
        e.preventDefault()

        $this = @$(e.target)
        if not $this.hasClass(@classes.sorting.sortable_class)
            $this = $this.parents(".#{@classes.sorting.sortable_class}")

        currentSort = $this.attr('data-sort')

        @collection.setSort(currentSort, direction)

    sort: (e) =>
        $this = @$(e.currentTarget)
        if $this.hasClass(@classes.sorting.sorted_desc_class)
            @_sort(e, 'asc')
        else
            @_sort(e, 'desc')

    sortBarChange: (e) =>
        $this = @$(e.currentTarget)
        column = ~~($this.attr('data-column'))
        value = $this.val()

        oldValue = @collection.sortbarColumns[column]
        existing = _.indexOf(@collection.sortbarColumns, value)
        if existing >= 0
            @collection.sortbarColumns[existing] = oldValue

        @collection.sortbarColumns[column] = value

        @renderer.update_template()
        @render()



# =require '../backbone.paginator'

class @Teeble.ClientCollection extends Backbone.Paginator.clientPager

    default_paginator_core:
        dataType: 'json'
        url: ->
            @url()


    default_paginator_ui:
        sortColumn: ''
        sortDirection: 'desc'
        firstPage: 1
        currentPage: 1
        perPage: 10
        pagesInRange: 3

    initialize: =>
        @paginator_ui = _.extend( {}, @default_paginator_ui, @paginator_ui )
        @paginator_core = _.extend( {}, @default_paginator_core, @paginator_core )
        super

    whereAll: (attrs) =>
        if _.isEmpty(attrs)
            return []
        return _.filter @origModels, (model) ->
            for key, value of attrs
                if value isnt model.get(key)
                    return false
            return true
# =require '../backbone.paginator'

class @Teeble.ServerCollection extends Backbone.Paginator.requestPager

    default_paginator_core:
        dataType: 'json'
        url: ->
            @url()


    default_paginator_ui:
        firstPage: 1
        currentPage: 1
        perPage: 10
        pagesInRange: 3

    default_server_api:
        'offset': ->
            return (@currentPage - 1) * @perPage

        'limit': ->
            return @perPage

    initialize: =>
        @paginator_ui = _.extend( {}, @default_paginator_ui, @paginator_ui )
        @paginator_core = _.extend( {}, @default_paginator_core, @paginator_core )
        @server_api = _.extend( {}, @default_server_api, @server_api )
        super

    nextPage: ( options ) =>
        if @currentPage < @information.totalPages
            @promise = @requestNextPage(options)

    previousPage: ( options ) =>
        if @currentPage > 1
            @promise = @requestPreviousPage(options)

    setSort: ( column, direction ) =>
        if column isnt undefined && direction isnt undefined
            @lastSortColumn = @sortColumn
            @sortColumn = column
            @sortDirection = direction
            @pager()
            @info()

    pager: =>
        if @lastSortColumn isnt @sortColumn
            @currentPage = 1;

            @lastSortColumn = @sortColumn

        super
