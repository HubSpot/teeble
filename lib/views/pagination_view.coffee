class @Teeble.PaginationView extends Backbone.View

    tagName : 'div'

    template: """
        <div class=" <%= pagination_class %>">
            <ul>
                <li>
                    <a href="#" class="pagination-previous previous <% if (prev_disabled){ %><%= pagination_disabled %><% } %>">Previous</a>
                </li>
                <% _.each(pages, function(page) { %>
                <li>
                    <a href="#" class="pagination-page <% if (page.active){ %><%= pagination_active %><% } %>" data-page="<%= page.number %>"><%= page.number %></a>
                </li>
                <% }); %>
                <li>
                    <a href="#" class="pagination-next next <% if(next_disabled){ %><%= pagination_disabled %><% } %>">Next</a>
                </li>
            </ul>
        </div>
        """

    initialize: =>
        @collection.bind('destroy', @remove, @);

    render : =>

        info = @collection.info()
        if info.totalPages > 1
            pages = for page in info.pageSet
                p =
                    active: if page is info.currentPage then @options.pagination.pagination_active
                    number: page
                p


            html = _.template @template,
                pagination_class: @options.pagination.pagination_class
                pagination_disabled: @options.pagination.pagination_disabled
                pagination_active: @options.pagination.pagination_active
                prev_disabled: info.previous is false or info.hasPrevious is false
                next_disabled: info.next is false or info.hasNext is false
                pages: pages

            @$el.html(html)
        @