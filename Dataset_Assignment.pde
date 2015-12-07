// Add Average to yearly progression (called mean?)


String countryAbbrev[] = {"CAN", "USA", "AL", "BE", "BG", "HR", "CZ", "DK", "EE", "FR", "GER", "GR", "HU", "IT", "LV", "LT", "LU", "NL", "NO", "PL", "PT", "RO", "SK", "SI", "ES", "TR", "UK"};

void setup()
{
   size(1000, 600);
   smooth();
   
   pageKey = 0;
   
   // Yearly Progression Properties
   yearlyBG = loadImage("Navy_Blue_Background.jpg");
   yearlyBG.resize(width, height);
   yearlyGraphBG = color(20);
   yearlyGraphOL = color(105);
   yearlyMOLineCol = color(225);
   yearlyMOTxtCol = color(225);
   yearlyNonLinearCol = color(0,255,255);
   yearlyLinearLineCol = color(0,25,255);
   linearToggle = false;    // Set linear comparison & mouseover to off on startup
   moToggle = false;
   
   // Yearly Title Properties
   yearlyTitleCol = color(255);
   yearlyTitleSize = 26;
   
   // Yearly Axis Properties
   yearlyAxisCol = color(255);
   yearlyAxisLblCol = color(255);
   yearlyAxisLblSize = 16;
   
   // Country Button Colours & Font Size
   coButtonCol = color(0);            // Default
   coButtonMOCol = color(0,150,255);  // MouseOver
   coButtonLblCol = color(255);     // Label
   coButtonLblSize = 12;
   
   // Overall Spent 
   ovrChartAxisCol = color(127);
   ovrChartBG = color(255);
   overallBG = loadImage("bluebackground.png");
   overallBG.resize(width, height);
   
   loadExpensesCountry();   // Load Data Into ArrayLists
   
   
  // Calculating Country Totals
  for (int i = 0; i < countryCount; i++)
  {
      for (int j = 0; j < militaryExpenses.size(); j++)
      {
         LoadData year = militaryExpenses.get(j);
         countryTotal[i] += year.spent[i];
      }
      combinedSum += countryTotal[i];
  }
  
  // Calculating Country Percent vs all
  for (int i = 0; i < countryTotal.length; i++)
  {
      float val = map(countryTotal[i], 0, combinedSum, 0, 100);
      countryPC[i] = nf(val, 2, 1);      // Formatting percentage output
  }
}


/************************
                      *************************************************************************************************************************************************************************
    RETURN TO MENU    *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/
// Indicates to user what key to press to return to main menu
// Sets pagekey to main menu's if the key is pressed

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
// Menu the user is greeted with at startup. Allows user to navigate to desired page

color menuOptsCol;
color optBGCol;
color optOLCol;

void drawMenu()
{
   String options[] = {"Military Expenses (Yearly Progression)", "Military Expenses (Overall Comparison)", "Exit"};
   
   for (int i = 0; i < 3; i++)
   {
      float optSize = height / 3;
      float startY = optSize * i;
      
      if (mouseY > startY && mouseY < startY + optSize)
      {
         optBGCol = color(45);
         optOLCol = color(0,150,255);
         menuOptsCol = optOLCol;
         
         if (mousePressed)
            pageKey = i+1;
      }
      else
      {
         optBGCol = color(0,150,255);
         optOLCol = color(45);
         menuOptsCol = optOLCol;
      }
      
      fill(optBGCol);
      stroke(optOLCol);
      rect(0, startY, width, optSize);
      
      textAlign(CENTER,CENTER);
      textSize(40);
      fill(menuOptsCol);
      text(options[i], width/2, startY + (optSize/2));
   }
}



/************************
                      *************************************************************************************************************************************************************************
      LOAD DATA       *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/
// Loads the dataset into the arraylist

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
   YEARLY Progression   *************************************************************************************************************************************************************************
                        *************************************************************************************************************************************************************************
************************/
// The Yearly Progression page.  Allows you to see the yearly progression of military expenditure in the countries over the course of 1949-2014.
// Includes country selection via buttons, a mouse-over feature displaying data @ mouse position, and linear comparison (to primary data)

PImage yearlyBG;    // Background


/*************************************
*************** GRAPH ****************
*************************************/
// Draws the graph background, title, axis & sets the graph boundry

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

String country[] = 
{"Canada","USA","Albania","Belgium","Bulgaria","Croatia","Czech Rep","Denmark","Estonia",
"France","Germany","Greece","Hungary","Italy","Latvia","Lithuania","Luxembourg","Netherlands",
"Norway","Poland","Portugal","Romania","Slovakia","Slovenia","Spain","Turkey","UK"};
int countryCount = country.length;
color yearlyTitleCol;
int yearlyTitleSize;

