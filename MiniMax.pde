class MiniMax{
 
  Tree tr;
  
  MiniMax(Tree tr){
    
    this.tr = tr;
    
  }
  
  Node Max(Node n,int alpha, int beta, boolean isMaximize){
   
    Node nn = new Node(null, null);
    
    if(n.ChildsExist()){
     
      if(isMaximize){
        nn.cout = -1000000;
        for(Node temp : n.childs){
          Node tt = Max(temp, alpha, beta, false);
          if(nn.cout < tt.cout)
            nn = tt;
          
          alpha = max(alpha, nn.cout);
          
          if(alpha >= beta)
            break;  
        }
      }else{
        nn.cout = 1000000;
        for(Node temp : n.childs){
          Node tt = Max(temp, alpha, beta, true);
          if(nn.cout > tt.cout)
            nn = tt;
          
          beta = min(beta, nn.cout);
          
          if(alpha >= beta)
            break;
          
        } 
      }
      
      
    }else{
       
      return n;
      
    }
    
    return nn;
    
  }
  
}
