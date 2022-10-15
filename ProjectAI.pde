// Hadjerci Mohammed Allaeddine M1 MIV
// matricule : 201500008855

PImage space, blank, bb, rb, mvt, select;
PImage mvtRight, mvtLeft, mvtUpLeft, mvtUpRight, mvtDownRight, mvtDownLeft;

int blankHeight = 40;
int blankWidth = 40;
int spaceSize = 40;

int cols, rows;
int boardCols = 22;
int boardRows = 13;

int translateValue = 0;

ArrayList<int[]> validMVT = new ArrayList<int[]>();
ArrayList<int[]> toMove = new ArrayList<int[]>();

boolean isBlackPlayer = true;
boolean modeAI = true;

int scoreBlack = 0;
int scoreRed = 0;

int blackWins = 0;
int redWins = 0;

int tempX;
int tempY;

int globalMap[][];

int framesRef = 0;

// arbre de jeux
Tree tr;

// Fonction Pour initialiser la map (board)
// 3 red
// 1 vide
// 2 black
void reInitMap(){
  
  globalMap = new int[][]{
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 1, 0, 1, 0, 3, 0, 3, 0, 3, 0, 1, 0, 1, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0},
{0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0},
{0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 1, 0, 1, 0, 2, 0, 2, 0, 2, 0, 1, 0, 1, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
};

  
}


// pour copier Board
int[][] copyMap(int[][] toCopy){
  
  int [][] tempMap = new int[boardRows][boardCols];
  
  for(int i = 0 ; i < boardRows ; i++){
    
    for(int j = 0 ; j < boardCols ; j++){
      
      tempMap[i][j] = toCopy[i][j];
      
    }
    
  }
  
  return tempMap;
  
}

// Ouvre les nodes pour l'arbre de jeux
void openLeafs(Node tn, int[][] map, int ball){
  
  int firstMap[][] = copyMap(map);
  
  for(int i = 0; i < boardRows ; i++){
    
    for(int j = 0 ; j < boardCols ; j++){
     
      init_mouvement(i, j, map);
      
      ArrayList<int[]> tempValid = new ArrayList<int []>();
      tempValid.addAll(validMVT);
      
      validMVT.clear();
      toMove.clear();
      
      if(map[i][j] == ball){
        
        for(int mvt[] : tempValid){
          
          validMVT.add(new int[]{mvt[0], mvt[1], mvt[2]});
          toMove.add(new int[]{i, j});
  
          Move(mvt[0], mvt[1], ball, map);
          
          Evaluate map_ev = new Evaluate(map, boardRows, boardCols, ball);
          
          tr.AddLeaf(tn, i, j, mvt[0], mvt[1], mvt[2], map_ev.score, map_ev);
          
          map = copyMap(firstMap);
          
          validMVT.clear();
          toMove.clear();
          
        }     
        
      }
        
      validMVT.clear();
      toMove.clear();
      
    }
    
  }
  
  validMVT.clear();
  toMove.clear();
  
  map = copyMap(firstMap);
  
}


// Ouvrire un Niveau dans l'arble
void openLevel(Node node, int ball){
  
  if(node.ChildsExist()){
      
      for(Node n : node.childs){
        openLevel(n, ball);
      }
  }else{
    openLeafs(node, node.ev.newMap , ball); 
  }
}


// generer des board virtual et evaluer les boards
// IA et le joueur max
void generatePlayMap(int [][]map){
  
  tr = new Tree();
  
  int tempMap[][] = copyMap(map);
  
  Node node = tr.root;
  tr.root.ev = new Evaluate(tempMap, boardRows, boardCols, 2);
  
  openLevel(node, 3);
  openLevel(node, 2);
  openLevel(node, 3);
  //openLevel(node, 2);
  
  validMVT.clear();
  toMove.clear();
  
  MiniMax m = new MiniMax(tr);
  Node nn = m.Max(tr.root,-100000, 100000, true);
  Node n = nn;
  
  n = nn.Parent.Parent;
  
  println(n.ev.score);
  
  validMVT.add(new int[]{n.toX, n.toY, n.wher});
  toMove.add(new int[]{n.playX, n.playY});
  
  Move(n.toX, n.toY, 3, map);
  
  isBlackPlayer = true;
  
}


// fonctions pour dessiner
int[] calculatePadding(int x, int y, int [][]map){
 
  int padd[] = {0, 0};
   
 for(int j = 0 ; j < x; j++){
   
   if(map[y][j] == 0)
     padd[0] += blankWidth;
   else if(map[y][j] == 1 || map[y][j] == 2 || map[y][j] == 3 || map[y][j] == 4)
     padd[0] += spaceSize;
     
 }
   
 for(int j = 0 ; j < y; j++){
   
   if(map[j][x] == 0)
     padd[1] += blankHeight;
   else if(map[j][x] == 1 || map[j][x] == 2 || map[j][x] == 3 || map[y][j] == 4)
     padd[1] += spaceSize;
   
     
 }
   
 return padd;
 
}


