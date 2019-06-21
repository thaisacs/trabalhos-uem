(function () {
  var tiles = [],
      goal = [];

  var startScreen = document.querySelector("#startScreen");
  startScreen.addEventListener("click", startGame, false);
  var endScreen = document.querySelector("#endScreen2");
  /**********
  Solução e initBoard
  **********/
  var initBoard = $(".initBoard").attr('data-value');
  var arrayInitBoard = initBoard.split(" ");

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
    this.style.opacity = "0";
    this.style.zIndex = "-1";
    this.removeEventListener("click", startGame, false);
    tiles = randomBoard(tiles);
    render();
  }

  function moveTile(){
    var index = tiles.indexOf(this);
    if(index % 3 !== 0){
      if(!tiles[index-1]){
        tiles[index-1] = this;
        tiles[index] = null;
      }
    }
    if(index % 3 !== 2 ){
      if(!tiles[index+1]){
        tiles[index+1] = this;
        tiles[index] = null;
      }
    }
    if(index > 2){
      if(!tiles[index-3]){
        tiles[index-3] = this;
        tiles[index] = null;
      }
    }
    if(index < 6){
      if(!tiles[index+3]){
        tiles[index+3] = this;
        tiles[index] = null;
      }
    }
    render();
    if(checkGoal()){
      showEndScreen();
    }
  }

  function randomBoard(oldBoard) {
    do{
      var newBoard = [];
      while(newBoard.length < oldBoard.length){
        var i = Math.floor(Math.random()*oldBoard.length);
        if(newBoard.indexOf(oldBoard[i]) < 0){
          newBoard.push(oldBoard[i]);
        }
      }
    }while(!validBoard(newBoard));
    return newBoard;
  }

  function validBoard(board) {
    var inversions = 0;
    for(var i = 0; i < board.length -1; i++){
      for(var j = i + 1; j < board.length; j++){
        if(board[i] && board[j] && board[i].dataset.value > board[j].dataset.value){
          inversions++;
        }
      }
    }
    console.log(inversions);
    return (inversions%2 === 0);
  }

  function showEndScreen() {
    endScreen.style.opacity = "1";
    endScreen.style.zIndex = "1";
    setTimeout(function functionName() {
      endScreen.addEventListener("click", startGame, false);
    })
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
