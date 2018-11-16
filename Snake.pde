ArrayList<Integer> coor_x = new ArrayList<Integer>(), coor_y =new ArrayList<Integer>();//guarda las coordenadas de la vibora
int[]dx={0,0,1,-1},dy={1,-1,0,0};//depende del valor es la posición a la que se mueve la vibora
int count=0;

class Snake {
  Snake(){
  }//constructor
  void draw(){
    for(int i=0;i<coor_x.size();i++){
      fill(0,255,0);
      rect(coor_x.get(i) * DEFAULT_SCALE, coor_y.get(i) * DEFAULT_SCALE, DEFAULT_SIZE, DEFAULT_SIZE);
    }
    if(frameCount%3==0){//cambia la velocidad de la vibora
      coor_x.add(0,coor_x.get(0) + dx[dir]);//se van agregando o quitando coordenadas
                                            //a la vibora lo que simula que se desliza
      coor_y.add(0,coor_y.get(0) + dy[dir]);
      coor_x.remove(coor_x.size()-1);
      coor_y.remove(coor_y.size()-1);
    }
    /*Solución no tan buena
    if(getSelectedRow(coor_y.get(0))!=-1 &&getSelectedCol(coor_x.get(0))!=-1){
      if(hasObject(coor_y.get(0),coor_x.get(0))){
        count++;
        if(count%3==0){
            println("Collision with object in position: "+coor_x.get(0)+" x "+coor_y.get(0)+" y");
            count=0;
        }
      }
    }*/
    //solución buena
    if(getSelectedRow(coor_y.get(0))!=-1 &&getSelectedCol(coor_x.get(0))!=-1){
      count++;
      if(count%3==0){//se hace esto para que solo aparezca una vez el letrero de que se encontró algo
        if(root.SearchObject(new Object(1,coor_x.get(0),coor_y.get(0)))==true)
          println("Collision with object in position: "+coor_x.get(0)+" x "+coor_y.get(0)+" y");
          count=0;
      }
    }
  }
}
