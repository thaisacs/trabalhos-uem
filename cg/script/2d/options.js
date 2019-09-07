/* tasks */
let NO_OP         = 0;
let DRAW_LINE     = 1;
let DRAW_TRIANGLE = 2;
let DRAW_SQUARE   = 3;
let DRAW_CIRCLE   = 4;
let DO_TRANSLATE  = 5;
let DO_ROTATE     = 6;
let DO_SCALE      = 7;
let DO_ZEXTEND    = 8;
let DO_ZOOM       = 9;
/* canvas info */
let W_CANVAS = 900;
let H_CANVAS = 560;
/* datail option */
let datail = false;
var d = document.querySelector("input[id=datail]");
d.addEventListener('click', function(evt) {
  datail = !datail;
});
