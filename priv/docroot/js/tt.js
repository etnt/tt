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
      'r<-ranking' : {
	'span.name'   : 'r.nick',
        'span.score'  : 'r.score',
	'span.matches': 'r.matches',
	'span.wins'   : 'r.wins',
	'span.losses' : 'r.losses'
      }
    }
  };
  var template = '<tr class="scoreentry">\
	    <td><span class="name"></span></td>\
	    <td><span class="score"></span></td>\
	    <td><span class="matches"></span></td>\
  	    <td><span class="wins"></span></td>\
  	    <td><span class="losses"></span></td>\
  </tr>';
  $('#scoredata').html(template);
  $('#ranking').render(x.data, directive);
  $('tr:even.scoreentry').addClass('even');
  $(".name").click(function() {show_user($(this).text())});
  update_header(x.header);
  update_emsg(x.emsg);
}

// Insert a table into the main area.
function show_ranking () {
  $.getJSON("/users?ranking=true", {}, function (x) {
    var table = '<table id="ranking" class="template">\
		  <thead>\
		    <tr>\
		      <th><span class="name">Name</span></td>\
		      <th><span class="score">Score</span></td>\
		      <th><span class="matches">Matches</span></td>\
	      	      <th><span class="wins">Wins</span></td>\
	      	      <th><span class="losses">Defeats</span></td>\
		    </tr>\
		  </thead>\
		  <tbody id="scoredata">\
		  </tbody>\
		  </table>';
    $('#main').html(table);
    render_ranking(x);
  });
}


/*
 *  M A T C H E S   P A G E
 */

// Show a list of last matches
function show_matches () {
  $.getJSON("/matches", {}, function (x) {
    var table = '<table id="matches" class="template">\
		  <thead>\
		    <tr>\
		      <th><span class="winner">Winner</span></td>\
		      <th><span class="looser">Looser</span></td>\
		      <th><span class="figures">Figures</span></td>\
		      <th><span class="date">Date</span></td>\
		    </tr>\
		  </thead>\
		  <tbody id="matchesdata">\
		  </tbody>\
		  </table>';
    $('#main').html(table);
    render_matches(x);
  });
}

// Fill a table with the matches
function render_matches(x) {
  var directive = {
    'tr.matchentry' : {
      'r<-matches' : {
	'span.winner'  : 'r.winner',
	'span.looser'  : 'r.looser',
	'span.figures' : 'r.figures',
	'span.date'    : 'r.date'
      }
    }
  };
  var template = '<tr class="matchentry">\
	    <td><span class="winner"></span></td>\
	    <td><span class="looser"></span></td>\
	    <td><span class="figures"></span></td>\
	    <td><span class="date"></span></td>\
	      </tr>';
  $('#matchesdata').html(template);
  $('#matches').render(x.data, directive);
  $('tr:even.matchentry').addClass('even');
  update_header(x.header);
  update_emsg(x.emsg);
}


/*
 *  U S E R   P A G E
 */
function render_user(x) {
  var date = x.data.created_tz.split("T");
  var user_info = "<p>Nick: " + x.data.nick + "</p>"
		    + "<p>Score: " + x.data.score + "</p>"
		    + "<p>Registered: " + date[0] + "</p>";
  $('#main').html(user_info);
  update_header(x.header);
  update_emsg(x.emsg);
}

function show_user(user) {
  $.getJSON("/users/" + user, {}, function (x) {
    render_user(x);
  });
}


/*
 *  N E W  M A T C H   P A G E
 */

// Register the score of the match
function register_score (args) {
  $.ajax({
	   url: "matches",
	   type: "POST",
	   data: args,
	   success: function () {
	     update_header("Match successfuly registered.");
	   },
	   error: function () {
	     alert("An error happened.");
	   }});
}

// Display a new match form.
function render_new_match (x) {
  var directive = {
    'option.users' : {
      'u<-users' : {
	'.' : 'u.nick',
	'@value' : 'u.nick'
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
    update_header('Add a match');

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

function show_new_match () {
  $.getJSON("users", {}, function (x) {
	    render_new_match(x);
  });
}


/*
 *  S I G N   U P   P A G E
 */

// Sign up the new user
function sign_up (args) {
  $.ajax({
	   url: "users",
	   type: "POST",
	   data: args,
	   success: function () {
	     update_header("Your nick has been successfuly registered.");
	   },
	   error: function () {
	     alert("Nick already used. Please try a new one.");
	     }});
}

function show_signup() {
  var form =
    '<form id="signform">\
      <div>\
	<label for="nick">Nick:</label>\
	<input type="text" id="nick" name="nick" />\
      </div>\
      <div class="submit">\
        <input type="submit" name="g" value="Submit" id="g" />\
      </div>\
    </form>';
  $('#main').html(form);
  update_header('Create a new user');

  // Setup the Submit button to do some simple sanity
  // checks the nick and then submit the data!
  $('#signform').submit(function () {
    var nick = $('#nick').val();
    if (nick.length > 0) {
      if (/^[a-zA-Z]+[a-zA-Z0-9]*$/.test(nick))
	sign_up($('#signform').serialize());
      else alert("'Nick' has wrong format!");
    }
    else alert("'Nick' has wrong format!");
    return false;
  });

  // Show the form
  $('#signform').show();
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
  $("#nnewmatch").click(function() {show_new_match()});
  $("#nmatches").click(function() {show_matches()});
  $("#nsign").click(function() {show_signup()});
  $("#nabout").click(function() {show_about()});
}

// Do stuff at page load.
$(function () {
    show_ranking();
    setup_navbar();
})
