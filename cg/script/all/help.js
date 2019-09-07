$(document).ready(function(){
  var idModal1 = "#modalHelp1";
  var idModal2 = "#modalHelp2";
  var idModal3 = "#modalHelp3";

  $("#btnHelp").click(function(e) {
    e.preventDefault();
    showModalHelp();
  });

  function showModalHelp() {
    var alturaTela = $(document).height();
    var larguraTela = $(window).width();

    //colocando o fundo preto
    $('#mask').css({'width':larguraTela,'height':alturaTela});
    $('#mask').fadeIn(1000);
    $('#mask').fadeTo("slow",0.8);

    var left = ($(window).width() /2) - ( $(idModal1).width() / 2 );
    var top = ($(window).height() / 2) - ( $(idModal1).height() / 2 );

    $(idModal1).css({'top':top,'left':left});
    $(idModal1).show();
  }

  $("#mask").click( function(){
      $(this).hide();
      $(".window").hide();
  });

  $('.close').click(function(ev){
      ev.preventDefault();
      $("#mask").hide();
      $(".window").hide();
  });

  $("#next").click(function() {
    $(idModal1).hide();
    var left = ($(window).width() /2) - ( $(idModal2).width() / 2 );
    var top = ($(window).height() / 2) - ( $(idModal2).height() / 2 );

    $(idModal2).css({'top':top,'left':left});
    $(idModal2).show();
  });

  $("#next2").click(function() {
    $(idModal2).hide();
    var left = ($(window).width() /2) - ( $(idModal3).width() / 2 );
    var top = ($(window).height() / 2) - ( $(idModal3).height() / 2 );

    $(idModal3).css({'top':top,'left':left});
    $(idModal3).show();
  });

  $("#back").click(function() {
    $(idModal2).hide();
    var left = ($(window).width() /2) - ( $(idModal1).width() / 2 );
    var top = ($(window).height() / 2) - ( $(idModal1).height() / 2 );
    $(idModal1).css({'top':top,'left':left});
    $(idModal1).show();
  });

  $("#back2").click(function() {
    $(idModal3).hide();
    var left = ($(window).width() /2) - ( $(idModal2).width() / 2 );
    var top = ($(window).height() / 2) - ( $(idModal2).height() / 2 );
    $(idModal2).css({'top':top,'left':left});
    $(idModal2).show();
  });
});
