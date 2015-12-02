
void setup()
{
   size(1000, 600);
   smooth();
   
   pageKey = 0;
   linegraphBG = loadImage("Navy_Blue_Background.jpg");
   linegraphBG.resize(width, height);
   
   // Country Button Colours
   coButtonCol = color(0);            // Default
   coButtonMOCol = color(0,150,255);  // MouseOver
   coButtonLabelCol = color(255);     // Label
   
   // Graph Colours
   graphLineCol = color(0);      // Graph Line
   graphAxisCol = color(0);      // Graph Axis
   graphMOLineCol = color(0,255,255);    // MouseOver Line
   graphMOTxtCol = color(0,255,255);     // MouseOver Text
   
   loadExpensesCountry();   // Load Data Into ArrayLists
   getTotal();   // Get Total Spent By Each Country
}


/************************
                      *************************************************************************************************************************************************************************
    RETURN TO MENU    *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/

void returnToMenu()
{
   String menuString = "Return to Main Menu [Press M]";
   PVector menuPos = new PVector(width / 2, height - 20);
   
   fill(0);
   textSize(16);
   textAlign(CENTER,CENTER);
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

void drawMenu()
{
   fill(255);
   textAlign(LEFT,CENTER);
   textSize(18);
     
   float textX = width * 0.3f;
   float opt1Y = height * 0.4f;
   float opt2Y = height * 0.5f;
   float opt3Y = height * 0.6f;
   String option1 = "Military Expenses Per Year [Press 1]";
   String option2 = "Overall Military Expenses [Press 2]";
   String option3 = "Exit [Press 3]";
     
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

ArrayList<ExpenseByCountry> expenseByCountry = new ArrayList<ExpenseByCountry>();

void loadExpensesCountry()
{
   String[] lines = loadStrings("expensesByCountry.csv");
   for (String line:lines)
   {
      ExpenseByCountry byCountry = new ExpenseByCountry(line);
      expenseByCountry.add(byCountry);
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

color coButtonCol;
color coButtonMOCol;
color coButtonLabelCol;
color graphLineCol;
color graphAxisCol;
color graphMOLineCol;
color graphMOTxtCol;

// Method to get total spent by each country
void getTotal()
{
   for (int i = 0; i < expenseByCountry.size(); i++)
   {
      ExpenseByCountry loadTotal = expenseByCountry.get(i);
      for (float amount:loadTotal.spent)
      {
         coTotalSpent[i] += amount;
      }
      println(coTotalSpent[i]);
   }
}

void yearlyGraphs()
{
   
   /*************** AXIS ***************/
   
   // Boundry Properties
   int boundrySize = width / 10;
   int xBoundry = boundrySize;
   int xLength = width - (boundrySize * 2);
   int yBoundry = height - boundrySize;
   int yLength = height - (boundrySize * 2);
     
   // Axis Properties
   stroke(255);
   strokeWeight(2);
   int markerSize = 10;
   int xTextOffset = 35;
   int yTextOffset = 20;
   int xAxisStartVal = 1949;
   int xAxisEndVal = 2014;
   int yAxisStartVal = 0;
   int yAxisEndVal = coMaxRange[countryID];
     
   // X-Axis
   line(xBoundry, yBoundry, xBoundry+xLength, yBoundry);
   // X-Axis Start Marker
   line(xBoundry, yBoundry, xBoundry, yBoundry+markerSize);
   textAlign(CENTER);
   text(xAxisStartVal, xBoundry, yBoundry+xTextOffset);
   // X-Axis End Marker
   line(xBoundry+xLength, yBoundry, xBoundry+xLength, yBoundry+markerSize);
   text(xAxisEndVal, xBoundry + xLength, yBoundry + xTextOffset);
     
   // Y-Axis 
   line(xBoundry, yBoundry, xBoundry, yBoundry - yLength);
   // Y-Axis start marker
   line(xBoundry, yBoundry, xBoundry - markerSize, yBoundry);
   textSize(20);
   textAlign(RIGHT, CENTER);
   text(yAxisStartVal, xBoundry - yTextOffset, yBoundry);
   // Y-Axis end marker
   line(xBoundry, yBoundry-yLength, xBoundry-markerSize, yBoundry-yLength);
   text(yAxisEndVal, xBoundry-yTextOffset, yBoundry-yLength);
   
   
   /*************** LINEGRAPH ***************/
   
   for (int i = 1; i < expenseByCountry.size(); i++)
   {
      ExpenseByCountry prev = expenseByCountry.get(i-1);
      ExpenseByCountry next = expenseByCountry.get(i);
      float prevX = map(i-1, 0, (expenseByCountry.size() - 1), boundrySize, width - boundrySize);
      float nextX = map(i, 0, (expenseByCountry.size() - 1), boundrySize, width - boundrySize);
      float prevY = map(prev.spent[countryID], 0, coMaxRange[countryID], yBoundry, boundrySize);
      float nextY = map(next.spent[countryID], 0, coMaxRange[countryID], yBoundry, boundrySize);
      stroke(0);
      strokeWeight(2);
      line(prevX, prevY, nextX, nextY);
       
      /********** MouseOver Feature **********/
    
      if (mouseY < yBoundry && mouseY > boundrySize)
      {
         if (mouseX > prevX && mouseX < nextX)
         {
            fill(200,0,0);
            textAlign(LEFT, CENTER);
            textSize(19);
            PVector yearStringPos = new PVector(xBoundry + 15, boundrySize + 5);
            PVector spentStringPos = new PVector(yearStringPos.x, yearStringPos.y + 25);
            String yearVal = "Year: " + (int)prev.year;
            String spentVal = "Spent (Mil.€): " + prev.spent[countryID];
            
            // MouseOver Line
            stroke(graphMOLineCol);
            line(mouseX, yBoundry, mouseX, boundrySize);
            
            // MouseOver Data
            fill(graphMOTxtCol);
            textAlign(LEFT, CENTER);
            textSize(19);
            text(yearVal, yearStringPos.x, yearStringPos.y);
            text(spentVal, spentStringPos.x, spentStringPos.y);
         }
      }
   }
   
   
   /*************** TITLE ***************/
   
   String title = country[countryID];
   PVector titlePos = new PVector(width/2, 60);
   fill(255);
   textAlign(CENTER, CENTER);
   textSize(22);
   text(title.toUpperCase(), titlePos.x, titlePos.y);
   
   
   /*************** COUNTRY BUTTONS ***************/
   
   // Button Properties
   float buttonWidth = (float) width / countryCount;
   int buttonHeight = 20;
   String countryAbbrev[] = {"CAN", "USA", "AL", "BE", "BG", "HR", "CZ", "DK", "EE", "FR", "GER", "GR", "HU", "IT", "LV", "LT", "LU", "NL", "NO", "PL", "PT", "RO", "SK", "SI", "ES", "TR", "UK"};
   
   // Button Code ... Display & Function
   for (int i = 0; i < countryCount; i++)   // Button For Each Country
   {
      float buttonX = buttonWidth * i;
      
      // If Mouse Is Over Button -- Else If Button Pressed -- Else..
      if (mouseX > buttonX && mouseX < (buttonX + buttonWidth) && mouseY < buttonHeight)
      {
         fill(coButtonMOCol);
         stroke(coButtonMOCol);
         
      if (mousePressed) countryID = i;
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
      textSize(12);
      text(countryAbbrev[i], labelPos.x, labelPos.y);
   }
}



/************************
                      *************************************************************************************************************************************************************************
     Second Graph     *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/

void overallSpent()
{
  
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