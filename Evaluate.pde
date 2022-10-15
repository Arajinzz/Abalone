class Evaluate{
 
  int nbReds = 0;
  int nbBlacks = 0;
  
  int defRedPower = 0;
  int defBlackPower = 0;
  
  int newMap[][];
  int score = 0;
  
  // 2 for black , 3 for red
  int turn = 0;
  
  int rows, cols;
  
  Evaluate(int [][]map, int rows, int cols, int turn){
   
    newMap = new int[rows][cols];
    
    for(int i = 0 ; i < rows ; i++){
     
      for(int j = 0 ; j < cols ; j++){
       
        newMap[i][j] = map[i][j]; 
        
      }
      
    }
    
    this.rows = rows;
    this.cols = cols;
    this.turn = turn;
    
    calculateScores();
    
  }
  
  
  // evaluer le board
  void calculateScores(){
    
    for(int i = 0 ; i < rows ; i++){
      
      for(int j = 0 ; j < cols ; j++){
       
        if(newMap[i][j] == 2){
          nbBlacks -= 20;
        }
          
        if(newMap[i][j] == 3){
          nbReds += 20;
        }
        
        if(newMap[i][j] == 2 || newMap[i][j] == 3){
          defLine(i, j, 1);
          defLine(i, j, -1);
          
          defDiagonal(i, j, 1, 1);
          defDiagonal(i, j, -1, -1);
          defDiagonal(i, j, 1, -1);
          defDiagonal(i, j, -1, 1);
        }
        
      }
      
    }
    
    score = nbBlacks + nbReds + defBlackPower + defRedPower;
    
    if( 14 - (nbReds/20) == 6){
       score -= 100000;
    }
    
    if(14 - (nbBlacks/20) == 6){
       score += 500000; 
    }
    
  }
  
  
  void defLine(int x, int y, int direction){
   
    int ball = newMap[x][y];
    int paddY = y+(2* direction);
    
    for(int i = 0 ; i < 3 && paddY < cols && paddY > 0 ; i++){
      
      if(ball == newMap[x][paddY] && ball == 2)
        defBlackPower-=5;
        
      if(ball == newMap[x][paddY] && ball == 3)
        defRedPower++;
        
      paddY += (2*direction);
      
    }
    
  }
  
  
  void defDiagonal(int x, int y, int directionX, int directionY){
    
    int ball = newMap[x][y];
    
    int paddX = x + directionX;
    int paddY = y + directionY;
    
    for(int i = 0 ; i < 3 && paddX > 0 && paddY > 0 && paddX < rows && paddY < cols ; i++){
      
      if(ball == newMap[paddX][paddY] && ball == 2)
        defBlackPower-=5;
        
      if(ball == newMap[paddX][paddY] && ball == 3)
        defRedPower++;
        
      paddX += directionX;
      paddY += directionY;
      
    }
    
  }
  
  
}
