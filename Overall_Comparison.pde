/************************
                        ***********************************************************************************************************************************************************************
   Overall Comparison   ***********************************************************************************************************************************************************************
                        ***********************************************************************************************************************************************************************
************************/
// A barchart conveying the difference between the total amount each country spent over the timelapse


/*********************************************
************** Overall Barchart **************
*********************************************/

PImage overallBG;
color ovrChartBG = color(255);
color ovrChartAxisCol = color(127);
float countryTotal[] = new float[countryCount];
String countryPC[] = new String[countryCount];
float combinedSum;       // total spent of each country combined

void overallChart()
{
   // Return To Menu Properties
   retToMenuCol = color(0);
   retToMenuSize = 20;
   menuPos = new PVector(width - 20, height * 0.05f);
  
  /********** Boundry **********/
  
  float boundryStart = 0;
  float boundryEnd = width;
  float boundryPos = height * 0.66f;
  fill(ovrChartBG);
  stroke(ovrChartBG);
  rect(boundryStart,0,width,boundryPos);    // Background for the barchart
  
   /********* Page Title *********/
   
   fill(45);
   textSize(40);
   textAlign(CENTER,CENTER);
   text("Military Expenditure (1949 - 2014)", width/2, height/4);
  
  /********* Data Headers **********/
  
  PVector percentPos = new PVector(width/2, boundryPos + 60);
  PVector spentPos = new PVector(width/2, percentPos.y + 50);

  fill(245);
  textAlign(CENTER,CENTER);
  textSize(16);
  text("Percent (%)", percentPos.x, percentPos.y);
  text("Amount Spent (Mil.€)", spentPos.x, spentPos.y);
  
  /********** Drawing Barchart & Data **********/
  
  float barWidth = (float) (width - 1) / countryCount;
  for (int i = 0; i < countryCount; i++)
  {
      float x = barWidth * i;
      float y = map(countryTotal[i], 0, 15000000, 0, boundryPos);
      float r = map(countryTotal[i], 0, 15000000, 1, 255);   // Colour scales from darkred(low spent) -> brightred(high spent)
      
      // Barchart
      fill(0,255-r,255-r);
      rect(x, boundryPos, barWidth, -y);
      
      // Country Name
      PVector coNamePos = new PVector(x + (barWidth/2), boundryPos + 20);
      textSize(14);
      textAlign(CENTER,CENTER);
      text(countryAbbrev[i], coNamePos.x, coNamePos.y);
      
      // Country Percent (out of all countries' total spent)
      PVector coPCPos = new PVector(coNamePos.x, percentPos.y + 20);
      textSize(11);
      textAlign(CENTER,CENTER);
      text(countryPC[i], coPCPos.x, coPCPos.y);
      
      // Total Spent (Mil.€)
      PVector coTotPos = new PVector (coNamePos.x, spentPos.y + 20);
      pushMatrix();
      translate(coTotPos.x, coTotPos.y);
      rotate(-HALF_PI);
      textSize(11);
      textAlign(RIGHT,CENTER);
      text(twoDecimals(countryTotal[i]), 0, 0);
      popMatrix();
   }
}



/*********************************************
**************** Draw Overall ****************
*********************************************/
// Includes all methods required for the Overall Comparison

void drawOverall()
{
   overallChart();
   returnToMenu();
}