//fonction pour dessiner
void updateMap(int [][]map){
  
  for(int y = 0 ; y < boardRows ; y++ ){
    for(int x = 0 ; x < boardCols ; x++){
      
      int padd[] = calculatePadding(x, y, map);
      
      if(map[y][x] == 0)
        image(blank, padd[0]+translateValue, padd[1]+translateValue);
      else if(map[y][x] == 1)
        image(space, padd[0]+translateValue, padd[1]+translateValue);
      else if(map[y][x] == 2){
        image(bb, padd[0]+translateValue, padd[1]+translateValue);
        scoreRed++;
      }
      else if(map[y][x] == 3){
        image(rb, padd[0]+translateValue, padd[1]+translateValue);
        scoreBlack++;
      }
    }
  }
  
  scoreBlack -= 14;
  scoreRed -= 14;
  
  if(isBlackPlayer){
    fill(0);
    textSize(32);
    text("Black Turn", 380, 40);
  }else{
    fill(255,0,0);
    textSize(32);
    text("Red Turn", 380, 40);
  }
  
  if(modeAI){
    fill(255,0,0);
    textSize(32);
    text("Mode Player vs CPU you are", 310-100, 520);
    fill(0);
    text(" Black", 740-100, 520);
  }else{
    fill(255,0,0);
    textSize(32);
    text("Mode Player vs Player", 300, 520);
  }
  
  fill(0);
  textSize(24);
  text("Press Q for Player vs Cpu Mode", 80, 600);
  
  fill(0);
  textSize(24);
  text("Press A for Player vs Player Mode", 80, 650);
  
  fill(0);
  textSize(24);
  text("Black Score : ", 800, 100);
  text(abs(scoreBlack), 950, 100);
  
  fill(255, 0, 0);
  textSize(24);
  text("Red Score : ", 800, 430);
  text(abs(scoreRed), 950, 430);
  
  fill(0);
  textSize(24);
  text("Black Wins : ", 20, 100);
  text(abs(blackWins), 160, 100);
  
  fill(255, 0, 0);
  textSize(24);
  text("Red Wins : ", 20, 430);
  text(abs(redWins), 160, 430);
  
  if(abs(scoreBlack) == 6){
    blackWins++;
    isBlackPlayer = true;
    reInitMap();
  }else if(abs(scoreRed) == 6){
    redWins++;
    isBlackPlayer = true;
    reInitMap();
  }
   
  scoreBlack = 0;
  scoreRed = 0;
}


void setup(){
  
  size(1000, 800);
  reInitMap();
  
  space = loadImage("space.png");
  blank = loadImage("blank.png");
  blank.resize(blankWidth, blankHeight);
  
  bb = loadImage("bb.png");
  rb = loadImage("rb.png");
  
  mvt = loadImage("mvt.png");
  mvtRight = loadImage("mvtRight.png");
  mvtLeft = loadImage("mvtLeft.png");
  mvtUpRight = loadImage("mvtUpright.png");
  mvtUpLeft = loadImage("mvtUpleft.png");
  mvtDownRight = loadImage("mvtDownright.png");
  mvtDownLeft = loadImage("mvtDownLeft.png");
  
  select = loadImage("select.png");
  
  updateMap(globalMap);
  
}


void draw(){
  
  background(104);
  
  updateMap(globalMap);
  drawMouvment(globalMap);
  drawSelected(globalMap);
  
  if(!isBlackPlayer && modeAI == true){
    
    // delay
    if(framesRef > 5){
      generatePlayMap(globalMap);
      framesRef = 0;
    }
    
    framesRef++;
    
  }
  
}

//pour dessiner les balls selectionner
void drawSelected(int map[][]){
  if(!toMove.isEmpty()){
     for(int i = 0 ; i < toMove.size(); i++){
        int pos[] = toMove.get(i);
        int padd[] = calculatePadding(pos[1], pos[0], map);
        
        image(select, padd[0]+translateValue, padd[1]+translateValue);
        
     }
  }
}


//pour dessiner les mouvement possible
void drawMouvment(int map[][]){
  if(!validMVT.isEmpty()){
     for(int i = 0 ; i < validMVT.size(); i++){
        int pos[] = validMVT.get(i);
        int padd[] = calculatePadding(pos[1], pos[0], map);
        
        if(pos[2] == 0)
          image(mvtRight, padd[0]+translateValue, padd[1]+translateValue);
        else if(pos[2] == 1)
          image(mvtLeft, padd[0]+translateValue, padd[1]+translateValue);
        else if(pos[2] == 2)
          image(mvtDownRight, padd[0]+translateValue, padd[1]+translateValue);
        else if(pos[2] == 3)
          image(mvtUpRight, padd[0]+translateValue, padd[1]+translateValue);
        else if(pos[2] == 5)
          image(mvtDownLeft, padd[0]+translateValue, padd[1]+translateValue);
        else
          image(mvtUpLeft, padd[0]+translateValue, padd[1]+translateValue);
     }
  }
}


// verifier si le mouvement et valid pour ne passe pas les boundries
boolean checkValid(int x, int y, int valX, int valY){
  if(x + valX < 13 && x + valX >= 0 && y + valY < 22 && y + valY >=0)
    return true;
  
  return false;
}


