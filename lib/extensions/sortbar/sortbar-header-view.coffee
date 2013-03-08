class @Teeble.SortbarHeaderView extends @Teeble.HeaderView

    events:
        'change .sortbar-column': 'sortBarChange'

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
        @collection.trigger('reset')