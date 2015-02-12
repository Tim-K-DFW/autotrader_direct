$(document).ready(function(){
  $(document).on('change', '#search_make', function(){
    $.ajax({
      type: 'POST',
      url: '/model',
      data: {make: $('#search_make').val()}});
    return false;
  });
});