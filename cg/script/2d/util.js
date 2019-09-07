function validPointArray(point) {
  if(isNaN(point.x) || isNaN(point.y)) {
    return false;
  }
  return true;
}

function isNumber(val) {
  return typeof val === "number";
}

function getMousePos(canvas, evt) {
  var rect = canvas.getBoundingClientRect();
  return {
      x: evt.clientX - rect.left,
      y: evt.clientY - rect.top
  };
}

function getModule(vetor) {
  m = Math.sqrt(Math.pow(vetor.x, 2) + Math.pow(vetor.y, 2));
  return m;
}

function addMsgCMD(phrase) {
  $("#msgs").append("<p>"+phrase+"</p>");
  jQuery("div#msgs").scrollTop(jQuery("div#msgs")[0].scrollHeight);
}

function mm(A, B) {
  var line = B.length;
  var col  = B[0].length;
  var R = [line];
  for(var i = 0; i < line; i++)
    R[i] = [col];
  for(var k = 0; k < col; k++) {
    for(var i = 0; i < line; i++) {
      var r = 0;
      for(var j = 0; j < line; j++) {
        r += A[i][j] * B[j][k];
      }
      R[i][k] = r;
    }
  }
  return R;
}

function refreshPoint(point) {
  var x = document.getElementById('X');
  var y = document.getElementById('Y');
  x.innerHTML = Math.trunc(point.x);
  y.innerHTML = Math.trunc(point.y);
}

function refreshDxDy(dx, dy) {
  // dx = dx.toFixed(2);
  // dy = dy.toFixed(2);
  var x = document.getElementById('dx');
  var y = document.getElementById('dy');
  x.innerHTML = dx;
  y.innerHTML = dy;
}

function refreshSxSy(sx, sy) {
  sx = sx.toFixed(2);
  sy = sy.toFixed(2);
  var x = document.getElementById('sx');
  var y = document.getElementById('sy');
  x.innerHTML = sx;
  y.innerHTML = sy;
}

function refreshAngle(cos, sin, angulo) {
  cos = cos.toFixed(2);
  sin = sin.toFixed(2);
  var c = document.getElementById('cos');
  var s = document.getElementById('sin');
  var a = document.getElementById('ang');
  angulo = angulo.toFixed(2);
  c.innerHTML = cos;
  s.innerHTML = sin;
  a.innerHTML = angulo;
}

function getSelectedSize(e) {
  var count = 0;
  for(var i = 0; i < e.length; i++) {
    if(e[i].isSelected()) {
      count++;
    }
  }
  return count;
}

function addTemporaryLine(context, pointA, pointB) {
  context.beginPath();
  context.moveTo(pointA.x, pointA.y);
  context.lineTo(pointB.x, pointB.y);
  context.stroke();
  pointA.draw(context, false);
}

function addTemporarySquare(context, pointA, pointB) {
  var pointC = new Point(pointB.x, pointA.y);
  var pointD = new Point(pointA.x, pointB.y);
  context.beginPath();
  context.moveTo(pointA.x, pointA.y);
  context.rect(pointA.x, pointA.y, pointB.x - pointA.x, pointB.y - pointA.y);
  context.stroke();
  pointA.draw(context, false);
  pointC.draw(context, false);
  pointD.draw(context, false);
}

function addTemporaryCircle(context, pointA, pointB) {
  context.beginPath();
  var radius = Math.max(Math.abs(pointB.x - pointA.x),Math.abs(pointB.y - pointA.y));
  context.arc(pointA.x, pointA.y, radius, 0, 2*Math.PI);
  context.stroke();
  pointA.draw(context, false);
}
