/*
 *    http://bitbucket.org/etnt/tt/
 */

// Functions to add text to various parts on the page
function update_header (hdr) {
  if (hdr != "")
    $('#header').text(hdr);
}

function update_emsg (msg) {
  if (msg != "")
    $('#emsg').text(msg);
}

/*
 *  R A N K I N G   S C O R E   P A G E
 */

// Fill a table with ranking scores.
function render_ranking (x) {
  var directive = {
    'tr.scoreentry' : {
      's<-scores' : {
	'span.name'  : 's.nick',
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
  $('#scoreboard').show();
}

// Insert a table into the main area.
function show_ranking () {
  $.getJSON("/data/ranking", {}, function (x) {
    var table = '<table id="ranking" class="template">\
		  <thead>\
		    <tr>\
		      <th><span class="name">Name</span></td>\
		      <th><span class="score">Score</span></td>\
		    </tr>\
		  </thead>\
		  <tbody id="scoredata">\
		  </tbody>\
		  </table>';
    $('#main').html(table);
    render_ranking(x);
  });
}

// Show a ranking table of all players with their scores.
function show_scores () {
  $.getJSON("/data/ranking", {}, function (x) {
    render_ranking(x);
  });
}


/*
 *  R E G I S T E R   S C O R E   P A G E
 */

// Register the score data
function register_score (args) {
  $.getJSON("/data/register?"+args, {}, function (x) {
    update_header(x.header);
    update_emsg(x.emsg);
  });
}


// Display a score registration form.
function render_register (x) {
  var directive = {
    'option.users' : {
      'u<-users' : {
	'.' : 'u.name',
	'@value' : 'u.name'
	  }
    }
  };
  var template =
    '<form id="regform">\
      <div>\
	<table id="regtable">\
	  <thead>\
	    <tr>\
	      <th>Winner</th>\
	      <th>&nbsp;</th>\
	      <th>Looser</th>\
	    </tr>\
	  </thead>\
	  <tbody>\
	    <tr>\
	      <td>\
		<select id="winner" name="winner">\
		  <option class="users" value="" ></option>\
		</select>\
	      </td>\
	      <td><span class="mdash">&mdash;</span></td>\
	      <td>\
		<select name="looser">\
		  <option class="users" value="" ></option>\
		</select>\
	      </td>\
	    </tr>\
	  </tbody>\
	</table>\
      <div>\
	<label for="figures">Figures:</label>\
	<input type="text" id="figures" name="figures" />\
      </div>\
      <div class="submit">\
        <input type="submit" name="g" value="Submit" id="g" />\
      </div>\
    </form>';

    // Populate the DOM with the template
    $('#main').html(template);
    // Populate the template with the data
    $('#regform').render(x.data, directive);
    // Update other parts of the page
    update_header(x.header);
    update_emsg(x.emsg);

    // Setup the Submit button to do some simple sanity
    // checks of the figures and then submit the data!
    $('#regform').submit(function () {
      var figures = $('#figures').val();
      if (figures.length > 0) {
	if (/^(([0-9]|[1][0-1])-([0-9]|[1][0-1]))+(,([0-9]|[1][0-1])-([0-9]|[1][0-1]))*$/.test(figures))
	  register_score($('#regform').serialize());
	else
	  alert("'Figures' has wrong format!");
      }
      else
	register_score($('#regform').serialize());

      return false;
    });

    // Show the form
    $('#regform').show();
}

function show_register () {
  $.getJSON("/data/users", {}, function (x) {
    render_register(x);
  });
}


/*
 *  A B O U T  P A G E
 */

function show_about () {
    var about = '<p>This a Table Tennis Score system to keep track of '
		  + 'the amazing games that are played every day at Klarna!</p>';
    update_header('About');
    update_emsg('');
    $('#main').html(about);
}


/*
 *  I N I T A L I S A T I O N   A T   P A G E   L O A D
 */

// Setup the actions of the navigation bar.
function setup_navbar () {
  $("#nranking").click(function() {show_ranking()});
  $("#nregister").click(function() {show_register()});
  $("#nscores").click(function() {show_scores()});
  $("#nabout").click(function() {show_about()});
}

// Do stuff at page load.
$(function () {
    show_ranking();
    setup_navbar();
})
