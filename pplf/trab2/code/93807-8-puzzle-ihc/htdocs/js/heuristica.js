(function () {
  var tiles = [],
      goal = [];

  var startScreen = document.querySelector("#startScreen");
  startScreen.addEventListener("click", startGame, false);
  var endScreen = document.querySelector("#endScreen");

  /**********
  Solução e initBoard
  **********/
  var initBoard = $(".initBoard").attr('data-value');
  var arrayInitBoard = initBoard.split(" ");

  var indexSolve = 0;
  var solveBoard = $(".solveBoard").attr('data-value');
  var arraySolveBoard = solveBoard.split(" ");
  arraySolveBoard.reverse();

  function setStepSolve(){
    indexSolve++;
    if(arraySolveBoard[indexSolve] == 'UP'){
      $('.showSolve').html("PASSO "+indexSolve+": CIMA");
    }else if(arraySolveBoard[indexSolve] == 'DOWN'){
      $('.showSolve').html("PASSO "+indexSolve+": BAIXO");
    }else if(arraySolveBoard[indexSolve] == 'RIGHT'){
      $('.showSolve').html("PASSO "+indexSolve+": DIREITA");
    }else if(arraySolveBoard[indexSolve] == 'LEFT'){
      $('.showSolve').html("PASSO "+indexSolve+": ESQUERDA");
    }else{
      $('.showSolve').html("FIM!!!");
    }
  }

  function init() {
    for(var i = 1; i < 9; i++){
      var tile = document.querySelector('#n' + i);
      tile.style.background = "url('/../img/n"+i+".png')";
      tile.addEventListener("click", moveTile, false);
      tiles.push(tile);
      goal.push(tile);
    }
    tiles.push(null);
    goal.push(null);
    render();
  }

  function render(){
    for(var i in tiles){
      var tile = tiles[i];
      if(tile != null){
        tile.style.left = (i%3) *100 + 5 + "px";
        if(i < 3){
          tile.style.top = "5px";
        }else if(i < 6){
          tile.style.top = "105px";
        }else{
          tile.style.top = "205px";
        }
      }
    }
  }

  function startGame(){
    /*remove screen start*/
    this.style.opacity = "0";
    this.style.zIndex = "-1";
    this.removeEventListener("click", startGame, false);
    /*coloca o estado init no board*/
    var aux = [];
    aux[0] = tiles[arrayInitBoard[0]-1];
    aux[1] = tiles[arrayInitBoard[1]-1];
    aux[2] = tiles[arrayInitBoard[2]-1];
    aux[3] = tiles[arrayInitBoard[3]-1];
    aux[4] = tiles[arrayInitBoard[4]-1];
    aux[5] = tiles[arrayInitBoard[5]-1];
    aux[6] = tiles[arrayInitBoard[6]-1];
    aux[7] = tiles[arrayInitBoard[7]-1];
    aux[8] = tiles[arrayInitBoard[8]-1];
    tiles = aux;
    render();
    setStepSolve();
  }

  function moveTile(){
    var index = tiles.indexOf(this);
    if(index % 3 !== 0 && arraySolveBoard[indexSolve] === "RIGHT"){
      if(!tiles[index-1]){
        tiles[index-1] = this;
        tiles[index] = null;
        setStepSolve();
      }
    }
    if(index % 3 !== 2 && arraySolveBoard[indexSolve] === "LEFT"){
      if(!tiles[index+1]){
        tiles[index+1] = this;
        tiles[index] = null;
        setStepSolve();
      }
    }
    if(index > 2 && arraySolveBoard[indexSolve] === "DOWN"){
      if(!tiles[index-3]){
        tiles[index-3] = this;
        tiles[index] = null;
        setStepSolve();
      }
    }
    if(index < 6 && arraySolveBoard[indexSolve] === "UP"){
      if(!tiles[index+3]){
        tiles[index+3] = this;
        tiles[index] = null;
        setStepSolve();
      }
    }
    render();
    if(checkGoal()){
      showEndScreen();
    }
  }

  function showEndScreen() {
    endScreen.style.opacity = "1";
    endScreen.style.zIndex = "1";
    setTimeout(function functionName() {
      endScreen.addEventListener("click", goIndex, false);
    })
  }
  
  function goIndex() {
    var url = window.location.href;
    var arrayUrl = url.split("/");
    console.log(arrayUrl);
    window.location="http://"+arrayUrl[2]+"/servlets/standalone.rkt;";
  }

  function setScore(){
    var inputScore = $('.scoreHidden').val();
    inputScore++;
    $('.score').html("SCORE "+inputScore);
    $('.scoreHidden').attr('value', inputScore);
  }

  function checkGoal(){
    for(var i in tiles){
      if(tiles[i] !== goal[i]){
        return false;
      }
    }
    return true;
  }

  init();
}());
