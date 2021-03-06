class LoadData
{
  float year;
  float spent[] = new float[countryCount];      // !*! Value stored is 1/1,000,000 of actual amount spent. Simplified to keep keep numbers small  *!* 
  float totSpentYearly;

  
  LoadData(String line)
  {
    String[] lineElements = line.split(",");
    year = Float.parseFloat(lineElements[0]);
    for (int i = 0; i < countryCount; i++)
    {
      spent[i] = Float.parseFloat(lineElements[i+1]);
      totSpentYearly += spent[i];
    }
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