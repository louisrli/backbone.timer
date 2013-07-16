module.exports = (grunt) ->
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')

    uglify:
      options:
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      build:
        files:
          'dist/<%= pkg.name %>.min.js' : 'dist/<%= pkg.name %>.js'
          '<%= pkg.name %>.min.js' : 'dist/<%= pkg.name %>.js'

    coffee:
      compile:
        options:
          bare: true
        files:
          "dist/<%= pkg.name %>.js": "src/<%= pkg.name %>.coffee"

      compiletest:
        files:
          "test/timer-test.js": "test/timer-test.coffee"

    qunit:
      all: ['test/*.html']

    jsdoc:
      dist:
        src: ['dist/<%= pkg.name %>.js']
        options:
          destination: 'doc'
  )

  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-qunit')
  grunt.loadNpmTasks('grunt-jsdoc')

  grunt.registerTask('default', ['coffee:compile', 'uglify'])
  grunt.registerTask('test', ['coffee:compile', 'coffee:compiletest', 'qunit'])
  grunt.registerTask('release', ['coffee', 'qunit', 'uglify', 'jsdoc:dist'])
