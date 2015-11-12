String countriesAbbr[] = {"CAN", "USA", "AL", "BE", "BG", "HR", "CZ", "DK", "EE", "FR", "GER", "GR", "HU", "IT", "LV", "LT", "LU", "NL", "NO", "PL", "PT", "RO", "SK", "SI", "ES", "TR", "UK"};
int countryCount = countriesAbbr.length;
int countryMaxRange[] = {16000, 750000, 200, 5000, 1000, 1500, 2500, 30000, 500, 50000, 40000, 10000, 1500, 30000, 600, 500, 300, 10000, 5000, 10000, 4000, 2000, 1000, 750, 15000, 15000, 60000};
int country = 0;
PImage countryGraphBG;
int pageKey = 1;

void setup()
{
  size(1000, 600);
  countryGraphBG = loadImage("lgraph.jpg");
  
  loadExpensesYear();
  loadExpensesCountry();
}

ArrayList<ExpenseByCountry> expenseByCountry = new ArrayList<ExpenseByCountry>();
ArrayList<ExpenseByYear> expenseByYear = new ArrayList<ExpenseByYear>();

void loadExpensesCountry()
{
  String[] lines = loadStrings("expensesByCountry.csv");
  
  for (String line:lines)
  {
    ExpenseByCountry byCountry = new ExpenseByCountry(line);
    expenseByCountry.add(byCountry);
  }
}

void loadExpensesYear()
{
  String[] lines = loadStrings("expensesByYear.csv");
  
  for (String line:lines)
  {
    ExpenseByYear byYear = new ExpenseByYear(line);
    expenseByYear.add(byYear);
  }
  
}

void countryGraphs()
{
  int boundryOffset = width / 10;
  
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
      
      // Display mouse-over year & value
      if (mouseY < yBoundry && mouseY > yBoundry - yLength)
      {
        if (mouseX >= lineGraphX1 && mouseX <= lineGraphX2)
        {
          stroke(255,0,0);
          line(mouseX, yBoundry, mouseX, boundryOffset);
          
          fill(255,255,255);
          textAlign(CENTER, CENTER);
          textSize(32);
          text("Year: " + (int)pointA.year, width / 2, (height / 2) - 35);
          text("Spent (Mil.€): " + pointA.spent[country], width / 2, (height / 2) + 35);
          stroke(255);
        }
      }
    }
}



void draw()
{
  //background(0);
  if (keyPressed)
  {
    if (key == '0') pageKey = 0;
    if (key == '1') pageKey = 1;
    if (key == '2') pageKey = 2;
  }
  
  if (pageKey == 0)
  {
    background(0);
    //drawMenu();
    
    if (keyPressed)
    {
      if (key == '0') pageKey = 0;
      if (key == '1') pageKey = 1;
      if (key == '2') pageKey = 2;
    }
  }
  if (pageKey == 1)
  {
    background(countryGraphBG);
    countryGraphs();
  }
  if (pageKey == 2)
  {
    background(255,0,0);
    //draw_?_();
  }
}
