//------ Line Graph for HTRC 
import java.text.*;
Table csv_table;

void setup() {
  size(1500,500);
  smooth();
}

void draw() {
  background(105,105,105); 
  noLoop();
  
  
  // line
  stroke(255);
  strokeWeight(4);
  strokeJoin(ROUND);
  noFill();
  
  //Get Data
  float total_norm;
  float max_sess  = 3467335; //Find Max Session for all data
  float max_scale = 200;     //Largest Circle 
  float min_sess  = 0;       //not used
  float min_scale = 0;       //not used
  int step        = 35;      //space between x'axis
  
  csv_table = loadTable("totals.csv","header");    //Load in data
  int x = 0;
  beginShape();
  for (TableRow row : csv_table.rows())
  {
    float totals = row.getInt("Totals");
   
    //max_sess = sqrt(max_sess);
    //totals   = sqrt(totals);

    total_norm = (((max_scale - min_scale)/(max_sess - min_sess))*(totals - max_sess)) + max_scale;

    total_norm = height-total_norm-height/2;
    vertex(x+width/4,total_norm);
    //ellipse(x+width/4,total_norm,4,4);
    x=x+step;
  } 
  endShape();

  //graph
  stroke(255,100);
  strokeWeight(2);
  line(width/4,height/2,width/4+x-step,height/2);
  
  line(width/4,height/2,width/4,height/2+15);
  line(width/4+x-step,height/2,width/4+x-step,height/2+15);
  
  textSize(20);
  textAlign(RIGHT,CENTER);
  text("2010 Q1",width/4-6,height/2+5);
  textAlign(LEFT,CENTER);
  text("2014 Q3",width/4+x-step+6,height/2+5);
  
  int step_num = 19;
 // for (TableRow row: csv_table.rows())
 // { 
        // loop simulator
 
    TableRow getTime = csv_table.getRow(step_num);
    String time = getTime.getString("Time");
    TableRow getTotal = csv_table.getRow(step_num);
    float totals = getTotal.getInt("Totals");
    
    String totals_text = NumberFormat.getInstance().format(totals);
  
    total_norm = (((max_scale - min_scale)/(max_sess - min_sess))*(totals - max_sess)) + max_scale;
    
    //Red highlight line
    stroke(195,0,0);
    line(width/4+step_num*step,height/2+step,width/4+step_num*step,height/2-max_scale);
   
    //Red highlight ellipse
    fill(255);
    ellipse(step_num*step+width/4,height-total_norm-height/2,15,15);
    
    //Step Numbers 
    textAlign(CENTER,CENTER);
    textSize(25);
    text(totals_text,width/4+step_num*step, height/2-max_scale-25);
  
    //Time Data follows line
    textSize(25);
    text(time, step_num*step+width/4,height/2+50);
    
    step_num++;
    
    saveFrame("output/"+step_num+"frame.png");
    exit();
//  }
  
  
}




