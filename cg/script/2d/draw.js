var canvas   = document.getElementById("mainCanvas");
var context = canvas.getContext('2d');

// var defineColor = document.getElementById("defineColor");
// var color = "#000000";

var action    = new Action();
var elements  = [];
var temporary = [];

var btnLine      = document.getElementById("btnLine");
var btnTriangle  = document.getElementById("btnTriangle");
var btnSquare    = document.getElementById("btnSquare");
var btnCircle    = document.getElementById("btnCircle");
var btnClean     = document.getElementById("btnClean");
var btnTranslate = document.getElementById("btnTranslate");
var btnRotate    = document.getElementById("btnRotate");
var btnScale     = document.getElementById("btnScale");
var btnZoom      = document.getElementById("btnZoom");
var btnZExtend   = document.getElementById("btnZExtend");

var input        = document.getElementById("inputCMD");

/* element: line */
btnLine.addEventListener("click", function (evt) {
  drawLine();
});

/* element: triangle */
btnTriangle.addEventListener("click", function (evt) {
  drawTriangle();
});

/* element: square */
btnSquare.addEventListener("click", function (evt) {
  drawSquare();
});

/* element: circle */
btnCircle.addEventListener("click", function (evt) {
  drawCircle();
});

/* action: clear */
btnClean.addEventListener("click", function (evt) {
  doClear();
});

/* action: translate */
btnTranslate.addEventListener("click", function(evt) {
  doTranslate();
});

/* action: rotate */
btnRotate.addEventListener("click", function(evt) {
  doRotate();
});

/* action: scale */
btnScale.addEventListener('click', function(evt) {
  doScale();
});

/* action: zoom */
btnZoom.addEventListener('click', function(evt) {
  doZoom();
});

/* action: zoom extend */
btnZExtend.addEventListener('click', function(evt) {
  doZoomExtend();
});

canvas.addEventListener("click", function (evt) {
  var mousePos = getMousePos(canvas, evt);
  var p = new Point(mousePos.x, mousePos.y);
  p.x = Math.trunc(p.x);
  p.y = Math.trunc(p.y);
  addPoint(p);
});

canvas.addEventListener("mousemove", function (evt) {
  var mousePos = getMousePos(canvas, evt);
  refreshPoint(mousePos);
});

canvas.addEventListener("mousemove", function (evt) {
  update(evt);
});

function drawLine() {
  action.type = DRAW_LINE;
  cleanPoints(action);
  deselectAll();
  addMsgCMD("> elemento RETA selecionado: para desenhar informe dois pontos");
}

function drawTriangle() {
  action.type = DRAW_TRIANGLE;
  addMsgCMD("> elemento TRIÂNGULO selecionado: para desenhar informe três pontos");
  cleanPoints(action);
  deselectAll();
}

function drawSquare() {
  action.type = DRAW_SQUARE;
  addMsgCMD("> elemento RETÂNGULO selecionado: para desenhar informe dois pontos");
  cleanPoints(action);
  deselectAll();
}

function drawCircle() {
  action.type = DRAW_CIRCLE;
  addMsgCMD("> elemento CÍRCULO selecionado: para desenhar informe dois pontos");
  cleanPoints(action);
  deselectAll();
}

function doClear() {
  addMsgCMD("> limpando o canvas...");
  cleanAll();
  cleanElements();
}

function doTranslate() {
  action.type = DO_TRANSLATE;
  action.level = 1;
  addMsgCMD("> operação TRANSLAÇÃO ativada: selecione o(s) objeto(s) definindo uma janela de seleção");
  cleanPoints(action);
  deselectAll();
}

function doRotate() {
  action.type = DO_ROTATE;
  action.level = 1;
  addMsgCMD("> operação ROTAÇÃO ativada: selecione o(s) objeto(s) definindo uma janela de seleção");
  cleanPoints(action);
  deselectAll();
}

function doScale() {
  action.type = DO_SCALE;
  action.level = 1;
  addMsgCMD("> operação ESCALA ativada: selecione o(s) objeto(s) definindo uma janela de seleção");
  cleanPoints(action);
  deselectAll();
}

