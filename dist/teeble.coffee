#! teeble - v0.3.7 - # 2014-01-15
#  https://github.com/HubSpot/teeble
# Copyright (c) 2014 HubSpot, Marc Neuwirth, Jonathan Kim;
# Licensed MIT

@Teeble = {}
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
            if @options[option]?
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
class @Teeble.HeaderView extends Backbone.View

    events:
        'click .sorting': 'sort'

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

    _sort: (e, direction) =>
        e.preventDefault()

        $this = @$(e.target)
        if not $this.hasClass(@classes.sorting.sortable_class)
            $this = $this.parents(".#{@classes.sorting.sortable_class}")

        currentSort = $this.attr('data-sort')

        if not $this.hasClass(@classes.sorting.sorted_desc_class) and not $this.hasClass(@classes.sorting.sorted_asc_class)
            direction = @collection.sortDirections[currentSort] ? direction

        @collection.setSort(currentSort, direction)

    sort: (e) =>
        $this = @$(e.currentTarget)
        if $this.hasClass(@classes.sorting.sorted_desc_class)
            @_sort(e, 'asc')
        else
            @_sort(e, 'desc')

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

    events:
        'click a.first': 'gotoFirst'
        'click a.previous': 'gotoPrev'
        'click a.next': 'gotoNext'
        'click a.last': 'gotoLast'
        'click a.pagination-page': 'gotoPage'

    template: """
        <div class=" <%= pagination_class %>">
            <ul>
                <li>
                    <a href="#" class="pagination-previous previous <% if (prev_disabled){ %><%= pagination_disabled %><% } %>">
                        <span class="left"></span>
                        Previous
                    </a>
                </li>
                <% _.each(pages, function(page) { %>
                <li>
                    <a href="#" class="pagination-page <% if (page.active){ %><%= pagination_active %><% } %>" data-page="<%= page.number %>"><%= page.number %></a>
                </li>
                <% }); %>
                <li>
                    <a href="#" class="pagination-next next <% if(next_disabled){ %><%= pagination_disabled %><% } %>">
                        Next
                        <span class="right"></span>
                    </a>
                </li>
            </ul>
        </div>
        """

    initialize: =>
        @collection.bind('destroy', @remove, @);

        super

    render : =>
        if not @collection.information
            @collection.pager()

        info = @collection.information
        if info.totalPages > 1
            pages = for page in info.pageSet
                {
                    active: if page is info.currentPage then @options.pagination.pagination_active
                    number: page
                }


            html = _.template @template,
                pagination_class: @options.pagination.pagination_class
                pagination_disabled: @options.pagination.pagination_disabled
                pagination_active: @options.pagination.pagination_active
                prev_disabled: info.previous is false
                next_disabled: info.next is false
                pages: pages

            @$el.html(html)
        @

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
        @collection.goTo(@collection.information.lastPage)

    gotoPage: (e) =>
        e.preventDefault()
        page = @$(e.target).text()
        @collection.goTo(page)

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

            if @options.sortColumnIndex?
                @$el.find('td').eq(@options.sortColumnIndex).addClass(@options.sortableClass)

        @
# =require '/../table-renderer'
# =require './row_view'
# =require './header_view'
# =require './footer_view'
# =require './pagination_view'
# =require './empty_view'

class @Teeble.TableView extends Backbone.View

    tagName : 'div'
    rendered: false

    classes:
        sorting:
            sortable_class: 'sorting'
            sorted_desc_class: 'sorting_desc'
            sorted_asc_class: 'sorting_asc'
            sortable_cell: 'sorting_1'
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

        @setOptions()

        super

        @collection.on('add', @addOne, @)
        @collection.on('reset', @renderBody, @)
        @collection.on('reset', @renderFooter, @)
        @collection.on('reset', @renderPagination, @)

        @sortIndex = {}
        i = 0
        for partial_name, partial of @options.partials
            if partial.sortable
                @sortIndex[partial.sortable] = i
            i++

        @renderer = new @subviews.renderer
            partials: @options.partials
            table_class: @options.table_class
            cid: @cid
            classes: @classes
            collection: @collection
            compile: @options.compile

    setOptions: =>
        @


    render: =>
         # Make sure this is only called for a ClientCollection
        if not @collection.origModels and @collection.whereAll?
            @collection.pager?()

        @$el.empty().append("<table><tbody></tbody></table>")
        @table = @$('table').addClass(@options.table_class)
        @body = @$('tbody')

        @rendered = true

        @renderHeader()
        @renderBody()
        @renderFooter()
        @renderPagination()
        @trigger('teeble.render', @)
        @

    renderPagination : =>
        if @options.pagination and @rendered
            @pagination?.remove()
            @pagination = new @subviews.pagination
                collection: @collection
                pagination: @classes.pagination

            @$el.append(@pagination.render().el)

            @trigger('pagination.render', @)

    renderHeader : =>
        if @rendered
            @header?.remove()
            @header = new @subviews.header
                renderer: @renderer
                collection: @collection
                classes: @classes

            @table.prepend(@header.render().el)

            @trigger('header.render', @)

    renderFooter : =>
        if @options.footer and @rendered
            @footer?.remove()

            if @collection.length > 0
                @footer = new @subviews.footer
                    renderer: @renderer
                    collection: @collection

                @table.append(@footer.render().el)

                @trigger('footer.render', @)

    renderBody : =>
        if @rendered
            @body.empty()

            if @collection.length > 0
                @collection.each(@addOne)
                @trigger('body.render', @)
            else
                @renderEmpty()

    renderEmpty : =>
        if @rendered
            options = _.extend({}, @options,
                renderer: @renderer
                collection: @collection
            )
            @empty = new @subviews.empty options

            @body.append(@empty.render().el)

            @trigger('empty.render', @)


    addOne : ( item ) =>
        if @collection.sortColumn
            sortColumnIndex = @sortIndex[@collection.sortColumn]


        view = new @subviews.row
            model: item
            renderer: @renderer
            sortColumnIndex: sortColumnIndex
            sortableClass: @classes.sorting.sortable_cell

        @body.append(view.render().el)

        @trigger('row.render', view)

# =require '../backbone.paginator'

class @Teeble.ClientCollection extends Backbone.Paginator.clientPager

    sortDirections: {}

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

    getFromAll: (obj) =>
        unless obj?
            return undefined

        id = obj.id or obj.cid or obj
        @_byId[id] or _.findWhere(@origModels, {id})

    eachAll: =>
        _.each.call _, (@origModels ? @models), arguments...

# =require '../backbone.paginator'

class @Teeble.ServerCollection extends Backbone.Paginator.requestPager

    sortDirections: {}

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
        @on 'reset', @info
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
        if @lastSortColumn isnt @sortColumn and @sortColumn?
            @currentPage = 1;
            @lastSortColumn = @sortColumn

        super

        @info()
