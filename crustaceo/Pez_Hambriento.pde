class Pez_Hambriento
{
  float[] _x = {350,650,1020,1308};
  float[] _y = {193,170,182,95};
  float[] _d1 = {236,303,230,362};
  float[] _d2 = {279,296,283,366};
  PImage[] foto = {loadImage("pez_hambriento1.png"),loadImage("pez_hambriento2.png"),loadImage("pez_hambriento3.png"),loadImage("pez_hambriento4_Patri.png")};
  int[] _cpedidas = {1,3,2,4};
  int[] _obtenidas = {0,0,0,0};
  float[] _princEsp = {275,600,950,1250};
  float[] _finalEsp = {525,900,1200,1600};
  float _pe,_fe;
  int _personaje;
  
  Pez_Hambriento( int personaje)
  {
    _personaje = personaje;
  }
  
  void draw()
  {
    push();
    image(foto[_personaje], _x[_personaje], _y[_personaje], _d1[_personaje], _d2[_personaje]);
    pop();
  }
  void ComeCangreburguer(){
    if(_obtenidas[_personaje]<_cpedidas[_personaje]){
      _obtenidas[_personaje]=_obtenidas[_personaje]+1;
    }
  }
  int estoyLleno(){
    if(_obtenidas[_personaje]==_cpedidas[_personaje]){
      return 1;
    }else{
      return 0;
    }
  }
}