function doZoom() {
  action.type = DO_ZOOM;
  action.level = 1;
  addMsgCMD("> operação ZOOM ativado: defina a janela de zoom");
  cleanPoints(action);
  deselectAll();
}

function doZoomExtend() {
  zoomExtend();
  addMsgCMD("> operação ZOOM EXTEND executada...");
}

function addPoint(p) {
  if(action.type > 0) {
    addMsgCMD("> ponto ("+p.x+","+p.y+") selecionado");
    action.points.push(p);
    draw();
  }
}

function update(evt) {
  var mousePos = getMousePos(canvas, evt);
  mousePos.x = Math.trunc(mousePos.x);
  mousePos.y = Math.trunc(mousePos.y);
  cleanAll();
  drawAll(elements);
  switch(action.type) {
    case DRAW_LINE:
      if(action.points.length == 1) {
        var pointA = action.points[0];
        addTemporaryLine(context, pointA, mousePos);
      }
      break;
    case DRAW_TRIANGLE:
      if(action.points.length === 1) {
        var pointA = action.points[0];
        addTemporaryLine(context, pointA, mousePos);
      }
      if(action.points.length === 2) {
        var pointA = action.points[0];
        var pointB = action.points[1];
        addTemporaryLine(context, pointA, pointB);
        addTemporaryLine(context, pointA, mousePos);
        addTemporaryLine(context, pointB, mousePos);
      }
      break;
    case DRAW_SQUARE:
      if(action.points.length === 1) {
        var pointA = action.points[0];
        addTemporarySquare(context, pointA, mousePos);
      }
      break;
    case DRAW_CIRCLE:
      if(action.points.length === 1) {
        var pointA = action.points[0];
        addTemporaryCircle(context, pointA, mousePos);
      }
      break;
    case DO_TRANSLATE:
      if(action.points.length === 1 && action.level === 1) {
        var pointA = action.points[0];
        drawWindow(pointA, mousePos);
      }else if(action.points.length === 1 && action.level === 2) {
        var dx = mousePos.x - action.points[0].x;
        var dy = mousePos.y - action.points[0].y;
        refreshDxDy(dx, dy);
        for(var i = 0; i < temporary.length; i++) {
            if(temporary[i].isSelected()) {
              temporary[i].translate(dx, dy);
            }
        }
        cleanAll();
        drawAll(temporary);
        updateTemporary();
      }
      break;
    case DO_ROTATE:
      if(action.points.length === 1 && action.level === 1) {
        var pointA = action.points[0];
        drawWindow(pointA, mousePos);
      }else if(action.points.length === 1 && action.level === 2) {
        // var pointA = action.points[1];    //ponto de referência
        var pointB = action.points[0];    //ponto de rotação
        var pointC = mousePos;            //mouse
        var angle = Math.atan2(pointC.y - pointB.y, pointC.x - pointB.x);
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);
        refreshAngle(cos, sin, angle * 180 / Math.PI);
        for(var i = 0; i < temporary.length; i++) {
          if(temporary[i].isSelected()) {
            temporary[i].rotate(cos, sin, pointB);
          }
        }
        cleanAll();
        drawAll(temporary);
        updateTemporary();
      }
      break;
    case DO_SCALE:
      if(action.points.length === 1 && action.level === 1) {
        var pointA = action.points[0];
        drawWindow(pointA, mousePos);
      }else if(action.points.length === 1 && action.level === 2) {
        var pointA = action.points[0];
        var sx = pointA.x - mousePos.x;
        var sy = pointA.y - mousePos.y;
        sx = sx/50;
        sy = sy/50;
        refreshSxSy(sx, sy);
        for(var i = 0; i < temporary.length; i++) {
            if(temporary[i].isSelected()) {
              temporary[i].scale(sx, sy, pointA);
            }
        }
        cleanAll();
        drawAll(temporary);
        updateTemporary();
      }
      break;
    case DO_ZOOM:
      if(action.points.length === 1 && action.level === 1) {
        var pointA = action.points[0];
        drawWindow(pointA, mousePos);
      }
      break;
  }
}

