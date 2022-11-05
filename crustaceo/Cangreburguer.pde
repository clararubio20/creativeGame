class Cangreburguer
{
  PImage hamburguesa;
  float _d, _x, _y, _vx, _vy;
  SoundFile sonido_cocinado;
  Cangreburguer(float dimension, float x, float y, float vx, float vy)
  {
    _d = dimension;
    _x = x;
    _y = y;
    _vx = vx;
    _vy = vy;
  }
  //Actualiza la posición y velocidad
  void update()
  {
    _vy -= random(0.07, 0.1);
    _vx += 0;
    _x = _x + _vx;
    _y = _y + _vy;
  }
  void draw()
  {
    hamburguesa = loadImage("hamburguesa.png");
    push();
    image(hamburguesa, _x, _y, 250/_d, 250/_d);
    pop();
    
  }
  //Devuelve la posición en Y de la cangreburguer
  float posY()
  {
    return _y;
  }
  //Devuelve la posición en X de la cangreburguer
  float posX()
  {
    return _x;
  }
}