// verifier les mouvement possible de gauche et droite
void checkLeftRight(int x, int y, int direction, int ball, int [][]map){
  
  int padd1=2*direction;
  int padd2=4*direction;
  int padd3=6*direction;
  int padd4=8*direction;
  int padd5=10*direction;
  
  int oppositBall = (ball == 3 ? 2 : 3);
  
  int whereToGo = (direction == 1 ? 0 : 1);
  
  if(checkValid(x, y, 0, padd1) && checkValid(x, y, 0, padd2) && checkValid(x, y, 0, padd3) 
     && checkValid(x, y, 0, padd4) && checkValid(x, y, 0, padd5) &&
     map[x][y] == ball && map[x][y+padd1] == ball && map[x][y+padd2] == ball &&
     map[x][y+padd3] == oppositBall && map[x][y+padd4] == oppositBall
     && (map[x][y+padd5] == 1 || map[x][y+padd5] == 0)){
    
     validMVT.add(new int[]{x, y+padd5, whereToGo});
    
  }
  
  if(checkValid(x, y, 0, padd1) && checkValid(x, y, 0, padd2) && checkValid(x, y, 0, padd3) &&
     checkValid(x, y, 0, padd4) && map[x][y] == ball && map[x][y+padd1] == ball && map[x][y+padd2] == ball
     && map[x][y+padd3] == oppositBall && (map[x][y+padd4] == 1 || map[x][y+padd4] == 0)){
    
     validMVT.add(new int[]{x, y+padd4, whereToGo});
    
  }
  
  if(checkValid(x, y, 0, padd1) && checkValid(x, y, 0, padd2) && checkValid(x, y, 0, padd3) &&
     map[x][y] == ball && map[x][y+padd1] == ball && map[x][y+padd2] == oppositBall
     && (map[x][y+padd3] == 1 || map[x][y+padd3] == 0)){
    
     validMVT.add(new int[]{x, y+padd3, whereToGo});
    
  }
  
  if(checkValid(x, y, 0, padd1) && checkValid(x, y, 0, padd2) && checkValid(x, y, 0, padd3) &&
     map[x][y+padd1] == ball && map[x][y+padd2] == ball && map[x][y+padd3] == 1){
    
     validMVT.add(new int[]{x, y+padd3, whereToGo});
    
  }
  
  if(checkValid(x, y, 0, padd1) && checkValid(x, y, 0, padd2) &&
     map[x][y+padd1] == ball && map[x][y+padd2] == 1){
    
     validMVT.add(new int[]{x, y+padd2, whereToGo});
    
  }
  
  if(checkValid(x, y, 0, padd1) && map[x][y+padd1] == 1 ){
    
     validMVT.add(new int[]{x, y+padd1, whereToGo});
    
  }
  
}


// verifier les mouvement possible de diagonal
void checkDiagonal(int x, int y , int directionX, int directionY, int ball, int [][]map){
  
  int padd1_x=1*directionX;
  int padd1_y=1*directionY;
  
  int padd2_x=2*directionX;
  int padd2_y=2*directionY;
  
  int padd3_x=3*directionX;
  int padd3_y=3*directionY;
  
  int padd4_x=4*directionX;
  int padd4_y=4*directionY;
  
  int padd5_x=5*directionX;
  int padd5_y=5*directionY;
  
  int oppositBall = (ball == 3 ? 2 : 3);
  
  int whereToGo = 0;
  
  if(directionX == 1 && directionY == 1)
     whereToGo = 2;
  else if(directionX == -1 && directionY == 1)
     whereToGo = 3;
  else if(directionX == 1 && directionY == -1)
     whereToGo = 5;
  else
     whereToGo = 4;
     
  if(checkValid(x, y, padd1_x, padd1_y) && checkValid(x, y, padd2_x, padd2_y) 
     && checkValid(x, y, padd3_x, padd3_y) && checkValid(x, y, padd4_x, padd4_y) &&
     checkValid(x, y, padd5_x, padd5_y) && map[x][y] == ball &&
     map[x+padd1_x][y+padd1_y] == ball && map[x+padd2_x][y+padd2_y] == ball &&
     map[x+padd3_x][y+padd3_y] == oppositBall && map[x+padd4_x][y+padd4_y] == oppositBall
     && (map[x+padd5_x][y+padd5_y] == 1 || map[x+padd5_x][y+padd5_y] == 0)){
    
     validMVT.add(new int[]{x+padd5_x, y+padd5_y, whereToGo});
    
  }
  
  if(checkValid(x, y, padd1_x, padd1_y) && checkValid(x, y, padd2_x, padd2_y) 
     && checkValid(x, y, padd3_x, padd3_y) && map[x][y] == ball &&
     map[x+padd1_x][y+padd1_y] == ball  && map[x+padd2_x][y+padd2_y] == oppositBall
     && (map[x+padd3_x][y+padd3_y] == 1 || map[x+padd3_x][y+padd3_y] == 0)){
    
     validMVT.add(new int[]{x+padd3_x, y+padd3_y, whereToGo});
    
  }
  
  if(checkValid(x, y, padd1_x, padd1_y) && checkValid(x, y, padd2_x, padd2_y) 
     && checkValid(x, y, padd3_x, padd3_y) && checkValid(x, y, padd4_x, padd4_y) && map[x][y] == ball &&
     map[x+padd1_x][y+padd1_y] == ball  && map[x+padd2_x][y+padd2_y] == ball
     && map[x+padd3_x][y+padd3_y] == oppositBall && (map[x+padd4_x][y+padd4_y] == 1 || map[x+padd4_x][y+padd4_y] == 0)){
    
     validMVT.add(new int[]{x+padd4_x, y+padd4_y, whereToGo});
    
  }
  
  if(checkValid(x, y, padd1_x, padd1_y) && checkValid(x, y, padd2_x, padd2_y)
     && checkValid(x, y, padd3_x, padd3_y) && map[x+padd1_x][y+padd1_y] == ball &&
     map[x+padd2_x][y+padd2_y] == ball && map[x+padd3_x][y+padd3_y] == 1){
    
     validMVT.add(new int[]{x+padd3_x, y+padd3_y, whereToGo});
    
  }
  
  if(checkValid(x, y, padd1_x, padd1_y) && checkValid(x, y, padd2_x, padd2_y) &&
     map[x+padd1_x][y+padd1_y] == ball && map[x+padd2_x][y+padd2_y] == 1){
    
     validMVT.add(new int[]{x+padd2_x, y+padd2_y, whereToGo});
    
  }
  
  if(checkValid(x, y, padd1_x, padd1_y) && map[x+padd1_x][y+padd1_y] == 1){
    
     validMVT.add(new int[]{x+padd1_x, y+padd1_y, whereToGo});
    
  }
  
}


