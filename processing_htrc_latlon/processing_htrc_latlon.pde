import com.reades.mapthing.*;
import net.divbyzero.gpx.*;
import net.divbyzero.gpx.parser.*;
import java.util.*;

BoundingBox envelope = new BoundingBox(4267, 90f, 180f, -90f, -180f);

PGraphics pg; //offscreen buffer renderer
float[] glyphParam = new float[4];
PImage shape_img;
PImage bg;
Table csv_table;
PFont labelFont;
ArrayList <PGraphics> apg;
//PGraphics pgtext;

void setup() {
  colorMode(HSB,360,100,100);
  int d = 4096;
  size(d,envelope.heightFromWidth(d),P3D);
  pg = createGraphics(1024,1024, P3D);    //initialize offscreen buffer
  //pgtext = createGraphics(1024,1024, P3D);
  hint(DISABLE_DEPTH_TEST);                      //avoids z-fighting
  //shape_img = loadImage("shape.png");
  bg = loadImage("world_complex.jpg");
  
  smooth();
  noLoop();  
}

void draw() {
  background(bg);
  fill(255);
  csv_table = loadTable("quarterly/2010_1.csv", "header");
  apg = new ArrayList<PGraphics>(); 
  pg.beginDraw();
  
  //Labels

  for (TableRow row : csv_table.rows())
  {
    float sess = row.getInt("sess");
    
    pg.fill(0,102,153);
    pg.textAlign(CENTER, CENTER); 
    pg.textSize(1000);
    pg.text(sess,512,512);
    apg.add(pg);
  } 
  println("APG SIZE = "+apg.size());
  
  pg.clear();
   
  //Create an offscreen render ellipse to be warped
  pg.background(0,0,0,0);
  pg.rotateZ(-18*PI/180);
  pg.fill(195,0,0,255);  // Hathi Trust red
  pg.stroke(255,255,255,255);
  pg.strokeWeight(pg.width/20);
  pg.smooth(8);
  pg.ellipse(pg.width/2, pg.height/2, pg.width/2, pg.height/2);
  pg.endDraw();
  
  
  //Create an offscreen render ellipse to be warped
  //pg.beginDraw();
  //pg.background(0,0,255,0);
  //

  //int oHeight = shape_img.height;
  //int oWidth  = shape_img.width;
  //shape_img.resize(pg.width, pg.height);

  //pg.image(shape_img, -(oWidth/2), oHeight/2);   //uncomment to show image
  //pg.endDraw();
  
 ///////////////////////////METHOD ONE///////////////////////////////////
 // Create quadStrip using method 1: Fish Eye Lense Algorithm          //
 // two files needed for this are getQuadStrip and C2SOS               //
 ////////////////////////////////////////////////////////////////////////
 
  PShape quadStrip1, quadStrip2, quadStrip3, quadStrip4; // Initialize Quads
  float sizeQuadX = 25.0;                                // size of quad x direction
  float sizeQuadY = 25.0;                                // size of quad y direction
  float resQuad = sizeQuadY;                             // y resolution of image
  
  for(int j = (30*width/360); j<=(330*width/360); j=j+(30*width/360))
  {  
    for(int i = (30*height/180); i<=(150*height/180); i=i+(30*height/180))
    {
      PShape quadStrip; // initialize shape
      //USAGE: quadStrip =   getQuadStrip(x-position, y-postion, sizeQuadX, sizeQuadY, resQuad, image to warp);
      quadStrip =   getQuadStrip(j, i-resQuad, sizeQuadX, sizeQuadY, resQuad, pg);
      //Uncomment to render
      //shape(quadStrip);
    }
  }

 
  PShape circle_Tissot; //initialize shape
  PShape text_Tissot;
  println(csv_table.getRowCount() + " total rows in table"); 
  
  //Scale
  float max_sess = 3856316; 
  float min_sess = 1;
  float max_scale = 200;
  float min_scale = 30;
  int i = 0;

  max_sess = sqrt(max_sess);

  for (TableRow row : csv_table.rows()) 
  {
    float lon = row.getFloat("lon");
    float lat = row.getFloat("lat");
    float sess = row.getInt("sess");
    
    float norm = (((max_scale - min_scale)/(max_sess - min_sess))*(sqrt(sess) - max_sess)) + max_scale;
    println("SESS MINUS " + ((sqrt(sess)-max_sess)*.005));
   
  
    circle_Tissot = createQuad(lon,lat,norm,norm,pg); 
    shape(circle_Tissot);
   
    text_Tissot = createQuad(lon,lat,100,100,apg.get(i));
    //shape(text_Tissot);
   
    //String name = row.getString("name"); 
    println(" lon="+lon+" : lat="+lat+" : sess="+sess+" : norm="+norm);
    println(" max="+max_scale + " min="+min_scale +" maxsess"+ max_sess +" minsess="+ min_sess);
    i++;
  }

 saveFrame("output/2010_1.png"); 
 //exit();
}
