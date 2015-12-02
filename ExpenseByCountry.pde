class ExpenseByCountry
{
  float year;
  int countrySize = 27;
  float[] spent = new float[countrySize];
  
  ExpenseByCountry(String line)
  {
    String[] lineElements = line.split(",");
    year = Float.parseFloat(lineElements[0]);
    for (int i = 0; i < countrySize; i++)
    {
      spent[i] = Float.parseFloat(lineElements[i+1]);
    }
  }
}