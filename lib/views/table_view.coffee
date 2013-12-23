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
