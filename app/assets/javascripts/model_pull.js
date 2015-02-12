$(document).on('change', '#search_make', function(){
  $.ajax({
    type: 'POST',
    url: '/models',
    data: {make: $('#search_make').val()}});
});

$(document).on('ready', function(){
  $.ajax({
    type: 'POST',
    url: '/models',
    data: {make: $('#search_make').val()}});
});