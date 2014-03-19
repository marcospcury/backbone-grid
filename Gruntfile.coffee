module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      grid:
        expand:true
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'dist'
        ext: '.js'
      test:
        expand:true
        cwd: 'test'
        src: ['**/*.coffee']
        dest: 'test'
        ext: '.js'
    mochacov:
      options:
        require: ['test/support/runnerSetup.js']
        reporter: 'spec'
      client: ['test/**/*.js']
    uglify:
      js:
        files:
          'dist/backbone-grid.min.js': ['dist/backbone-grid.js']
    watch:
      compileAndTest:
        files: [ 'test/**/*.coffee', 'src/**/*.coffee' ]
        tasks: [ 'compileAndTest' ]
        options:
          nospawn: true
    bower:
      install:
        options:
          target: 'vendor'
          copy: false
          verbose: true

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-mocha-cov'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  _ = grunt.util._
  filterFiles = (files, dir) ->
    _.chain(files)
     .filter((f) -> _(f).startsWith dir)
     .map((f)->_(f).strRight "#{dir}/")
     .value()

  changedFiles = {}
  onChange = grunt.util._.debounce ->
    files = Object.keys(changedFiles)
    testFiles = filterFiles files, 'test'
    clientFiles = filterFiles files, 'src'
    grunt.config ['test', 'src'], testFiles
    grunt.config ['client', 'src'], clientFiles
    changedFiles = {}
  , 1000
  grunt.event.on 'watch', (action, filepath) ->
    changedFiles[filepath] = action
    onChange()

  grunt.registerTask 'compile', ['coffee', 'uglify']
  grunt.registerTask 'test', ['coffee:grid', 'coffee:test', 'mochacov:client']
  grunt.registerTask 'compileAndTest', ->
    tasks = []
    if grunt.config(['client', 'src']).length isnt 0 or grunt.config(['test', 'src']).length isnt 0
      tasks.push 'test'
      grunt.log.writeln "Running unit tests"
    grunt.task.run tasks
  grunt.registerTask 'watch:test', ['watch:compileAndTest']
