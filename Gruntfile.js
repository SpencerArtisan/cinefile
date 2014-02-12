'use strict';

module.exports = function(grunt) {

grunt.initConfig({
  pkg: grunt.file.readJSON('package.json'),

  imagemin: {                          // Task
    dist: {                          // Target
      files: {
        'public/images/slave.min.jpg': 'public/images/slave.jpg'
      }
    }
  },

  uglify: {
    my_target: {
    files: {
      'public/js/films.min.js': ['public/js/films.js']
    }
    }
  }});

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-imagemin');

  // Default task(s).
  grunt.registerTask('default', ['uglify', 'imagemin']);

};

