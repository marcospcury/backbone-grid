requirejs.config
  paths:
    jquery: 'vendor/jquery/jquery'
    underscore: 'vendor/underscore/underscore'
    backbone: 'vendor/backbone/backbone'
    backboneGrid: 'dist/backbone-grid'
    handlebars: 'vendor/handlebars/index'
    text: 'vendor/requirejs-text/text'
    sinon: 'vendor/sinon/lib/sinon'
  shim:
    'underscore':
      exports: '_'
    'backbone':
      deps: ['jquery', 'underscore']
      exports: 'Backbone'
    'backboneGrid':
      deps: ['jquery', 'underscore', 'backbone']
      exports: 'Backbone.Grid'