// verifier les mouvement possible en fleche de gauche et droite
void checkLeftRightFleche(int pos1[], int pos2[],int pos3[] , int direction, int [][]map){
  
  int padd = 2 * direction;
  
  if(pos3 == null){
    if(checkValid(pos1[0], pos1[1], 0, padd) && map[pos1[0]][pos1[1]+padd] == 1
      && checkValid(pos2[0], pos2[1], 0, padd) && map[pos2[0]][pos2[1]+padd] == 1)
       if(direction == 1)
         validMVT.add(new int[]{pos1[0], pos1[1]+padd, 0});
       else
         validMVT.add(new int[]{pos1[0], pos1[1]+padd, 1});
  }else{
    if(checkValid(pos1[0], pos1[1], 0, padd) && map[pos1[0]][pos1[1]+padd] == 1
      && checkValid(pos2[0], pos2[1], 0, padd) && map[pos2[0]][pos2[1]+padd] == 1
      && checkValid(pos3[0], pos3[1], 0, padd) && map[pos3[0]][pos3[1]+padd] == 1)
       if(direction == 1)
         validMVT.add(new int[]{pos1[0], pos1[1]+padd, 0});
       else
         validMVT.add(new int[]{pos1[0], pos1[1]+padd, 1});
  }
  
}


// verifier les mouvement possible en fleche de diagonal
void checkDiagonalFleche(int pos1[], int pos2[], int pos3[], int d1, int d2, int [][]map){
   
  int whereToGo = 0;
  
  if(d1 == 1 && d2 == 1)
     whereToGo = 2;
  else if(d1 == -1 && d2 == 1)
     whereToGo = 3;
  else if(d1 == 1 && d2 == -1)
     whereToGo = 5;
  else
     whereToGo = 4;
   
   
   if(pos3 == null){
     if(checkValid(pos1[0], pos1[1], d1, d2) && map[pos1[0]+d1][pos1[1]+d2] == 1
        && checkValid(pos2[0], pos2[1], d1, d2) && map[pos2[0]+d1][pos2[1]+d2] == 1){
         validMVT.add(new int[]{pos1[0] + d1, pos1[1]+d2, whereToGo});
         
     }
     
   }else{
     if(checkValid(pos1[0], pos1[1], d1, d2) && map[pos1[0]+d1][pos1[1]+d2] == 1
        && checkValid(pos2[0], pos2[1], d1, d2) && map[pos2[0]+d1][pos2[1]+d2] == 1
        && checkValid(pos3[0], pos3[1], d1, d2) && map[pos3[0]+d1][pos3[1]+d2] == 1){
         validMVT.add(new int[]{pos1[0] + d1, pos1[1]+d2, whereToGo});
         
     }
     
   }
   
   
   
}


// obtenir tout les mouvement valid
void getValidMouvement(int [][]map){
    
    validMVT.clear();
    
    if(toMove.size() == 1){
      int size = 0;
      int ball = map[toMove.get(size)[0]][toMove.get(size)[1]];
      checkLeftRight(toMove.get(size)[0], toMove.get(size)[1], 1, ball, map);
      checkLeftRight(toMove.get(size)[0], toMove.get(size)[1], -1, ball, map);
      checkDiagonal(toMove.get(size)[0], toMove.get(size)[1], 1, 1, ball, map);
      checkDiagonal(toMove.get(size)[0], toMove.get(size)[1], 1, -1, ball, map);
      checkDiagonal(toMove.get(size)[0], toMove.get(size)[1], -1, 1, ball, map);
      checkDiagonal(toMove.get(size)[0], toMove.get(size)[1], -1, -1, ball, map);
    }else if(toMove.size() == 2){
      
      // NOT COMPLETED
      int firstPos[] = toMove.get(0);
      int lastPos[] = toMove.get(1);
      
      checkLeftRightFleche(firstPos, lastPos, null, 1, map);
      checkLeftRightFleche(lastPos, firstPos, null, -1, map);
      
      checkDiagonalFleche(firstPos, lastPos, null, 1, 1, map);
      checkDiagonalFleche(lastPos, firstPos, null, -1, -1, map);
      
      checkDiagonalFleche(lastPos, firstPos, null, 1, -1, map);
      checkDiagonalFleche(firstPos, lastPos, null, -1, 1, map);
      
      
      
    }else if(toMove.size() == 3){
      int firstPos[] = toMove.get(0);
      int middlePos[] = toMove.get(1);
      int lastPos[] = toMove.get(2);
      
      checkLeftRightFleche(firstPos, lastPos, middlePos, 1, map);
      checkLeftRightFleche(lastPos, firstPos, middlePos, -1, map);
      
      checkDiagonalFleche(firstPos, lastPos, middlePos, 1, 1, map);
      checkDiagonalFleche(lastPos, firstPos, middlePos, -1, -1, map);
      
      checkDiagonalFleche(lastPos, firstPos, middlePos, 1, -1, map);
      checkDiagonalFleche(firstPos, lastPos, middlePos, -1, 1, map);
      
    }
}


