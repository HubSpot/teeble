# teeble

A tiny table

## What is teeble?
Teeble is a set of [Backbone](http://backbonejs.org/) views and collection abstractions around [backbone.paginator](https://github.com/addyosmani/backbone.paginator).

You are able to page, sort and filter your data easily by creating views that pass events to backbone.paginator

## Getting Started

Download the [production version][min] or the [development version][max].

[min]: https://raw.github.com/hijonathan/teeble/master/dist/teeble.min.js
[max]: https://raw.github.com/hijonathan/teeble/master/dist/teeble.js

Include it in your web page:

```html
<script src="dist/teeble.min.js"></script>
```

## Documentation

### Collections
Currently you can choose from server-side processing of the pagination, filtering and sorting (`Teeble.ServerCollection`) or client-side (`Teeble.ClientCollection`). Extending your Backbone collection from one of these base collections will set it up to use all of the [backbone.paginator](https://github.com/addyosmani/backbone.paginator) methods

### Views

##### TableView
Teeble's main controller is the `TableView`. This view contains all of the major event bindings and is in charge of rendering all of the subviews. You can extend this view to provide additional options, methods, events, etc.

##### TableView Parameters
* `table_class`
* `subviews`
* `partials`
* `collection`
* `footer`

##### Teeble Subviews
* `HeaderView`: view that renders the header
* `FooterView`: view the render the footer
* `RowView`: view that renders each row
* `PaginationView`: view that renders the pagination controls
* `EmptyView`: view that is rendered if there is no data in the collection

Each of these views can be extended or overridden completely by passing them using the `subviews` parameter to the `TableView` or setting them explicitly in your extended `TableView`

### Table Renderer
Teeble's table-renderer uses `Handlebars` partials to combine and render the different parts of the view. These partials are defined in the `partials` parameter which allows you to define templates (header, cell, footer) for each column of the table. This allows you to update your table templates on the fly to do things like add, remove and rearrange columns. The renderer can also be extended or overwritten in the same way as the subviews

## Examples
* [Client-side paging](http://github.hubspot.com/teeble/examples/netflix-client-paging/index.html)
* [Server-side paging](http://github.hubspot.com/teeble/examples/netflix-request-paging/index.html)

## Contributing
In lieu of a formal style-guide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [grunt](http://gruntjs.com/).

_Also, please don't edit files in the "dist" subdirectory as they are generated via grunt. You'll find source code in the "lib" subdirectory!_

## TODOs
* Test
* Simpler templating option for less complex tables
* Abstract the table renderer for other templating languages


## Release History
0.1.0: Initial Release

## License
Copyright (c) 2013 HubSpot
Licensed under the MIT license.
