        .                        .o8       oooo
      .o8                       "888       `888
    .o888oo  .ooooo.   .ooooo.   888oooo.   888   .ooooo.
      888   d88' `88b d88' `88b  d88' `88b  888  d88' `88b
      888   888ooo888 888ooo888  888   888  888  888ooo888
      888 . 888    .o 888    .o  888   888  888  888    .o
      "888" `Y8bod8P' `Y8bod8P'  `Y8bod8P' o888o `Y8bod8P'

      A tiny table

## What is teeble?
Teeble is a set of [Backbone](http://backbonejs.org/) views and collection abstractions around [backbone.paginator](https://github.com/addyosmani/backbone.paginator).

You are able to page, sort and filter your data easily by creating views that pass events to backbone.paginator

## Getting Started

Download the [production version][min] or the [development version][max].

[min]: https://raw.github.com/hubspot/teeble/master/dist/teeble.min.js
[max]: https://raw.github.com/hubspot/teeble/master/dist/teeble.js

## Documentation

#### Collections
Currently you can choose from server-side processing of the pagination, filtering and sorting (`Teeble.ServerCollection`) or client-side (`Teeble.ClientCollection`). Extending your Backbone collection from one of these base collections will set it up to use all of the [backbone.paginator](https://github.com/addyosmani/backbone.paginator) methods

#### Views

##### TableView
Teeble's main controller is the `TableView`. This view contains all of the major event bindings and is in charge of rendering all of the subviews. You can extend this view to provide additional options, methods, events, etc.

##### TableView Parameters
* `table_class`: optional class on the table element
* `subviews`: optional overrides
* `partials`
* `collection`
* `footer`
* `compile`

##### Teeble Subviews
* `HeaderView`: view that renders the header
* `FooterView`: view the render the footer
* `RowView`: view that renders each row
* `PaginationView`: view that renders the pagination controls
* `EmptyView`: view that is rendered if there is no data in the collection

Each of these views can be extended or overridden completely by passing them using the `subviews` parameter to the `TableView` or setting them explicitly in your extended `TableView`

#### Table Renderer
Teeble's table-renderer builds templates from partial definitions and renders the different parts of the view. These partials are defined in the `partials` parameter which allows you to define templates (header, cell, footer) for each column of the table. This allows you to update your table templates on the fly to do things like add, remove and rearrange columns. The renderer can also be extended or overwritten in the same way as the subviews

## Examples
* [Client-side paging](http://github.hubspot.com/teeble/examples/netflix-client-paging/index.html)
* [Custom Extension example: Sortbar](http://github.hubspot.com/teeble/examples/sortbar/index.html)

Netflix has shut down their OData API, so our [server-side paging example](http://github.hubspot.com/teeble/examples/netflix-request-paging/index.html) doesn't fully work.

## Contributing
In lieu of a formal style-guide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [grunt](http://gruntjs.com/).

_Also, please don't edit files in the "dist" subdirectory as they are generated via grunt. You'll find source code in the "lib" subdirectory!_

## TODOs
* Tests
* Simpler templating option for less complex tables
* Abstract the table renderer for other templating languages

## Release History
* 0.3.14: Properly remove rows along with the table
* 0.3.13: Pagination View has `options` manually attacehd as  `this.options`
* 0.3.12: Backbone Views `options` manually attached as `this.options`
* 0.3.11: Add proper un/delegating of table events
* 0.3.10: Allow overrides in `pager()` arguments for server-side collections
* 0.3.9:
  - Allow HTML in empty message
  - Don't remove the views on destroy since destroy bubbles up from any model that is destroyed
  - Pass `{reset: true}` to Backbone when calling `pager()` on server-side collections.
* 0.3.8: Add paginator filter for filtering on the entire model
* 0.3.7: Render footer on collection reset
* 0.3.5: Add eachAll() function to the client collection to use origModels
* 0.3.4: Fix ServerCollection Bug
* 0.3.3: Add getFromAll() function to the client collection to use origModels
* 0.3.2: Attach falsey options in the constructor
* 0.3.1: Updating backbone paginator to the latest public version
* 0.3.0: Allow for multiple sort rules and override default sort on click
* 0.2.1: Bug fix for pagination on ServerSideCollections
* 0.2.0: Documentation, grunt, bug fixes
* 0.1.0: Initial Release

## License
Copyright (c) 2014 HubSpot
Licensed under the MIT license.
