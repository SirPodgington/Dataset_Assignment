/************************
                        *************************************************************************************************************************************************************************
   YEARLY Progression   *************************************************************************************************************************************************************************
                        *************************************************************************************************************************************************************************
************************/
// The Yearly Progression page.  Allows you to see the yearly progression of military expenditure in the countries over the course of 1949-2014.
// Includes country selection via buttons, a mouse-over feature displaying data @ mouse position, and linear comparison (to primary data)

PImage yearlyBG;


/*************************************
*********** Yearly GRAPH *************
*************************************/
// Sets the return to menu string position
// Draws the graph background & title

color yearlyGraphBG = color(220);               // Graph background colour
color yearlyGraphOL = color(105);               // Graph bg outline colour
color yearlyTitleCol = color(20);              // Graph title colour
int yearlyTitleSize = 30;                       // Graph title size
String country[] = 
{"Canada","USA","Albania","Belgium","Bulgaria","Croatia","Czech Rep","Denmark","Estonia",         // Graph titles (country names)
"France","Germany","Greece","Hungary","Italy","Latvia","Lithuania","Luxembourg","Netherlands",
"Norway","Poland","Portugal","Romania","Slovakia","Slovenia","Spain","Turkey","UK"};

void yearlyGraph()
{ 
   /********* Return To Menu Properties *********/
   retToMenuCol = color(20);
   retToMenuSize = 14;
   menuPos = new PVector(width - 20, buttonHeight + 20);
   
   /********* Graph Background *********/
   strokeWeight(0.5);
   stroke(yearlyGraphOL);
   fill(yearlyGraphBG);
   rect(xBoundryStart, yBoundryEnd, xLength, yLength);
   
   /********* Graph Title *********/
   String title = country[countryID];
   PVector titlePos = new PVector(width/2, 55);
   textAlign(CENTER, CENTER);
   textSize(yearlyTitleSize);
   fill(yearlyTitleCol);
   text(title.toUpperCase(), titlePos.x, titlePos.y); 
}



/*************************************
**************** AXIS ****************
*************************************/

color yearlyAxisCol = color(20);
color yearlyAxisLblCol = color(20);
int yearlyAxisLblSize = 16;

int boundrySize;
int xBoundryStart;
int xBoundryEnd;
int xLength;
int yBoundryStart;
int yBoundryEnd;
int yLength;

void drawYearlyAxis()
{
   /********* Boundry *********/
   boundrySize = width / 10;
   xBoundryStart = boundrySize;
   xBoundryEnd = width - boundrySize;
   xLength = xBoundryEnd - xBoundryStart;
   yBoundryStart = height - boundrySize;
   yBoundryEnd = boundrySize;
   yLength = yBoundryStart - yBoundryEnd;
   
   /********* AXIS **********/
   strokeWeight(2);
   stroke(yearlyAxisCol);
   fill(yearlyAxisLblCol);
   textSize(yearlyAxisLblSize);
   
   int markerSize = 10;
   int xTextOffset = 35;
   int yTextOffset = 20;
   int xAxisStartVal = 1949;
   int xAxisEndVal = 2014;
   int yAxisStartVal = 0;
   int yAxisEndVal = coMaxRange[countryID];
   
   // X-Axis
   line(xBoundryStart, yBoundryStart, xBoundryEnd, yBoundryStart);
   // X-Axis Start Marker
   line(xBoundryStart, yBoundryStart, xBoundryStart, yBoundryStart + markerSize);
   textAlign(CENTER);
   text(xAxisStartVal, xBoundryStart, yBoundryStart + xTextOffset);
   // X-Axis End Marker
   line(xBoundryEnd, yBoundryStart, xBoundryEnd, yBoundryStart + markerSize);
   text(xAxisEndVal, xBoundryEnd, yBoundryStart + xTextOffset);
     
   // Y-Axis 
   line(xBoundryStart, yBoundryStart, xBoundryStart, yBoundryEnd);
   // Y-Axis start marker
   line(xBoundryStart, yBoundryStart, xBoundryStart - markerSize, yBoundryStart);
   textAlign(RIGHT, CENTER);
   text(yAxisStartVal, xBoundryStart - yTextOffset, yBoundryStart);
   // Y-Axis end marker
   line(xBoundryStart, yBoundryEnd, xBoundryStart-markerSize, yBoundryEnd);
   text(yAxisEndVal, xBoundryStart - yTextOffset, yBoundryEnd);
}



/******************************************
********* Non Linear Progression **********
******************************************/
// Conveys the military expenditure progression in the form of a non-linear linegraph

