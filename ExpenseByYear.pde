
class ExpenseByYear
{
  float year;
  int countrySize = 27;
  float[] spent = new float[countrySize];
  String countries[] = {"Canada", "USA", "Albania", "Belgium", "Bulgaria", "Croatia", "Czech Republic", "Denmark", "Estonia", "France", "Germany", "Greece", "Hungary", "Italy", "Latvia", "Lithuania", "Luxembourg", "Netherlands", "Norway", "Poland", "Portugal", "Romania", "Slovakia", "Slovenia", "Spain", "Turkey", "UK"};
  
  ExpenseByYear(String line)
  {
    String[] lineElements = line.split(",");
    year = Float.parseFloat(lineElements[0]);
    for (int i = 0; i < countrySize; i++)
    {
      spent[i] = Float.parseFloat(lineElements[i+1]);
    }
  }
  
}
