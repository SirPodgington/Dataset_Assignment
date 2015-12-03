String countryAbbrev[] = {"CAN", "USA", "AL", "BE", "BG", "HR", "CZ", "DK", "EE", "FR", "GER", "GR", "HU", "IT", "LV", "LT", "LU", "NL", "NO", "PL", "PT", "RO", "SK", "SI", "ES", "TR", "UK"};

void setup()
{
   size(1000, 600);
   smooth();
   
   pageKey = 0;
   
   // Graph Properties
   linegraphBG = loadImage("Navy_Blue_Background.jpg");
   linegraphBG.resize(width, height);
   
   graphLineCol = color(0);      // Graph Line
   graphAxisCol = color(255);      // Graph Axis
   graphAxisTxtCol = color(255);
   graphMOLineCol = color(0,255,255);    // MouseOver Line
   graphMOTxtCol = color(0,255,255);     // MouseOver Text
   graphTitleCol = color(255);
   graphTitleTxtSize = 26;
   graphAxisTxtSize = 16;
   
   // Country Button Colours & Font Size
   coButtonCol = color(0);            // Default
   coButtonMOCol = color(0,150,255);  // MouseOver
   coButtonLabelCol = color(255);     // Label
   coButtonTxtSize = 12;
   
   // Return To Menu Colour & Font Size
   retToMenuCol = color(0);
   retToMenuTxtSize = 26;
   
   // Barchart Colours & Font Size
   barchartBG = loadImage("");
   barchartBG.resize(width, height);
   barAxisCol = colour(255);
   
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
int retToMenuTxtSize;

void returnToMenu()
{
   fill(retToMenuCol);
   textSize(retToMenuTxtSize);
   textAlign(CENTER,CENTER);
  
   String menuString = "Return to Main Menu [Press M]";
   PVector menuPos = new PVector(width / 2, height - (boundrySize/2));
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
  COUNTRY LINEGRAPH   *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/

String country[] = 
{"Canada","USA","Albania","Belgium","Bulgaria","Croatia","Czech Rep","Denmark","Estonia",
"France","Germany","Greece","Hungary","Italy","Latvia","Lithuania","Luxembourg","Netherlands",
"Norway","Poland","Portugal","Romania","Slovakia","Slovenia","Spain","Turkey","UK"};
int coMaxRange[] =
{16000, 750000, 200, 5000, 1000, 1500, 2500, 30000, 500, 50000, 40000, 10000, 1500,      // Stores the max range values for all countries
30000, 600, 500, 300, 10000, 5000, 10000, 4000, 2000, 1000, 750, 15000, 15000, 60000};
int countryCount = 27;
float coTotalSpent[] = new float[countryCount];      // Array to store total spent for each country
int countryID = 0;                                   // References the arraylist position of the requested country -> Initialised to 0 (first country position)
PImage linegraphBG;                                  // Background for the page
float totalToDate;
int boundrySize;

color coButtonCol;
color coButtonMOCol;
color coButtonLabelCol;
color graphTitleCol;
color graphLineCol;
color graphAxisCol;
color graphAxisTxtCol;
color graphMOLineCol;
color graphMOTxtCol;
int coButtonTxtSize;
int graphTitleTxtSize;
int graphAxisTxtSize;


void yearlyGraphs()
{
   
   /*************** AXIS ***************/
   
   // Boundry Properties
   boundrySize = width / 10;
   int xBoundryStart = boundrySize;
   int xBoundryEnd = width - boundrySize;
   int xLength = xBoundryEnd - xBoundryStart;
   int yBoundryStart = height - boundrySize;
   int yBoundryEnd = boundrySize;
   int yLength = yBoundryStart - yBoundryEnd;
     
   // Axis Properties
   stroke(graphAxisCol);
   fill(graphAxisTxtCol);
   strokeWeight(2);
   textSize(graphAxisTxtSize);
   
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
   
   
   /*************** LINEGRAPH ***************/
   
   totalToDate = militaryExpenses.get(0).spent[countryID];
   
   for (int i = 1; i < militaryExpenses.size(); i++)
   {
      LoadData prev = militaryExpenses.get(i-1);
      LoadData next = militaryExpenses.get(i);
 
      float prevX = map(i-1, 0, (militaryExpenses.size() - 1), boundrySize, width - boundrySize);
      float nextX = map(i, 0, (militaryExpenses.size() - 1), boundrySize, width - boundrySize);
      float prevY = map(prev.spent[countryID], 0, coMaxRange[countryID], yBoundryStart, boundrySize);
      float nextY = map(next.spent[countryID], 0, coMaxRange[countryID], yBoundryStart, boundrySize);
      
      stroke(0);
      strokeWeight(2);
      line(prevX, prevY, nextX, nextY);
       
      /********** MouseOver Feature **********/
      
      PVector yearStringPos = new PVector(xBoundryStart + 15, boundrySize + 5);
      PVector spentStringPos = new PVector(yearStringPos.x, yearStringPos.y + 25);
      PVector totalStringPos = new PVector(yearStringPos.x, spentStringPos.y + 25);
      String yearVal = "Year: " + (int)prev.year;
      String spentVal = "Spent (Mil.€): " + prev.spent[countryID];
      String totalVal = "Total To Date: " + totalToDate;
      
      stroke(graphMOLineCol);
      fill(graphMOTxtCol);
      textAlign(LEFT, CENTER);
      textSize(19);
      
      if (mouseY < yBoundryStart && mouseY > yBoundryEnd)
      {
         if (mouseX > prevX && mouseX < nextX)
         {       
            // MouseOver Line
            line(mouseX, yBoundryStart, mouseX, yBoundryEnd);
            
            // MouseOver Data
            text(yearVal, yearStringPos.x, yearStringPos.y);
            text(spentVal, spentStringPos.x, spentStringPos.y);
            text(totalVal, totalStringPos.x, totalStringPos.y);
         }
      }
      totalToDate += next.spent[countryID];
   }

   
   
   /*************** TITLE ***************/
   
   textAlign(CENTER, CENTER);
   textSize(graphTitleTxtSize);
   fill(graphTitleCol);
   
   String title = country[countryID];
   PVector titlePos = new PVector(width/2, 60);
   text(title.toUpperCase(), titlePos.x, titlePos.y);
   
   
   /*************** COUNTRY BUTTONS ***************/
   
   // Button Properties
   float buttonWidth = (float) width / countryCount;
   int buttonHeight = 20;
   
   // Button Code ... Display & Function
   for (int i = 0; i < countryCount; i++)   // Button For Each Country
   {
      float buttonX = buttonWidth * i;
      
      // If Mouse Is Over Button -- Else If Button Pressed -- Else..
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
      textSize(coButtonTxtSize);
      text(countryAbbrev[i], labelPos.x, labelPos.y);
   }
}



/************************
                      *************************************************************************************************************************************************************************
  Yearly Comparison   *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/

color barAxisCol;

void drawBarchart()
{
  /********** Boundry **********/
  float boundrySize = height * 0.1f;
  float boundryStart = 0;
  float boundryEnd = width;
  float boundryPos = height - boundrySize;
  
  /********** Axis **********/
  stroke(barAxisCol);
  line(boundryStart, boundryPos, boundryEnd, boundryPos);
  
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
  
   // YEARLY GRAPH PAGE
   if (pageKey == 1)
   {  
      background(linegraphBG);
      yearlyGraphs();
      returnToMenu();
   }
 
   // OVERALL SPENT PAGE
   if (pageKey == 2)
   {
      background(255,0,0);
      overallSpent();
      returnToMenu();
   }
   
}
