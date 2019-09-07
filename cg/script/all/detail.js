var idModal = "#modalDetail";

$("#mask").click( function(){
    $(this).hide();
    $(".windowT").hide();
});

$('.close').click(function(ev){
    ev.preventDefault();
    $("#mask").hide();
    $(".windowT").hide();
});

function showModal() {
  var alturaTela = $(document).height();
  var larguraTela = $(window).width();

  //colocando o fundo preto
  $('#mask').css({'width':larguraTela,'height':alturaTela});
  $('#mask').fadeIn(1000);
  $('#mask').fadeTo("slow",0.8);

  var left = ($(window).width() /2) - ( $(idModal).width() / 2 );
  var top = ($(window).height() / 2) - ( $(idModal).height() / 2 );

  $(idModal).css({'top':top,'left':left});
  $(idModal).show();
}

function showTranslate(mobjO, mobjN, dx, dy) {
  dx = dx.toFixed(2);
  dy = dy.toFixed(2);
  var formula = "$$M\'_{obj} = T("+dx+", "+dy+")M_{obj}$$";
  var op = "\\begin{bmatrix}" +
           " 1 & 0 & " + dx + " \\\\\\" +
           " 0 & 1 & " + dy + " \\\\\\" +
           " 0 & 0 & 1"+
           " \\end{bmatrix}";
  var n_mobjN = "\\begin{bmatrix}";
  for(var i = 0; i < mobjN.length; i++) {
    for(var j = 0; j < mobjN[0].length; j++) {
      if(i === 2) {
        n_mobjN += mobjN[i][j];
      }else {
        n_mobjN += mobjN[i][j].toFixed(2);
      }
      if(j < mobjN[0].length - 1)
        n_mobjN += " & ";
    }
    if(i < mobjN.length - 1)
      n_mobjN += " \\\\\\ ";
  }
  n_mobjN += "\\end{bmatrix}";
  var n_mobjO = "\\begin{bmatrix}";
  for(var i = 0; i < mobjO.length; i++) {
    for(var j = 0; j < mobjO[0].length; j++) {
      if(i === 2) {
        n_mobjO += mobjO[i][j];
      }else {
        n_mobjO += mobjO[i][j].toFixed(2);
      }
      if(j < mobjO[0].length - 1)
        n_mobjO += " & ";
    }
    if(i < mobjO.length - 1)
      n_mobjO += " \\\\\\ ";
  }
  n_mobjO += "\\end{bmatrix}";
  var r = formula + "\\begin{equation}" + op + n_mobjO + "=" + n_mobjN + "\\end{equation}";
  $("#modalTransf").html(r);
  showModal();
  MathJax.Hub.Queue(["Typeset",MathJax.Hub,"modalTransf"]);
}

