/*
REFACTOR CODE:  Split the axis from the drawLineGraph method and give it it's own.  Then have other methods to load the Linear Progression (separate), min/max/avg (onto the defualt linegraph)

Add music player (if i can figure it out, if not... thinking of other ideas still)

*/


String countryAbbrev[] = {"CAN", "USA", "AL", "BE", "BG", "HR", "CZ", "DK", "EE", "FR", "GER", "GR", "HU", "IT", "LV", "LT", "LU", "NL", "NO", "PL", "PT", "RO", "SK", "SI", "ES", "TR", "UK"};

void setup()
{
   size(1000, 600);
   smooth();
   
   pageKey = 0;
   
   // Yearly Linegraph Properties
   yearlyBG = loadImage("Navy_Blue_Background.jpg");
   yearlyBG.resize(width, height);
   yearlyGraphBG = color(20);
   yearlyGraphOL = color(105);
   yearlyNonLinearCol = color(0,255,255);      // Graph Line
   yearlyMOLineCol = color(225);    // MouseOver Line
   yearlyMOTxtCol = color(225);     // MouseOver Text
   
   // Yearly Linear Progression Properties
   yearlyLinearLineCol = color(0,50,255);
   
   // Yearly Title Properties
   yearlyTitleCol = color(255);
   yearlyTitleSize = 26;
   
   // Yearly Axis Properties
   yearlyAxisCol = color(255);      // Graph Axis
   yearlyAxisLblCol = color(255);
   yearlyAxisLblSize = 16;
   
   // Country Button Colours & Font Size
   coButtonCol = color(0);            // Default
   coButtonMOCol = color(0,150,255);  // MouseOver
   coButtonLblCol = color(255);     // Label
   coButtonLblSize = 12;
   
   // Overall Spent Linegraph
   ovrChartAxisCol = color(127);
   ovrChartBG = color(0);
   
   // Overall Spent Comparison
   overallBG = loadImage("orange_background.jpg");
   overallBG.resize(width, height);
   
   // Main Menu Colours & Font Size
   menuOptsCol = color(0,255,255);
   menuOptsTxtSize = 30;
   
   loadExpensesCountry();   // Load Data Into ArrayLists
}


/************************
                      *************************************************************************************************************************************************************************
    RETURN TO MENU    *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/

color retToMenuCol;
int retToMenuSize;
PVector menuPos;

void returnToMenu()
{
   fill(retToMenuCol);
   textSize(retToMenuSize);
   textAlign(RIGHT,CENTER);
  
   String menuString = "Return to Main Menu [Press M]";
   text(menuString, menuPos.x, menuPos.y);
   
   if (keyPressed && (key == 'M' || key == 'm'))
   {
      pageKey = 0;
   }
}



/************************
                      *************************************************************************************************************************************************************************
      MAIN MENU       *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/

color menuOptsCol;
int menuOptsTxtSize;

void drawMenu()
{
   float textX = width * 0.3f;
   float opt1Y = height * 0.4f;
   float opt2Y = height * 0.5f;
   float opt3Y = height * 0.6f;
   String option1 = "Military Expenses Per Year [Press 1]";
   String option2 = "Overall Military Expenses [Press 2]";
   String option3 = "Exit [Press 3]";
   
   fill(menuOptsCol);
   textAlign(LEFT,CENTER);
   textSize(menuOptsTxtSize);
   
   text(option1, textX, opt1Y);
   text(option2, textX, opt2Y);
   text(option3, textX, opt3Y);
   
   if (keyPressed)
   {
      if (key == '1') pageKey = 1;
      if (key == '2') pageKey = 2;
      if (key == '3') System.exit(0);
   }
}



/************************
                      *************************************************************************************************************************************************************************
      LOAD DATA       *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/

ArrayList<LoadData> militaryExpenses = new ArrayList<LoadData>();

void loadExpensesCountry()
{
   String[] lines = loadStrings("expensesByCountry.csv");
   for (String line:lines)
   {
      LoadData row = new LoadData(line);
      militaryExpenses.add(row);
   }
}



/************************
                      *************************************************************************************************************************************************************************
   YEARLY LINEGRAPH   *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/

PImage yearlyBG;    // Background

/*************************************
*************** TITLE ****************
*************************************/

String country[] = 
{"Canada","USA","Albania","Belgium","Bulgaria","Croatia","Czech Rep","Denmark","Estonia",
"France","Germany","Greece","Hungary","Italy","Latvia","Lithuania","Luxembourg","Netherlands",
"Norway","Poland","Portugal","Romania","Slovakia","Slovenia","Spain","Turkey","UK"};
int countryCount = country.length;
color yearlyTitleCol;
int yearlyTitleSize;