void yearlyGraph()
{ 
   /********* Return To Menu Properties *********/
   
   retToMenuCol = color(175);
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
   
   /********* Boundry Properties *********/
   
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
   
   /********** MouseOver Table **********/
   
   moTableWidth = width - 450;
   moTableHeight = boundrySize * 0.7;
   moTableLeft = (width - moTableWidth) * .5f;
   moTableRight = moTableLeft + moTableWidth;
   moTableTop = height - moTableHeight;
   moTableBottom = height;
   
   // If MouseOver feature is toggled on -> Draw MouseOver table
   if (moToggle)
   {
      strokeWeight(1);
      stroke(105);
      fill(yearlyGraphBG);
      rect(moTableLeft, moTableBottom, moTableWidth, -moTableHeight);
   }
}



/****************************************
************* Graph Buttons *************
****************************************/
// Adds toggle buttons to the graph, which allow the user to toggle the MouseOver & Linear Comparison features on/off.

boolean linearToggle;
boolean moToggle;

void graphButtons()
{
   float buttonW = 40;
   float buttonH = 18;
   
   /********** LINEAR BUTTON **********/
   
   textAlign(LEFT,CENTER);
   textSize(10);
   text("Toggle Linear Comparison: ", xBoundryStart+20, yBoundryEnd+20);
   
   float linearX1 = xBoundryStart + 165;
   float linearY1 = yBoundryEnd + 12;
   color linearButtonCol = color(0);
   
   // If Mouse Over Button ... / Else ...
   if (mouseX > linearX1 && mouseX < linearX1 + buttonW && mouseY > linearY1 && mouseY < linearY1 + buttonH)
   {
      linearButtonCol = color(0,150,255);
      if (mousePressed)
         linearToggle = !linearToggle;
   }
   else
   {
      linearButtonCol = color(0,0,255);
   }
   
   // Setting Button Label
   String linearLbl;
   if (linearToggle)
      linearLbl = "ON";
   else
      linearLbl = "OFF";
   
   // Draw Button
   fill(linearButtonCol);
   stroke(linearButtonCol);
   rect(linearX1, linearY1, buttonW, buttonH);
   
   // Draw Button Label
   fill(255);
   textAlign(CENTER,CENTER);
   textSize(12);
   text(linearLbl, linearX1 + (buttonW/2), linearY1 + (buttonH/2));
   
   /********** MouseOver Button **********/
   
   textAlign(LEFT,CENTER);
   textSize(10);
   text("Toggle Mouse-Over Feature: ", xBoundryStart+20, yBoundryEnd+50);
   
   float moX1 = xBoundryStart + 165;
   float moY1 = yBoundryEnd + 42;
   color moButtonCol = color(0);
   
   // If Mouse Over Button ... / Else ...
   if (mouseX > moX1 && mouseX < moX1 + buttonW && mouseY > moY1 && mouseY < moY1 + buttonH)
   {
      moButtonCol = color(0,150,255);
      if (mousePressed)
         moToggle = !moToggle;
   }
   else
   {
      moButtonCol = color(0,0,255);
   }
   
   // Setting Button Label
   String moLbl;
   if (moToggle)
      moLbl = "ON";
   else
      moLbl = "OFF";
   
   // Draw Button
   fill(moButtonCol);
   stroke(moButtonCol);
   rect(moX1, moY1, buttonW, buttonH);
   
   // Draw Button Label
   fill(255);
   textAlign(CENTER,CENTER);
   textSize(12);
   text(moLbl, moX1 + (buttonW/2), moY1 + (buttonH/2));
   
}



/******************************************
********* Non Linear Progression **********
******************************************/
// Displays the primary data in the form of a non-linear linegraph
// Calculates MouseOver data

color yearlyNonLinearCol;
color yearlyMOLineCol;
color yearlyMOTxtCol;

int coMaxRange[] =
{16000, 750000, 200, 5000, 1000, 1500, 2500, 30000, 500, 50000, 40000, 10000, 1500,      // Stores the max range values for all countries
30000, 600, 500, 300, 10000, 5000, 10000, 4000, 2000, 1000, 750, 15000, 15000, 60000};

float moTableWidth;
float moTableHeight;
float moTableLeft;
float moTableRight;
float moTableTop;
float moTableBottom;

