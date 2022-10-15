class Tree{
 
  Node root;
  
  Tree(){
   
    root = new Node(null, null);
    
  }
  
  void AddLeaf(Node Parent, int playX, int playY, int toX, int toY , int wher, int cout, Evaluate ev){
   
    if(cout == -1)
      Parent.AddChild(new Node(Parent, null));
    else
      Parent.AddChild(new Node(Parent, playX, playY, toX, toY, wher, ev));
      
      
  }
  
  
  
}
