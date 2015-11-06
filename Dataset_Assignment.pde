String[] tempData;
ArrayList<dataStructure> dataList;

void setup()
{
  size(800,500);
  background(220);
}



void loadData(String[] dataArray, ArrayList<dataStructure> dataList)
{
  dataArray = loadStrings("filename.csv");
  dataList = new ArrayList<dataStructure>();
}



void draw()
{
  
}
