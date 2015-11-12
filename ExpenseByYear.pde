
class ExpenseByYear
{
  String country;
  String currency;
  int yearSize = (2014 - 1949) + 1;
  float[] year = new float[yearSize];
  color colour;
  
  ExpenseByYear(String line)
  {
    String[] lineElements = line.split(",");
    country = lineElements[0];
    currency = lineElements[1];
    colour = color(random(0,255), random(0,255), random(0,255));
    
    for (int i = 0; i < yearSize; i++)
    {
      if (lineElements[i+2].isEmpty())
      {
        year[i] = 0.0f;
      }
      else year[i] = Float.parseFloat(lineElements[i+2]);
    }
  }
  
}

