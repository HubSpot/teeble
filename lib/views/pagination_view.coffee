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
