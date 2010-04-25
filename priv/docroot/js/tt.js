/*
 *    http://bitbucket.org/etnt/tt/
 */

function is_int(value){
  if((parseFloat(value) == parseInt(value)) && !isNaN(parseInt(value))){
      return true;
 } else {
      return false;
 }
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
}

// Insert a table into the main area.
function show_ranking () {
  $.getJSON("/users?ranking=true", {}, function (x) {
    var table = '<h2>RANKING</h2>\
		 <table id="ranking" class="template">\
		  <thead>\
		    <tr>\
		      <th scope="col"><span class="name">Name</span></td>\
		      <th scope="col"><span class="score">Score</span></td>\
		      <th scope="col"><span class="matches">Matches</span></td>\
	      	      <th scope="col"><span class="wins">Wins</span></td>\
	      	      <th scope="col"><span class="losses">Defeats</span></td>\
		    </tr>\
		  </thead>\
		  <tbody id="scoredata">\
		  </tbody>\
		  </table>';
    $('#nranking').html(table);
    render_ranking(x);
  });
}


/*
 *  M A T C H E S   P A G E
 */

// Show a list of last matches
function show_matches () {
  $.getJSON("/matches", {}, function (x) {
    var table = '<h2>LAST MATCHES</h2>\
		  <table id="matches" class="template">\
		  <thead>\
		    <tr>\
		      <th scope="col"><span class="winner">Winner</span></td>\
		      <th scope="col"><span class="looser">Loser</span></td>\
		      <th scope="col"><span class="figs">Figures</span></td>\
		      <th scope="col"><span class="date">Date</span></td>\
		    </tr>\
		  </thead>\
		  <tbody id="matchesdata">\
		  </tbody>\
		  </table>';
    $('#nmatches').html(table);
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
	'span.figs'    : 'r.figures',
	'span.date'    : 'r.date'
      }
    }
  };
  var template = '<tr class="matchentry">\
	    <td><span class="winner"></span></td>\
	    <td><span class="looser"></span></td>\
	    <td><span class="figs"></span></td>\
	    <td><span class="date"></span></td>\
	      </tr>';
  $('#matchesdata').html(template);
  $('#matches').render(x.data, directive);
  $('tr:even.matchentry').addClass('even');
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
	     show_ranking();
	     show_matches();
	     show_new_match();
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
  $('.usersselect').html("<option class=\"users\" value=\"\" ></option>");
  $('#regform').render(x.data, directive);

  // Setup the Submit button to do some simple sanity
  // checks of the figures and then submit the data!
  $('#regform').submit(function () {
    if ($('#winner').val() == $('#looser').val())
      alert("Winner and loser are the same players");
    else {
      var wfigures = $('#wfigures').val();
      var lfigures = $('#lfigures').val();
      if (wfigures.length > 0 && lfigures.length > 0 && is_int(wfigures)
	&& is_int(lfigures) && parseInt(wfigures) > parseInt(lfigures))
	    register_score($('#regform').serialize());
      else alert("'Figures' are not correct");
    }
    return false;
  });
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
	     $('#nick').val("");
	     alert("Good! Start playing!");
	     show_ranking();
	   },
	   error: function () {
	     alert("Nick already used. Please try a new one.");
	   }});
}


// Do stuff at page load.
$(function () {
    // Setup signup form
    $('#signform').submit(function () {
    var nick = $('#nick').val();
    if (nick.length > 2 && nick.length < 10) {
      if (/^[a-zA-Z]+[a-zA-Z0-9]*$/.test(nick))
	sign_up($('#signform').serialize());
      else alert("'Nick' has wrong format!");
    }
    else alert("'Nick' has wrong format! It should have between 3 and 9"
	       + " characters and it should only contain letters and numbers");
    return false;
    });

    show_ranking();
    show_matches();
    show_new_match();
})
