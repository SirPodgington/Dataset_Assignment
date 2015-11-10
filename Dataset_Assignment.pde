int countryCount = 27;
int mapRanges[] = {};


void setup()
{
  size(600, 600);
  
  loadExpensesYear();
  loadExpensesCountry();
  
  /*  ByCountry TEST: PRINTING OUT FIRST 7 EXPENSE VALUES FOR EACH COUNTRY **WORKS**
  for (int i = 0; i < expenseByCountry.size(); i++)
  {
    ExpenseByCountry test = expenseByCountry.get(i);
    print(test.country + "\t\t" + test.currency + "\t\t");
    for (int j = 0; j < 7; j++) print(test.year[j] + "\t\t");
    println("");
  }
  */
}

ArrayList<ExpenseByCountry> expenseByCountry = new ArrayList<ExpenseByCountry>();
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

void loadExpensesCountry()
{
  String[] lines = loadStrings("expensesByCountry.csv");
  
  for (String line:lines)
  {
    ExpenseByCountry byCountry = new ExpenseByCountry(line);
    expenseByCountry.add(byCountry);
  }
}

void lGraphYearly()
{
  //*****************************************
  //****************  AXIS  *****************
  //*****************************************
  
  // ******** REMOVE AXIS AND PUT INTO SEPARATE METHOD ****************
  
  int boundryOffset = 80;
  int xBoundry = boundryOffset;
  int xLength = width - (boundryOffset * 2);
  int yBoundry = height - boundryOffset;
  int yLength = height - (boundryOffset * 2);
  
  // X-Axis
  line(xBoundry, yBoundry, xBoundry+xLength, yBoundry);
  // Y-Axis
  line(xBoundry, yBoundry, xBoundry, yBoundry - yLength);
  
  
  //*****************************************
  //*************  LINEGRAPH  ***************
  //*****************************************
  
  //for (int j = 0; j < countryCount; j++) for iterating through each country
  for (int i = 1; i < expenseByYear.size(); i++)
  {
    ExpenseByYear pointA = expenseByYear.get(i-1);
    ExpenseByYear pointB = expenseByYear.get(i);
    float lineGraphX1 = map(i-1, 0, expenseByYear.size(), boundryOffset, width - boundryOffset);
    float lineGraphX2 = map(i, 0, expenseByYear.size(), boundryOffset, width - boundryOffset);
    float lineGraphY1 = map(pointA.spent[0], 0, 22000, yBoundry, boundryOffset);
    float lineGraphY2 = map(pointB.spent[0], 0, 22000, yBoundry, boundryOffset);
    stroke(255);
    line(lineGraphX1, lineGraphY1, lineGraphX2, lineGraphY2);
  }
  
}

void draw()
{
  background(0);
  lGraphYearly();
  //text("Press 1 for Military Expenses by Year", x, y);
  //text("Press 2 for Military Expenses by Country", x, y);
}
