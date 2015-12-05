class LoadData
{
  float year;
  float spent[] = new float[countryCount];
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
