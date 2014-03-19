define = require('amdefine')(module, requirejs) if (typeof define isnt 'function')
define [
  'jquery'
  'test/support/generatorHelper'
], ($, Generator) ->
  $("body").append '<div id="grid"></div>'
  grid = {}
  describe 'Backbone.Grid', ->
    describe 'initialize', ->
      before ->
        grid = new Backbone.Grid
          columns: []
          collection: []
          pageable: true
          selectRow: true
      it 'sets the column definition', ->
        expect(grid.columns).to.not.equal undefined
      it 'sets the collection definition', ->
        expect(grid.collection).to.not.equal undefined
      it 'sets target DOM element #grid', ->
        expect(grid.el).to.not.equal undefined
      it 'sets the pageable option', ->
        expect(grid.pageable).to.be.true
      it 'sets the selectRow option', ->
        expect(grid.selectRow).to.be.true

    describe 'basic config', ->
      before ->
        grid = new Backbone.Grid
          columns: [ { title: 'coluna 1', field: 'id' }, { title: 'coluna 2', field:'name' }]
          collection: Generator.testCollection
      describe 'render', ->
        before ->
          grid.render()
        it 'renders the base table structure', ->
          expect($("#grid-container").html()).to.not.equal undefined
        it 'renders the column header row', ->
          expect($("#grid-container thead th").length).to.equal 2
        it 'renders the column header title', ->
          expect($(".grid-header-0").html()).to.equal 'coluna 1'
        it 'renders the data rows', ->
          expect($("#grid-container tbody tr").length).to.equal 2
        it 'renders the cell content', ->
          expect($($('.grid-cell')[1]).html()).to.equal 'model 1'

    describe 'row selection', ->
      before ->
        $("#grid").html()
        rowSelectedSpy = sinon.spy
        grid = new Backbone.Grid
          columns: [ { title: 'coluna 1', field: 'id' }, { title: 'coluna 2', field:'name' }]
          collection: Generator.testCollection
          selectRow: true
          rowSelected: rowSelectedSpy
      describe 'render', ->
        before ->
          grid.render()
        it 'renders the table hover effect', ->
          expect($("#grid-container").hasClass("table-hover")).to.be.true
        it 'renders the pointer cursor over the rows', ->
          expect($("#grid-container tbody tr").css("cursor")).to.equal 'pointer'

