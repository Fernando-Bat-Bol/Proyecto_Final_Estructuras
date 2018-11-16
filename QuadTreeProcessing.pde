//Codigo principal del proyecto
//libreria para poder usar el botón F2 en el programa 
import java.awt.event.KeyEvent;

//si dice final significa que solo se le puede asignar un valor una vez
final int DEFAULT_SCALE = 4;//cambia el tamaño de los cuadros
final int MAX_OBJECTS = 4;//máximo de objetos en un árbol 

int MAX_LEVELS;//la altura máxima del árbol
int RANDOM_OBJECTS;
int dir=2;//direccion de la vibora 

int rows, cols;
int[][] data;

QuadTree root = null;
Snake serpi = null;

boolean simulateQuadTrees = false;//no se usa
boolean snakeslide = false;

void init() { //inicialización del programa
  clear();
  smooth();
  background(50);

  rows = height / DEFAULT_SCALE;
  cols = width / DEFAULT_SCALE;

  MAX_LEVELS = int((log(width / DEFAULT_SCALE) / log(2)));
  RANDOM_OBJECTS = int(pow(MAX_LEVELS, 2) * MAX_OBJECTS) * 2;

  data = new int[rows][cols];

  if (root == null) {
    root = new QuadTree(1, 0, 0, cols, rows, MAX_OBJECTS, MAX_LEVELS, true);
    serpi = new Snake();
  } else {
    root.clear();
  }

  println("Logging for Grid [rows, cols] = " + rows + " , " + cols);
  println("Min. Level QuadTree: " + (rows / int(pow(2, MAX_LEVELS - 1))));
}

void setup() {
  size(512, 512);

  init();
}

void draw() {
  drawGrid();//llama a la función para dibujar la cuadrícula

  if (simulateQuadTrees) {
    root.simulate(root, DEFAULT_SCALE, MAX_LEVELS);
  } else{
    root.draw();//llama a la función dibujar de la clase quadtree
    if(snakeslide==true){
    serpi.draw();//llama a la función dibujar de la classe snake
    }
  }
}

void drawGrid() {
  noFill();
  stroke(70);//colo del contorno de los cuadrados

  for (int rowId=0; rowId<data.length; rowId++) {
    for (int colId=0; colId<data[0].length; colId++) {
      rect(colId * DEFAULT_SCALE, rowId * DEFAULT_SCALE, DEFAULT_SCALE, DEFAULT_SCALE);
    }//dibuja los cuadrados
  }
}

void generateRandomObjects() {//función que genera al azar los objetos
  for (int i = 0; i < RANDOM_OBJECTS; i++) {
    data[int(random(0, rows))][int(random(0, cols))] = 1;
  }

  root.loadData(data);//se manda llamar a la función loadData de Quadtree para guardar los objetos en el árbol
}

void keyPressed() {
  String keyAsString = str(key).toUpperCase();

  if (keyAsString.equalsIgnoreCase("C")) { // Se limpia
    init();
  } else if (keyAsString.equalsIgnoreCase("R")) { // Genera objetos al azar
    init();
    generateRandomObjects();
  } else if (key == CODED && keyCode == KeyEvent.VK_F2) { // Muestra o oculta la simulación de QuadTrees
    simulateQuadTrees = !simulateQuadTrees;
  }
    else if(keyAsString.equalsIgnoreCase("S")){ // Aparece la vibora
    snakeslide=true;
      coor_x.add(5);
      coor_y.add(5);
  }
  if(snakeslide == true){//depende de las teclas es hacia donde se mueve la vibora
    int newdir = key =='k'?0:(key=='i'? 1:(key=='l'? 2:(key=='j'? 3: -1)));
    if(newdir != -1) dir=newdir;
  }
}

void mousePressed() {//cuando se presione el mouse (un click) se crea un objeto
  int colId = getSelectedCol(mouseX);//mouse x da la posición de la coordenada x del mouse
  int rowId = getSelectedRow(mouseY);

  if (colId == -1 || rowId == -1) {//si está afuera del cuadro
    return;
  }

  data[rowId][colId] = 1;

  root.addObject(new Object(1, colId, rowId));//se agrega el objeto al árbol 
  
}

void mouseDragged() {//cuando se deja presionado el mouse 
  int colId = getSelectedCol(mouseX);
  int rowId = getSelectedRow(mouseY);

  if (colId == -1 || rowId == -1) {
    return;
  }

  data[rowId][colId] = 1;

  root.addObject(new Object(1, colId, rowId));
}

boolean hasObject(int rowId, int colId) {//regresa si hay un objeto en la posición buscada
  return data[rowId][colId] == 1;
}

int getSelectedRow(int mouseY) {//regresa la fila buscada
  return mouseY >=0 && mouseY < height ? mouseY / DEFAULT_SCALE : -1;
}

int getSelectedCol(int mouseX) {
  return mouseX >=0 && mouseX < width ? mouseX / DEFAULT_SCALE : -1;
}
