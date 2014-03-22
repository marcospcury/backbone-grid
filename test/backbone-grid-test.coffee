define = require('amdefine')(module, requirejs) if (typeof define isnt 'function')
define [
  'jquery'
  'test/support/generatorHelper'
], ($, Generator) ->
  grid = {}
  $("body").append '<div id="grid"></div>'
  describe 'Backbone.Grid', ->
    describe 'initialize', ->
      before ->
        grid = new Backbone.Grid
          columns: []
          collection: []
          pageable: true
          selectRow: true
      after ->
        grid.remove()
        $("body").append '<div id="grid"></div>'
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
          columns: [ { title: 'column 1', field: 'id' }, { title: 'column 2', field:'name' }]
          collection: Generator.testCollection
      after ->
        grid.remove()
        $("body").append '<div id="grid"></div>'
      describe 'render', ->
        before ->
          grid.render()
        it 'renders the base table structure', ->
          expect($("#grid-container").html()).to.not.equal undefined
        it 'renders the column header row', ->
          expect($("#grid-container thead th").length).to.equal 2
        it 'renders the column header title', ->
          expect($(".grid-header-0").html()).to.equal 'column 1'
        it 'renders the data rows', ->
          expect($("#grid-container tbody tr").length).to.equal 2
        it 'renders the cell content', ->
          expect($($('.grid-cell')[1]).html()).to.equal 'model 1'

    describe 'row selection', ->
      rowSelectedSpy = sinon.spy()
      before ->
        $("#grid").html("")
        grid = new Backbone.Grid
          columns: [ { title: 'column 1', field: 'id' }, { title: 'column 2', field:'name' }]
          collection: Generator.testCollection
          selectRow: true
          rowSelected: rowSelectedSpy
        grid.render()
      after ->
        grid.remove()
        $("body").append '<div id="grid"></div>'
      describe 'render', ->
        it 'renders the table hover effect', ->
          expect($("#grid-container").hasClass("table-hover")).to.be.true
        it 'renders the pointer cursor over the rows', ->
          expect($("#grid-container tbody tr").css("cursor")).to.equal 'pointer'
      describe 'row click', ->
        before ->
          grid.$($(".grid-cell")[0]).click()
        it 'invoke the callback click method', ->
          expect(rowSelectedSpy).to.be.called
        it 'send selected model as callback argument', ->
          expect((rowSelectedSpy.args[0][0]).get("name")).to.equal "model 1"

    describe 'button cell', ->
      buttonClickSpy = sinon.spy()
      before ->
        $("#grid").html("")
        grid = new Backbone.Grid
          columns: [ { title: '', type: 'button', text: 'button 1' }, { title: 'column 1', field: 'id' }, { title: 'column 2', field:'name' }]
          collection: Generator.testCollection
        grid.render()
        console.log grid.columns
      after ->
        grid.remove()
        $("body").append '<div id="grid"></div>'
      describe 'render', ->
        it 'renders the buttons', ->
          expect($("button").length).to.equal 2


