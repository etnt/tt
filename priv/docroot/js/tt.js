
function update_header (hdr) {
  if (hdr != "")
    $('#header').text(hdr);
}

function update_emsg (msg) {
  if (msg != "")
    $('#emsg').text(msg);
}

function render_ranking (x) {
  var directive = {
    'tr.scoreentry' : {
      's<-scores' : {
	'span.name'  : 's.name',
        'span.score' : 's.score'
      }
    }
  };
  var template = '<tr class="scoreentry">\
	    <td><span class="name"></span></td>\
	    <td><span class="score"></span></td>\
  </tr>';
  $('#scoredata').html(template);
  $('#ranking').render(x.data, directive);
  $('tr:even.scoreentry').addClass('even');
  update_header(x.header);
  update_emsg(x.emsg);
  $('#scoreboard').show('slow');
}

function show_ranking () {
  $.getJSON("/data/ranking", {}, function (x) {
    render_ranking(x);
  });
}

function setup_navbar () {
  $("#nranking").click(function() {show_ranking()});
  $("#nregister").click(function() {show_register()});
  $("#nscores").click(function() {show_scores()});
  $("#nabout").click(function() {show_about()});
}

$(function () {
    show_ranking();
    setup_navbar();
})
