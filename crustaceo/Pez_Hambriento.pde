class Pez_Hambriento
{
  float[] _x = {350,650,1020,1308};            //Posición en x de los personajes
  float[] _y = {193,170,182,95};               //Posición en y de los personajes
  float[] _d1 = {236,303,230,362};             //Dimensión 1 de la foto de los personajes
  float[] _d2 = {279,296,283,366};             //Dimensión 2 de la foto de los personajes
  //Fotos equivalentes a cada personaje:
  PImage[] foto = {loadImage("pez_hambriento1.png"),loadImage("pez_hambriento2.png"),loadImage("pez_hambriento3.png"),loadImage("pez_hambriento4_Patri.png")};
  int[] _cpedidas = {1,3,2,4};                 //Número de cangreburguers que cada personaje pide
  int[] _obtenidas = {0,0,0,0};                //Número de cangreburguers iniciales que tiene cada personaje
  float[] _princEsp = {275,600,950,1250};      //Límite inicial del espacio que se considera que una cangreburguer pertenece a un personaje u otro
  float[] _finalEsp = {525,900,1200,1600};     //Límite final del espacio que se considera que una cangreburguer pertenece a un personaje u otro
  int _personaje;                              //ID del personaje
  
  Pez_Hambriento( int personaje)
  {
    _personaje = personaje;
  }
  
  //Funcion de dibujo de los personajes
  void draw()
  {
    push();
    image(foto[_personaje], _x[_personaje], _y[_personaje], _d1[_personaje], _d2[_personaje]);
    pop();
  }
  
  //Función que incrementa el valor de las cangreburguers que ha pedido un personaje
  void ComeCangreburguer(){
    if(_obtenidas[_personaje]<_cpedidas[_personaje])
    {
      _obtenidas[_personaje]++;                //Incrementa en 1 el valor
    }
  }
  
  //Función que pone a 0 el valor de cangreburguers que tiene el personaje
  void meVoy()
  {
    _obtenidas[_personaje] = 0;
  }
  
  //Función que devuelve si el personaje ha completado su pedido
  int estoyLleno()
  {
    if(_obtenidas[_personaje]==_cpedidas[_personaje])
    {
      return 1;
    }
    else
    {
      return 0;
    }
  }
  
  //Devuelve 1 si la cangreburguer se encuentra en el espacio del personaje
  int esMia(float posX)
  {
    if(posX >= _princEsp[_personaje] && posX <= _finalEsp[_personaje])
    {
      return 1;
    }
    else
    {
      return 0;
    }
  }
}
