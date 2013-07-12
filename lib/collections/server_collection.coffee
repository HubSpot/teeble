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
        if @lastSortColumn isnt @sortColumn
            @currentPage = 1;

            @lastSortColumn = @sortColumn

        super

        @info()
