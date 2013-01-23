/*! teeble - v0.1.0 - 2013-01-22
* https://github.com/hijonathan/teeble
* Copyright (c) 2013 HubSpot, Marc Neuwirth, Jonathan Kim; Licensed MIT */

(function() {

  this.Teeble = {};

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.Teeble.TableRenderer = (function() {

    TableRenderer.prototype.debug = false;

    TableRenderer.prototype.log = [];

    TableRenderer.prototype.key = 'rows';

    TableRenderer.prototype.hasFooter = false;

    TableRenderer.prototype.data = null;

    TableRenderer.prototype.header_template = null;

    TableRenderer.prototype.row_template = null;

    TableRenderer.prototype.rows_template = null;

    TableRenderer.prototype.table_class = null;

    TableRenderer.prototype.sortable_class = 'sorting';

    TableRenderer.prototype.table_template = null;

    TableRenderer.prototype.table_template_compiled = null;

    TableRenderer.prototype.empty_message = "No data to display";

    TableRenderer.prototype._initialize = function(options) {
      var option, validOptions, _i, _len;
      this.start = Date.now();
      this.options = options;
      validOptions = ['table_class', 'debug', 'key', 'partials', 'data', 'hasFooter', 'pagination_template', 'empty_message', 'cid'];
      for (_i = 0, _len = validOptions.length; _i < _len; _i++) {
        option = validOptions[_i];
        if (this.options[option]) {
          this[option] = this.options[option];
        }
      }
      this._log_time("start");
      if (this.partials) {
        this._log_time("generate partials");
        this.update_template(this.partials);
      }
      if (this.data) {
        return this.render(this.data);
      }
    };

    TableRenderer.prototype._parse_data = function(data) {
      var item, new_data;
      if (data) {
        if (Backbone && data instanceof Backbone.Collection) {
          new_data = {};
          new_data[this.key] = data.toJSON();
          this.data = new_data;
        } else if (data[this.key]) {
          this.data = data;
        } else if (data instanceof Array) {
          new_data = {};
          data = (function() {
            var _i, _len, _results;
            _results = [];
            for (_i = 0, _len = data.length; _i < _len; _i++) {
              item = data[_i];
              if (Backbone && item instanceof Backbone.Model) {
                _results.push(item.toJSON());
              } else {
                _results.push(item);
              }
            }
            return _results;
          })();
          new_data[this.key] = data;
          this.data = new_data;
        } else {
          new_data = {};
          new_data[this.key] = [data];
          this.data = new_data;
        }
      }
      if (this.data) {
        return true;
      }
      console.log('could not parse data');
      return false;
    };

    TableRenderer.prototype._render = function(template, data) {
      if (data == null) {
        data = this.data;
      }
      if (!template) {
        console.log('no compiled template');
        return false;
      }
      if (!data) {
        console.log('no data');
        return false;
      } else {
        this._log_time("start compile");
        this.rendered = template(data);
        this._log_time("end compile");
        return this.rendered;
      }
    };

    function TableRenderer(options) {
      this.render_pagination = __bind(this.render_pagination, this);

      this.update_template = __bind(this.update_template, this);

      this.render_empty = __bind(this.render_empty, this);

      this.render_footer = __bind(this.render_footer, this);

      this.render_header = __bind(this.render_header, this);

      this.render_row = __bind(this.render_row, this);

      this.render_rows = __bind(this.render_rows, this);

      this.render = __bind(this.render, this);

      this.print_log = __bind(this.print_log, this);

      this._log_time = __bind(this._log_time, this);

      this._render = __bind(this._render, this);

      this._parse_data = __bind(this._parse_data, this);

      this._initialize = __bind(this._initialize, this);
      this._initialize(options);
      this;

    }

    TableRenderer.prototype._log_time = function(label) {
      if (this.debug) {
        return this.log.push("" + (Date.now() - this.start) + "ms: " + label);
      }
    };

    TableRenderer.prototype.print_log = function() {
      return console.log(this.log);
    };

    TableRenderer.prototype.render = function(data) {
      if (this._parse_data(data)) {
        return this._render(this.table_template_compiled);
      }
    };

    TableRenderer.prototype.render_rows = function(data) {
      if (!this.rows_template_compiled) {
        this.rows_template_compiled = Handlebars.compile(this.rows_template);
      }
      if (this._parse_data(data)) {
        return this._render(this.rows_template_compiled);
      }
    };

    TableRenderer.prototype.render_row = function(data) {
      if (!this.row_template_compiled) {
        this.row_template_compiled = Handlebars.compile(this.row_template);
      }
      if (data) {
        return this._render(this.row_template_compiled, data);
      }
    };

    TableRenderer.prototype.render_header = function(data) {
      if (!this.header_template_compiled) {
        this.header_template_compiled = Handlebars.compile(this.header_template);
      }
      if (data) {
        return this._render(this.header_template_compiled, data);
      }
    };

    TableRenderer.prototype.render_footer = function(data) {
      if (!this.footer_template_compiled) {
        this.footer_template_compiled = Handlebars.compile(this.footer_template);
      }
      if (data) {
        return this._render(this.footer_template_compiled, data);
      }
    };

    TableRenderer.prototype.render_empty = function(data) {
      if (!this.table_empty_template_compiled) {
        this.table_empty_template_compiled = Handlebars.compile(this.table_empty_template);
      }
      if (data) {
        if (!data.message) {
          data.message = this.empty_message;
        }
        return this._render(this.table_empty_template_compiled, data);
      }
    };

    TableRenderer.prototype.update_template = function(partials) {
      var attribute, footer, footer_cell, footer_partial_name, header, header_cell, header_partial_name, i, partial, partial_name, row, row_cell, row_partial_name, value, _ref, _ref1, _ref2;
      this._log_time("generate master template");
      header = "";
      row = "";
      footer = "";
      i = 0;
      for (partial_name in partials) {
        partial = partials[partial_name];
        if (partial.header) {
          header_cell = "<th";
          if (!partial.header.attributes) {
            partial.header.attributes = {};
          }
          if (partial.sortable) {
            if (partial_name) {
              partial.header.attributes['data-sort'] = partial_name;
            }
            if (!partial.header.attributes["class"]) {
              partial.header.attributes["class"] = [this.sortable_class];
            } else {
              if (typeof partial.header.attributes["class"] === 'string') {
                partial.header.attributes["class"] = [partial.header.attributes["class"]];
              }
              partial.header.attributes["class"].push(this.sortable_class);
            }
          }
          _ref = partial.header.attributes;
          for (attribute in _ref) {
            value = _ref[attribute];
            if (value instanceof Array) {
              value = value.join(' ');
            }
            header_cell += " " + attribute + "=\"" + value + "\" ";
          }
          if (partial.header.template) {
            header_partial_name = "" + this.cid + "-header" + i;
            Handlebars.registerPartial(header_partial_name, partial.header.template);
            header_cell += ">{{> " + header_partial_name + " }}";
          } else {
            header_cell += ">";
          }
          header_cell += "</th>";
          header += header_cell;
        }
        if (partial.footer) {
          footer_cell = "<td";
          if (!partial.footer.attributes) {
            partial.footer.attributes = {};
          }
          _ref1 = partial.footer.attributes;
          for (attribute in _ref1) {
            value = _ref1[attribute];
            if (value instanceof Array) {
              value = value.join(' ');
            }
            footer_cell += " " + attribute + "=\"" + value + "\" ";
          }
          if (partial.footer.template) {
            footer_partial_name = "" + this.cid + "-footer" + i;
            Handlebars.registerPartial(footer_partial_name, partial.footer.template);
            footer_cell += ">{{> " + footer_partial_name + " }}";
          } else {
            footer_cell += ">";
          }
          footer_cell += "</td>";
          footer += footer_cell;
        }
        if (partial.cell) {
          row_cell = "<td";
          if (!partial.cell.attributes) {
            partial.cell.attributes = {};
          }
          if (partial.sortable) {
            if (partial_name) {
              partial.cell.attributes['data-sort'] = partial_name;
            }
          }
          _ref2 = partial.cell.attributes;
          for (attribute in _ref2) {
            value = _ref2[attribute];
            if (value instanceof Array) {
              value = value.join(' ');
            }
            row_cell += " " + attribute + "=\"" + value + "\" ";
          }
          if (partial.cell.template) {
            row_partial_name = "" + this.cid + "-partial" + i;
            Handlebars.registerPartial(row_partial_name, partial.cell.template);
            row_cell += ">{{> " + row_partial_name + " }}";
          } else {
            row_cell += ">";
          }
          row_cell += "</td>";
          row += row_cell;
        }
        i++;
      }
      this.header_template = "<tr>" + header + "</tr>";
      this.footer_template = footer;
      this.row_template = row;
      this.rows_template = "{{#each " + this.key + "}}<tr>" + this.row_template + "</tr>{{/each}}";
      this.table_empty_template = "<td valign=\"top\" colspan=\"" + i + "\" class=\"teeble_empty\">{{message}}</td>";
      if (!this.table_template) {
        this.table_template = "<table class=\"" + this.table_class + "\">\n<thead>" + this.header_template + "</thead>\n<tbody>" + this.row_template + "</tbody>\n{{#if " + this.hasFooter + "}}\n<tfoot>" + this.footer_template + "<tfoot>\n{{/if}}\n</table>";
      }
      return this.table_template_compiled = Handlebars.compile(this.table_template);
    };

    TableRenderer.prototype.pagination_template_compiled = null;

    TableRenderer.prototype.pagination_template = "<div class=\"{{pagination_class}}\">\n    <ul>\n        <li><a href=\"#\" class=\"pagination-previous previous {{#if prev_disabled}}{{pagination_disabled}}{{/if}}\">Previous</a></li>\n        {{#each pages}}\n        <li><a href=\"#\" class=\"pagination-page {{#if active}}{{active}}{{/if}}\" data-page=\"{{number}}\">{{number}}</a></li>\n        {{/each}}\n        <li><a href=\"#\" class=\"pagination-next next {{#if next_disabled}}{{pagination_disabled}}{{/if}}\">Next</a></li>\n    </ul>\n</div>";

    TableRenderer.prototype.render_pagination = function(options) {
      if (!this.pagination_template_compiled) {
        this.pagination_template_compiled = Handlebars.compile(this.pagination_template);
      }
      return this.pagination_template_compiled(options);
    };

    return TableRenderer;

  })();

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Teeble.EmptyView = (function(_super) {

    __extends(EmptyView, _super);

    function EmptyView() {
      this.render = __bind(this.render, this);

      this.initialize = __bind(this.initialize, this);
      return EmptyView.__super__.constructor.apply(this, arguments);
    }

    EmptyView.prototype.initialize = function() {
      this.renderer = this.options.renderer;
      return this.collection.bind('destroy', this.remove, this);
    };

    EmptyView.prototype.render = function() {
      if (this.renderer) {
        this.el = this.renderer.render_empty(this.options);
      }
      return this;
    };

    return EmptyView;

  })(Backbone.View);

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Teeble.FooterView = (function(_super) {

    __extends(FooterView, _super);

    function FooterView() {
      this.render = __bind(this.render, this);

      this.initialize = __bind(this.initialize, this);
      return FooterView.__super__.constructor.apply(this, arguments);
    }

    FooterView.prototype.tagName = 'tfoot';

    FooterView.prototype.initialize = function() {
      this.renderer = this.options.renderer;
      return this.collection.bind('destroy', this.remove, this);
    };

    FooterView.prototype.render = function() {
      if (this.renderer) {
        this.$el.html(this.renderer.render_footer({}));
      }
      return this;
    };

    return FooterView;

  })(Backbone.View);

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Teeble.HeaderView = (function(_super) {

    __extends(HeaderView, _super);

    function HeaderView() {
      this.render = __bind(this.render, this);

      this.initialize = __bind(this.initialize, this);
      return HeaderView.__super__.constructor.apply(this, arguments);
    }

    HeaderView.prototype.tagName = 'thead';

    HeaderView.prototype.initialize = function() {
      this.renderer = this.options.renderer;
      return this.collection.bind('destroy', this.remove, this);
    };

    HeaderView.prototype.render = function() {
      if (this.renderer) {
        this.$el.html(this.renderer.render_header(this.options));
      }
      return this;
    };

    return HeaderView;

  })(Backbone.View);

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Teeble.PaginationView = (function(_super) {

    __extends(PaginationView, _super);

    function PaginationView() {
      this.render = __bind(this.render, this);

      this.initialize = __bind(this.initialize, this);
      return PaginationView.__super__.constructor.apply(this, arguments);
    }

    PaginationView.prototype.tagName = 'div';

    PaginationView.prototype.initialize = function() {
      this.renderer = this.options.renderer;
      return this.collection.bind('destroy', this.remove, this);
    };

    PaginationView.prototype.render = function() {
      var data, info, p, page, pages;
      if (this.renderer) {
        info = this.collection.info();
        if (info.totalPages > 1) {
          pages = (function() {
            var _i, _len, _ref, _results;
            _ref = info.pageSet;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              page = _ref[_i];
              p = {
                active: page === info.currentPage ? this.options.pagination.pagination_active : void 0,
                number: page
              };
              _results.push(p);
            }
            return _results;
          }).call(this);
          data = {
            pagination_class: this.options.pagination.pagination_class,
            pagination_disabled: this.options.pagination.pagination_disabled,
            prev_disabled: info.previous === false || info.hasPrevious === false,
            next_disabled: info.next === false || info.hasNext === false,
            pages: pages
          };
          this.$el.html(this.renderer.render_pagination(data));
        }
      }
      return this;
    };

    return PaginationView;

  })(Backbone.View);

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Teeble.RowView = (function(_super) {

    __extends(RowView, _super);

    function RowView() {
      this.render = __bind(this.render, this);

      this.initialize = __bind(this.initialize, this);
      return RowView.__super__.constructor.apply(this, arguments);
    }

    RowView.prototype.tagName = 'tr';

    RowView.prototype.initialize = function() {
      this.renderer = this.options.renderer;
      this.model.bind('change', this.render, this);
      return this.model.bind('destroy', this.remove, this);
    };

    RowView.prototype.render = function() {
      if (this.renderer) {
        this.$el.html(this.renderer.render_row(this.model.toJSON({
          teeble: true
        })));
      }
      return this;
    };

    return RowView;

  })(Backbone.View);

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Teeble.TableView = (function(_super) {

    __extends(TableView, _super);

    function TableView() {
      this.sort = __bind(this.sort, this);

      this._sort = __bind(this._sort, this);

      this.gotoPage = __bind(this.gotoPage, this);

      this.gotoLast = __bind(this.gotoLast, this);

      this.gotoNext = __bind(this.gotoNext, this);

      this.gotoPrev = __bind(this.gotoPrev, this);

      this.gotoFirst = __bind(this.gotoFirst, this);

      this.addOne = __bind(this.addOne, this);

      this.renderEmpty = __bind(this.renderEmpty, this);

      this.renderBody = __bind(this.renderBody, this);

      this.renderFooter = __bind(this.renderFooter, this);

      this.renderHeader = __bind(this.renderHeader, this);

      this.renderPagination = __bind(this.renderPagination, this);

      this.render = __bind(this.render, this);

      this.setOptions = __bind(this.setOptions, this);

      this.initialize = __bind(this.initialize, this);
      return TableView.__super__.constructor.apply(this, arguments);
    }

    TableView.prototype.tagName = 'div';

    TableView.prototype.classes = {
      sorting: {
        sortable_class: 'sorting',
        sorted_desc_class: 'sorting_desc',
        sorted_asc_class: 'sorting_asc'
      },
      pagination: {
        pagination_class: 'pagination',
        pagination_active: 'active',
        pagination_disabled: 'disabled'
      }
    };

    TableView.prototype.subviews = {
      header: Teeble.HeaderView,
      row: Teeble.RowView,
      footer: Teeble.FooterView,
      pagination: Teeble.PaginationView,
      renderer: Teeble.TableRenderer,
      empty: Teeble.EmptyView
    };

    TableView.prototype.initialize = function() {
      this.events = _.extend({}, this.events, {
        'click a.first': 'gotoFirst',
        'click a.previous': 'gotoPrev',
        'click a.next': 'gotoNext',
        'click a.last': 'gotoLast',
        'click a.pagination-page': 'gotoPage',
        'click .sorting': 'sort'
      });
      this.setOptions();
      TableView.__super__.initialize.apply(this, arguments);
      this.collection.on('add', this.addOne, this);
      this.collection.on('reset', this.renderBody, this);
      this.collection.on('reset', this.renderPagination, this);
      return this.renderer = new this.subviews.renderer({
        partials: this.options.partials,
        table_class: this.options.table_class,
        cid: this.cid
      });
    };

    TableView.prototype.setOptions = function() {
      return this;
    };

    TableView.prototype.render = function() {
      this.$el.empty().append("<table><tbody></tbody></table");
      this.table = this.$('table').addClass(this.options.table_class);
      this.body = this.$('tbody');
      this.renderHeader();
      this.renderBody();
      this.renderFooter();
      this.renderPagination();
      return this;
    };

    TableView.prototype.renderPagination = function() {
      var _ref;
      if (this.options.pagination) {
        if ((_ref = this.pagination) != null) {
          _ref.remove();
        }
        this.pagination = new this.subviews.pagination({
          renderer: this.renderer,
          collection: this.collection,
          pagination: this.classes.pagination
        });
        return this.$el.append(this.pagination.render().el);
      }
    };

    TableView.prototype.renderHeader = function() {
      var _ref;
      if ((_ref = this.header) != null) {
        _ref.remove();
      }
      this.header = new this.subviews.header({
        renderer: this.renderer,
        collection: this.collection
      });
      return this.table.prepend(this.header.render().el);
    };

    TableView.prototype.renderFooter = function() {
      var _ref;
      if (this.options.footer) {
        if ((_ref = this.footer) != null) {
          _ref.remove();
        }
        if (this.collection.length > 0) {
          this.footer = new this.subviews.footer({
            renderer: this.renderer,
            collection: this.collection
          });
          return this.table.append(this.footer.render().el);
        }
      }
    };

    TableView.prototype.renderBody = function() {
      this.body.empty();
      if (this.collection.length > 0) {
        return this.collection.each(this.addOne);
      } else {
        return this.renderEmpty();
      }
    };

    TableView.prototype.renderEmpty = function() {
      this.empty = new this.subviews.empty({
        renderer: this.renderer,
        collection: this.collection
      });
      return this.body.append(this.empty.render().el);
    };

    TableView.prototype.addOne = function(item) {
      var view;
      view = new this.subviews.row({
        model: item,
        renderer: this.renderer
      });
      return this.body.append(view.render().el);
    };

    TableView.prototype.gotoFirst = function(e) {
      e.preventDefault();
      return this.collection.goTo(1);
    };

    TableView.prototype.gotoPrev = function(e) {
      e.preventDefault();
      return this.collection.previousPage();
    };

    TableView.prototype.gotoNext = function(e) {
      e.preventDefault();
      return this.collection.nextPage();
    };

    TableView.prototype.gotoLast = function(e) {
      e.preventDefault();
      return this.collection.goTo(this.collection.information.lastPage);
    };

    TableView.prototype.gotoPage = function(e) {
      var page;
      e.preventDefault();
      page = this.$(e.target).text();
      return this.collection.goTo(page);
    };

    TableView.prototype._sort = function(e, direction) {
      var $this, currentSort;
      e.preventDefault();
      this.$el.find('.sorting').removeClass('sorting_desc sorting_asc');
      $this = this.$(e.target);
      if (!$this.hasClass('sorting')) {
        $this = $this.parents('.sorting');
      }
      $this.addClass("sorting_" + direction);
      currentSort = $this.attr('data-sort');
      this.collection.setSort(currentSort, direction);
      this.renderBody();
      return this.renderPagination();
    };

    TableView.prototype.sort = function(e) {
      var $this;
      $this = $(e.currentTarget);
      if ($this.hasClass('sorting_desc')) {
        return this._sort(e, 'asc');
      } else {
        return this._sort(e, 'desc');
      }
    };

    return TableView;

  })(Backbone.View);

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Teeble.ClientCollection = (function(_super) {

    __extends(ClientCollection, _super);

    function ClientCollection() {
      this.initialize = __bind(this.initialize, this);
      return ClientCollection.__super__.constructor.apply(this, arguments);
    }

    ClientCollection.prototype.default_paginator_core = {
      dataType: 'json',
      url: function() {
        return this.url();
      }
    };

    ClientCollection.prototype.default_paginator_ui = {
      sortColumn: '',
      sortDirection: 'desc',
      firstPage: 1,
      currentPage: 1,
      perPage: 10,
      pagesInRange: 3
    };

    ClientCollection.prototype.initialize = function() {
      this.paginator_ui = _.extend({}, this.default_paginator_ui, this.paginator_ui);
      this.paginator_core = _.extend({}, this.default_paginator_core, this.paginator_core);
      return ClientCollection.__super__.initialize.apply(this, arguments);
    };

    return ClientCollection;

  })(Backbone.Paginator.clientPager);

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Teeble.ServerCollection = (function(_super) {

    __extends(ServerCollection, _super);

    function ServerCollection() {
      this.pager = __bind(this.pager, this);

      this.setSort = __bind(this.setSort, this);

      this.previousPage = __bind(this.previousPage, this);

      this.nextPage = __bind(this.nextPage, this);

      this.initialize = __bind(this.initialize, this);
      return ServerCollection.__super__.constructor.apply(this, arguments);
    }

    ServerCollection.prototype.default_paginator_core = {
      dataType: 'json',
      url: function() {
        return this.url();
      }
    };

    ServerCollection.prototype.default_paginator_ui = {
      firstPage: 1,
      currentPage: 1,
      perPage: 10,
      pagesInRange: 3
    };

    ServerCollection.prototype.default_server_api = {
      'offset': function() {
        return (this.currentPage - 1) * this.perPage;
      },
      'limit': function() {
        return this.perPage;
      }
    };

    ServerCollection.prototype.initialize = function() {
      this.paginator_ui = _.extend({}, this.default_paginator_ui, this.paginator_ui);
      this.paginator_core = _.extend({}, this.default_paginator_core, this.paginator_core);
      this.server_api = _.extend({}, this.default_server_api, this.server_api);
      return ServerCollection.__super__.initialize.apply(this, arguments);
    };

    ServerCollection.prototype.nextPage = function(options) {
      if (this.currentPage < this.information.totalPages) {
        return this.promise = this.requestNextPage(options);
      }
    };

    ServerCollection.prototype.previousPage = function(options) {
      if (this.currentPage > 1) {
        return this.promise = this.requestPreviousPage(options);
      }
    };

    ServerCollection.prototype.setSort = function(column, direction) {
      if (column !== void 0 && direction !== void 0) {
        this.lastSortColumn = this.sortColumn;
        this.sortColumn = column;
        this.sortDirection = direction;
        this.pager();
        return this.info();
      }
    };

    ServerCollection.prototype.pager = function() {
      if (this.lastSortColumn !== this.sortColumn) {
        this.currentPage = 1;
        this.lastSortColumn = this.sortColumn;
      }
      return ServerCollection.__super__.pager.apply(this, arguments);
    };

    return ServerCollection;

  })(Backbone.Paginator.requestPager);

}).call(this);
