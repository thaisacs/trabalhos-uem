function Point(x, y) {
  this.x = x;
  this.y = y;

  this.translate = function(dx, dy) {
    var Mobj = [
      [this.x],
      [this.y],
      [1     ]
    ]
    var Txy = [
      [1, 0, dx],
      [0, 1, dy],
      [0, 0, 1 ]
    ]
    var new_Mobj = mm(Txy, Mobj);
    this.x = new_Mobj[0][0];
    this.y = new_Mobj[1][0];
  }

  this.rotate = function(cos, sen, point) {
    this.translate(-point.x, -point.y);
    var Rt = [
      [cos, -sen, 0],
      [sen,  cos, 0],
      [0,    0,   1]
    ];
    var Mobj = [
      [this.x],
      [this.y],
      [1     ]
    ]
    new_Mobj = mm(Rt, Mobj);
    this.x = new_Mobj[0][0];
    this.y = new_Mobj[1][0];
    this.translate(point.x, point.y);
  }

  this.draw = function(context, selected) {
    if(selected) {
      context.fillStyle = "#DB7093";
      context.StrokeStyle = "#DB7093";
    }
    context.beginPath();
    context.arc(this.x, this.y, 2, 0, 2*Math.PI);
    context.fill()
    context.stroke();
    if(selected) {
      context.fillStyle = "#000";
      context.strokeStyle = "#000";
    }
  }
}

function Line(pointA, pointB) {
  this.pointA = pointA;
  this.pointB = pointB;
  this.selected = false;

  this.draw = function(context) {
    if(this.isSelected())
      context.strokeStyle = "#DB7093";
    context.beginPath();
    context.moveTo(this.pointA.x, this.pointA.y);
    context.lineTo(this.pointB.x, this.pointB.y);
    context.stroke();
    if(this.isSelected())
      context.strokeStyle = "#000";
    this.pointA.draw(context, this.selected);
    this.pointB.draw(context, this.selected);
  };

  this.isSelected = function() {
    return this.selected;
  };

  this.select = function(pointA, pointB) {
    if(pointB.x < pointA.x) {
      var aux = pointA;
      pointA = pointB;
      pointB = aux;
    }
    if((this.pointA.x >= pointA.x) && (this.pointA.x <= pointB.x) &&
       (this.pointB.x >= pointA.x) && (this.pointB.x <= pointB.x)) {
         this.selected = true;
    }
    if(pointB.y < pointA.y) {
      var aux = pointA;
      pointA = pointB;
      pointB = aux;
    }
    if((this.pointA.y >= pointA.y) && (this.pointA.y <= pointB.y) &&
       (this.pointB.y >= pointA.y) && (this.pointB.y <= pointB.y) &&
       this.selected) {
         this.selected = true;
    }else {
      this.selected = false;
    }
  }

  this.deselect = function() {
    this.selected = false;
  }

  this.clone = function() {
    var pointA = new Point(this.pointA.x, this.pointA.y);
    var pointB = new Point(this.pointB.x, this.pointB.y);
    var element = new Line(pointA, pointB);
    if(this.selected)
      element.selected = true;
    return element;
  }

  this.translate = function (dx, dy) {
    var Mobj = this.getMobj();
    var Txy = [
      [1, 0, dx],
      [0, 1, dy],
      [0, 0, 1 ]
    ]
    var new_Mobj = mm(Txy, Mobj);
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
  }

  this.rotate = function(cos, sen, point) {
    this.translate(-point.x, -point.y);
    var Rt = [
      [cos, -sen, 0],
      [sen,  cos, 0],
      [0,    0,   1]
    ];
    var Mobj = this.getMobj();
    new_Mobj = mm(Rt, Mobj)
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
    this.translate(point.x, point.y);
  }

  this.scale = function(sx, sy, point) {
    var dx = point.x;
    var dy = point.y;
    this.translate(-dx, -dy);
    var Mobj = this.getMobj();
    var Sxy = [
      [sx, 0, 0],
      [0, sy, 0],
      [0, 0,  1]
    ]
    var new_Mobj = mm(Sxy, Mobj);
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
    this.translate(dx, dy);
  }

  this.mm = function(Tvj) {
    var Mobj = [
      [this.pointA.x, this.pointB.x],
      [this.pointA.y, this.pointB.y],
      [1,             1            ]
    ]
    var new_Mobj = mm(Tvj, Mobj);
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
  }

  this.getSmallerX = function() {
    var x = this.pointA.x;
    if(this.pointB.x < x)
      x = this.pointB.x;
    return x;
  }

  this.getSmallerY = function() {
    var y = this.pointA.y;
    if(this.pointB.y < y)
      y = this.pointB.y;
    return y;
  }

  this.getGreatherX = function() {
    var x = this.pointA.x;
    if(this.pointB.x > x)
      x = this.pointB.x;
    return x;
  }

  this.getGreatherY = function() {
    var y = this.pointA.y;
    if(this.pointB.y > y)
      y = this.pointB.y;
    return y;
  }

  this.getMobj = function() {
    var Mobj = [
      [this.pointA.x, this.pointB.x],
      [this.pointA.y, this.pointB.y],
      [1,             1            ]
    ]
    return Mobj;
  }
}

