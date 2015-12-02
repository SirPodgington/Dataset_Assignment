
void setup()
{
   size(1000, 600);
   smooth();
   
   pageKey = 0;
   yearlyGraphBG = loadImage("lgraph.jpg");
   
   // Country Button Colours
   countryButton = color(0);   // Default
   countryButtonMO = color(255,0,0);  // MouseOver
   
   // Load Data Into ArrayLists
   loadExpensesCountry();
}


/************  RETURN TO MENU  ************/

void returnToMenu()
{
   String menuString = "Return to Main Menu [Press M]";
   PVector menuPos = new PVector(width / 2, height - 20);
   
   fill(0);
   textSize(16);
   textAlign(CENTER,CENTER);
   text(menuString, menuPos.x, menuPos.y);
   
   if (keyPressed && key == 'M')
   {
      pageKey = 0;
   }
}


//********************************************************************************************************************************************************************************************



//********************************************************************************************************************************************************************************************

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
     Second Graph     *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/


void overallSpent()
{
  
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
int countryCount = 27;
int countryID = 0;                                                                        // References the arraylist position of the requested country -> Initialised to 0 (first country position)
int countryMaxRange[] =                                                                   // Stores the max range values for all countries
{16000, 750000, 200, 5000, 1000, 1500, 2500, 30000, 500, 50000, 40000, 10000, 1500,
30000, 600, 500, 300, 10000, 5000, 10000, 4000, 2000, 1000, 750, 15000, 15000, 60000};
PImage yearlyGraphBG;                                                                     // Background for the page
color countryGraphLine;
color countryButton;
color countryButtonMO;



//*****************************************
//**************  LOAD DATA ***************
//*****************************************

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



//*****************************************
//*************  DRAW GRAPH ***************
//*****************************************

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
   int yAxisEndVal = countryMaxRange[countryID];
     
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
      float prevY = map(prev.spent[countryID], 0, countryMaxRange[countryID], yBoundry, boundrySize);
      float nextY = map(next.spent[countryID], 0, countryMaxRange[countryID], yBoundry, boundrySize);
      stroke(0);
      strokeWeight(2);
      line(prevX, prevY, nextX, nextY);
       
      // Mouse-Over feature
      stroke(255,0,0);
      strokeWeight(2);
      fill(200,0,0);
      textAlign(LEFT, CENTER);
      textSize(19);
      float yearCaptionX = xBoundry + 15;
      float yearCaptionY = boundrySize + 5;
      String yearVal = "Year: " + (int)prev.year;
      float spentCaptionX = yearCaptionX;
      float spentCaptionY = yearCaptionY + 25;
      String spentVal = "Spent (Mil.€): " + prev.spent[countryID];
    
      if (mouseY < yBoundry && mouseY > boundrySize)
      {
         if (mouseX > prevX && mouseX < nextX)
         {
            line(mouseX, yBoundry, mouseX, boundrySize);
            text(yearVal, yearCaptionX, yearCaptionY);
            text(spentVal, spentCaptionX, spentCaptionY);
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
         fill(countryButtonMO);
         stroke(countryButtonMO);
         
         if (mousePressed) countryID = i;
      }
      else 
      {
         fill(countryButton);
         stroke(countryButton);
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



/*********************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************
*********************************************************************************************************************************************************************************************/

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
      background(yearlyGraphBG);
      yearlyGraphs();
      returnToMenu();
   }
 
   // OVERALL SPENT PAGE
   if (pageKey == 2)
   {
      background(255,0,0);
      //draw_?_();
   }
   
}