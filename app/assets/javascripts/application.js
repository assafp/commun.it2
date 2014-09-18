$(function() {

  function call_ajax(button) {
    method = $(button).data('method');
    member = $(button).closest('.member');

    $.ajax('/dashboard/'+ method + '/', {
      data: member.data(),
      beforeSend: function() {
        member.hide();
      }}).success(function(data) {
        member.parent().append(data);
    });
  }

  $('.dismiss_button').click(function() {
    call_ajax(this)
  });
});
