/*!
* teeble - v0.2.0 - 2013-03-06
* https://github.com/HubSpot/teeble
* Copyright (c) 2013 HubSpot, Marc Neuwirth, Jonathan Kim;
* Licensed MIT 
*/

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

    TableRenderer.prototype.table_template = null;

    TableRenderer.prototype.table_template_compiled = null;

    TableRenderer.prototype.empty_message = "No data to display";

    TableRenderer.prototype.classes = {
      sorting: {
        sortable_class: 'sorting'
      },
      pagination: {
        pagination_class: 'pagination',
        pagination_active: 'active',
        pagination_disabled: 'disabled'
      }
    };

    TableRenderer.prototype._now = function() {
      if (!Date.now) {
        return +(new Date);
      } else {
        return Date.now();
      }
    };

    TableRenderer.prototype._initialize = function(options) {
      var option, validOptions, _i, _len;
      this.start = this._now();
      this.options = options;
      validOptions = ['table_class', 'debug', 'key', 'partials', 'data', 'hasFooter', 'pagination_template', 'empty_message', 'cid', 'classes', 'collection'];
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

      this.pagination_template = __bind(this.pagination_template, this);

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
        return this.log.push("" + (this._now() - this.start) + "ms: " + label);
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
      var attribute, column, footer, footer_cell, footer_partial_name, header, header_cell, header_partial_name, i, j, k, name, partial, partial_name, row, row_cell, row_partial_name, selected, template, value, _i, _len, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6;
      if (partials == null) {
        partials = this.partials;
      }
      this._log_time("generate master template");
      header = "";
      row = "";
      footer = "";
      i = 0;
      for (partial_name in partials) {
        partial = partials[partial_name];
        /* Header
        */

        if (partial.header) {
          template = void 0;
          if (typeof partial.header === 'string') {
            template = partial.header;
            header_cell = '';
          } else {
            if (partial.header.template) {
              template = partial.header.template;
            }
            header_cell = "<th";
            if (!partial.header.attributes) {
              partial.header.attributes = {};
            }
            if (partial.sortable) {
              partial.header.attributes['data-sort'] = partial.sortable;
              if (!partial.header.attributes["class"]) {
                partial.header.attributes["class"] = [this.classes.sorting.sortable_class];
              } else {
                if (typeof partial.header.attributes["class"] === 'string') {
                  partial.header.attributes["class"] = [partial.header.attributes["class"]];
                }
                partial.header.attributes["class"].push(this.classes.sorting.sortable_class);
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
            header_cell += ">";
          }
          if (template) {
            header_partial_name = "" + this.cid + "-header" + i;
            Handlebars.registerPartial(header_partial_name, template);
            header_cell += "{{> " + header_partial_name + " }}";
          }
          if (partial.header !== template) {
            header_cell += "</th>";
          }
          header += header_cell;
        }
        /* Footer
        */

        if (partial.footer) {
          template = void 0;
          if (typeof partial.footer === 'string') {
            template = partial.footer;
            footer_cell = "";
          } else {
            if (partial.footer.template) {
              template = partial.footer.template;
            }
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
            footer_cell += ">";
          }
          if (template) {
            footer_partial_name = "" + this.cid + "-footer" + i;
            Handlebars.registerPartial(footer_partial_name, template);
            footer_cell += "{{> " + footer_partial_name + " }}";
          }
          if (partial.footer !== template) {
            footer_cell += "</td>";
          }
          footer += footer_cell;
        }
        /* Cell
        */

        if (partial.cell) {
          template = void 0;
          if (typeof partial.cell === 'string') {
            template = partial.cell;
            row_cell = "";
          } else {
            if (partial.cell.template) {
              template = partial.cell.template;
            }
            row_cell = "<td";
            if (!partial.cell.attributes) {
              partial.cell.attributes = {};
            }
            if (partial.sortable) {
              partial.cell.attributes['data-sort'] = partial.sortable;
            }
            _ref2 = partial.cell.attributes;
            for (attribute in _ref2) {
              value = _ref2[attribute];
              if (value instanceof Array) {
                value = value.join(' ');
              }
              row_cell += " " + attribute + "=\"" + value + "\" ";
            }
            row_cell += ">";
          }
          if (template) {
            row_partial_name = "" + this.cid + "-partial" + i;
            Handlebars.registerPartial(row_partial_name, template);
            row_cell += "{{> " + row_partial_name + " }}";
          }
          if (partial.cell !== template) {
            row_cell += "</td>";
          }
          row += row_cell;
        }
        i++;
      }
      j = 0;
      if (this.collection.sortbarColumns) {
        header = "<th colspan=\"" + (_.size(partials)) + "\">Sorted by: <select class=\"sortbar-field-select\">";
        if (this.collection.sortbarSortOptions) {
          _ref3 = this.collection.sortbarSortOptions;
          for (value in _ref3) {
            name = _ref3[value];
            header += "<option value=\"" + value + "\" " + selected + ">" + name + "</option>";
          }
        }
        _ref4 = this.collection.sortbarColumnOptions;
        for (value in _ref4) {
          name = _ref4[value];
          header += "<option value=\"" + value + "\" " + selected + ">" + name + "</option>";
        }
        header += "</select><div class=\"sort-reverser\"><div class=\"up\"></div><div class=\"down\"></div></div> Showing:</th>";
        _ref5 = this.collection.sortbarColumns;
        for (_i = 0, _len = _ref5.length; _i < _len; _i++) {
          column = _ref5[_i];
          header_cell = "<th><select data-column=\"" + j + "\" class=\"sortbar-column sortbar-column-" + j + "\">";
          k = 0;
          if (this.collection.sortbarColumnOptions) {
            _ref6 = this.collection.sortbarColumnOptions;
            for (value in _ref6) {
              name = _ref6[value];
              selected = '';
              if (value === column) {
                selected = "selected";
                footer_cell = "<td>{{" + value + "}}</td>";
                row_cell = "<td>{{" + value + "}}</td>";
              }
              header_cell += "<option value=\"" + value + "\" " + selected + ">" + name + "</option>";
              k++;
            }
            header_cell += "</select></th>";
            header += header_cell;
            footer += footer_cell;
            row += row_cell;
            j++;
          }
        }
      }
      this.header_template = "<tr>" + header + "</tr>";
      this.footer_template = footer;
      this.row_template = row;
      this.rows_template = "{{#each " + this.key + "}}<tr>" + this.row_template + "</tr>{{/each}}";
      this.table_empty_template = "<td valign=\"top\" colspan=\"" + i + "\" class=\"teeble_empty\">{{message}}</td>";
      if (!this.table_template) {
        this.table_template = "<table class=\"" + this.table_class + "\">\n<thead>" + this.header_template + "</thead>\n<tbody>" + this.row_template + "</tbody>\n{{#if " + this.hasFooter + "}}\n<tfoot>" + this.footer_template + "<tfoot>\n{{/if}}\n</table>";
      }
      this.table_template_compiled = Handlebars.compile(this.table_template);
      this.table_template_compiled = null;
      this.rows_template_compiled = null;
      this.row_template_compiled = null;
      this.header_template_compiled = null;
      this.footer_template_compiled = null;
      return this.table_empty_template_compiled = null;
    };

    TableRenderer.prototype.pagination_template_compiled = null;

    TableRenderer.prototype.pagination_template = function() {
      return "<div class=\"{{pagination_class}}\">\n    <ul>\n        <li><a href=\"#\" class=\"pagination-previous previous {{#if prev_disabled}}" + this.classes.pagination.pagination_disabled + "{{/if}}\">Previous</a></li>\n        {{#each pages}}\n        <li><a href=\"#\" class=\"pagination-page {{#if active}}" + this.classes.pagination.pagination_active + "{{/if}}\" data-page=\"{{number}}\">{{number}}</a></li>\n        {{/each}}\n        <li><a href=\"#\" class=\"pagination-next next {{#if next_disabled}}" + this.classes.pagination.pagination_disabled + "{{/if}}\">Next</a></li>\n    </ul>\n</div>";
    };

    TableRenderer.prototype.render_pagination = function(options) {
      if (!this.pagination_template_compiled) {
        this.pagination_template_compiled = Handlebars.compile(this.pagination_template());
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
      this.setSort = __bind(this.setSort, this);

      this.render = __bind(this.render, this);

      this.initialize = __bind(this.initialize, this);
      return HeaderView.__super__.constructor.apply(this, arguments);
    }

    HeaderView.prototype.tagName = 'thead';

    HeaderView.prototype.initialize = function() {
      this.renderer = this.options.renderer;
      this.classes = this.options.classes;
      this.collection.bind('destroy', this.remove, this);
      return this.collection.bind('reset', this.setSort, this);
    };

    HeaderView.prototype.render = function() {
      if (this.renderer) {
        this.$el.html(this.renderer.render_header(this.options));
        this.setSort();
      }
      return this;
    };

    HeaderView.prototype.setSort = function() {
      var classDirection, direction;
      if (this.collection.sortColumn) {
        direction = 'desc';
        if (this.collection.sortDirection) {
          direction = this.collection.sortDirection;
        }
        classDirection = "sorted_" + direction + "_class";
        return this.$el.find("." + this.classes.sorting.sortable_class).removeClass("" + this.classes.sorting.sorted_desc_class + " " + this.classes.sorting.sorted_asc_class).filter(".sorting[data-sort=\"" + this.collection.sortColumn + "\"]").addClass("" + this.classes.sorting[classDirection]);
      }
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

  this.Teeble.SortbarView = (function(_super) {

    __extends(SortbarView, _super);

    function SortbarView() {
      this.render = __bind(this.render, this);

      this.initialize = __bind(this.initialize, this);
      return SortbarView.__super__.constructor.apply(this, arguments);
    }

    SortbarView.prototype.tagName = 'thead';

    SortbarView.prototype.template = "<tr>\n    <% _.each(partials, function(partial) { %>\n        <%= partial.header %>\n    <% }); %>\n    <% for(var i = 0; i < sortbarColumns; i++) { %>\n        <th>\n            <select class=\"column-<%= i %>\" >\n                <% _.each(sortbarColumnOptions, function(name, value) { %>\n                    <option value=\"<%= value %>\" ><%= name %></option>\n                <% }); %>\n            </select>\n        </th>\n    <% } %>\n</tr>";

    SortbarView.prototype.initialize = function() {
      this.renderer = this.options.renderer;
      return this.collection.bind('destroy', this.remove, this);
    };

    SortbarView.prototype.render = function() {
      var html;
      if (this.renderer) {
        html = _.template(this.template, {
          partials: this.options.renderer.partials,
          sortbarColumns: this.options.collection.sortbarColumns,
          sortbarColumnOptions: this.options.collection.sortbarColumnOptions
        });
        this.$el.html(html);
      }
      return this;
    };

    return SortbarView;

  })(Backbone.View);

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Teeble.TableView = (function(_super) {

    __extends(TableView, _super);

    function TableView() {
      this.sortBarChange = __bind(this.sortBarChange, this);

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
      this.subviews = _.extend({}, this.subviews, this.options.subviews);
      this.events = _.extend({}, this.events, {
        'click a.first': 'gotoFirst',
        'click a.previous': 'gotoPrev',
        'click a.next': 'gotoNext',
        'click a.last': 'gotoLast',
        'click a.pagination-page': 'gotoPage',
        'click .sorting': 'sort',
        'change .sortbar-column': 'sortBarChange'
      });
      this.setOptions();
      TableView.__super__.initialize.apply(this, arguments);
      this.collection.on('add', this.addOne, this);
      this.collection.on('reset', this.renderBody, this);
      this.collection.on('reset', this.renderPagination, this);
      return this.renderer = new this.subviews.renderer({
        partials: this.options.partials,
        collection: this.collection,
        table_class: this.options.table_class,
        cid: this.cid,
        classes: this.classes
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
      this.trigger('teeble.render', this);
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
        this.$el.append(this.pagination.render().el);
        return this.trigger('pagination.render', this);
      }
    };

    TableView.prototype.renderHeader = function() {
      var _ref;
      if ((_ref = this.header) != null) {
        _ref.remove();
      }
      this.header = new this.subviews.header({
        renderer: this.renderer,
        collection: this.collection,
        classes: this.classes
      });
      this.table.prepend(this.header.render().el);
      return this.trigger('header.render', this);
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
          this.table.append(this.footer.render().el);
          return this.trigger('footer.render', this);
        }
      }
    };

    TableView.prototype.renderBody = function() {
      this.body.empty();
      if (this.collection.length > 0) {
        this.collection.each(this.addOne);
      } else {
        this.renderEmpty();
      }
      return this.trigger('body.render', this);
    };

    TableView.prototype.renderEmpty = function() {
      this.empty = new this.subviews.empty({
        renderer: this.renderer,
        collection: this.collection
      });
      this.body.append(this.empty.render().el);
      return this.trigger('empty.render', this);
    };

    TableView.prototype.addOne = function(item) {
      var view;
      view = new this.subviews.row({
        model: item,
        renderer: this.renderer
      });
      this.body.append(view.render().el);
      return this.trigger('row.render', view);
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
      $this = this.$(e.target);
      if (!$this.hasClass(this.classes.sorting.sortable_class)) {
        $this = $this.parents("." + this.classes.sorting.sortable_class);
      }
      currentSort = $this.attr('data-sort');
      return this.collection.setSort(currentSort, direction);
    };

    TableView.prototype.sort = function(e) {
      var $this;
      $this = this.$(e.currentTarget);
      if ($this.hasClass(this.classes.sorting.sorted_desc_class)) {
        return this._sort(e, 'asc');
      } else {
        return this._sort(e, 'desc');
      }
    };

    TableView.prototype.sortBarChange = function(e) {
      var $this, column, existing, oldValue, value;
      $this = this.$(e.currentTarget);
      column = ~~($this.attr('data-column'));
      value = $this.val();
      oldValue = this.collection.sortbarColumns[column];
      existing = _.indexOf(this.collection.sortbarColumns, value);
      if (existing >= 0) {
        this.collection.sortbarColumns[existing] = oldValue;
      }
      this.collection.sortbarColumns[column] = value;
      this.renderer.update_template();
      return this.render();
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
      this.whereAll = __bind(this.whereAll, this);

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

    ClientCollection.prototype.whereAll = function(attrs) {
      if (_.isEmpty(attrs)) {
        return [];
      }
      return _.filter(this.origModels, function(model) {
        var key, value;
        for (key in attrs) {
          value = attrs[key];
          if (value !== model.get(key)) {
            return false;
          }
        }
        return true;
      });
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