function draw() {
  switch(action.type) {
    case DRAW_LINE:
      if(action.points.length === 2) {
        var pointA = new Point(action.points[0].x, action.points[0].y);
        var pointB = new Point(action.points[1].x, action.points[1].y);
        var line = new Line(pointA, pointB);
        elements.push(line);
        cleanAll();
        drawAll(elements);
        cleanPoints(action);
        addMsgCMD("> desenhando a reta...");
      }
      break;
    case DRAW_TRIANGLE:
      if(action.points.length === 3) {
        var pointA = new Point(action.points[0].x, action.points[0].y);
        var pointB = new Point(action.points[1].x, action.points[1].y);
        var pointC = new Point(action.points[2].x, action.points[2].y);
        var triangle = new Triangle(pointA, pointB, pointC);
        elements.push(triangle);
        cleanAll();
        cleanPoints(action);
        drawAll(elements);
        addMsgCMD("> desenhando o triângulo...");
      }
      break;
    case DRAW_SQUARE:
      if(action.points.length === 2) {
        var pointA = new Point(action.points[0].x, action.points[0].y);
        var pointB = new Point(action.points[1].x, action.points[0].y);
        var pointC = new Point(action.points[1].x, action.points[1].y);
        var pointD = new Point(action.points[0].x, action.points[1].y);
        var square = new Square(pointA, pointB, pointC, pointD);
        elements.push(square);
        cleanAll();
        drawAll(elements);
        cleanPoints(action);
        addMsgCMD("> desenhando o retângulo...");
      }
      break;
    case DRAW_CIRCLE:
      if(action.points.length === 2) {
        var pointA = new Point(action.points[0].x, action.points[0].y);
        var pointB = new Point(action.points[1].x, action.points[1].y);
        var radius = Math.max(Math.abs(pointB.x - pointA.x),Math.abs(pointB.y - pointA.y));
        var circle = new Circle(pointA, pointB, radius);
        elements.push(circle);
        cleanAll();
        drawAll(elements);
        cleanPoints(action);
        addMsgCMD("> desenhando o círculo...");
      }
      break;
    case DO_TRANSLATE:
      if(action.points.length === 2 && action.level === 1) {
        selectAction();
        action.level = 2;
        action.points = [];
        updateTemporary();
        addMsgCMD("> janela de seleção definida...");
        addMsgCMD("> informe o ponto de referência");
      }else if(action.points.length === 1 && action.level === 2) {
        addMsgCMD("> informe o ponto de destino");
      }else if(action.points.length === 2 && action.level === 2) {
        var dx = action.points[1].x - action.points[0].x;
        var dy = action.points[1].y - action.points[0].y;
        refreshDxDy(dx, dy);
        if(datail && getSelectedSize(elements) === 1) {
          var index = getIndexFirstSelected(elements);
          var mobjO = elements[index].getMobj();
        }
        for(var i = 0; i < elements.length; i++) {
            if(elements[i].isSelected())
                elements[i].translate(dx, dy);
        }
        if(datail && getSelectedSize(elements) === 1) {
          var mobjN = elements[index].getMobj();
          showTranslate(mobjO, mobjN, dx, dy);
        }
        reset();
        addMsgCMD("> translação executada...");
      }
      break;
    case DO_ROTATE:
      if(action.points.length === 2 && action.level === 1) {
        selectAction();
        action.level = 2;
        action.points = [];
        updateTemporary();
        addMsgCMD("> janela de seleção definida...");
        addMsgCMD("> informe o centro de rotação");
      }else if(action.points.length === 1 && action.level === 2) {
        // addMsgCMD("> informe o ponto de referência para calcular o ângulo desejado ou insira ele (em graus) direto na linha de comando");
        addMsgCMD("> informe o ponto que forma o ângulo de rotação desejado ou insira ele (em graus) direto na linha de comando");
      }else if(action.points.length === 2 && action.level === 2) {
        // var pointA = action.points[1]; //ponto de referência
        var pointB = action.points[0]; //ponto de rotação
        var pointC = action.points[1]; //mouse
        var angle = Math.atan2(pointC.y - pointB.y, pointC.x - pointB.x);
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);
        refreshAngle(cos, sin, angle * 180 / Math.PI);
        if(datail && getSelectedSize(elements) === 1) {
          var index = getIndexFirstSelected(elements);
          var mobjO = elements[index].getMobj();
        }
        for(var i = 0; i < elements.length; i++) {
          if(elements[i].isSelected()) {
            elements[i].rotate(cos, sin, pointB);
          }
        }
        if(datail && getSelectedSize(elements) === 1) {
          var mobjN = elements[index].getMobj();
          showRotate(mobjO, mobjN, angle, pointB);
        }
        reset();
        addMsgCMD("> rotação executada...");
      }
      break;
    case DO_SCALE:
      if(action.points.length === 2 && action.level === 1) {
        selectAction();
        action.level = 2;
        action.points = [];
        updateTemporary();
        addMsgCMD("> janela de seleção definida...");
        addMsgCMD("> informe o ponto de referência");
      }else if(action.points.length === 1 && action.level === 2) {
        addMsgCMD("> informe o ponto, que junto com o ponto de referência, irão formar o Sx e Sy");
      }else if(action.points.length === 2 && action.level === 2) {
        var pointA = action.points[0];
        var pointB = action.points[1];
        var sx = pointA.x - pointB.x;
        var sy = pointA.y - pointB.y;
        sx = sx/50;
        sy = sy/50;
        refreshSxSy(sx, sy);
        if(datail && getSelectedSize(elements) === 1) {
          var index = getIndexFirstSelected(elements);
          var mobjO = elements[index].getMobj();
        }
        for(var i = 0; i < elements.length; i++) {
            if(elements[i].isSelected()) {
              elements[i].scale(sx, sy, pointA);
            }
        }
        if(datail && getSelectedSize(elements) === 1) {
          var mobjN = elements[index].getMobj();
          showScale(mobjO, mobjN, sx, sy, pointA);
        }
        reset();
        addMsgCMD("> mudança de escala executada...");
      }
      break;
    case DO_ZOOM:
      if(action.points.length === 2 && action.level === 1) {
        var pointA = new Point(action.points[0].x, action.points[0].y);
        var pointB = new Point(action.points[1].x, action.points[1].y);
        zoom(pointA, pointB);
        reset();
        addMsgCMD("> zoom executado...");
      }
      break;
  }
}

