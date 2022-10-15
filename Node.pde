class Node{
 
  Node Parent = null;
  ArrayList<Node> childs = new ArrayList<Node>();
  
  int cout = -1;
  
  int playX = -1;
  int playY = -1;
  
  int toX = -1;
  int toY = -1;
  
  int wher = -1;
  
  Evaluate ev;  
  
  Node(Node Parent, Evaluate ev){
    
    this.Parent = Parent;
    this.ev = ev;
    
  }
  
  Node(Node Parent, int playX,int playY,int toX,int toY, int wher, Evaluate ev){
    
    this.Parent = Parent;
    this.cout = ev.score;
    this.playX = playX;
    this.playY = playY;
    this.toX = toX;
    this.toY = toY;
    this.wher = wher;
    this.ev = ev;
    
  }
  
  void AddChild(Node child){
    childs.add(child);
  }
  
  Node GetChild(int index){
   
    return childs.get(index);
    
  }
  
  boolean ParentExist(){
   
    if(Parent == null)
      return false;
    
    return true;
    
  }
  
  boolean ChildsExist(){
   
    if(childs.size() == 0)
      return false;
      
    return true;
    
  }
  
}
