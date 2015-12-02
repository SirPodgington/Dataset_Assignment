String countriesAbbr[] = {"CAN", "USA", "AL", "BE", "BG", "HR", "CZ", "DK", "EE", "FR", "GER", "GR", "HU", "IT", "LV", "LT", "LU", "NL", "NO", "PL", "PT", "RO", "SK", "SI", "ES", "TR", "UK"};
int countryCount = countriesAbbr.length;
int countryMaxRange[] = {16000, 750000, 200, 5000, 1000, 1500, 2500, 30000, 500, 50000, 40000, 10000, 1500, 30000, 600, 500, 300, 10000, 5000, 10000, 4000, 2000, 1000, 750, 15000, 15000, 60000};
int country = 0;
PImage yearlyGraphBG;
int pageKey = 0;

void setup()
{
  size(1000, 600);
  yearlyGraphBG = loadImage("lgraph.jpg");
  
  loadExpensesYear();
  loadExpensesCountry();
}

//********************************************************************************************************************************************************************************************

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

//********************************************************************************************************************************************************************************************

ArrayList<ExpenseByYear> expenseByYear = new ArrayList<ExpenseByYear>();

void loadExpensesYear()
{
  String[] lines = loadStrings("expensesByYear.csv");
  
  for (String line:lines)
  {
    ExpenseByYear byYear = new ExpenseByYear(line);
    expenseByYear.add(byYear);
  }
  
}

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
  
}

//********************************************************************************************************************************************************************************************

void overallSpent()
{
  
}

//********************************************************************************************************************************************************************************************

void yearlyGraphs()
{
  int boundryOffset = width / 10;
  
  String returnMenu = "Return to Main Menu [Press M]";
  textSize(16);
  textAlign(CENTER,CENTER);
  fill(0);
  float menuX = width/2;
  float menuY = height - (boundryOffset/2);
  text(returnMenu, menuX, menuY);
  
  //*****************************************
  //*************  BUTTONS  *****************
  //*****************************************
  
  float buttonGap = (float) width / countryCount;
  int buttonHeight = 20;
  
  for (int i = 0; i < countryCount; i++)
  {
    float buttonX = buttonGap * i;
    
    if (mouseX > buttonX && mouseX < (buttonX + buttonGap) && mouseY < buttonHeight)
    {
      fill(255,0,0);
      if (mousePressed) 
      {
        country = i;
      }
    }
    else 
    {
      fill(0);
    }
    rect(buttonX, 0, buttonGap, buttonHeight);
    line(buttonX, 0, buttonX, buttonHeight);
    
    // Button text (Country name abbreviation)
    float textX = buttonX + (buttonGap / 2);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(countriesAbbr[i], textX, 10);
  }
  
  // Graph title (country name)
  ExpenseByYear countryName = expenseByYear.get(country + 1);
  String gTitle = countryName.country;
  textAlign(CENTER, CENTER);
  textSize(22);
  text(gTitle.toUpperCase(), width / 2, (boundryOffset + buttonHeight) / 2);

  //*****************************************
  //***************  AXIS  ******************
  //*****************************************
  
  int xBoundry = boundryOffset;
  int xLength = width - (boundryOffset * 2);
  int yBoundry = height - boundryOffset;
  int yLength = height - (boundryOffset * 2);
  int markerSize = 10;

  // X-Axis
  line(xBoundry, yBoundry, xBoundry+xLength, yBoundry);
  
  // X-Axis start marker
  int xAxisStartVal = (int)expenseByCountry.get(0).year;
  line(xBoundry, yBoundry, xBoundry, yBoundry + markerSize);
  textAlign(CENTER);
  text(xAxisStartVal, xBoundry, yBoundry + 35);
  
  // X-Axis end marker
  int xAxisEndVal = (int)expenseByCountry.get(expenseByCountry.size() - 1).year;
  line(xBoundry + xLength, yBoundry, xBoundry + xLength, yBoundry + markerSize);
  text(xAxisEndVal, xBoundry + xLength, yBoundry + 35);
  
  // Y-Axis 
  line(xBoundry, yBoundry, xBoundry, yBoundry - yLength);
  
  // Y-Axis start marker
  int yAxisStartVal = 0;
  line(xBoundry, yBoundry, xBoundry - markerSize, yBoundry);
  textSize(20);
  textAlign(RIGHT, CENTER);
  text(yAxisStartVal, xBoundry - 20, yBoundry);
  
  // Y-Axis end marker
  int yAxisEndVal = countryMaxRange[country];
  line(xBoundry, yBoundry - yLength, xBoundry - markerSize, yBoundry - yLength);
  text(yAxisEndVal, xBoundry - 20, yBoundry - yLength);
  
  //*****************************************
  //*************  LINEGRAPH  ***************
  //*****************************************

    for (int i = 1; i < expenseByCountry.size(); i++)
    {
      ExpenseByCountry pointA = expenseByCountry.get(i-1);
      ExpenseByCountry pointB = expenseByCountry.get(i);
      float lineGraphX1 = map(i-1, 0, (expenseByCountry.size() - 1), boundryOffset, width - boundryOffset);
      float lineGraphX2 = map(i, 0, (expenseByCountry.size() - 1), boundryOffset, width - boundryOffset);
      float lineGraphY1 = map(pointA.spent[country], 0, countryMaxRange[country], yBoundry, boundryOffset);
      float lineGraphY2 = map(pointB.spent[country], 0, countryMaxRange[country], yBoundry, boundryOffset);
      stroke(0);
      strokeWeight(4);
      line(lineGraphX1, lineGraphY1, lineGraphX2, lineGraphY2);
      strokeWeight(1);
      stroke(255);
      
      // Display mouse-over year & value ******************************
      if (mouseY < yBoundry && mouseY > yBoundry - yLength)
      {
        if (mouseX >= lineGraphX1 && mouseX <= lineGraphX2)
        {
          stroke(255,0,0);
          line(mouseX, yBoundry, mouseX, boundryOffset);
          
          float yearCaptionX = xBoundry + 15;
          float yearCaptionY = boundryOffset + 5;
          String yearVal = "Year: " + (int)pointA.year;
          float spentCaptionX = yearCaptionX;
          float spentCaptionY = yearCaptionY + 25;
          String spentVal = "Spent (Mil.€): " + pointA.spent[country];
          
          fill(200,0,0);
          textAlign(LEFT, CENTER);
          textSize(19);
          text(yearVal, yearCaptionX, yearCaptionY);
          text(spentVal, spentCaptionX, spentCaptionY);
          stroke(255);
        }
      }
    }
}

//********************************************************************************************************************************************************************************************

void draw()
{
  
  // MAIN MENU *********************************
  if (pageKey == 0)
  {
    background(0);
    drawMenu();
    
    if (keyPressed)
    {
      if (key == '1') pageKey = 1;
      if (key == '2') pageKey = 2;
      if (key == '3') System.exit(0);
    }
  }
  // END OF MAIN MENU **************************
  
  
  
  if (pageKey == 1 || pageKey == 2)
  {
    if (keyPressed && (key == 'M' || key == 'm'))
      pageKey = 0;
    
    // YEARLY GRAPH PAGE
    if (pageKey == 1)
    {  
      background(yearlyGraphBG);
      yearlyGraphs();
    }
    
    // OVERALL SPENT PAGE
    if (pageKey == 2)
    {
      background(255,0,0);
      //draw_?_();
    }
  }
}
