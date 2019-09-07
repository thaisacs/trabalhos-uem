var btn2D = document.getElementById('2d');
var btn3D = document.getElementById('3d');

btn2D.addEventListener('click', function(evt) {
  var url = window.location.href;
  window.location.href = url.replace('index', '2d');
});

btn3D.addEventListener('click', function(evt) {
  var url = window.location.href;
  window.location.href = url.replace('index', '3d');
});
