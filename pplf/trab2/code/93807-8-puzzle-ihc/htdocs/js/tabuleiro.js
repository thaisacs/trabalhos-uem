(function () {
  var level = 0;
  var arrayLevelBoard; //board do level
  var tiles = [],
      goal = [];

  var startScreen = document.querySelector("#level1Screen");
  startScreen.addEventListener("click", startGame, false);
  var endScreen = document.querySelector("#endScreen");

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
    goNextLevel();
  }

  function updateBoard(){
    var aux = [];
    aux[0] = tiles[arrayLevelBoard[0]-1];
    aux[1] = tiles[arrayLevelBoard[1]-1];
    aux[2] = tiles[arrayLevelBoard[2]-1];
    aux[3] = tiles[arrayLevelBoard[3]-1];
    aux[4] = tiles[arrayLevelBoard[4]-1];
    aux[5] = tiles[arrayLevelBoard[5]-1];
    aux[6] = tiles[arrayLevelBoard[6]-1];
    aux[7] = tiles[arrayLevelBoard[7]-1];
    aux[8] = tiles[arrayLevelBoard[8]-1];
    tiles = aux;
    render();
  }

  function nextLevel(){
    level++;
    var levelBoard = $(".level-"+level).attr('data-value');
    arrayLevelBoard = levelBoard.split(" ");
  }

  function moveTile(){
    var index = tiles.indexOf(this);
    if(index % 3 !== 0){
      if(!tiles[index-1]){
        tiles[index-1] = this;
        tiles[index] = null;
        setScore();
      }
    }
    if(index % 3 !== 2){
      if(!tiles[index+1]){
        tiles[index+1] = this;
        tiles[index] = null;
        setScore();
      }
    }
    if(index > 2){
      if(!tiles[index-3]){
        tiles[index-3] = this;
        tiles[index] = null;
        setScore();
      }
    }
    if(index < 6){
      if(!tiles[index+3]){
        tiles[index+3] = this;
        tiles[index] = null;
        setScore();
      }
    }
    render();
    if(checkGoal()){
      showEndScreen();
    }
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

  function showEndScreen() {
    if(level == 1){
      level2Screen.style.opacity = "1";
      level2Screen.style.zIndex = "1";
      setTimeout(function functionName() {
        level2Screen.addEventListener("click", startGame, false);
      })
    }else if(level == 2){
      level3Screen.style.opacity = "1";
      level3Screen.style.zIndex = "1";
      setTimeout(function functionName() {
        level3Screen.addEventListener("click", startGame, false);
      })
    }else if(level == 3){
      level4Screen.style.opacity = "1";
      level4Screen.style.zIndex = "1";
      setTimeout(function functionName() {
        level4Screen.addEventListener("click", startGame, false);
      })
    }else if(level == 4){
      level5Screen.style.opacity = "1";
      level5Screen.style.zIndex = "1";
      setTimeout(function functionName() {
        level5Screen.addEventListener("click", startGame, false);
      })
    }else{
      alert("Parabéns!!! Você concluiu todas as fases com SCORE de " + $('.scoreHidden').val());
      goIndex();
    }
  }

  function goNextLevel(){
    nextLevel();
    updateBoard();
  }

  function goIndex() {
    $(".usernew").submit();
  }

  init();
}());
