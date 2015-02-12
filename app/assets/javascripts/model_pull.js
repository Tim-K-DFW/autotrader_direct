$(document).on('change', '#search_make', function(){
  $.ajax({
    type: 'POST',
    url: '/models',
    data: {make: $('#search_make').val()}});
});

$(document).on('ready', function(){
  if ($('#search_make').length)
  {
    $.ajax({
      type: 'POST',
      url: '/models',
      data: {make: $('#search_make').val()}});
  };
});