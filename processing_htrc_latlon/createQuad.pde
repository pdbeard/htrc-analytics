//Created by the Advanced Visualization Laboratory at Indiana University
//Created by Karla Vega
//Processing 2.1.1 

public PShape createQuad(float px_, float py_,float sizex_, float sizey_, PImage image){
  
//This function returns a quad strip
//px_, py_ - location of quad in degrees, lat, lon
//sizex_, sizey_ - width and height of quadstrip
//image - texture to apply

//This function uses the Tissot Indicatrix method

  float px = px_; //Longitude in degrees
  float py = py_; //Latitude in degrees
  float sizeX = sizex_;     //width of the quadstrip
  float sizeY = sizey_;    //height of quadstrip
  float sizeYD = sizeY*180/height; //size of Y in degrees
  float sizeXD = sizeX*360/width; //size of X in degrees
  float res = sizeY; //resolution of the quad strip in degrees
  PShape quadStrip;
  PImage tex = image; //Texture
  
  //needed for map function
  int w_start = 180; //Longitude start - largest longitude value
  int w_end = -180; //Longitude end - smallest longitude value
  float h_start = 90; //Latitude start - largest latitude value
  float h_end = -90; //Latitude end - smallest latitude value
  
  quadStrip = createShape();
  quadStrip.beginShape(QUAD_STRIP);
  quadStrip.textureMode(NORMAL);
  quadStrip.texture(tex);
  quadStrip.noStroke();
  quadStrip.fill(0, 0, 255);
  
  for(float j = 0; j <= sizeY; j = j+(sizeY/res)){
      
      
      float ytemp = py + sizeYD/2 - (j*180/height);
      
      //Use scale distortion formula to calculate the distortion along the latitude
      float scale = scaleDistortion(ytemp, sizeY/res);
      
      //Since this methods assumes an infinitesimally small sphere, adjust the following
      //Parameter depending on the size of the quad. Range would be from 1/1 to 1/8.
      //the smaller the param number, the smaller the observed distortion.
      float param = 1/1;
      
      //Use this for small quads
      float sizeXDp = sizeXD*scale;
      
      //Use this for larger quads (param ~! than 1/1)
      //float param = 1/8;
      //float sizeXDp = sizeXD*pow(scale,param);
      
      float yvertex = map(ytemp, h_start, h_end, 0, height); //yvertex in pixel coordinates
      float xvertex1 = map((px - sizeXDp/2), w_end, w_start, 0, width); //xvertex1 in pixel coordinates
      float xvertex2 = map((px + sizeXDp/2), w_end, w_start, 0, width); //xvertex2 in pixel coordinates    
      
      quadStrip.vertex(xvertex1, yvertex, 0, j/sizeY);
      quadStrip.vertex(xvertex2, yvertex, 1, j/sizeY);
    }
    quadStrip.endShape(CLOSE);
  
  return quadStrip;
}


