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
PImage fondo_comienzo;                       //Guarda el fondo de pantalla del inicio
int comienzo = 0;                            //Está a 0 si sigue la pantalla de inicio y no se ha iniciado el juego
PImage fondo_perder, fondo_ganar;            //Fondos de pantalla finales (caso perder y ganar)
int ganado = 0, perdido = 0;                 //Variables de control de estado final
int segundos = 60;                           //Contador de tiempo
int segundo = 1000;                          //Un segundo
long tiempo_anterior2 = 0;                   //Guarda la última vez que un pez entró al crustaceo
import processing.serial.*;
ArrayList<Cangreburguer> cangreburguers;     //Guarda todas las cangreburguers que se creen
ArrayList<Pez_Hambriento> peces;             //Guarda los 4 peces hambrientos de la escena
Serial myPort;
long tiempo_anterior = 0;                    //Guarda la última vez que un pez entró al crustaceo
long periodo = 2000;                         //Periodo de aparición de nuevos peces
int[] pecesPidiendo;                         //Array que guarda si los peces están en escena (1) o no están pidiendo (0)
int NUM_PECES = 4;                           //Número de peces máximo
int cont_peces_satisfechos = 0;              //Cuenta el número de peces que ya se han ido

void setup()
{
  //Inicialización fondos de pantalla
  size(2166,1080);                                    //Tamaño de la imagen de fondo
  fondo_comienzo = loadImage("fondo_principio.jpg");  //Carga la imagen de fondo del comienzo
  fondo = new PImage[4];
  fondo[0] = loadImage("fondo.jpg");                  //Carga la imagen de fondo
  fondo[1] = loadImage("fondo1.jpg");                 //Carga la imagen de fondo con una estrella
  fondo[2] = loadImage("fondo2.jpg");                 //Carga la imagen de fondo con dos estrella
  fondo[3] = loadImage("fondo3.jpg");                 //Carga la imagen de fondo con tres estrella
  fondo_perder = loadImage("fondo_perder.jpg");       //Carga la imagen de fondo en el caso de perder
  fondo_ganar = loadImage("fondo_ganar.jpg");         //Carga la imagen de fondo en el caso de ganar
  
  textSize(35);                                       //Tamaño del texto del marcador
  
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
  
  sonido_cocinado = new SoundFile(this,"sonido_carne.aiff");  //Carga sonido de cocinado de la carne 
  
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600); 
  myPort.bufferUntil(10);
  myPort.clear();
}

void draw()
{
  //Si no se ha iniciado el juego, se dibuja el fondo de comienzo
  if(comienzo == 0)
  {
    background(fondo_comienzo);
  }
  //Si se ha acabado el tiempo, se activa el estado y fondo correspondiente
  else if(segundos <= 0)
  {
    //Caso ganador
    if(cont_estrellas == 3)
    {
      ganado = 1;
      background(fondo_ganar);
    }
    //Caso perdedor
    else
    {
      perdido = 1;
      background(fondo_perder);
    }
  }
  //Modo juego
  else
  {
    background(fondo[cont_estrellas]);  //Carga la imagen de fondo para que esté siempre por debajo de los objetos que se crean
    
    //Actualizo los datos del marcador
    actualizaTiempo();
    actualizaMarcador();
    
    //Se dibujan a los peces que estén en escena y se comprueba si están llenos
    for (int i = 0; i< NUM_PECES; i++)
    {
      Pez_Hambriento j = peces.get(i);
      
      //Si los peces están en escena los redibujo
      if(pecesPidiendo[i]==1)
      {
        j.draw();
      }
      compruebaClienteSatisfecho(j, i);
    }
    
    //Se actualizan las cangreburguers y se comprueba si han llegado a algún destino (final o pez)
    for (int i = 0; i<cangreburguers.size(); i++)
    {
      Cangreburguer g = cangreburguers.get(i);
      g.update();
      g.draw();
      destinoCangreburguer(g, i);
    }
    
    //Se crean los peces pasados un tiempo en el lugar libre
    creaPez();
  }
}

//Función que se activa al hacer click con el ratón
void mousePressed()
{
  //Si está activa la pantalla de inicio, inicia el juego
  if(comienzo == 0)
  {
    comienzo = 1;
  }
  //Si se ha ganado o perdido, se termina el juego
  else if(ganado == 1)
  {
    exit();
  }
  else if(perdido == 1)
  {
    exit();
  }
  //Crea una cangreburguer
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

//Función de actualización y escritura de tiempo en el marcador
void actualizaTiempo()
{
  //Si ha pasado un segundo se resta
  if(millis() - tiempo_anterior2 > segundo)
  {
    segundos--;
    tiempo_anterior2 = millis();
  }
  
  //Se escribe en el marcador
  if(segundos < 10)
  {
    text(segundos, 1282, 56);                   //Posición para 1 cifra
  }
  else
  {
    text(segundos, 1271, 56);                   //Posición para 2 cifras
  }
}

//Función que actualiza el marcador de los peces satisfechos
void actualizaMarcador()
{
  if(cont_peces_satisfechos >= 10)
  {
    text(cont_peces_satisfechos, 1115, 60);    //Escribe el número de peces satisfechos en el marcador ajustado a valores de dos cifras
  }
  else 
  {
    text(cont_peces_satisfechos, 1127, 60);    //Escribe el número de peces satisfechos en el marcador ajustado a valores de una cifra
  }
}

//Comprueba si algún cliente se ha llenado y actualiza el marcador de estrellas
void compruebaClienteSatisfecho(Pez_Hambriento j, int id)
{
  //Si han conseguido todas las cangreburguers que pedían se van
  if(j.estoyLleno() == 1)
  {
    j.meVoy();
    mmm = new SoundFile(this,(int)random(1,numsounds+1) + ".aiff");
    mmm.play();
    pecesPidiendo[id] = 0;
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

void creaPez()
{
  //Se crea un pez cada periodo en el espacio que no haya ninguno
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

//Comprueba si alguna cangreburguer ha llegado a un pez en escena o al final
void destinoCangreburguer(Cangreburguer g, int id)
{
  //Si la cangreburguer llega hasta arriba se elimina
  if(g.posY()<100)
  {
    cangreburguers.remove(id);
  }
  //Si la cangreburguer llega a la línea dónde se encuentran los personajes se comprueba si es de alguien
  else if(g.posY()<400)
  {
    //Los peces deben estar en la escena para comer
    //Si comen se elimina la cangreburguer
    if(pecesPidiendo[0] == 1 && peces.get(0).esMia(g.posX()) == 1)
    {
      peces.get(0).ComeCangreburguer();
      cangreburguers.remove(id);
    }
    else if(pecesPidiendo[1] == 1 && peces.get(1).esMia(g.posX()) == 1)
    {
      peces.get(1).ComeCangreburguer();
      cangreburguers.remove(id);
    }
    else if(pecesPidiendo[2] == 1 && peces.get(2).esMia(g.posX()) == 1)
    {
      peces.get(2).ComeCangreburguer();
      cangreburguers.remove(id);
    }
    else if(pecesPidiendo[3] == 1 && peces.get(3).esMia(g.posX()) == 1)
    {
      peces.get(3).ComeCangreburguer();
      cangreburguers.remove(id);
    }
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
