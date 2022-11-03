//
// Clara Rubio Almagro y Laura Sánchez Sánchez 
// 
// Código de ejercicio de la asignatura electrónica creatima de la ETSIT UMA
//
// Simula el típico juego de preparación de comida mediante el uso de un piezoeléctrico
// conectado a un arduino
//

PImage fondo;
import processing.serial.*;
ArrayList<Cangreburguer> cangreburguers;
ArrayList<Pez_Hambriento> peces;
Serial myPort;
long tiempo_anterior = 0;
long periodo = 3000;
int[] pecesPidiendo;
float[] _princEsp = {275,600,950,1250};
float[] _finalEsp = {525,900,1200,1600};
int NUM_PECES = 4;

void setup()
{
  size(2166,1080);
  fondo = loadImage("fondo.jpg");
  background(fondo);
  cangreburguers = new ArrayList<Cangreburguer>();
  peces = new ArrayList<Pez_Hambriento>();
  for(int i= 0; i<4;i++)
  {
    creaPez_Hambriento(i);
  }
  pecesPidiendo = new int[4];
  for(int i = 0; i<4;i++){
    pecesPidiendo[i] = 0;
  }
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600); 
  myPort.bufferUntil(10);
  myPort.clear();
}

void draw()
{
  background(fondo);
  for (int i = 0; i<cangreburguers.size(); i++)
  {
    Cangreburguer g = cangreburguers.get(i);
    g.update();
    g.draw();
    if(g.posY()<100)
    {
      cangreburguers.remove(i);
    }
    else if(g.posY()<400)
    {
      if(pecesPidiendo[0] == 1 && peces.get(0).esMia(g.posX()) == 1)
      {
        peces.get(0).ComeCangreburguer();
        cangreburguers.remove(i);
      }
      else if(pecesPidiendo[1] == 1 && peces.get(1).esMia(g.posX()) == 1)
      {
        peces.get(1).ComeCangreburguer();
        cangreburguers.remove(i);
      }
      else if(pecesPidiendo[2] == 1 && peces.get(2).esMia(g.posX()) == 1)
      {
        peces.get(2).ComeCangreburguer();
        cangreburguers.remove(i);
      }
      else if(pecesPidiendo[3] == 1 && peces.get(3).esMia(g.posX()) == 1)
      {
        peces.get(3).ComeCangreburguer();
        cangreburguers.remove(i);
      }
    }
  }
  
  for (int i = 0; i< NUM_PECES; i++)
  {
    Pez_Hambriento j = peces.get(i);
    
    if(pecesPidiendo[i]==1)
    {
      j.draw();
    }
    
    if(j.estoyLleno() == 1)
    {
      j.meVoy();
      pecesPidiendo[i] = 0;
    }
  }
  
  if(millis()-tiempo_anterior > periodo)
  {
    int encontrado=0;
    int pez_libre = 0;
    while((pez_libre < NUM_PECES) && (encontrado == 0))
    {
      if(pecesPidiendo[pez_libre] == 0)
      {
        encontrado = 1;
        pecesPidiendo[pez_libre] = 1;
      }
      else
      {
        pez_libre++;
      }
      tiempo_anterior = millis();
    }
  }
}

void mousePressed()
{
 creaCangreburguer(); 
}

void serialEvent(Serial p)
{
  String datoS = p.readString();
  datoS = datoS.trim();
  //println(datoS);
  if (datoS.equals("Knock!"))
  {
      //creaCangreburguer(int();
  }
}

void creaCangreburguer()
{
  cangreburguers.add(new Cangreburguer(random(2,5),
    mouseX, 
    850, 
    0.0, 
    0.0));
    println(cangreburguers.size());
}

void creaPez_Hambriento(int pez)
{
  peces.add(new Pez_Hambriento(pez));
}