function drawWindow(pointA, pointB) {
  var width = pointB.x - pointA.x;
  var height = pointB.y - pointA.y;
  context.strokeStyle = "#FFF";
  context.beginPath();
  context.rect(pointA.x, pointA.y, width, height);
  context.stroke();
  context.strokeStyle = "#000";
}

function selectAction() {
  if(action.points.length === 2) {
    cleanAll();
    var pointA = action.points[0];
    var pointB = action.points[1];
    if(pointB.x < pointA.x) {
      var aux = pointA;
      pointA = pointB;
      pointB = aux;
    }
    for(var i = 0; i < elements.length; i++) {
      elements[i].select(pointA, pointB);
    }
    drawAll(elements);
  }
}

function zoom(pointA, pointB) {
  var u = {min: 0, max: W_CANVAS};
  var v = {min: 0, max: H_CANVAS};

  if(pointA.x < pointB.x) {
    var x = {min: pointA.x, max: pointB.x};
  }else {
    var x = {min: pointB.x, max: pointA.x};
  }
  if(pointA.y < pointB.y) {
    var y = {min: pointA.y, max: pointB.y};
  }else {
    var y = {min: pointB.y, max: pointA.y};
  }

  var Rw = (x.max - x.min)/(y.max - y.min);
  var Rv = (u.max - u.min)/(v.max - v.min);
  if(Rw > Rv) {
    v.max = (u.max - u.min)/Rw + v.min;
  }else if(Rw < Rv){
    u.max = Rw*(v.max - v.min) + u.min;
  }
  var sx = (u.max - u.min)/(x.max - x.min);
  var sy = (v.max - v.min)/(y.max - y.min);
  var T1 = [
    [1, 0, -x.min],
    [0, 1, -y.min],
    [0, 0, 1     ]
  ];
  var T2 = [
    [1, 0, u.min],
    [0, 1, v.min],
    [0, 0, 1    ]
  ];
  var S = [
    [sx, 0, 0],
    [0, sy, 0],
    [0, 0 , 1]
  ];
  var Tjv = mm(S, T1);
  Tjv = mm(T2, Tjv);

  for(var i = 0; i < elements.length; i++) {
    elements[i].mm(Tjv);
  }
}