function Triangle(pointA, pointB, pointC) {
  this.pointA = pointA;
  this.pointB = pointB;
  this.pointC = pointC;
  this.selected = false;

  this.draw = function(context) {
    if(this.isSelected())
      context.strokeStyle = "#DB7093";
    context.beginPath();
    context.moveTo(this.pointA.x, this.pointA.y);
    context.lineTo(this.pointB.x, this.pointB.y);
    context.lineTo(this.pointC.x, this.pointC.y);
    context.lineTo(this.pointA.x, this.pointA.y);
    context.stroke();
    if(this.isSelected())
      context.strokeStyle = "#000";
    this.pointA.draw(context, this.selected);
    this.pointB.draw(context, this.selected);
    this.pointC.draw(context, this.selected);
  };

  this.isSelected = function() {
    return this.selected;
  }

  this.select = function(pointA, pointB) {
    if(pointB.x < pointA.x) {
      var aux = pointA;
      pointA = pointB;
      pointB = aux;
    }
    if((this.pointA.x >= pointA.x) && (this.pointA.x <= pointB.x) &&
       (this.pointB.x >= pointA.x) && (this.pointB.x <= pointB.x) &&
       (this.pointC.x >= pointA.x) && (this.pointC.x <= pointB.x)) {
         this.selected = true;
    }
    if(pointB.y < pointA.y) {
      var aux = pointA;
      pointA = pointB;
      pointB = aux;
    }
    if((this.pointA.y >= pointA.y) && (this.pointA.y <= pointB.y) &&
       (this.pointB.y >= pointA.y) && (this.pointB.y <= pointB.y) &&
       (this.pointC.y >= pointA.y) && (this.pointC.y <= pointB.y) &&
       this.selected) {
         this.selected = true;
    }else {
      this.selected = false;
    }
  }

  this.deselect = function() {
    this.selected = false;
  }

  this.clone = function() {
    var pointA = new Point(this.pointA.x, this.pointA.y);
    var pointB = new Point(this.pointB.x, this.pointB.y);
    var pointC = new Point(this.pointC.x, this.pointC.y);
    var element = new Triangle(pointA, pointB, pointC);
    if(this.selected)
      element.selected = true;
    return element;
  }

  this.translate = function (dx, dy) {
    var Mobj = this.getMobj();
    var Txy = [
      [1, 0, dx],
      [0, 1, dy],
      [0, 0, 1 ]
    ]
    var new_Mobj = mm(Txy, Mobj);
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
    this.pointC.x = new_Mobj[0][2];
    this.pointC.y = new_Mobj[1][2];
  }

  this.rotate = function(cos, sen, point) {
    this.translate(-point.x, -point.y);
    var Rt = [
      [cos, -sen, 0],
      [sen,  cos, 0],
      [0,    0,   1]
    ];
    var Mobj = this.getMobj();
    new_Mobj = mm(Rt, Mobj)
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
    this.pointC.x = new_Mobj[0][2];
    this.pointC.y = new_Mobj[1][2];
    this.translate(point.x, point.y);
  }
  this.scale = function(sx, sy, point) {
    var dx = point.x;
    var dy = point.y;
    this.translate(-dx, -dy);
    var Mobj = this.getMobj();
    var Sxy = [
      [sx, 0, 0],
      [0, sy, 0],
      [0, 0,  1]
    ]
    var new_Mobj = mm(Sxy, Mobj);
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
    this.pointC.x = new_Mobj[0][2];
    this.pointC.y = new_Mobj[1][2];
    this.translate(dx, dy);
  }

  this.mm = function(Tvj) {
    var Mobj = this.getMobj();
    var new_Mobj = mm(Tvj, Mobj);
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
    this.pointC.x = new_Mobj[0][2];
    this.pointC.y = new_Mobj[1][2];
  }

  this.getSmallerX = function() {
    var x = this.pointA.x;
    if(this.pointB.x < x)
      x = this.pointB.x;
    if(this.pointC.x < x)
      x = this.pointC.x;
    return x;
  }

  this.getSmallerY = function() {
    var y = this.pointA.y;
    if(this.pointB.y < y)
      y = this.pointB.y;
    if(this.pointC.y < y)
      y = this.pointC.y;
    return y;
  }

  this.getGreatherX = function() {
    var x = this.pointA.x;
    if(this.pointB.x > x)
      x = this.pointB.x;
    if(this.pointC.x > x)
      x = this.pointC.x;
    return x;
  }

  this.getGreatherY = function() {
    var y = this.pointA.y;
    if(this.pointB.y > y)
      y = this.pointB.y;
    if(this.pointC.y > y)
      y = this.pointC.y;
    return y;
  }

  this.getMobj = function() {
    var Mobj = [
      [this.pointA.x, this.pointB.x, this.pointC.x],
      [this.pointA.y, this.pointB.y, this.pointC.y],
      [1,             1,             1            ]
    ]
    return Mobj;
  }
}

