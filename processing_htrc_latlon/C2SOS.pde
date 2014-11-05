//Created by the Advanced Visualization Laboratory at Indiana University
//Created by Karla Vega
//Processing 2.1.1 
//This function takes a x and y coordinates and warps it to the correct projection for the SOS
//Derived from fish eye lense algorithm for a unit circle
//Distortion is not only dependent on latitude, but also on the size of the image to be distorted

public float C2SOS(float x, float y, float size){

  //1. Normalize 
  float X = x/width;
  float r = height/2; //radius size for image
  float Y = (y-r)/(r); //normalize
  float XP; //output
  float SIZE = size; //quad size 
  
 
  float val;
  float nSIZE = SIZE/height; //(ranges from 1 to 2);
  
  //val will vary depending on the size of the quad - here I fitted a curve to formula to approximate 
  //all values. Change val as neccesary to fit the right distortion wrt the size of the quad. 
   val = (0.28)*pow(nSIZE,0.6668104348); // Fitted with three data points R^2=0.990134
   
   //This is the distortion formula - the only thing that varies wrt to size of quad is the value val
    XP = (X + (1 - pow(1-sq(Y),val)))*width;

  //Uncomment here for no distortion
  //XP = X;*/

  
  return XP;
}
