//------ Legend for HTRC
// Need Relative Text Sizing
// Automate csv switching?
// Percentage based text?

PShape total;
PShape usa;
PShape max;
PImage bg;
Table csv_table;

//vars
float max_sess  = 3856316; //Find Max Session for all data
float max_scale = 300;     //Largest Circle 
int line_size = 300;       //Underlining line length for labels
float min_sess  = 0;       //not used
float min_scale = 0;       //not used

float total_sessions;
float usa_sessions;
float total_norm;
float usa_norm;

float usa_move;
float total_move;
float half_move;
float quarter_move;


void setup()
{
  size(800,800,P2D);
  bg = loadImage("trans.png");

//
//------ Start Scale
//  

  //Gets first row data for USA (Should search by lat and lon coords instead of first row *technically*) 
  csv_table = loadTable("quarterly/2014_3.csv", "header");
  TableRow getUSA = csv_table.getRow(0);
  usa_sessions = getUSA.getInt("sess");
  
  //Adds all sessions together
  for (TableRow row : csv_table.rows())
  {
    float sess = row.getInt("sess");
    total_sessions = total_sessions + sess;
  } 
  
  //Doesn't need the max/min sessions or scale. But It looks fancy.  #stylepoints
  //total_norm = max_scale;
  total_norm = (((max_scale - min_scale)/(max_sess - min_sess))*(total_sessions - max_sess)) + max_scale;
  usa_norm   = (((max_scale - min_scale)/(max_sess - min_sess))*(usa_sessions - max_sess)) + max_scale;
  
  //Prints useful data
  println("Total Sessions = "+total_sessions+" USA Sessions = "+usa_sessions);
  println("total norm = " +total_norm + " Usa norm = " +usa_norm);

//
//------ End Scale
//

  //Move variables
  usa_move     = (max_scale-usa_norm)/2;
  total_move   = (max_scale-total_norm)/2;
  quarter_move = max_scale/4;
  half_move    = max_scale/2;
  
  //Create Shapes
  shapeMode(CENTER);
  
  max = createShape(ELLIPSE,width/3,height/2,max_scale,max_scale);
  max.setStrokeWeight(4);
  
  total = createShape(ELLIPSE,width/3,height/2+total_move,total_norm,total_norm);
  total.setFill(color(195,0,0,255));
  total.setStrokeWeight(4);
  
  usa = createShape(ELLIPSE,width/3,height/2+usa_move,usa_norm,usa_norm);
  usa.setStrokeWeight(4);
}


void draw()
{
 background(bg);
 textAlign(CENTER,CENTER);
 noLoop();
 
 //Removes Trailing zeros in float values
 String max_text   = new java.text.DecimalFormat("#").format(max_sess);
 String total_text = new java.text.DecimalFormat("#").format(total_sessions);
 String usa_text   = new java.text.DecimalFormat("#").format(usa_sessions);
 
 //Max Session Circle Properties
 shape(max);
 fill(0);
 textSize(35);
 text(max_text, width/3, height/2-quarter_move);
 
 //Total Session Circle Properties
 shape(total);
 fill(255);
 textSize(20);
 text(total_text, width/3, height/2+total_move-(total_norm/4));
 
 //USA Session Circle Properties
 shape(usa);
 fill(0);
 textSize(15);
 text(usa_text, width/3, height/2+usa_move);
 
 //Label Line Properties
 strokeWeight(4);
 stroke(0);
 line(width/3+half_move-20,height/2.5,width/3+half_move+line_size,height/2.5); //Bring in clear variables
 line(width/3+(total_norm/2),height/2+(total_move),width/3+half_move+line_size,height/2+total_move); //Bring in clear variables
 line(width/3+(usa_norm/2),height/2+(usa_move),width/3+half_move+line_size,height/2+usa_move); //Bring in clear variables

 //Label Text Properties
 fill(0);
 textAlign(LEFT,CENTER);
 textSize(20);                                                                                 
 text("Record quarterly sessions", width/3+half_move, height/2.5-20);
 text("Total sessions this quarter", width/3+half_move, height/2+total_move-20);
 text("USA sessions this quarter", width/3+half_move, height/2+usa_move-20);
 
 //Title 
 textSize(40);
 text("3rd Quarter 2014",width/3.5,height/4.5); 
 
 //Save to output
 saveFrame("output/2014_3.png"); 
}
