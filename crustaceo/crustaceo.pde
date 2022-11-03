// Luis Molina-Tanco - 2021. 
// 
// Ejemplo uso puerto serie. 
//
// Este programa está pensado para funcionar con un arduino
// que esté ejecutando el ejemplo Knock, que se puede
// ver aquí:
//
// https://www.arduino.cc/en/Tutorial/BuiltInExamples/Knock

PImage fondo;
import processing.serial.*;
ArrayList<Cangreburguer> cangreburguers;
ArrayList<Pez_Hambriento> peces;
Serial myPort;
int cont = 0;
long tiempo_anterior = 0;
long periodo = 3000;
int[] pecesPidiendo;
int[] cangreburguersConseguidas;
float[] _princEsp = {275,600,950,1250};
float[] _finalEsp = {525,900,1200,1600};

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
  cangreburguersConseguidas = new int[4];
  for(int i = 0; i<4;i++){
    pecesPidiendo[i] = 0;
    cangreburguersConseguidas[i] = 0;
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
      if(g.posX()<525 && g.posX()>275 && pecesPidiendo[0] == 1)
      {
        cangreburguersConseguidas[0]++;
        cangreburguers.remove(i);
      }
      else if(g.posX()<900 && g.posX()>600 && pecesPidiendo[1] == 1)
      {
        cangreburguersConseguidas[1]++;
        cangreburguers.remove(i);
      }
      else if(g.posX()<1200 && g.posX()>950 && pecesPidiendo[2] == 1)
      {
        cangreburguersConseguidas[2]++;
        cangreburguers.remove(i);
      }
      else if(g.posX()<1600 && g.posX()>1250 && pecesPidiendo[3] == 1)
      {
        cangreburguersConseguidas[3]++;
        cangreburguers.remove(i);
      }
      
    }
  }
  for (int i = 0; i<peces.size(); i++)
  {
    Pez_Hambriento j = peces.get(i);
    if(pecesPidiendo[i]==1)
    {
      j.draw();
    }
    if(cangreburguersConseguidas[i]!=0)
    {
      j.ComeCangreburguer();
      cangreburguersConseguidas[i]--;
    }
    if(j.estoyLleno() == 1)
    {
      j.meVoy();
      pecesPidiendo[i]=0;
    }
  }
  
  if(millis()-tiempo_anterior > periodo)
  {
    int encontrado=0;
    int pez_libre = 0;
    while((pez_libre < 4) && (encontrado == 0))
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
 creaCangreburguer(mouseX,mouseY); 
}

void serialEvent(Serial p)
{
  String datoS = p.readString();
  datoS = datoS.trim();
  //println(datoS);
  if (datoS.equals("Knock!"))
  {
      //creaCangreburguer(int(random(0,width)),height-100);
  }
}

void creaCangreburguer(int x, int y)
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