function showRotate(mobjO, mobjN, angle, point) {
  var dx = (point.x).toFixed(2);
  var dy = (point.y).toFixed(2);
  angle = angle * 180 / Math.PI;
  angle = angle.toFixed(2);
  var formula = "$$M\'_{obj} = T("+dx+", "+dy+")R_{"+angle+"}^0T("+-dx+", "+-dy+")M_{obj}$$";
  var op = "\\begin{bmatrix} \\cos{"+angle+"} & -\\sin{"+angle+"} & 0 \\\\\\ \\sin{"+angle+"} & \\cos{"+angle+"} & 0 \\\\\\ 0 & 0 & 1" +
           " \\end{bmatrix}";
  var n_mobjO = "\\begin{bmatrix}";
  for(var i = 0; i < mobjO.length; i++) {
    for(var j = 0; j < mobjO[0].length; j++) {
      if(i === 2) {
        n_mobjO += mobjO[i][j];
      }else {
        n_mobjO += mobjO[i][j].toFixed(2);
      }
      if(j < mobjO[0].length - 1)
        n_mobjO += " & ";
    }
    if(i < mobjO.length - 1)
      n_mobjO += " \\\\\\ ";
  }
  n_mobjO += "\\end{bmatrix}";
  var n_mobjN = "\\begin{bmatrix}";
  for(var i = 0; i < mobjN.length; i++) {
    for(var j = 0; j < mobjN[0].length; j++) {
      if(i === 2) {
        n_mobjN += mobjN[i][j];
      }else {
        n_mobjN += mobjN[i][j].toFixed(2);
      }
      if(j < mobjN[0].length - 1)
        n_mobjN += " & ";
    }
    if(i < mobjN.length - 1)
      n_mobjN += " \\\\\\ ";
  }
  n_mobjN += "\\end{bmatrix}";
  var t1 = "\\begin{bmatrix} 1 & 0 & " + (-dx).toFixed(2) + " \\\\\\ 0 & 1 & " + (-dy).toFixed(2) + " \\\\\\ 0 & 0 & 1 \\end{bmatrix}";
  var t2 = "\\begin{bmatrix} 1 & 0 & " + dx + " \\\\\\ 0 & 1 & " + dy + " \\\\\\ 0 & 0 & 1 \\end{bmatrix}";
  var r = formula + "\\begin{equation}" + t2 +op + t1 + n_mobjO + "=" + n_mobjN + "\\end{equation}";
  $("#modalTransf").html(r);
  showModal();
  MathJax.Hub.Queue(["Typeset",MathJax.Hub,"modalTransf"]);
}

function showScale(mobjO, mobjN, sx, sy, point) {
  var dx = (point.x).toFixed(2);
  var dy = (point.y).toFixed(2);
  var formula = "$$M\'_{obj} = T("+dx+", "+dy+")S("+sx+","+sy+")T("+-dx+", "+-dy+")M_{obj}$$";
  var op = "\\begin{bmatrix} "+sx+" & 0 & 0 \\\\\\ 0 & "+sy+" & 0 \\\\\\ 0 & 0 & 1 \\end{bmatrix}";
  var n_mobjO = "\\begin{bmatrix}";
  for(var i = 0; i < mobjO.length; i++) {
    for(var j = 0; j < mobjO[0].length; j++) {
      if(i === 2) {
        n_mobjO += mobjO[i][j];
      }else {
        n_mobjO += mobjO[i][j].toFixed(2);
      }
      if(j < mobjO[0].length - 1)
        n_mobjO += " & ";
    }
    if(i < mobjO.length - 1)
      n_mobjO += " \\\\\\ ";
  }
  n_mobjO += "\\end{bmatrix}";
  var n_mobjN = "\\begin{bmatrix}";
  for(var i = 0; i < mobjN.length; i++) {
    for(var j = 0; j < mobjN[0].length; j++) {
      if(i === 2) {
        n_mobjN += mobjN[i][j];
      }else {
        n_mobjN += mobjN[i][j].toFixed(2);
      }
      if(j < mobjN[0].length - 1)
        n_mobjN += " & ";
    }
    if(i < mobjN.length - 1)
      n_mobjN += " \\\\\\ ";
  }
  n_mobjN += "\\end{bmatrix}";
  var t1 = "\\begin{bmatrix} 1 & 0 & " + (-dx).toFixed(2) + " \\\\\\ 0 & 1 & " + (-dy).toFixed(2) + " \\\\\\ 0 & 0 & 1 \\end{bmatrix}";
  var t2 = "\\begin{bmatrix} 1 & 0 & " + dx + " \\\\\\ 0 & 1 & " + dy + " \\\\\\ 0 & 0 & 1 \\end{bmatrix}";
  var r = formula + "\\begin{equation}" + t2 +op + t1 + n_mobjO + "=" + n_mobjN + "\\end{equation}";
  $("#modalTransf").html(r);
  showModal();
  MathJax.Hub.Queue(["Typeset",MathJax.Hub,"modalTransf"]);
}