// deplacer une ball a gauche ou droite
void MoveLeftRight(int x, int y, int direction, int ball, int [][]map){
  
  int padd1=2*direction;
  int padd2=4*direction;
  int padd3=6*direction;
  int padd4=8*direction;
  int padd5=10*direction;
  
  int oppositBall = (ball == 3 ? 2 : 3);
  
  if(checkValid(x, y, 0, padd1) && checkValid(x, y, 0, padd2) && checkValid(x, y, 0, padd3) 
     && checkValid(x, y, 0, padd4) && checkValid(x, y, 0, padd5) &&
     map[x][y] == ball && map[x][y+padd1] == ball && map[x][y+padd2] == ball &&
     map[x][y+padd3] == oppositBall && map[x][y+padd4] == oppositBall
     && (map[x][y+padd5] == 1 || map[x][y+padd5] == 0)){
     
     if(map[x][y+padd5] != 0)
       map[x][y+padd5] = map[x][y+padd4];
     map[x][y+padd4] = map[x][y+padd3];
     map[x][y+padd3] = map[x][y+padd2];
     map[x][y+padd2] = map[x][y+padd1];
     map[x][y+padd1] = map[x][y];
     map[x][y] = 1;
     
    
  }
  
  if(checkValid(x, y, 0, padd1) && checkValid(x, y, 0, padd2) && checkValid(x, y, 0, padd3) &&
     map[x][y] == ball && map[x][y+padd1] == ball && map[x][y+padd2] == ball
     && map[x][y+padd3] == oppositBall && (map[x][y+padd4] == 1 || map[x][y+padd4] == 0)){
    
     if(map[x][y+padd4] != 0)
       map[x][y+padd4] = map[x][y+padd3];
       
     map[x][y+padd3] = map[x][y+padd2];
     map[x][y+padd2] = map[x][y+padd1];
     map[x][y+padd1] = map[x][y];
     map[x][y] = 1;
    
  }
  
  if(checkValid(x, y, 0, padd1) && checkValid(x, y, 0, padd2) && checkValid(x, y, 0, padd3) &&
     map[x][y] == ball && map[x][y+padd1] == ball && map[x][y+padd2] == oppositBall
     && (map[x][y+padd3] == 1 || map[x][y+padd3] == 0)){
     
     if(map[x][y+padd3] != 0)
       map[x][y+padd3] = map[x][y+padd2];
       
     map[x][y+padd2] = map[x][y+padd1];
     map[x][y+padd1] = map[x][y];
     map[x][y] = 1;
    
  }
  
  if(checkValid(x, y, 0, padd1) && checkValid(x, y, 0, padd2) && checkValid(x, y, 0, padd3) &&
     map[x][y+padd1] == ball && map[x][y+padd2] == ball && map[x][y+padd3] == 1){
    
     map[x][y+padd3] = map[x][y+padd2];
     map[x][y+padd2] = map[x][y+padd1];
     map[x][y+padd1] = map[x][y];
     map[x][y] = 1;
    
  }
  
  if(checkValid(x, y, 0, padd1) && checkValid(x, y, 0, padd2) &&
     map[x][y+padd1] == ball && map[x][y+padd2] == 1){
    
     map[x][y+padd2] = map[x][y+padd1];
     map[x][y+padd1] = map[x][y];
     map[x][y] = 1;
    
  }
  
  if(checkValid(x, y, 0, padd1) && map[x][y+padd1] == 1 ){
    
     map[x][y+padd1] = map[x][y];
     map[x][y] = 1;
    
  }
  
}