void yearlyTitle()
{
   // Return To Menu Properties
   // Including this here as it is placed close to title at top of the page
   retToMenuCol = color(175);
   retToMenuSize = 14;
   menuPos = new PVector(width - 20, buttonHeight + 20);
   
   textAlign(CENTER, CENTER);
   textSize(yearlyTitleSize);
   fill(yearlyTitleCol);
   
   String title = country[countryID];
   PVector titlePos = new PVector(width/2, 40);
   text(title.toUpperCase(), titlePos.x, titlePos.y);
}


/*************************************
*************** AXIS *****************
*************************************/

color yearlyAxisCol;
color yearlyAxisLblCol;
int yearlyAxisLblSize;
color yearlyGraphBG;
color yearlyGraphOL;

int boundrySize;
int xBoundryStart;
int xBoundryEnd;
int xLength;
int yBoundryStart;
int yBoundryEnd;
int yLength;

void yearlyAxis()
{ 
   // Graph Background
   strokeWeight(0.5);
   stroke(yearlyGraphOL);
   fill(yearlyGraphBG);
   rect(xBoundryStart, yBoundryEnd, xLength, yLength);
   
   // Boundry Properties
   boundrySize = width / 10;
   xBoundryStart = boundrySize;
   xBoundryEnd = width - boundrySize;
   xLength = xBoundryEnd - xBoundryStart;
   yBoundryStart = height - boundrySize;
   yBoundryEnd = boundrySize;
   yLength = yBoundryStart - yBoundryEnd;
     
   // Axis Properties
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


/*******************************************
********** Graph MouseOver Table ***********
*******************************************/

float moTableWidth;
float moTableHeight;
float moTableLeft;
float moTableRight;
float moTableTop;
float moTableBottom;

void graphMOTable()
{
  moTableWidth = width - 450;
  moTableHeight = boundrySize * 0.7;
  
  moTableLeft = (width - moTableWidth) * .5f;
  moTableRight = moTableLeft + moTableWidth;
  moTableTop = height - moTableHeight;
  moTableBottom = height;
  
  strokeWeight(1);
  stroke(105);
  fill(yearlyGraphBG);
  
  rect(moTableLeft, moTableBottom, moTableWidth, -moTableHeight);
}


/******************************************
********* Non Linear Progression **********
******************************************/

color yearlyNonLinearCol;
color yearlyMOLineCol;
color yearlyMOTxtCol;

int coMaxRange[] =
{16000, 750000, 200, 5000, 1000, 1500, 2500, 30000, 500, 50000, 40000, 10000, 1500,      // Stores the max range values for all countries
30000, 600, 500, 300, 10000, 5000, 10000, 4000, 2000, 1000, 750, 15000, 15000, 60000};
float totalSpent[] = new float[countryCount];      // Array to store total spent for each country

void yearlyNonLinearProg()
{   
   // Non Linear
   float totalToDate = militaryExpenses.get(0).spent[countryID];
   totalSpent[0] = totalToDate;
   
   for (int i = 1; i < militaryExpenses.size(); i++)
   {
      LoadData prev = militaryExpenses.get(i-1);
      LoadData next = militaryExpenses.get(i);
 
      float prevX = map(i-1, 0, (militaryExpenses.size() - 1), xBoundryStart, xBoundryEnd);
      float nextX = map(i, 0, (militaryExpenses.size() - 1), xBoundryStart, xBoundryEnd);
      float prevY = map(prev.spent[countryID], 0, coMaxRange[countryID], yBoundryStart, yBoundryEnd);
      float nextY = map(next.spent[countryID], 0, coMaxRange[countryID], yBoundryStart, yBoundryEnd);
      
      stroke(yearlyNonLinearCol);
      strokeWeight(2);
      line(prevX, prevY, nextX, nextY);
       
      /********** MouseOver Feature **********/
      
      PVector yearLblPos = new PVector(moTableLeft + 100, height - (moTableHeight / 2));
      PVector spentLblPos = new PVector(yearLblPos.x + 160, moTableTop + 25);
      PVector spentValPos = new PVector(spentLblPos.x, spentLblPos.y + 20);
      PVector totalLblPos = new PVector(spentLblPos.x + 150, spentLblPos.y);
      PVector totalValPos = new PVector(totalLblPos.x, spentValPos.y);
      
      int yearLbl = (int)prev.year;
      String spentLbl = "Spent (Mil.€)";
      String totalLbl = "Total To Date";
      float spentVal = prev.spent[countryID];
      float totalVal = totalToDate;
      
      if (mouseY < yBoundryStart && mouseY > yBoundryEnd)
      {
         if (mouseX > prevX && mouseX < nextX)
         {       
            // MouseOver Line
            strokeWeight(1);
            stroke(yearlyMOLineCol);
            line(mouseX, yBoundryStart, mouseX, yBoundryEnd);
            
            // MouseOver Data
            textAlign(CENTER, CENTER);
            
            fill(255,0,0);
            textSize(30);
            text(yearLbl, yearLblPos.x, yearLblPos.y);
            
            fill(255);
            textSize(13);
            text(spentLbl, spentLblPos.x, spentLblPos.y);
            text(totalLbl, totalLblPos.x, totalLblPos.y);
            
            fill(0,50,255);
            textSize(16);
            text(spentVal, spentValPos.x, spentValPos.y);
            text(totalVal, totalValPos.x, totalValPos.y);
         }
      }
      totalToDate += next.spent[countryID];
   }
   totalSpent[countryID] = totalToDate;
}


/*****************************************
*********** Linear Progression ***********
*****************************************/

color yearlyLinearLineCol;

void yearlyLinearProg()
{
   // Getting the element[#] of first
   int yearCount = militaryExpenses.size();
   int endIndex = yearCount - 1;
   int startIndex = -1;
   for (int i = 0; startIndex == -1; i++)
   {
      LoadData getVal = militaryExpenses.get(i);
      
      if (getVal.spent[countryID] != 0)
      {
         if (i == 0) startIndex = i;
         else startIndex = i - 1;
      }
   }
   
   LoadData start = militaryExpenses.get(startIndex);
   LoadData end = militaryExpenses.get(endIndex);
   
   float startX = map(startIndex+1, 1, yearCount, xBoundryStart, xBoundryEnd);
   float endX = map(yearCount, 1, yearCount, xBoundryStart, xBoundryEnd);
   float startY = map(start.spent[countryID], 0, coMaxRange[countryID], yBoundryStart, yBoundryEnd);
   float endY = map(end.spent[countryID], 0, coMaxRange[countryID], yBoundryStart, yBoundryEnd);
      
   strokeWeight(0.7);
   stroke(yearlyLinearLineCol);
   line(startX, startY, endX, endY);

}


/************************************************
**************** COUNTRY BUTTONS ****************
************************************************/

color coButtonCol;
color coButtonMOCol;
color coButtonLblCol;
int coButtonLblSize;
int buttonHeight = 20;

int countryID = 0;      // References the arraylist position of the requested country -> Initialised to 0 (first country position)

void countryButtons()
{
   float buttonWidth = (float) width / countryCount;

   for (int i = 0; i < countryCount; i++)   // Button For Each Country
   {
      float buttonX = buttonWidth * i;
      
      // If Mouse Is Over Button -> If Button Pressed | Else..
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
      rect(buttonX, 0, buttonWidth, buttonHeight);
    
      // Button Label
      PVector labelPos = new PVector(buttonX + (buttonWidth / 2), buttonHeight / 2);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(coButtonLblSize);
      text(countryAbbrev[i], labelPos.x, labelPos.y);
   }
}


/************************
                      *************************************************************************************************************************************************************************
     Overall Spent    *************************************************************************************************************************************************************************
     Progression &    *************************************************************************************************************************************************************************
      Comparison      *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/

PImage overallBG;
color ovrChartBG;
color ovrChartAxisCol;

void drawOverall()
{
  // Return To Menu Colour & Font Size
   retToMenuCol = color(0);
   retToMenuSize = 20;
   menuPos = new PVector(width / 2, height * 0.95f);
  
  //////////////////////////
  ///////  BARCHART  ///////
  //////////////////////////
  // Barchart comparing overall spent by all countries combined each year over the course of the timelapse
  
  /********** Boundry **********/
  float boundryStart = 0;
  float boundryEnd = width;
  float boundryPos = height * 0.33f;
  fill(ovrChartBG);
  stroke(ovrChartBG);
  rect(boundryStart,0,width,boundryPos); // background for the barchart
  
  /********** Barchart **********/
  
  
  
  ///////////////////////
  /////  COMPARISON /////
  ///////////////////////
  // Circles or something similar with size being the default comparator, comparing overall spent by all countries
  
  
}


/************************
                      *************************************************************************************************************************************************************************
     DRAW METHOD      *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/

int pageKey;   // Stores Page IDs

void draw()
{
  
   // MAIN MENU
   if (pageKey == 0)
   {
      background(0);
      drawMenu();  
   }
  
   // Linegraph page
   if (pageKey == 1)
   {  
      background(yearlyBG);
      yearlyTitle();
      yearlyAxis();
      graphMOTable();
      yearlyLinearProg();
      yearlyNonLinearProg();
      countryButtons();
      returnToMenu();
   }
 
   // Overall page
   if (pageKey == 2)
   {
      background(overallBG);
      drawOverall();
      returnToMenu();
   }
   
}