color yearlyNonLinearCol = color(150);   // Non Linear graphline colour;
int coMaxRange[] =
{16000, 750000, 200, 5000, 1000, 1500, 2500, 30000, 500, 50000, 40000, 10000, 1500,      // Stores the max range values for all countries
30000, 600, 500, 300, 10000, 5000, 10000, 4000, 2000, 1000, 750, 15000, 15000, 60000};

void yearlyNonLinearProg()
{
   for (int i = 1; i < yearCount; i++)
   {
      LoadData prev = militaryExpenses.get(i-1);
      LoadData next = militaryExpenses.get(i);
 
      float prevX = map(i-1, 0, (yearCount - 1), xBoundryStart, xBoundryEnd);
      float nextX = map(i, 0, (yearCount - 1), xBoundryStart, xBoundryEnd);
      float prevY = map(prev.spent[countryID], 0, coMaxRange[countryID], yBoundryStart, yBoundryEnd);
      float nextY = map(next.spent[countryID], 0, coMaxRange[countryID], yBoundryStart, yBoundryEnd);
      
      stroke(yearlyNonLinearCol);
      strokeWeight(2);
      line(prevX, prevY, nextX, nextY); 
   }
}


/************************************************
**************** COUNTRY BUTTONS ****************
************************************************/
// Draws the country buttons at the top of the screen
// The buttons allow the user to select the country for which they want to view data on

color coButtonCol = color(20);
color coButtonMOCol = color(75);
color coButtonLblCol = color(255);
int coButtonLblSize = 12;
int buttonHeight = 20;
int countryID = 0;      // References the arraylist position of the requested country -> Initialised to 0 (first country position)

void yearlyCountryButtons()
{
   float buttonWidth = (float) width / countryCount;

   // Drawing Button For Each Country
   for (int i = 0; i < countryCount; i++)
   {
      float buttonX = buttonWidth * i;   // Get x value for start of button
      
      // Setting Button Colours & Getting Requested CountryID
      if (mouseX > buttonX && mouseX < (buttonX + buttonWidth) && mouseY < buttonHeight)
      {
         fill(coButtonMOCol);
         stroke(coButtonMOCol);
         if (mousePressed)
           countryID = i;
      }
      else 
      {
         fill(coButtonCol);
         stroke(coButtonCol);
      }
      // Draw button
      rect(buttonX, 0, buttonWidth, buttonHeight);
    
      // Button Label
      PVector labelPos = new PVector(buttonX + (buttonWidth / 2), buttonHeight / 2);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(coButtonLblSize);
      text(countryAbbrev[i], labelPos.x, labelPos.y);
   }
}



/****************************************
********* Graph Feature Buttons *********
****************************************/
// Adds feature buttons to the graph, which allow the user to toggle the MouseOver & Linear Comparison features on/off.

color featureDescCol = color(20);
int featureCount = 5;
boolean yearlyFeatureState[] = new boolean[featureCount];  // All initialized to false

void yearlyFeatureButtons()
{
   float buttonW = 40;
   float halfButtonW = buttonW / 2;
   float buttonH = 18;
   float halfButtonH = buttonH / 2;
   int lblSize = 10;
   
   String desc[] = {"Toggle Mouse-Over Feature: ", "Toggle Linear Comparison: ", "Display Mean Value: ", "Correlation Vs. Total Spent: ", "Comparison Vs. Avg Spent: "};
   color colour[] = {yearlyMOLineCol, yearlyLinearCol, yearlyMeanCol, totCorrelCol, avgComparisonCol};
   
   // Initial position of description, feature button & feature button label.
   PVector descPos = new PVector(xBoundryStart + 20, yBoundryEnd + 20);
   PVector buttonPos;
   PVector buttonLblPos;
   color buttonCol = color(0);
   
   for (int i = 0; i < featureCount; i++, descPos.y += 30)
   {
      // The feature button position is calculated based on current description position
      // The button label pos is then calculated based on the feature button pos
      buttonPos = new PVector(descPos.x + 200, descPos.y - halfButtonH);
      buttonLblPos = new PVector(buttonPos.x + halfButtonW, buttonPos.y + halfButtonH);
      
      // Description
      textAlign(LEFT,CENTER);
      textSize(lblSize);
      fill(colour[i]);
      text(desc[i], descPos.x, descPos.y);
      
      // Change feature button colour if mouse is over it ... if clicked toggle on/off
      if (mouseX > buttonPos.x && mouseX < buttonPos.x + buttonW && mouseY > buttonPos.y && mouseY < buttonPos.y + buttonH)
      {
         buttonCol = color(0,200,255);
         if (mousePressed)
            yearlyFeatureState[i] = !yearlyFeatureState[i];
      }
      else
      {
         buttonCol = color(0,150,255);
      }
      
      // Setting button label based on state
      String buttonLbl;
      if (yearlyFeatureState[i])
         buttonLbl = "ON";
      else
         buttonLbl = "OFF";
         
      // Draw Button
      fill(buttonCol);
      stroke(buttonCol);
      rect(buttonPos.x, buttonPos.y, buttonW, buttonH);
      
      // Draw Button Label
      fill(featureDescCol);
      textAlign(CENTER,CENTER);
      textSize(12);
      text(buttonLbl, buttonLblPos.x, buttonLblPos.y);
   }
}