// deplacer une ball diagonal
void MoveDiagonal(int x, int y, int directionX, int directionY, int ball, int [][]map){
  
  int padd1_x=1*directionX;
  int padd1_y=1*directionY;
  
  int padd2_x=2*directionX;
  int padd2_y=2*directionY;
  
  int padd3_x=3*directionX;
  int padd3_y=3*directionY;
  
  int padd4_x=4*directionX;
  int padd4_y=4*directionY;
  
  int padd5_x=5*directionX;
  int padd5_y=5*directionY;
  
  int oppositBall = (ball == 3 ? 2 : 3);
     
  if(checkValid(x, y, padd1_x, padd1_y) && checkValid(x, y, padd2_x, padd2_y) 
     && checkValid(x, y, padd3_x, padd3_y) && checkValid(x, y, padd4_x, padd4_y) &&
     checkValid(x, y, padd5_x, padd5_y) && map[x][y] == ball &&
     map[x+padd1_x][y+padd1_y] == ball && map[x+padd2_x][y+padd2_y] == ball &&
     map[x+padd3_x][y+padd3_y] == oppositBall && map[x+padd4_x][y+padd4_y] == oppositBall
     && (map[x+padd5_x][y+padd5_y] == 1 || map[x+padd5_x][y+padd5_y] == 0)){
     
     if(map[x+padd5_x][y+padd5_y] != 0)
       map[x+padd5_x][y+padd5_y] = map[x+padd4_x][y+padd4_y];
       
     map[x+padd4_x][y+padd4_y] = map[x+padd3_x][y+padd3_y];
     map[x+padd3_x][y+padd3_y] = map[x+padd2_x][y+padd2_y];
     map[x+padd2_x][y+padd2_y] = map[x+padd1_x][y+padd1_y];
     map[x+padd1_x][y+padd1_y] = map[x][y];
     map[x][y] = 1;
    
  }
  
  if(checkValid(x, y, padd1_x, padd1_y) && checkValid(x, y, padd2_x, padd2_y) 
     && checkValid(x, y, padd3_x, padd3_y) && map[x][y] == ball &&
     map[x+padd1_x][y+padd1_y] == ball  && map[x+padd2_x][y+padd2_y] == oppositBall
     && (map[x+padd3_x][y+padd3_y] == 1 || map[x+padd3_x][y+padd3_y] == 0)){
     
     if(map[x+padd3_x][y+padd3_y] != 0)
       map[x+padd3_x][y+padd3_y] = map[x+padd2_x][y+padd2_y];
       
     map[x+padd2_x][y+padd2_y] = map[x+padd1_x][y+padd1_y];
     map[x+padd1_x][y+padd1_y] = map[x][y];
     map[x][y] = 1;
    
  }
  
  if(checkValid(x, y, padd1_x, padd1_y) && checkValid(x, y, padd2_x, padd2_y) 
     && checkValid(x, y, padd3_x, padd3_y) && checkValid(x, y, padd4_x, padd4_y) && map[x][y] == ball &&
     map[x+padd1_x][y+padd1_y] == ball  && map[x+padd2_x][y+padd2_y] == ball
     && map[x+padd3_x][y+padd3_y] == oppositBall && (map[x+padd4_x][y+padd4_y] == 1 || map[x+padd4_x][y+padd4_y] == 0)){
    
     if(map[x+padd4_x][y+padd4_y] != 0)
       map[x+padd4_x][y+padd4_y] = map[x+padd3_x][y+padd3_y];
       
     map[x+padd3_x][y+padd3_y] = map[x+padd2_x][y+padd2_y];
     map[x+padd2_x][y+padd2_y] = map[x+padd1_x][y+padd1_y];
     map[x+padd1_x][y+padd1_y] = map[x][y];
     map[x][y] = 1;
    
  }
  
  if(checkValid(x, y, padd1_x, padd1_y) && checkValid(x, y, padd2_x, padd2_y)
     && checkValid(x, y, padd3_x, padd3_y) && map[x+padd1_x][y+padd1_y] == ball &&
     map[x+padd2_x][y+padd2_y] == ball && map[x+padd3_x][y+padd3_y] == 1){
    
     map[x+padd3_x][y+padd3_y] = map[x+padd2_x][y+padd2_y];
     map[x+padd2_x][y+padd2_y] = map[x+padd1_x][y+padd1_y];
     map[x+padd1_x][y+padd1_y] = map[x][y];
     map[x][y] = 1;
    
  }
  
  if(checkValid(x, y, padd1_x, padd1_y) && checkValid(x, y, padd2_x, padd2_y) &&
     map[x+padd1_x][y+padd1_y] == ball && map[x+padd2_x][y+padd2_y] == 1){
    
     map[x+padd2_x][y+padd2_y] = map[x+padd1_x][y+padd1_y];
     map[x+padd1_x][y+padd1_y] = map[x][y];
     map[x][y] = 1;
    
  }
  
  if(checkValid(x, y, padd1_x, padd1_y) && map[x+padd1_x][y+padd1_y] == 1){
    
     map[x+padd1_x][y+padd1_y] = map[x][y];
     map[x][y] = 1;
    
  }
  
}

