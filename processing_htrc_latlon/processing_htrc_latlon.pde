import com.reades.mapthing.*;
import net.divbyzero.gpx.*;
import net.divbyzero.gpx.parser.*;
import java.util.*;
import java.text.*;

BoundingBox envelope = new BoundingBox(4267, 90f, 180f, -90f, -180f);

PGraphics pg; //offscreen buffer renderer
PGraphics legendPg;
float[] glyphParam = new float[4];
PImage graph_img;
PImage logo;
int logoSize;
PImage bg;
Table csv_table;
PFont labelFont;
ArrayList <PGraphics> apg;
//PGraphics pgtext;

String savedate = "2012_1";

void setup() {
  //colorMode(HSB,360,100,100);
  int d = 4096;
  size(d,envelope.heightFromWidth(d),P3D);
  pg = createGraphics(1024,1024, P3D);    //initialize offscreen buffer
  legendPg = createGraphics(1024,1024,P3D);
  //pgtext = createGraphics(1024,1024, P3D);
  hint(DISABLE_DEPTH_TEST);                      //avoids z-fighting
  graph_img = loadImage("graphs/"+savedate+"_g.png");
  bg = loadImage("world_complex.jpg");
  logo = loadImage("htrc_logo.jpg");
  logoSize = 100;
  
  smooth();
  noLoop();  
}

void draw() {
  background(bg);
  fill(255);
  csv_table = loadTable("quarterly/"+savedate+".csv", "header");
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
  //shapeMode(CENTER);
  //pg.ellipseMode(CENTER);
  pg.background(0,0,0,0);
  //pg.rotateZ(-18*PI/180);
  //pg.fill(195,0,0,255);  // Hathi Trust red
  pg.fill(55,126,184,255);      // Blue
  pg.stroke(255,255,255,255);
  pg.strokeWeight(pg.width/20);
  pg.smooth(8);
  pg.ellipse(pg.width/2, pg.height/2, pg.width/2, pg.height/2);
  pg.endDraw();
  
  
  
  
  
  
  
  
  legendPg.beginDraw();
  legendPg.background(0,0,0,0);
  
  legendPg.fill(228,26,28,0);  // ColorBrewer Set1 red
  
  legendPg.stroke(255,255,255,255);
  legendPg.strokeWeight(pg.width/20);
  legendPg.smooth(8);
  //PShape stars = star(320,640, 100,260, 5);   // star ( x, y, inner radius , outer radius , points) 

  legendPg.ellipse(pg.width/2, pg.height/2, pg.width/2, pg.height/2);
  legendPg.endDraw();
  
  
  
  
  
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
  //println(csv_table.getRowCount() + " total rows in table"); 
  
  //Scale
  float max_sess = 3467335; 
  float min_sess = 1;
  float max_scale = 450;
  float min_scale = 10;
  int i = 0;

  max_sess = sqrt(max_sess);
  
  
  
  
  
  
  
  
  
  float legendSize = (((max_scale - min_scale)/(max_sess - min_sess))*(max_sess - max_sess)) + max_scale;
  float legendSizeSmall = (((max_scale - min_scale)/(max_sess - min_sess))*(sqrt(max_sess*max_sess/10) - max_sess)) + max_scale;
  
  
  float[][] legendCoordinates = {/*{-41.38053, 12.236328},*/
                                 /*{-180, -26.1},*/
                                 {-120, -26.1},
                                 {80.6, -26.1}}; // {longitude, latitude}
  
  
  
  //needed for map function
  int w_start = -180; //Longitude start - largest longitude value
  int w_end = 180; //Longitude end - smallest longitude value
  float h_start = 90; //Latitude start - largest latitude value
  float h_end = -90; //Latitude end - smallest latitude value
  
  
  
  for (int k = 0; k < legendCoordinates.length; k++)
  {
      circle_Tissot = createQuad(legendCoordinates[k][0],legendCoordinates[k][1],legendSize,legendSize,legendPg);
      shape(circle_Tissot);
  
      circle_Tissot = createQuad(legendCoordinates[k][0],legendCoordinates[k][1] - (180 * legendSizeSmall/width),legendSizeSmall,legendSizeSmall,legendPg);
      shape(circle_Tissot);
      
      
      float y = map(legendCoordinates[k][1], h_start, h_end, 0, height); //yvertex in pixel coordinates
      float x = map(legendCoordinates[k][0], w_start, w_end, 0, width); //yvertex in pixel coordinates
      /*
      image(logo, x - logoSize/2, y - 1.7*legendSize, logoSize, logoSize);
      */
      
      textAlign(CENTER);
      
      /*
      textSize(50);
      text("Hathi Trust", x, y - legendSize/1.25);
      
      textSize(40);
      text("Publications per Country", x, y - legendSize/2);
      */
      textSize(20);
      text(NumberFormat.getInstance().format((int)(max_sess*max_sess)), x, y - legendSize/3);
      text(NumberFormat.getInstance().format((int)(max_sess*max_sess/10)), x, y);
      
      textSize(40);
      text("Sessions", x, y + legendSize/2.5);
  }
  
  
  
  
  
  
  
  

  for (TableRow row : csv_table.rows()) 
  {
    float lon = row.getFloat("lon");
    float lat = row.getFloat("lat");
    float sess = row.getInt("sess");
    
    float norm = (((max_scale - min_scale)/(max_sess - min_sess))*(sqrt(sess) - max_sess)) + max_scale;
    //println("SESS MINUS " + ((sqrt(sess)-max_sess)*.005));
   
  
    circle_Tissot = createQuad(lon,lat,norm,norm,pg); 
    shape(circle_Tissot);
   
    //text_Tissot = createQuad(lon,lat,100,100,apg.get(i));
    //shape(text_Tissot);
   
    //String name = row.getString("name"); 
    //println(" lon="+lon+" : lat="+lat+" : sess="+sess+" : norm="+norm);
    //println(" max="+max_scale + " min="+min_scale +" maxsess"+ max_sess +" minsess="+ min_sess);
    i++;
  }
 

 int main_scoot = 704;
 image(graph_img, width-main_scoot,height/2.5,550,203);
 image(logo,width-main_scoot+225, height/2-402,100,100);
 
 image(graph_img, width/2-main_scoot,height/2.5,550,203);
 image(logo,width/2-main_scoot+225, height/2-402,100,100);
 
 fill(255);
 textAlign(CENTER, RIGHT);
 textSize(40);
 text("Hathi Trust ",width-main_scoot+275,height/2-250 );
 text("Hathi Trust",width/2-main_scoot+275, height/2-250 );
 textSize(20);
 text("Hathitrust.org quarterly web sessions: 2010 - 2014",width-main_scoot+275,height/2-210);
 text("Hathitrust.org quarterly web sessions: 2010 - 2014",width/2-main_scoot+275, height/2-210);
 
 saveFrame("output/"+savedate+".png"); 
 exit();
}

