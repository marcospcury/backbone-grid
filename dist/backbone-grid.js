(function() {
  var Grid, noConflict;

  if (!window.Backbone) {
    throw new Error("Backbone.js is required");
  }

  noConflict = Backbone.Grid || {};

  Grid = Backbone.Grid = Backbone.View.extend({
    initialize: function(options) {
      options || (options = {});
      if (!(options.columns && options.collection)) {
        throw new Error("Grid.initialize -> invalid arguments");
      }
      this.setupOptions(options);
      this.loadTemplates();
      return this.setElement(this.targetElement);
    },
    setupOptions: function(options) {
      this.targetElement = options.targetElement || "#grid";
      this.columns = options.columns;
      this.collection = options.collection;
      this.pageable = options.pageable;
      return this.selectRow = options.selectRow;
    },
    loadTemplates: function() {
      this.templateTable = '<table id="grid-container" class="table table-striped table-bordered"><thead></thead><tbody></tbody><tfoot></tfoot></table>';
      this.templateHeader = _.template('<tr><%var cell = 0; _.map(columns, function(item) {%><th class="grid-header-<%=cell%>"><%=item.title%></th><% cell++;});%></tr>');
      this.templateStringCell = _.template('<td data-id="<%=model.id%>" class="grid-cell"><%=model.get(column.field)%></td>');
      return this.templateButtonCell = _.template('<td><button data-id="<%=model.id%>" class="btn <%=column.buttonClassName ? column.buttonClassName : "btn-default"%> <%=column.idElement%>"><%=column.text%></button></td>');
    },
    render: function() {
      this.renderBaseTable();
      this.renderHeader();
      this.renderDataRows();
      return this.formatCells();
    },
    renderBaseTable: function() {
      return this.$el.html(this.templateTable);
    },
    renderHeader: function() {
      return this.$("#grid-container thead").html(this.templateHeader({
        columns: this.columns
      }));
    },
    renderDataRows: function() {
      var model, tbody, _i, _len, _ref;
      tbody = [];
      _ref = this.collection.models;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        model = _ref[_i];
        this.renderDataColumns(model, tbody);
      }
      return this.$("#grid-container tbody").html(tbody.join(''));
    },
    renderDataColumns: function(model, tbody) {
      var column, _i, _len, _ref;
      tbody.push('<tr>');
      _ref = this.columns;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        column = _ref[_i];
        tbody.push(this.renderCellByType({
          model: model,
          column: column
        }));
      }
      return tbody.push('</tr>');
    },
    renderCellByType: function(cellData) {
      var cellTemplate, type, _base;
      (_base = cellData.column).type || (_base.type = 'string');
      type = cellData.column.type;
      cellTemplate = (function() {
        switch (false) {
          case !(type = 'string'):
            return this.templateStringCell(cellData);
        }
      }).call(this);
      return cellTemplate;
    },
    formatCells: function() {
      if (this.selectRow) {
        this.$("#grid-container").addClass("table-hover");
        return this.$("#grid-container tbody tr").css("cursor", "pointer");
      }
    }
  });

  Grid.version = "0.1.1";

  Grid.noConflict = noConflict;

}).call(this);
