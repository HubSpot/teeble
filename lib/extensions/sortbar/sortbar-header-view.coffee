class @Teeble.SortbarHeaderView extends @Teeble.HeaderView

    events:
        'change .sortbar-column': 'sortBarChange'
        'change .sortbar-field-select': 'sortFieldChange'
        'click .sort-reverser': 'sort'

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

    sortFieldChange: (e) =>
        @sort(e, 'asc')


    sort: (e, direction) =>
        e?.preventDefault()

        $sortReverser = @$('.sort-reverser')

        if $sortReverser.hasClass('reverse') or direction
            $sortReverser.removeClass('reverse')
            direction = 'asc'
        else
            $sortReverser.addClass('reverse')
            direction = 'desc'


        currentSort = @$('.sortbar-field-select').val()

        @collection.setSort(currentSort, direction)