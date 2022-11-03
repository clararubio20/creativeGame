class Cangreburguer
{
  PImage hamburguesa;
  float _d, _x, _y, _vx, _vy;
  Cangreburguer(float dimension, float x, float y, float vx, float vy)
  {
    _d = dimension;
    _x = x;
    _y = y;
    _vx = vx;
    _vy = vy;
  }
  void update()
  {
    _vy -= random(0.03, 0.05);
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
  float posY(){
    return _y;
  }
  float posX(){
    return _x;
  }
}