/*****************************************
*********** Mouse-Over Feature ***********
*****************************************/
// MouseOver Feature.

color moTableBGCol = color(20);
color moTableOLCol = color(175);
color yearlyMOLineCol = color(255,0,0);             // MouseOver line colour;
color yearlyMOLblCol = color(255);              // MouseOver line colour;
color yearlyMODataCol = color(255,0,0);      // MouseOver data colour;

void yearlyMouseOver()
{
   // If mouse-over state is true & mouse is within graph boundaries ...
   if (mouseY < yBoundryStart && mouseY > yBoundryEnd && mouseX < xBoundryEnd && mouseX > xBoundryStart)
   {
      // Mouse-Over Data Table
      float moTableWidth = width - 450;
      float moTableHeight = boundrySize * 0.7;
      float moTableLeft = (width - moTableWidth) * .5f;
      float moTableRight = moTableLeft + moTableWidth;
      float moTableTop = height - moTableHeight;
      float moTableBottom = height;
      float totalToDate = 0;  // Stores the total amount spent up to mouse-over date
      float gap = (float) xLength / yearCount;
      strokeWeight(1);
      stroke(moTableOLCol);
      fill(moTableBGCol);
      rect(moTableLeft, moTableBottom, moTableWidth, -moTableHeight);
      
      // Get Mouse-Over Data
      for (int i = 0; i < yearCount; i++)
      {
         LoadData current = militaryExpenses.get(i);
         totalToDate += current.spent[countryID];
         
         // Data positions
         PVector yearLblPos = new PVector(moTableLeft + 100, height - 38);
         PVector spentLblPos = new PVector(yearLblPos.x + 160, moTableTop + 25);
         PVector spentValPos = new PVector(spentLblPos.x, spentLblPos.y + 20);
         PVector totalLblPos = new PVector(spentLblPos.x + 150, spentLblPos.y);
         PVector totalValPos = new PVector(totalLblPos.x, spentValPos.y);
         
         // Data labels/values
         int yearLbl = (int)current.year;
         String spentLbl = "Spent (Mil.€)";
         String totalLbl = "Total To Date (Mil.€)";
         String spentVal = twoDecimals(current.spent[countryID]);
         String totalVal = twoDecimals(totalToDate);
         
         // Draw data
         float yearMark = map(i, 0, yearCount - 1, xBoundryStart, xBoundryEnd);
         float yearStart = yearMark - (gap/2);
         float yearEnd = yearMark + (gap/2);
         
         if (mouseX > yearStart && mouseX < yearEnd)
         {       
            // MouseOver Line
            strokeWeight(1);
            stroke(yearlyMOLineCol);
            line(mouseX, yBoundryStart, mouseX, yBoundryEnd);
            
            // MouseOver Data
            textAlign(CENTER, CENTER);
            
            fill(yearlyMOLblCol);
            textSize(30);
            text(yearLbl, yearLblPos.x, yearLblPos.y);      // Year label
            textSize(13);
            text(spentLbl, spentLblPos.x, spentLblPos.y);   // Spent label
            text(totalLbl, totalLblPos.x, totalLblPos.y);   // Total label
            
            fill(yearlyMODataCol);
            textSize(16);
            text(spentVal, spentValPos.x, spentValPos.y);   // Spent value
            text(totalVal, totalValPos.x, totalValPos.y);   // Total to date value
         }
      }
   }
}



/*****************************************
*********** Linear Comparison ************
*****************************************/
// Straight line from the first to last year, used to compare against the non-linear progression
// This allows you to see more clearly, the spikes of increase/decrease to money spent over the years

color yearlyLinearCol = color(61,145,64);   // Linear graphline colour;