function zoomExtend() {
  var old = 0;
  var u = {min: 0, max: W_CANVAS};
  var v = {min: 0, max: H_CANVAS};

  if(elements.length > 0) {
    var x = {min: elements[0].getSmallerX(), max: elements[0].getGreatherX()};
    var y = {min: elements[0].getSmallerY(), max: elements[0].getGreatherY()};
    for (var i = 1; i < elements.length; i++) {
      if(elements[i].getSmallerX() < x.min) {
        x.min = elements[i].getSmallerX();
      }
      if(elements[i].getSmallerY() < y.min) {
        y.min = elements[i].getSmallerY();
      }
      if(elements[i].getGreatherX() > x.max) {
        x.max = elements[i].getGreatherX();
      }
      if(elements[i].getGreatherY() > y.max) {
        y.max = elements[i].getGreatherY();
      }
    }
    x.max += 50;
    y.max += 50;
    x.min -= 50;
    y.min -= 50;
    var Rw = (x.max - x.min)/(y.max - y.min);
    var Rv = (u.max - u.min)/(v.max - v.min);
    if(Rw > Rv) {
      old = v.max;
      v.max = (u.max - u.min)/Rw + v.min;
    }else if(Rw < Rv){
      old = u.max;
      u.max = Rw*(v.max - v.min) + u.min;
    }
    var sx = (u.max - u.min)/(x.max - x.min);
    var sy = (v.max - v.min)/(y.max - y.min);
    var T1 = [
      [1, 0, -x.min],
      [0, 1, -y.min],
      [0, 0, 1     ]
    ];
    var T2 = [
      [1, 0, u.min],
      [0, 1, v.min],
      [0, 0, 1    ]
    ];
    var S = [
      [sx, 0, 0],
      [0, sy, 0],
      [0, 0 , 1]
    ];
    var Tjv = mm(S, T1);
    Tjv = mm(T2, Tjv);
    for(var i = 0; i < elements.length; i++) {
      elements[i].mm(Tjv);
    }
    if(Rw > Rv) {
      Tv = [
        [1, 0, 0                 ],
        [0, 1, (old - v.max)/2   ],
        [0, 0, 1                 ]
      ];
      for(var i = 0; i < elements.length; i++) {
        elements[i].mm(Tv);
      }
    }else if(Rw < Rv){
      Tv = [
        [1, 0, (old - u.max)/2   ],
        [0, 1, 0                 ],
        [0, 0, 1                 ]
      ];
      for(var i = 0; i < elements.length; i++) {
        elements[i].mm(Tv);
      }
    }
    cleanAll();
    drawAll(elements);
  }
}

function drawPointsExtra() {
  switch (action.type) {
    case DO_ROTATE:
      if(action.level > 1) {
        if(action.points.length >= 1) {
          action.points[0].draw(context);
        }
      }
    break;
  }
}

function getIndexFirstSelected(e) {
  var index;
  for(var i = 0; i < e.length; i++) {
    if(elements[i].isSelected()) {
      return i;
    }
  }
}

