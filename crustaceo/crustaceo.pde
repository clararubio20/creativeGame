//
// Clara Rubio Almagro y Laura Sánchez Sánchez 
// 
// Código de ejercicio de la asignatura electrónica creatima de la ETSIT UMA
//
// Simula el típico juego de preparación de comida mediante el uso de un piezoeléctrico
// conectado a un arduino
//

import processing.sound.*;
SoundFile sonido_cocinado;                   //Sonido que hace la hamburguesa al cocinarse
SoundFile mmm;                               //Sonido que hacen los peces al irse
int numsounds = 3;                           //Número de sonidos que hacen los peces al irse
PImage[] fondo;                              //Guarda el fondo de pantalla
int cont_estrellas = 0;                      //Contador de la puntuación
PImage fondo_comienzo;
int comienzo = 0;
int segundos = 60;
int segundo = 1000;
long tiempo_anterior2;                    //Guarda la última vez que un pez entró al crustaceo
import processing.serial.*;
ArrayList<Cangreburguer> cangreburguers;     //Guarda todas las cangreburguers que se creen
ArrayList<Pez_Hambriento> peces;             //Guarda los 4 peces hambrientos de la escena
Serial myPort;
long tiempo_anterior;                    //Guarda la última vez que un pez entró al crustaceo
long periodo = 2000;                         //Periodo de aparición de nuevos peces
int[] pecesPidiendo;                         //Array que guarda si los peces están en escena (1) o no están pidiendo (0)
int NUM_PECES = 4;                           //Número de peces máximo
int cont_peces_satisfechos = 0;              //Cuenta el número de peces que ya se han ido

void setup()
{
  size(2166,1080);                           //Tamaño de la imagen de fondo
  fondo_comienzo = loadImage("fondo_principio.jpg");
    
  fondo = new PImage[4];
  fondo[0] = loadImage("fondo.jpg");         //Carga la imagen de fondo
  fondo[1] = loadImage("fondo1.jpg");        //Carga la imagen de fondo con una estrella
  fondo[2] = loadImage("fondo2.jpg");        //Carga la imagen de fondo con dos estrella
  fondo[3] = loadImage("fondo3.jpg");        //Carga la imagen de fondo con tres estrella
  background(fondo[cont_estrellas]);         //Muestra la imagen de fondo
  
  textSize(35);                              //Tamaño del texto
  
  cangreburguers = new ArrayList<Cangreburguer>();    //Crea el array de tipo cangreburguer
  peces = new ArrayList<Pez_Hambriento>();            //Crea el array de tipo pez hambriento
  
  //Crea los 4 peces que participan en el juego
  for(int i= 0; i<4;i++)
  {
    creaPez_Hambriento(i);
  }
  //Inicializa los valores de peces pidiendo a 0
  pecesPidiendo = new int[4];
  for(int i = 0; i<4;i++)
  {
    pecesPidiendo[i] = 0;
  }
  
  sonido_cocinado = new SoundFile(this,"sonido_carne.aiff");
  
  tiempo_anterior = 0;
  
  
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600); 
  myPort.bufferUntil(10);
  myPort.clear();
}

void draw()
{
  if(comienzo == 0)
  {
    background(fondo_comienzo);
  }
  else
  {
  background(fondo[cont_estrellas]);  //Carga la imagen de fondo para que esté siempre por debajo de los objetos que se crean
  
  if(millis() - tiempo_anterior2 > segundo)
  {
    segundos--;
    tiempo_anterior2 = millis();
  }
  
  if(segundos < 10)
  {
    text(segundos, 1282, 56);
  }
  else
  {
    text(segundos, 1271, 56);
  }
  
  if(cont_peces_satisfechos >= 10)
  {
    text(cont_peces_satisfechos, 1115, 60);    //Escribe el número de peces satisfechos en el marcador ajustado a valores de dos cifras
  }
  else 
  {
    text(cont_peces_satisfechos, 1127, 60);    //Escribe el número de peces satisfechos en el marcador ajustado a valores de una cifra
  }
  
  for (int i = 0; i< NUM_PECES; i++)
  {
    Pez_Hambriento j = peces.get(i);
    
    //Si los peces están en escena los redibujo
    if(pecesPidiendo[i]==1)
    {
      j.draw();
    }
    
    //Si han conseguido todas las cangreburguers que pedían se van
    if(j.estoyLleno() == 1)
    {
      j.meVoy();
      mmm = new SoundFile(this,(int)random(1,numsounds+1) + ".aiff");
      mmm.play();
      pecesPidiendo[i] = 0;
      cont_peces_satisfechos++;
    }
    
    //Si consigue más clientes, consigue 1 estrella más
    if(cont_peces_satisfechos == 10)
    {
      cont_estrellas = 1;
    }
    else if(cont_peces_satisfechos == 15)
    {
      cont_estrellas = 2;
    }
    else if(cont_peces_satisfechos == 20)
    {
      cont_estrellas = 3;
    }
  }
  
  for (int i = 0; i<cangreburguers.size(); i++)
  {
    Cangreburguer g = cangreburguers.get(i);
    g.update();
    g.draw();
    
    //Si la cangreburguer llega hasta arriba se elimina
    if(g.posY()<100)
    {
      cangreburguers.remove(i);
    }
    //Si la cangreburguer llega a la línea dónde se encuentran los personajes compruebo si es de alguien
    else if(g.posY()<400)
    {
      //Los peces deben estar en la escena para comer
      //Si comen se elimina la cangreburguer
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
  
  //Creamos un pez cada periodo en el espacio que no haya ninguno
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
}

//Si se presiona el ratón crea una cangreburguer
void mousePressed()
{
  if(comienzo == 0)
  {
    comienzo = 1;
  }
  else
  {
    creaCangreburguer();
  }
}

//Si recibe un knock crea una cangreburguer
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

//Crea las cangreburguers de un tamaño random, a partir de la y = 850
//y la posición x del ratón
void creaCangreburguer()
{
  cangreburguers.add(new Cangreburguer(random(2,5),
    mouseX, 
    850, 
    0.0, 
    0.0));
    println(cangreburguers.size());
    
    sonido_cocinado.play();
}

//Crea el pez pasado por parámetro (según su posición de izquierda a derecha)
void creaPez_Hambriento(int pez)
{
  peces.add(new Pez_Hambriento(pez));
}
