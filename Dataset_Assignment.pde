// Add Average to yearly progression (called mean?)


String countryAbbrev[] = {"CAN", "USA", "AL", "BE", "BG", "HR", "CZ", "DK", "EE", "FR", "GER", "GR", "HU", "IT", "LV", "LT", "LU", "NL", "NO", "PL", "PT", "RO", "SK", "SI", "ES", "TR", "UK"};

void setup()
{
   size(1000, 600);
   smooth();
   
   pageKey = 0;
   
   // Yearly Progression Background
   yearlyBG = loadImage("bluebackground.png");
   yearlyBG.resize(width, height);
   
   // Overall Comparison Background
   overallBG = loadImage("bluebackground.png");
   overallBG.resize(width, height);
   
   // Set linear comparison & mouseover to off on startup
   linearToggle = false;
   moToggle = false;
   
   loadExpensesCountry();   // Load Data Into ArrayLists
   
   
  // Calculating Each Countrys' Total Spent Over Timeframe & Combined Sum Of Totals
  for (int i = 0; i < countryCount; i++)
  {
      for (int j = 0; j < militaryExpenses.size(); j++)
      {
         LoadData year = militaryExpenses.get(j);
         countryTotal[i] += year.spent[i];
      }
      combinedSum += countryTotal[i];
  }
  
  // Calculating Each Countrys' % (Country Total / Combined Sum Of All Countrys' Totals)
  for (int i = 0; i < countryTotal.length; i++)
  {
      float val = map(countryTotal[i], 0, combinedSum, 0, 100);
      countryPC[i] = nf(val, 2, 1);      // Formatting percentage output
  }
}


/************************
                       *************************************************************************************************************************************************************************
    RETURN TO MENU     *************************************************************************************************************************************************************************
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



/*********************************
                                *************************************************************************************************************************************************************************
     Format To 2 Decimals       *************************************************************************************************************************************************************************
                                *************************************************************************************************************************************************************************
*********************************/
// Converts the inputted float to string and limits it to 2 decimal places

String twoDecimals(float val)
{
   String formatted = String.format("%.02f", val);
   return formatted;
}



/************************
                      *************************************************************************************************************************************************************************
      MAIN MENU       *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/
// Menu the user is greeted with at startup. Allows user to navigate to desired page or exit program

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
      
      // Option Background Outline
      fill(optBGCol);
      stroke(optOLCol);
      rect(0, startY, width, optSize);
      
      // Option Background Colour
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

PImage yearlyBG;

/*************************************
*************** GRAPH ****************
*************************************/
// Sets the graph boundry & return to menu position
// Draws the graph background, title, axis & mouse-over table

/* Colours*/
color yearlyGraphBG = color(255);               // Graph background;
color yearlyGraphOL = color(105);               // Graph bg outline;
color yearlyAxisCol = color(20);
color yearlyAxisLblCol = color(20);
color yearlyTitleCol = color(255);
color moTableBGCol = color(20);;

/* Font Size */
int yearlyTitleSize = 26;
int yearlyAxisLblSize = 16;

/* Boundry*/
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
      fill(moTableBGCol);
      rect(moTableLeft, moTableBottom, moTableWidth, -moTableHeight);
   }
}



/****************************************
************* Graph Buttons *************
****************************************/
// Adds toggle buttons to the graph, which allow the user to toggle the MouseOver & Linear Comparison features on/off.

boolean linearToggle;
boolean moToggle;
color toggleLblCol = color(20);

void yearlyToggleButtons()
{
   float buttonW = 40;
   float buttonH = 18;
   
   /********** LINEAR BUTTON **********/
   
   textAlign(LEFT,CENTER);
   textSize(10);
   fill(toggleLblCol);
   text("Toggle Linear Comparison: ", xBoundryStart+20, yBoundryEnd+20);
   
   PVector linearTogglePos = new PVector(xBoundryStart + 165, yBoundryEnd + 12);
   color linearToggleCol = color(0);
   
   // If Mouse Over Button ... / Else ...
   if (mouseX > linearTogglePos.x && mouseX < linearTogglePos.x + buttonW && mouseY > linearTogglePos.y && mouseY < linearTogglePos.y + buttonH)
   {
      linearToggleCol = color(0,150,255);
      if (mousePressed)
         linearToggle = !linearToggle;
   }
   else
   {
      linearToggleCol = color(0,0,255);
   }
   
   // Setting Button Label
   String linearLbl;
   if (linearToggle)
      linearLbl = "ON";
   else
      linearLbl = "OFF";
   
   // Draw Button
   fill(linearToggleCol);
   stroke(linearToggleCol);
   rect(linearTogglePos.x, linearTogglePos.y, buttonW, buttonH);
   
   // Draw Button Label
   fill(255);
   textAlign(CENTER,CENTER);
   textSize(12);
   text(linearLbl, linearTogglePos.x + (buttonW/2), linearTogglePos.y + (buttonH/2));
   
   
   /********** MouseOver Button **********/
   
   textAlign(LEFT,CENTER);
   textSize(10);
   fill(toggleLblCol);
   text("Toggle Mouse-Over Feature: ", xBoundryStart+20, yBoundryEnd+50);
   
   float moX1 = linearTogglePos.x;
   float moY1 = linearTogglePos.y + 30;
   color moToggleCol = color(0);
   
   // If Mouse Over Button ... / Else ...
   if (mouseX > moX1 && mouseX < moX1 + buttonW && mouseY > moY1 && mouseY < moY1 + buttonH)
   {
      moToggleCol = color(0,150,255);
      if (mousePressed)
         moToggle = !moToggle;
   }
   else
   {
      moToggleCol = color(0,0,255);
   }
   
   // Setting Button Label
   String moLbl;
   if (moToggle)
      moLbl = "ON";
   else
      moLbl = "OFF";
   
   // Draw Button
   fill(moToggleCol);
   stroke(moToggleCol);
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

color yearlyNonLinearCol = color(0,255,255);   // Non Linear graphline colour;
color yearlyMOLineCol = color(20);             // MouseOver line colour;
color yearlyMOLblCol = color(20);              // MouseOver line colour;
color yearlyMODataCol = color(0,150,255);      // MouseOver data colour;

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
      String spentVal = twoDecimals(prev.spent[countryID]);
      String totalVal = twoDecimals(totalToDate);
      
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
            
            fill(yearlyMOLblCol);
            textSize(30);
            text(yearLbl, yearLblPos.x, yearLblPos.y);      // Year label
            textSize(13);
            text(spentLbl, spentLblPos.x, spentLblPos.y);   // Spent label
            text(totalLbl, totalLblPos.x, totalLblPos.y);   // Total label
            
            fill(yearlyMODataCol);
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

color yearlyLinearLineCol = color(0,25,255);   // Linear graphline colour;

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
   
   // Getting the co-ords to draw the lines.
   // The co-ordinates are mapped so that they fit the screen  @ the desired scale (0 -> country max range)
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

color coButtonCol = color(20);
color coButtonMOCol = color(75);
color cotoggleLblCol = color(255);
int coButtonLblSize = 12;
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
color ovrChartBG = color(255);
color ovrChartAxisCol = color(127);
float countryTotal[] = new float[countryCount];
String countryPC[] = new String[countryCount];
float combinedSum;       // total spent of each country combined

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
  
  fill(245);
  textAlign(CENTER,CENTER);
  textSize(16);
  text("Percent (%)", width/2, boundryPos + 48);
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
      text(twoDecimals(countryTotal[i]), 0, 0);
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
      yearlyToggleButtons();
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