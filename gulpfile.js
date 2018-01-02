'use strict';

var gulp = require('gulp');
var shell = require('gulp-shell');

var commands = {
  kill_player : 'pkill flashplayer*',
  launch_player : 'lime test flash -debug'
}

gulp.task('kill_player', shell.task(commands.kill_player, {ignoreErrors: true}));

gulp.task('launch_flash', shell.task(commands.launch_player, {ignoreErrors: true}));

gulp.task('default', gulp.series('kill_player', 'launch_flash'));

gulp.task('watch:files', function () {
  gulp.watch([
    'source/**/*.*',
    'assets/**/*.*'
  ], gulp.task('default'));
});

gulp.task('watch', gulp.task('watch:files'));