void yearlyLinearComparison()
{
   int endIndex = yearCount - 1;
   
   // Find first element index that has a value
   int startIndex = -1;
   
   for (int i = 0; startIndex == -1; i++)
   {
      LoadData getVal = militaryExpenses.get(i);
      
      if (getVal.spent[countryID] != 0)
      {
         // If index is not [0] then decrement it by one.
         // This is in place to ensure the line starts from the year previous to the first year with expenditure
         // Providing a more accurate linear comparison 
         if (i == 0)
            startIndex = i;
         else 
            startIndex = i - 1;
      }
   }
   
   LoadData start = militaryExpenses.get(startIndex);
   LoadData end = militaryExpenses.get(endIndex);
   
   // Get line co-ords (start + end)
   // The co-ordinates are mapped so that they fit the screen  @ the desired scale (0 -> country max range)
   float startX = map(startIndex+1, 1, yearCount, xBoundryStart, xBoundryEnd);
   float endX = map(yearCount, 1, yearCount, xBoundryStart, xBoundryEnd);
   float startY = map(start.spent[countryID], 0, coMaxRange[countryID], yBoundryStart, yBoundryEnd);
   float endY = map(end.spent[countryID], 0, coMaxRange[countryID], yBoundryStart, yBoundryEnd);
   
   // Draw the line
   strokeWeight(0.7);
   stroke(yearlyLinearCol);
   line(startX, startY, endX, endY);
}



/********************************
*********** Get Mean ************
********************************/
// Displays the country's mean value on the Y-Axis

float countryMean[] = new float[countryCount];
color yearlyMeanCol = color(75,0,130);
color yearlyMeanOL = color(0);

void yearlyGetMean()
{
   float y = map(countryMean[countryID], 0, coMaxRange[countryID], yBoundryStart, yBoundryEnd);
   float x = xBoundryStart;
   
   // Draw the mean marker (circle)
   strokeWeight(0.5);
   stroke(yearlyMeanOL);
   fill(yearlyMeanCol);
   ellipse(x, y, 10, 10);
   
   // Draw the mean data
   fill(yearlyMeanCol);
   textSize(15);
   textAlign(LEFT, CENTER);
   text("Mean: " + twoDecimals(countryMean[countryID]), x + 10, y);
}



/***************************************************************
************* Correlation Vs All Countries (total) *************
***************************************************************/
// Compares the country's spending vs the total spent by all countries
// Correlation is not 100% accurate due to hardcoded max range value, however I haven't got much time left to finish this so leaving it as is. Still provides a pretty accurate comparison!!

color totCorrelCol = color(255,128,0);

void yearlyTotalCorrelation()
{
      for (int i = 1; i < yearCount; i++)
      {
         float prev = militaryExpenses.get(i-1).totSpentYearly;
         float next = militaryExpenses.get(i).totSpentYearly;
    
         float prevX = map(i-1, 0, (yearCount - 1), xBoundryStart, xBoundryEnd);
         float nextX = map(i, 0, (yearCount - 1), xBoundryStart, xBoundryEnd);
         float prevY = map(prev, 0, 1000000, yBoundryStart, yBoundryEnd);
         float nextY = map(next, 0, 1000000, yBoundryStart, yBoundryEnd);
         
         stroke(totCorrelCol);
         strokeWeight(2);
         line(prevX, prevY, nextX, nextY); 
      }
}



/***************************************************************
*************** Comparison Vs Country Avg Spent ****************
***************************************************************/
// Compares the country's spending vs. the average spent by all countries
// Line goes off the grid for some countries.  This is intended as SHOWING DATA > TIDY SCREEN.  By chopping the out-of-bounds off, you are chopping off important data!

color avgComparisonCol = color(255,150,250);
float yearAvg[];

void yearlyAvgComparison()
{
      for (int i = 1; i < yearCount; i++)
      {
         float prevAvg = yearAvg[i-1];
         float nextAvg = yearAvg[i];
         
         float prevX = map(i-1, 0, (yearCount - 1), xBoundryStart, xBoundryEnd);
         float nextX = map(i, 0, (yearCount - 1), xBoundryStart, xBoundryEnd);
         float prevY = map(prevAvg, 0, coMaxRange[countryID], yBoundryStart, yBoundryEnd);
         float nextY = map(nextAvg, 0, coMaxRange[countryID], yBoundryStart, yBoundryEnd);
         
         stroke(avgComparisonCol);
         strokeWeight(2);
         line(prevX, prevY, nextX, nextY); 
      }
}



/*********************************************
***************** Draw Yearly ****************
*********************************************/
// Includes all methods required to draw the Yearly Progression page

void drawYearly()
{
   yearlyGraph();
   yearlyNonLinearProg();
   drawYearlyAxis();
   
   // If relative feature state is enabled, the method is called
   if (yearlyFeatureState[0])
      yearlyMouseOver();
      
   if (yearlyFeatureState[1])
      yearlyLinearComparison();
      
   if (yearlyFeatureState[2])
      yearlyGetMean();
      
   if (yearlyFeatureState[3])
      yearlyTotalCorrelation();
      
   if (yearlyFeatureState[4])
      yearlyAvgComparison();
   
   yearlyFeatureButtons();
   yearlyCountryButtons();
   
   returnToMenu();
}