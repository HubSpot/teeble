class @Teeble.SortbarRenderer extends @Teeble.TableRenderer

    _getExtraData: =>
        sortbarColumns: @options.collection.sortbarColumns
        sortbarSortOptions: @options.collection.sortbarSortOptions
        sortbarColumnOptions: @options.collection.sortbarColumnOptions
        sortColumn: @options.collection.sortColumn
        sortDirection: @options.collection.sortDirection
        partials: @partials

    _generate_template: (name, columns, wrap) =>
        str = super(name, columns)
        for column in @options.collection.sortbarColumns
            str += "<td><%= #{column} %></td>"

        if wrap
            str = "<#{wrap}>#{str}</#{wrap}>"

        return str

    update_template: (partials = @partials) =>
        columns = @generate_columns()

        @header_template = """
            <tr>
                <th colspan="#{_.size(partials)}">
                    <div class="sort-label">Sorted by: </div>
                    <div class="sort">
                        <select class="sortbar-field-select">
                            <% _.each(sortbarSortOptions, function(name, value) { %>
                                <option value="<%= value %>" <% if (sortColumn === value){ %>selected<% } %>><%= name %></option>
                            <% }); %>
                            <% _.each(sortbarColumnOptions, function(name, value) { %>
                                <option value="<%= value %>" <% if (sortColumn === value){ %>selected<% } %>><%= name %></option>
                            <% }); %>
                        </select>
                    </div>
                    <div class="sort-reverser <% if( sortDirection === 'desc' ){ %>reverse<% } %>">
                        <div class="up"></div>
                        <div class="down"></div>
                    </div>
                     <div class="columns-label">Showing:</div>
                </th>
                <% for(var i = 0; i < sortbarColumns.length; i++) { %>
                    <th>
                        <select data-column="<%= i %>" class="sortbar-column sortbar-column-<%= i %>">
                        <% _.each(sortbarColumnOptions, function(name, value) { %>
                            <option value="<%= value %>" <% if(value === sortbarColumns[i]){%>selected<%}%> ><%= name %></option>
                        <% }); %>
                    </th>
                <% } %>
            </tr>
        """

        @footer_template = @_generate_template('footer', columns, 'tr')
        @row_template = @_generate_template('cell', columns)
        @table_empty_template = """<td valign="top" colspan="#{columns.length}" class="teeble_empty">{{message}}</td>"""

        @row_template_compiled = null
        @header_template_compiled = null
        @footer_template_compiled = null
        @table_empty_template_compiled = null