void yearlyNonLinearProg()
{
   float totalToDate = militaryExpenses.get(0).spent[countryID];
   
   /********** Linegraph **********/
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
       
      /********** MouseOver Data **********/
      PVector yearLblPos = new PVector(moTableLeft + 100, height - 38);
      PVector spentLblPos = new PVector(yearLblPos.x + 160, moTableTop + 25);
      PVector spentValPos = new PVector(spentLblPos.x, spentLblPos.y + 20);
      PVector totalLblPos = new PVector(spentLblPos.x + 150, spentLblPos.y);
      PVector totalValPos = new PVector(totalLblPos.x, spentValPos.y);
      
      int yearLbl = (int)prev.year;
      String spentLbl = "Spent (Mil.€)";
      String totalLbl = "Total To Date (Mil.€)";
      float spentVal = prev.spent[countryID];
      float totalVal = totalToDate;
      
      if (moToggle && mouseY < yBoundryStart && mouseY > yBoundryEnd)
      {
         if (mouseX > prevX && mouseX < nextX)
         {       
            // MouseOver Line
            strokeWeight(1);
            stroke(yearlyMOLineCol);
            line(mouseX, yBoundryStart, mouseX, yBoundryEnd);
            
            // MouseOver Data
            textAlign(CENTER, CENTER);
            
            fill(0,150,255);
            textSize(30);
            text(yearLbl, yearLblPos.x, yearLblPos.y);
            
            fill(0,150,255);
            textSize(13);
            text(spentLbl, spentLblPos.x, spentLblPos.y);
            text(totalLbl, totalLblPos.x, totalLblPos.y);
            
            fill(255);
            textSize(16);
            text(spentVal, spentValPos.x, spentValPos.y);
            text(totalVal, totalValPos.x, totalValPos.y);
         }
      }
      totalToDate += next.spent[countryID];
   }
}



/*****************************************
*********** Linear Progression ***********
*****************************************/
// Straight line from the first to last year, used to compare against the non-linear progression
// This allows you to see more clearly the spikes of increase/decrease to money spent over the years

color yearlyLinearLineCol;

void yearlyLinearProg()
{
   int yearCount = militaryExpenses.size();
   int endIndex = yearCount - 1;
   int startIndex = -1;
   
   // First first element index that has a value
   for (int i = 0; startIndex == -1; i++)
   {
      LoadData getVal = militaryExpenses.get(i);
      
      if (getVal.spent[countryID] != 0)
      {
         // If index is not [0] then decrement it by one, so that the line starts from "0 spent" (year prev to first year with expenditure)
         // This is in place to provide a more accurate linear comparison
         if (i == 0)
            startIndex = i;
         else 
            startIndex = i - 1;
      }
   }
   
   LoadData start = militaryExpenses.get(startIndex);
   LoadData end = militaryExpenses.get(endIndex);
   
   // Getting the co-ords to draw the lines.
   // The co-ordinates are mapped so that they fit the screen accordingly @ the desired scale
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
// Draws the country buttons at the top of the screen
// The buttons allow the user to select the country for which they want to view data on

color coButtonCol;
color coButtonMOCol;
color coButtonLblCol;
int coButtonLblSize;
int buttonHeight = 20;
int countryID = 0;      // References the arraylist position of the requested country -> Initialised to 0 (first country position)

void countryButtons()
{
   float buttonWidth = (float) width / countryCount;

   // Drawing Button For Each Country
   for (int i = 0; i < countryCount; i++)
   {
      float buttonX = buttonWidth * i;
      
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
                        ***********************************************************************************************************************************************************************
   Overall Comparison   ***********************************************************************************************************************************************************************
                        ***********************************************************************************************************************************************************************
************************/
// A barchart conveying the difference between the amount each country spent over the timelapse

PImage overallBG;
color ovrChartBG;
color ovrChartAxisCol;
float combinedSum;       // total spent of each country combined
float countryTotal[] = new float[countryCount];
String countryPC[] = new String[countryCount];


void drawOverall()
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
  fill(45);
  textAlign(CENTER,CENTER);
  textSize(16);
  text("Percent (%)", width/2, boundryPos + 50);
  text("Amount Spent (Mil.€)", width/2, boundryPos + 100);
  
  /********** Drawing Barchart & Data **********/
  float barWidth = (float) width / countryCount;
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
      PVector coPCPos = new PVector(coNamePos.x, coNamePos.y + 50);
      textSize(11);
      textAlign(CENTER,CENTER);
      text(countryPC[i], coPCPos.x, coPCPos.y);
      
      // Total Spent (Mil.€)
      PVector coTotPos = new PVector (coNamePos.x, coPCPos.y + 50);
      pushMatrix();
      translate(coTotPos.x, coTotPos.y);
      rotate(-HALF_PI);
      textSize(11);
      textAlign(RIGHT,CENTER);
      text(countryTotal[i], 0, 0);
      popMatrix();
      
   }
}



/************************
                      *************************************************************************************************************************************************************************
     DRAW METHOD      *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/

int pageKey;   // Stores Page IDs

void draw()
{
  
   /********** MAIN MENU **********/
   // If Pagekey is set to 0, the Main Menu is displayed on the screen
   if (pageKey == 0)
   {
      background(0);
      drawMenu();  
   }
  
   /********** Yearly Progression **********/
   if (pageKey == 1)
   {  
      background(yearlyBG);
      yearlyGraph();
      graphButtons();
      if (linearToggle)      // If Linear is toggled on -> draw linear progression line
         yearlyLinearProg();
      yearlyNonLinearProg();
      countryButtons();
      returnToMenu();
   }
 
   /********** Overall Comparison **********/
   if (pageKey == 2)
   {
      background(overallBG);
      drawOverall();
      returnToMenu();
   }
   
   if (pageKey == 3)
      System.exit(0);
   
}