//  more SVG info at:
//  http://www.w3.org/TR/SVG/painting.html
//  http://www.w3.org/TR/SVG/paths.html

Data data;
String r = "\r";
String t = "\t";

int sW = 640;
int sH = 480;
color bgColor = color(0);
color fillColor = color(150);
color strokeColor = color(150, 0, 0);
int strkwidth = 2;
float alphaNum = 0.3;

int numPathReps = 100;
int numCurveReps = 30;
boolean isClosed = true;

//~~~~~~~~~~~~~~
PVector d1 = new PVector(3, 10);  //0-infinite, amount of basic direction shift
PVector d3 = new PVector(10,3); //0-infinite, multiplier of spike 
//--
PVector d2 = new PVector(0.1, 0.9);  //0-1, odds of major spike
PVector d4 = new PVector(0.5,0.2); //0-1, odds of directon shift being negative
//~~~~~~~~~~~~~~

PVector p = new PVector(0, 0);
PShape shp;
boolean svgExists = false;

void setup() {
  size(sW, sH);
  smooth();
  doSvg();
}

void draw() {
  background(bgColor);
  if (svgExists) {
    shape(shp, 0, 0);
  }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void keyPressed() {
  if (key==' ') {
    doSvg();
  }
}

void doSvg() {
  makeSvg(fillColor, strokeColor, strkwidth, alphaNum, numPathReps, numCurveReps, isClosed);
  svgExists = true;
  shp = loadShape("foo.svg");
}

void makeSvg(color _fc, color _sc, int _sw, float _an, int _npr, int _ncr, boolean _cl) {
  fillColor = color(random(255), random(255), random(255));
  strokeColor = color(random(255), random(255), random(255));
  strkwidth = int(random(1, 10));
  beginSvg();
  for (int i=0;i<_npr;i++) {
    pathSvg(_fc, _sc, _sw, _an, _ncr, _cl);
  }
  cSvg();
}

void beginSvg() {
  data = new Data();
  data.beginSave();
  data.add("<?xml version=\"1.0\" encoding=\"utf-8\"?>" + r);
  data.add("<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">" + r);
  data.add("<svg version=\"1.1\" id=\"Layer_1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" x=\"0px\" y=\"0px\"" + r);
  data.add(t + "width=\"" + sW + "px\" height=\"" + sH + "px\" viewBox=\"0 0 " + sW + " " + sH + "\" enable-background=\"new 0 0 " + sW + " " + sH +"\" xml:space=\"preserve\">" + r);
}

void pathSvg(color _fc, color _sc, int _sw, float _an, int _ncr, boolean _cl) {
  data.add("<path fill=\""+ rgbToHex(_fc) + "\" stroke=\""+ rgbToHex(_sc) + "\" stroke-width=\"" + _sw + "\" fill-opacity=\"" + _an + "\" stroke-opacity=\"" + _an + "\" d=\"");
  String q = pathGenerator(_ncr, _cl);
  println(q);
  data.add(q);
  data.add("\"/>");
}

void cSvg() {
  data.add("</svg>" + r);
  data.endSave("foo.svg");
}

String pathGenerator(int _ncr, boolean closed) {
  String path = "";

  for (int i=0;i<_ncr;i++) {
    if (i==0) {
      //origin point X Y
      p = new PVector(rounder(random(sW), 3), rounder(random(sH), 3));
      path += "M" + p.x + "," + p.y + ",";
    } 
    else if (i==_ncr-1) {
      //final curve returns to origin
        path += "C"; // = absolute bezier coords
        path += p.x + changeDir(0); //0 means always a comma
        path += p.y + changeDir(0);
        path += p.x + changeDir(0);
        path += p.y + changeDir(0);
        path += p.x + changeDir(0);
        path += p.y;
        if(closed){
          path += "z";
        }
    } 
    else {
      //middle curves, X1, Y1, X2, Y2, CX, CY
      path += "c";  // = relative bezier coords
      path += rndVec().x + changeDir(d4.x);
      path += rndVec().y + changeDir(d4.y);
      path += rndVec().x + changeDir(d4.x);
      path += rndVec().y + changeDir(d4.y);
      path += rndVec().x + changeDir(d4.x);
      path += rndVec().y + ",";
      }
    }
  return path;
}

String changeDir(float _odds){
if(random(1)<_odds){
  return "-";
}else{
  return ",";
}
}

PVector rndVec(){
PVector q = new PVector(rounder(random(d1.x), 3), rounder(random(d1.y), 3));
if (random(1)<d2.x) q.x *= d3.x;
if (random(1)<d2.y) q.y *= d3.y;
return q;
}

String rgbToHex(color c) {
  return "#" + hex(c, 6);
}

float rounder(float _val, float _places) {
  _val *= pow(10, _places);
  _val = round(_val);
  _val /= pow(10, _places);
  return _val;
}


