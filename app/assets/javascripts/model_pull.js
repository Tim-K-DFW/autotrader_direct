$(document).on('change', '#search_make', function(){
  $.ajax({
    type: 'POST',
    url: '/models',
    data: {make: $('#search_make').val()}});
});