/* 
   pour deplacer les balls
   0 right
   1 left
   2 down right
   3 up right
   4 up left
   5 down left
*/
void Move(int x, int y, int ball, int [][]map){
  if(!validMVT.isEmpty()){
    
    for(int i = 0; i < validMVT.size() ; i++){
      
      int pos[] = validMVT.get(i);
      
      if(pos[0] == x && pos[1] == y){
        
        if(toMove.size() == 1){
          
          int tomvt[] = toMove.get(0);
          
          if(pos[2] == 0)
            MoveLeftRight(tomvt[0], tomvt[1], 1, ball, map);
          if(pos[2] == 1)
            MoveLeftRight(tomvt[0], tomvt[1], -1, ball, map);
          if(pos[2] == 2)
            MoveDiagonal(tomvt[0], tomvt[1], 1, 1, ball, map);
          if(pos[2] == 3)
            MoveDiagonal(tomvt[0], tomvt[1], -1, 1, ball, map);
          if(pos[2] == 4)
            MoveDiagonal(tomvt[0], tomvt[1], -1, -1, ball, map);
          if(pos[2] == 5)
            MoveDiagonal(tomvt[0], tomvt[1], 1, -1, ball, map);
        }else if(toMove.size() == 2){
          
          if(pos[2] == 0){
            int tomvt[] = toMove.get(0);
            MoveLeftRight(tomvt[0], tomvt[1], 1, ball, map);
            
            tomvt = toMove.get(1);
            MoveLeftRight(tomvt[0], tomvt[1], 1, ball, map);
            
          }
          
          if(pos[2] == 1){
            int tomvt[] = toMove.get(1);
            MoveLeftRight(tomvt[0], tomvt[1], -1, ball, map);
            
            tomvt = toMove.get(0);
            MoveLeftRight(tomvt[0], tomvt[1], -1, ball, map);
            
          }
          
          if(pos[2] == 2){
            int tomvt[] = toMove.get(0);
            MoveDiagonal(tomvt[0], tomvt[1], 1, 1, ball, map);
            
            tomvt = toMove.get(1);
            MoveDiagonal(tomvt[0], tomvt[1], 1, 1, ball, map);
            
          }
          
          if(pos[2] == 3){
            int tomvt[] = toMove.get(0);
            MoveDiagonal(tomvt[0], tomvt[1], -1, 1, ball, map);
            
            tomvt = toMove.get(1);
            MoveDiagonal(tomvt[0], tomvt[1], -1, 1, ball, map);
            
          }
          
          if(pos[2] == 4){
            int tomvt[] = toMove.get(1);
            MoveDiagonal(tomvt[0], tomvt[1], -1, -1, ball, map);
            
            tomvt = toMove.get(0);
            MoveDiagonal(tomvt[0], tomvt[1], -1, -1, ball, map);
            
          }
          
          if(pos[2] == 5){
            int tomvt[] = toMove.get(0);
            MoveDiagonal(tomvt[0], tomvt[1], 1, -1, ball, map);
            
            tomvt = toMove.get(1);
            MoveDiagonal(tomvt[0], tomvt[1], 1, -1, ball, map);
            
          }
          
        }else if(toMove.size() == 3){
          
          if(pos[2] == 0){
            int tomvt[] = toMove.get(0);
            MoveLeftRight(tomvt[0], tomvt[1], 1, ball, map);
            
            tomvt = toMove.get(1);
            MoveLeftRight(tomvt[0], tomvt[1], 1, ball, map);
            
            tomvt = toMove.get(2);
            MoveLeftRight(tomvt[0], tomvt[1], 1, ball, map);
            
          }
          
          if(pos[2] == 1){
            int tomvt[] = toMove.get(2);
            MoveLeftRight(tomvt[0], tomvt[1], -1, ball, map);
            
            tomvt = toMove.get(1);
            MoveLeftRight(tomvt[0], tomvt[1], -1, ball, map);
           
            tomvt = toMove.get(0);
            MoveLeftRight(tomvt[0], tomvt[1], -1, ball, map);
          
          }
          
          if(pos[2] == 2){
            int tomvt[] = toMove.get(0);
            MoveDiagonal(tomvt[0], tomvt[1], 1, 1, ball, map);
            
            tomvt = toMove.get(1);
            MoveDiagonal(tomvt[0], tomvt[1], 1, 1, ball, map);
            
            tomvt = toMove.get(2);
            MoveDiagonal(tomvt[0], tomvt[1], 1, 1, ball, map);
            
          }
          
          if(pos[2] == 3){
            int tomvt[] = toMove.get(2);
            MoveDiagonal(tomvt[0], tomvt[1], -1, 1, ball, map);
            
            tomvt = toMove.get(1);
            MoveDiagonal(tomvt[0], tomvt[1], -1, 1, ball, map);
            
            tomvt = toMove.get(0);
            MoveDiagonal(tomvt[0], tomvt[1], -1, 1, ball, map);
            
          }
          
          if(pos[2] == 4){
            int tomvt[] = toMove.get(2);
            MoveDiagonal(tomvt[0], tomvt[1], -1, -1, ball, map);
            
            tomvt = toMove.get(1);
            MoveDiagonal(tomvt[0], tomvt[1], -1, -1, ball, map);
            
            tomvt = toMove.get(0);
            MoveDiagonal(tomvt[0], tomvt[1], -1, -1, ball, map);
            
          }
          
          if(pos[2] == 5){
            int tomvt[] = toMove.get(0);
            MoveDiagonal(tomvt[0], tomvt[1], 1, -1, ball, map);
            
            tomvt = toMove.get(1);
            MoveDiagonal(tomvt[0], tomvt[1], 1, -1, ball, map);
            
            tomvt = toMove.get(2);
            MoveDiagonal(tomvt[0], tomvt[1], 1, -1, ball, map);
            
          }
        
        }
        
        validMVT.clear();
        toMove.clear();
        
        return;
        
      }
      
    }
  }
  
}


