define = require('amdefine')(module, requirejs) if (typeof define isnt 'function')
define ->
  Generator = {}
  Generator.TestModel = Backbone.Model.extend()
  Generator.TestCollection = Backbone.Collection.extend
    model: Generator.TestModel

  testCollection = new Generator.TestCollection()
  testCollection.add new Generator.TestModel id:1, name: 'model 1'
  testCollection.add new Generator.TestModel id:2, name: 'model 2'
  Generator.testCollection = testCollection
  Generator