function Square(pointA, pointB, pointC, pointD) {
  this.pointA = pointA;
  this.pointB = pointB;
  this.pointC = pointC;
  this.pointD = pointD;
  this.selected = false;

  this.draw = function(context) {
    if(this.isSelected())
      context.strokeStyle = "#DB7093";
    context.beginPath();
    context.beginPath();
    context.moveTo(this.pointA.x, this.pointA.y);
    context.lineTo(this.pointB.x, this.pointB.y);
    context.lineTo(this.pointC.x, this.pointC.y);
    context.lineTo(this.pointD.x, this.pointD.y);
    context.lineTo(this.pointA.x, this.pointA.y);
    context.stroke();
    if(this.isSelected())
      context.strokeStyle = "#000";
    this.pointA.draw(context, this.selected);
    this.pointB.draw(context, this.selected);
    this.pointC.draw(context, this.selected);
    this.pointD.draw(context, this.selected);
  };

  this.isSelected = function() {
    return this.selected;
  }

  this.select = function(pointA, pointB) {
    if(pointB.x < pointA.x) {
      var aux = pointA;
      pointA = pointB;
      pointB = aux;
    }
    if((this.pointA.x >= pointA.x) && (this.pointA.x <= pointB.x) &&
       (this.pointB.x >= pointA.x) && (this.pointB.x <= pointB.x)) {
         this.selected = true;
    }
    if(pointB.y < pointA.y) {
      var aux = pointA;
      pointA = pointB;
      pointB = aux;
    }
    if((this.pointA.y >= pointA.y) && (this.pointA.y <= pointB.y) &&
       (this.pointB.y >= pointA.y) && (this.pointB.y <= pointB.y) &&
       this.selected) {
         this.selected = true;
    }else {
      this.selected = false;
    }
  }

  this.deselect = function() {
    this.selected = false;
  }

  this.clone = function() {
    var pointA = new Point(this.pointA.x, this.pointA.y);
    var pointB = new Point(this.pointB.x, this.pointB.y);
    var pointC = new Point(this.pointC.x, this.pointC.y);
    var pointD = new Point(this.pointD.x, this.pointD.y);
    var element = new Square(pointA, pointB, pointC, pointD);
    if(this.selected)
      element.selected = true;
    return element;
  }

  this.translate = function (dx, dy) {
    var Mobj = this.getMobj();
    var Txy = [
      [1, 0, dx],
      [0, 1, dy],
      [0, 0, 1 ]
    ];
    var new_Mobj = mm(Txy, Mobj);
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
    this.pointC.x = new_Mobj[0][2];
    this.pointC.y = new_Mobj[1][2];
    this.pointD.x = new_Mobj[0][3];
    this.pointD.y = new_Mobj[1][3];
  }

  this.rotate = function(cos, sen, point) {
    this.translate(-point.x, -point.y);
    var Rt = [
      [cos, -sen, 0],
      [sen,  cos, 0],
      [0,    0,   1]
    ];
    var Mobj = this.getMobj();
    new_Mobj = mm(Rt, Mobj)
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
    this.pointC.x = new_Mobj[0][2];
    this.pointC.y = new_Mobj[1][2];
    this.pointD.x = new_Mobj[0][3];
    this.pointD.y = new_Mobj[1][3];
    this.translate(point.x, point.y);
  }

  this.scale = function(sx, sy, point) {
    var dx = point.x;
    var dy = point.y;
    this.translate(-dx, -dy);
    var Mobj = this.getMobj();
    var Sxy = [
      [sx, 0, 0],
      [0, sy, 0],
      [0, 0,  1]
    ]
    var new_Mobj = mm(Sxy, Mobj);
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
    this.pointC.x = new_Mobj[0][2];
    this.pointC.y = new_Mobj[1][2];
    this.pointD.x = new_Mobj[0][3];
    this.pointD.y = new_Mobj[1][3];
    this.translate(dx, dy);
  }

  this.mm = function(Tvj) {
    var Mobj = this.getMobj();
    var new_Mobj = mm(Tvj, Mobj);
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
    this.pointC.x = new_Mobj[0][2];
    this.pointC.y = new_Mobj[1][2];
    this.pointD.x = new_Mobj[0][3];
    this.pointD.y = new_Mobj[1][3];
  }

  this.getSmallerX = function() {
    var x = this.pointA.x;
    if(this.pointB.x < x)
      x = this.pointB.x;
    if(this.pointC.x < x)
      x = this.pointC.x;
    if(this.pointD.x < x)
      x = this.pointD.x;
    return x;
  }

  this.getSmallerY = function() {
    var y = this.pointA.y;
    if(this.pointB.y < y)
      y = this.pointB.y;
    if(this.pointC.y < y)
      y = this.pointC.y;
    if(this.pointD.y < y)
      y = this.pointD.y;
    return y;
  }

  this.getGreatherX = function() {
    var x = this.pointA.x;
    if(this.pointB.x > x)
      x = this.pointB.x;
    if(this.pointC.x > x)
      x = this.pointC.x;
    if(this.pointD.x > x)
      x = this.pointD.x;
    return x;
  }

  this.getGreatherY = function() {
    var y = this.pointA.y;
    if(this.pointB.y > y)
      y = this.pointB.y;
    if(this.pointC.y > y)
      y = this.pointC.y;
    if(this.pointD.y > y)
      y = this.pointD.y;
    return y;
  }

  this.getMobj = function() {
    var Mobj = [
      [this.pointA.x, this.pointB.x, this.pointC.x, this.pointD.x],
      [this.pointA.y, this.pointB.y, this.pointC.y, this.pointD.y],
      [1            , 1            , 1            , 1            ]
    ]
    return Mobj;
  }

}

