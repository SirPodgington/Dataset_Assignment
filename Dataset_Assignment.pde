String countryAbbrev[] = {"CAN", "USA", "AL", "BE", "BG", "HR", "CZ", "DK", "EE", "FR", "GER", "GR", "HU", "IT", "LV", "LT", "LU", "NL", "NO", "PL", "PT", "RO", "SK", "SI", "ES", "TR", "UK"};
int countryCount = countryAbbrev.length;
int yearCount;

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
   
   loadExpensesCountry();   // Load Data Into ArrayLists
   yearCount = militaryExpenses.size();
   
   
  // Calculating Each Countrys' Total Spent & Mean Over Timeframe & Combined Sum Of Totals
  for (int i = 0; i < countryCount; i++)
  {
      for (int j = 0; j < yearCount; j++)
      {
         LoadData year = militaryExpenses.get(j);
         countryTotal[i] += year.spent[i];
      }
      combinedSum += countryTotal[i];
      countryMean[i] = (float) countryTotal[i] / yearCount;
  }
  
  // Calculating Each Countrys' % (Country Total / Combined Sum Of All Countrys' Totals)
  for (int i = 0; i < countryTotal.length; i++)
  {
      float val = map(countryTotal[i], 0, combinedSum, 0, 100);
      countryPC[i] = nf(val, 2, 1);      // Formatting percentage output
  }
  
  // Calculating Avg Spent Each Year
  yearAvg = new float[yearCount];
  for (int i = 0; i < yearCount; i++)
  {
     LoadData year = militaryExpenses.get(i);
     yearAvg[i] = (float) year.totSpentYearly / countryCount;
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
   // Calls the necessary methods based on what page key is set. (one for each page on program)
   
   /********** MAIN MENU **********/
   if (pageKey == 0)
   {
      background(0);
      drawMenu();  
   }
  
   /********** Yearly Progression **********/
   if (pageKey == 1)
   {  
      background(yearlyBG);
      drawYearly();
   }
 
   /********** Overall Comparison **********/
   if (pageKey == 2)
   {
      background(overallBG);
      drawOverall();
   }
   
   if (pageKey == 3)
      System.exit(0);
   
}