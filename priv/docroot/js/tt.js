var directive = {
  'tr.scoredata' : { //trigger a loop
    'animal<-animals' : { // loop on the property animals in the JSON
      '@class+':function(arg){ // add(+) the return value of the function to the class
      var oddEven, firstLast;
      oddEven = (arg.pos % 2 == 0) ? ' even' : ' odd';
		  firstLast = (arg.pos == 0) ?
          ' first' :
          (arg.pos == arg.animal.items.length - 1) ?
            ' last' :
              '';
		return oddEven + firstLast;
      },
      'span.name':'animal.name',
      'span.score':'animal.score'
    }
  }
};


function render_home() {
  $('#scoreboard').render(data, directive);
  $('#scoreboard').show('slow');
}

$(function () {
    //render_home();

    $.getScript("/data/home", function () {
      render_home();
    });

})
