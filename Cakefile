fs = require 'fs'

{print} = require 'util'
{spawn} = require 'child_process'

build = (callback) ->
    coffee = spawn 'coffee', ['-c', '-o', 'public/js', 'public/js']
    coffee.stderr.on 'data', (data) ->
        process.stderr.write data.toString()
    coffee.stdout.on 'data', (data) ->
        print data.toString()
    coffee.on 'exit', (code) ->
        callback?() if code is 0

watch = (callback) ->
    coffee = spawn 'coffee', ['-w', '-c', '-o', 'public/js', '.']
    coffee.stderr.on 'data', (data) ->
        process.stderr.write data.toString()
    coffee.stdout.on 'data', (data) ->
        print data.toString()
    coffee.on 'exit', (code) ->
        callback?() if code is 0
        
task 'build', ->
    build()

task 'watch', ->
    watch()
