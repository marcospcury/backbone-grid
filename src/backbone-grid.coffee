throw new Error "Backbone.js is required" if not window.Backbone
noConflict = Backbone.Grid || {}
Grid = Backbone.Grid = Backbone.View.extend
  initialize: (options) ->
    options ||= {}
    throw new Error("Grid.initialize -> invalid arguments") unless options.columns and options.collection
    @setupOptions options
    @loadTemplates()
    @setElement @targetElement
  setupOptions: (options) ->
    @targetElement = options.targetElement || "#grid"
    @columns = options.columns
    @collection = options.collection
    @pageable = options.pageable
    @selectRow = options.selectRow
  loadTemplates: ->
    @templateTable = '<table id="grid-container" class="table table-striped table-bordered"><thead></thead><tbody></tbody><tfoot></tfoot></table>'
    @templateHeader = _.template '<tr><%var cell = 0; _.map(columns, function(item) {%><th class="grid-header-<%=cell%>"><%=item.title%></th><% cell++;});%></tr>'
    @templateStringCell = _.template '<td data-id="<%=model.id%>" class="grid-cell"><%=model.get(column.field)%></td>'
    @templateButtonCell = _.template '<td><button data-id="<%=model.id%>" class="btn <%=column.buttonClassName ? column.buttonClassName : "btn-default"%> <%=column.idElement%>"><%=column.text%></button></td>'
  render: ->
    @renderBaseTable()
    @renderHeader()
    @renderDataRows()
    @formatCells()
  renderBaseTable: ->
    @$el.html @templateTable
  renderHeader: ->
    @$("#grid-container thead").html @templateHeader columns: @columns
  renderDataRows: ->
    tbody = []
    @renderDataColumns model, tbody for model in @collection.models
    @$("#grid-container tbody").html tbody.join ''
  renderDataColumns: (model, tbody) ->
    tbody.push '<tr>'
    tbody.push @renderCellByType model: model, column: column for column in @columns
    tbody.push '</tr>'
  renderCellByType: (cellData) ->
    cellData.column.type ||= 'string'
    type = cellData.column.type
    cellTemplate = switch
      when type = 'string' then @templateStringCell cellData
    cellTemplate
  formatCells: ->
    if @selectRow
      @$("#grid-container").addClass("table-hover")
      @$("#grid-container tbody tr").css("cursor", "pointer")

Grid.version = "0.1.1"
Grid.noConflict = noConflict
