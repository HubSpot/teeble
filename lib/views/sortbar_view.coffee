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