function Circle(pointA, pointB, radius) {
  this.pointA = pointA;
  this.pointB = pointB;
  this.radius =  radius;
  this.selected = false;

  this.draw = function(context) {
    if(this.isSelected())
      context.strokeStyle = "#DB7093";
    context.beginPath();
    context.arc(this.pointA.x, this.pointA.y, this.radius, 0, 2*Math.PI);
    context.stroke();
    if(this.isSelected())
      context.strokeStyle = "#000000";
    this.pointA.draw(context, this.selected);
  };

  this.isSelected = function() {
    return this.selected;
  }

  this.select = function(pointA, pointB) {
    if(pointB.x < pointA.x) {
      var aux = pointA;
      pointA = pointB;
      pointB = aux;
    }
    if((this.pointA.x >= pointA.x) && (this.pointA.x <= pointB.x) &&
       (this.pointB.x >= pointA.x) && (this.pointB.x <= pointB.x)) {
         this.selected = true;
    }
    if(pointB.y < pointA.y) {
      var aux = pointA;
      pointA = pointB;
      pointB = aux;
    }
    if((this.pointA.y >= pointA.y) && (this.pointA.y <= pointB.y) &&
       (this.pointB.y >= pointA.y) && (this.pointB.y <= pointB.y) &&
       this.selected) {
         this.selected = true;
    }else {
      this.selected = false;
    }
  }

  this.deselect = function() {
    this.selected = false;
  }

  this.clone = function() {
    var pointA = new Point(this.pointA.x, this.pointA.y);
    var pointB = new Point(this.pointB.x, this.pointB.y);
    var element = new Circle(pointA, pointB, this.radius);
    if(this.selected)
      element.selected = true;
    return element;
  }

  this.translate = function (dx, dy) {
    var Txy = [
      [1, 0, dx],
      [0, 1, dy],
      [0, 0, 1 ]
    ]
    var Mobj = this.getMobj();
    var new_Mobj = mm(Txy, Mobj);
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
  }

  this.rotate = function(cos, sen, point) {
    this.translate(-point.x, -point.y);
    var Rt = [
      [cos, -sen, 0],
      [sen,  cos, 0],
      [0,    0,   1]
    ];
    var Mobj = this.getMobj();
    new_Mobj = mm(Rt, Mobj)
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
    this.translate(point.x, point.y);
  }

  this.scale = function(sx, sy, point) {
    var dx = point.x;
    var dy = point.y;
    this.translate(-dx, -dy);
    var Mobj = this.getMobj();
    var Sxy = [
      [sx, 0, 0],
      [0, sy, 0],
      [0, 0,  1]
    ]
    var new_Mobj = mm(Sxy, Mobj);
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
    this.translate(dx, dy);
    this.radius =  Math.max(Math.abs(this.pointB.x - this.pointA.x),
    Math.abs(this.pointB.y - this.pointA.y));
  }

  this.mm = function(Tvj) {
    var Mobj = this.getMobj();
    var new_Mobj = mm(Tvj, Mobj);
    this.pointA.x = new_Mobj[0][0];
    this.pointA.y = new_Mobj[1][0];
    this.pointB.x = new_Mobj[0][1];
    this.pointB.y = new_Mobj[1][1];
    this.radius =  Math.max(Math.abs(this.pointB.x - this.pointA.x),
    Math.abs(this.pointB.y - this.pointA.y));
  }

  this.getSmallerX = function() {
    var x = this.pointA.x;
    return (x - this.radius);
  }

  this.getSmallerY = function() {
    var y = this.pointA.y;
    return (y - this.radius);
  }

  this.getGreatherX = function() {
    var x = this.pointA.x;
    return (x + this.radius);
  }

  this.getGreatherY = function() {
    var y = this.pointA.y;
    return (y + this.radius);
  }

  this.getMobj = function() {
    var Mobj = [
      [this.pointA.x, this.pointB.x],
      [this.pointA.y, this.pointB.y],
      [1,             1            ]
    ]
    return Mobj;
  }

}