/* linha de comando */
input.addEventListener("keypress", function(e) {
  if(e.which == 13) {
    var command = input.value;
    var c = command.split(',');
    if(command === "reta") {
      drawLine();
    }else if(command === "triangulo") {
      drawTriangle();
    }else if(command === "retangulo") {
      drawSquare();
    }else if(command === "circulo") {
      drawCircle();
    }else if(command === "translacao") {
      doTranslate();
    }else if(command === "rotacao") {
      doRotate();
    }else if(command === "escala") {
      doScale();
    }else if(command === "zoom") {
      doZoom();
    }else if(command === "zextend") {
      doZoomExtend();
    }else if(c.length > 1) {
      var x = parseFloat(c[0]);
      var y = parseFloat(c[1]);
      if(!isNaN(x) && !isNaN(y)) {
        var p = new Point(x, y);
        addPoint(p);
      }else {
        addMsgCMD("> ponto inválido");
      }
    }else if(!isNaN(parseFloat(command))) {
      if(action.type === DO_ROTATE && action.points.length === 1) {
        var angle = parseFloat(command) * (Math.PI/180);
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);
        for(var i = 0; i < elements.length; i++) {
          if(elements[i].isSelected()) {
            elements[i].rotate(cos, sin, action.points[0]);
          }
        }
        reset();
      }
    }else if(command === "ajuda") {
      addMsgCMD("> os comandos válidos são:<br/>" +
                "&emsp;&emsp;<span style=\"color: #DB7093\">reta:</span> seleciona o elemento reta;<br/>" +
                "&emsp;&emsp;<span style=\"color: #DB7093\">triangulo:</span> seleciona o elemento triângulo;<br/>" +
                "&emsp;&emsp;<span style=\"color: #DB7093\">retangulo:</span> seleciona o elemento retângulo;<br/>" +
                "&emsp;&emsp;<span style=\"color: #DB7093\">circulo:</span> seleciona o elemento círculo;<br/>" +
                "&emsp;&emsp;<span style=\"color: #DB7093\">translacao:</span> seleciona a operação translação;<br/>" +
                "&emsp;&emsp;<span style=\"color: #DB7093\">rotacao:</span> seleciona a operação rotação;<br/>" +
                "&emsp;&emsp;<span style=\"color: #DB7093\">escala:</span> seleciona a operação escala;<br/>"+
                "&emsp;&emsp;<span style=\"color: #DB7093\">zoom:</span> seleciona a operação zoom;<br/>" +
                "&emsp;&emsp;<span style=\"color: #DB7093\">zextend:</span> seleciona a operação zoom extend;<br/>" +
                "&emsp;&emsp;<span style=\"color: #DB7093\">ajuda:</span> exibe essa mensagem;<br/>" +
                "&emsp;&emsp;<span style=\"color: #DB7093\">clear:</span> limpa o canvas;<br/>" +
                "&emsp;&emsp;<span style=\"color: #DB7093\">x,y:</span> informa um ponto de coordena x e y;<br/>" +
                "&emsp;&emsp;<span style=\"color: #DB7093\">x:</span> durante a rotação, informa ângulo igual a x;");
    }else if(command === "clear") {
      doClear();
    }else {
      addMsgCMD("> comando inválido: use o comando \"ajuda\" ou acesse a opçao Ajuda no menu");
    }
    input.value = '';
  }
});

function cleanElements() {
  elements = [];
}

function updateTemporary() {
  temporary = [];
  for(var i = 0; i < elements.length; i++) {
    temporary.push(elements[i].clone());
  }
}

function deselectAll() {
  for(var i = 0; i < elements.length; i++) {
    elements[i].deselect();
  }
  cleanAll();
  drawAll(elements);
}

function drawAll(e) {
  for(var i = 0; i < e.length; i++) {
    e[i].draw(context);
  }
  drawPointsExtra();
}

function cleanAll() {
  context.clearRect(0, 0, canvas.width, canvas.height);
}

function cleanPoints() {
  action.points = [];
}

function reset() {
  action.type = 0;
  cleanPoints();
  deselectAll();
  updateTemporary();
}
