//Created by the Advanced Visualization Laboratory at Indiana University
//Created by Karla Vega
//Processing 2.1.1 

public float scaleDistortion(float phi, float semiMinor){
//This function calculates distortion according to Tissot Indicatrix
//phi - latitude
//semiMinor - usually assumed to be 1
//reference: J. P. Snyder. Map Projections: A Working Manual. U.S. Geological Survey Professional Paper 1395, pages 154–163, 1987.

  float P = phi*PI/180.0;
  float w = asin(abs(cos(P) -1)/(cos(P)+1));
  float b = semiMinor;
  float a;
  
  if(abs(phi) >= 90){
    a = 360;
  } else{
    a = (-b*(sin(w)+1))/(sin(w)-1);
  }

  return a;
}
