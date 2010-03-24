
    var directive = {
    'tr' : { //trigger a loop
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
       'td':'animal.name'
       }
     }
    };

    var data = {
      animals:[
        {name:'bird'},
        {name:'cat'},
        {name:'dog'},
        {name:'mouse'}
      ]
    };

$(function () {
    $('table#scoring').render(data, directive);
})
