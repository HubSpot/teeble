//= require '/../table-renderer'
//= require './row_view'
//= require './header_view'
//= require './footer_view'
//= require './pagination_view'
//= require './empty_view'

class @Teeble.TableView extends Backbone.View

    tagName : 'div'

    classes:
        sorting:
            sortable_class: 'sorting'
            sorted_desc_class: 'sorting_desc'
            sorted_asc_class: 'sorting_asc'
        pagination:
            pagination_class: 'hs-pagination'
            pagination_active: 'active'
            pagination_disabled: 'disabled'

    defaults:
        partials: {}


    initialize : =>
        super

        @options = _.extend( {}, @defaults, @options)

        @renderer = new Teeble.TableRenderer
            partials: @options.partials
            table_class: @options.table_class

        @collection.pager()
        @collection.on('add', @addOne, @)
        @collection.on('reset', @renderPagination, @)
        @collection.on('reset', @renderBody, @)

        @events = _.extend {}, @events,
            'click a.first': 'gotoFirst'
            'click a.previous': 'gotoPrev'
            'click a.next': 'gotoNext'
            'click a.last': 'gotoLast'
            'click a.pagination-page': 'gotoPage'

            'click .sorting': 'sortByAscending'
            'click .sorting.sorting_asc': 'sortByDescending'
            'click .sorting.sorting_desc': 'sortByAscending'

    afterRender: =>

    render: =>
        @$el.empty().append("<table><tbody></tbody></table")
        @table = @$('table').addClass(@options.table_class)
        @body = @$('tbody')

        @renderHeader()
        @renderBody()
        @renderFooter()
        @renderPagination()
        @afterRender()
        @

    renderPagination : =>
        if @options.pagination
            @pagination?.remove()
            @pagination = new Teeble.PaginationView
                renderer: @renderer
                collection: @collection
                pagination: @classes.pagination

            @$el.append(@pagination.render().el)

    renderHeader : =>
        @header?.remove()
        @header = new Teeble.HeaderView
            renderer: @renderer
            collection: @collection

        @table.append(@header.render().el)

    renderFooter : =>
        if @options.footer
            @footer?.remove()
            @footer = new Teeble.FooterView
                renderer: @renderer
                collection: @collection

            @table.append(@footer.render().el)

    renderBody : =>
        @body.empty()
        if @collection.length > 0
            @collection.each(@addOne)
        else
            @renderEmpty()

        @afterRenderBody()

    afterRenderBody : =>


    renderEmpty : =>
        @empty = new Teeble.EmptyView
            renderer: @renderer
            collection: @collection

        @body.append(@empty.render().el)


    addOne : ( item ) =>
        view = new Teeble.RowView
            model: item
            renderer: @renderer

        @body.append(view.render().el)

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
        @$el.find('.sorting').removeClass('sorting_desc sorting_asc')
        $this = @$(e.target)
        if not $this.hasClass('sorting')
            $this = $this.parents('.sorting')

        $this.addClass("sorting_#{direction}")
        currentSort = $this.attr('data-sort')
        @collection.setSort(currentSort, direction)

    sortByAscending: (e) =>
        @_sort(e, 'asc')

    sortByDescending: (e) =>
        @_sort(e, 'desc')