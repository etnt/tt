
function render_scoreboard(x) {
  var directive = {
    'tr.scoredata' : {
      's<-scores' : {
	'span.name'  : 's.name',
        'span.score' : 's.score'
      }
    }
  };
  $('#scoreboard').render(x.data, directive);
  $('tr:even.scoredata').addClass('even');
  $('#header').text(x.header);
  $('#scoreboard').show('slow');
}

$(function () {
    $.getJSON("/data/scores", {}, function (x) {
      render_scoreboard(x);
    });
})