// la selection multiple
void addValidPoint(int x, int y){
  
  if(toMove.size() == 3)
    return;
  
  if(toMove.isEmpty())
    return;
  
  boolean toAdd = false;
  //int arrow = 0;
  
  for(int i = 0 ; i < toMove.size(); i++){
    if((toMove.get(i)[0] + 1 == x && toMove.get(i)[1] + 1 == y) ||
       (toMove.get(i)[0] - 1 == x && toMove.get(i)[1] - 1 == y) ||
       (toMove.get(i)[0] + 1 == x && toMove.get(i)[1] - 1 == y) ||
       (toMove.get(i)[0] - 1 == x && toMove.get(i)[1] + 1 == y) ||
       (toMove.get(i)[0] == x && toMove.get(i)[1] + 2 == y) ||
       (toMove.get(i)[0] == x && toMove.get(i)[1] - 2 == y)
       ){
       
      toAdd = true;
      break;
    }else{
      toAdd = false; 
    }
    
  }
  
  if(toMove.size() == 2){
    if(toMove.get(0)[0] + 2 == x && toMove.get(0)[1] == y)
        toAdd = false;
    
    if(toMove.get(1)[0] + 2 == x && toMove.get(1)[1] == y)
        toAdd = false;
        
    if(toMove.get(0)[0] - 2 == x && toMove.get(0)[1] == y)
        toAdd = false;
    
    if(toMove.get(1)[0] - 2 == x && toMove.get(1)[1] == y)
        toAdd = false;
    
    if(toMove.get(1)[0] + 1 == toMove.get(0)[0] && toMove.get(0)[0] == x && toMove.get(0)[1] + 2 == y)
        toAdd = false;
    
    if(toMove.get(1)[0] + 1 == toMove.get(0)[0] && toMove.get(0)[0] == x && toMove.get(0)[1] - 2 == y)
        toAdd = false;
        
    if(toMove.get(1)[0] + 1 == toMove.get(0)[0] && toMove.get(1)[0] == x && toMove.get(1)[1] + 2 == y)
        toAdd = false;
        
    if(toMove.get(1)[0] + 1 == toMove.get(0)[0] && toMove.get(1)[0] == x && toMove.get(1)[1] - 2 == y)
        toAdd = false;
    
    if(toMove.get(0)[1] - 2 == toMove.get(1)[1] && toMove.get(0)[0] == x + 1)
        toAdd = false;
        
    if(toMove.get(0)[1] - 2 == toMove.get(1)[1] && toMove.get(1)[0] == x - 1)
        toAdd = false;
  }
  
  
  if(toAdd)
    toMove.add(new int[]{x, y});
  
  for(int i = 0 ; i < toMove.size(); i++){
    for(int j = 0 ; j < toMove.size()-1; j++){
      if(toMove.get(j)[0] < toMove.get(j+1)[0]){
        int []temp = new int[2];
        temp[0] = toMove.get(j)[0];
        temp[1] = toMove.get(j)[1];
        
        toMove.get(j)[0] = toMove.get(j+1)[0];
        toMove.get(j)[1] = toMove.get(j+1)[1];
        
        toMove.get(j+1)[0] = temp[0];
        toMove.get(j+1)[1] = temp[1];
      
      }else if(toMove.get(j)[0] == toMove.get(j+1)[0] && toMove.get(j)[1] < toMove.get(j+1)[1]){
        
        int []temp = new int[2];
        temp[0] = toMove.get(j)[0];
        temp[1] = toMove.get(j)[1];
        
        toMove.get(j)[0] = toMove.get(j+1)[0];
        toMove.get(j)[1] = toMove.get(j+1)[1];
        
        toMove.get(j+1)[0] = temp[0];
        toMove.get(j+1)[1] = temp[1];
        
      }
    }
    
  }
  
}

void init_mouvement(int y, int x, int [][]map){
  if(toMove.isEmpty()){
       toMove.add(new int[]{y, x});
       getValidMouvement(map);
    }else{
      
       boolean isRemoved = false;
       for(int i=0 ; i < toMove.size() ; i++ ){
         if(y == toMove.get(i)[0] && x == toMove.get(i)[1]){
           if(i == 1 && toMove.size() == 3){
              toMove.clear();
              validMVT.clear();
              isRemoved = true;
              break;
           }
           toMove.remove(i);
           isRemoved = true;
           getValidMouvement(map);
           break;
         }
       }
       
       if(!isRemoved){
           addValidPoint(y, x);
           getValidMouvement(map);
       }
    }
}


// fonction de mouse
void mousePressed(){

  int x = floor((mouseX) / 40) ;
  int y = floor((mouseY) / 40) ;
  
  if(x < 0 || x >= boardCols || y < 0 || y >= boardRows){
    return; 
  }
  
  if(modeAI){
    if(isBlackPlayer){
      if(globalMap[y][x] == 2)
        init_mouvement(y, x, globalMap);
      else{
        if(!toMove.isEmpty()){
          Move(y, x, globalMap[toMove.get(0)[0]][toMove.get(0)[1]], globalMap);
          if(toMove.isEmpty()){
            isBlackPlayer = false;
          }
        }
      }
    }
  }else{
    if(isBlackPlayer){
      if(globalMap[y][x] == 2){
        init_mouvement(y, x, globalMap);
      }else{
        if(!toMove.isEmpty()){
          Move(y, x, globalMap[toMove.get(0)[0]][toMove.get(0)[1]], globalMap);
          if(toMove.isEmpty()){
            isBlackPlayer = false;
          }
        }
      } 
    }else{
      if(globalMap[y][x] == 3){
        init_mouvement(y, x, globalMap);
      }else{
        if(!toMove.isEmpty()){
          Move(y, x, globalMap[toMove.get(0)[0]][toMove.get(0)[1]], globalMap);
          if(toMove.isEmpty()){
            isBlackPlayer = true;
          }
        }
      } 
    }
  }
  
}

// fonction de clavier pour changer le mode de jeux
void keyPressed(){
  
  if(key == 'Q' || key == 'q'){
    if(modeAI == false){
      reInitMap(); 
      blackWins = 0;
      redWins = 0;
      isBlackPlayer = true;
    }
    modeAI = true;
  }
  
  if(key == 'A' || key == 'a'){
    if(modeAI == true){
      reInitMap(); 
      blackWins = 0;
      redWins = 0;
      isBlackPlayer = true;
    }
    modeAI = false;
  }
  
}
