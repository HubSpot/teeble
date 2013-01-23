module.exports = function(grunt) {
    grunt.loadNpmTasks('grunt-coffee');
    // Project configuration.
    grunt.initConfig({
        pkg: '<json:package.json>',
        server: {
          port: 3000,
          base: '.'
        },
        meta: {
            banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
                '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
                '<%= pkg.homepage ? "* " + pkg.homepage + "\n" : "" %>' +
                '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
                ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */'
        },
        concat: {
            dist: {
                src: [
                    '<banner:meta.banner>',
                    'lib/setup.coffee.js',
                    'lib/table-renderer.coffee.js',
                    'lib/views/*.coffee.js',
                    'lib/collections/*.coffee.js'
                ],
                dest: 'dist/<%= pkg.name %>.js'
            },
            test: {
              src: [
                  '<banner:meta.banner>',
                  'vendor/jquery.js',
                  'vendor/underscore.js',
                  'vendor/backbone.js',
                  'vendor/backbone.paginator.js',
                  'vendor/handlebars.js',
                  'lib/setup.coffee.js',
                  'lib/table-renderer.coffee.js',
                  'lib/views/*.coffee.js',
                  'lib/collections/*.coffee.js'
              ],
              dest: 'dist/<%= pkg.name %>.test.js'
            }
        },
        min: {
            dist: {
                src: ['<banner:meta.banner>', '<config:concat.dist.dest>'],
                dest: 'dist/<%= pkg.name %>.min.js'
            }
        },
        test: {
            files: ['test/**/*.js']
        },
        lint: {
          files: ['grunt.js', 'lib/**/*.js']
        },
        watch: {
          files: ['lib/**/*.coffee'],
          tasks: 'coffee concat'
        },
        coffee: {
            build: {
                src: ['lib/**/*.coffee'],
                extension: ".coffee.js",
                options: {
                    bare: false
                }
            }
        }
    });

    // Default task.
    grunt.registerTask('default', 'coffee concat min test');

};
