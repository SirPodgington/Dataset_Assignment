/************************
                      *************************************************************************************************************************************************************************
      MAIN MENU       *************************************************************************************************************************************************************************
                      *************************************************************************************************************************************************************************
************************/
// Menu the user is greeted with at startup. Allows user to navigate to desired page or exit program

color optLblCol;
color optBGCol;
color optOLCol;

void drawMenu()
{
   String options[] = {"Military Expenses (Yearly Progression)", "Military Expenses (Overall Comparison)", "Exit"};
   float optHeight = height / 3;
   
   for (int i = 0; i < 3; i++)
   {
      float startY = optHeight * i;
      
      if (mouseY > startY && mouseY < startY + optHeight)
      {
         optBGCol = color(45);
         optOLCol = color(0,150,255);
         optLblCol = optOLCol;
         
         if (mousePressed)
            pageKey = i+1;
      }
      else
      {
         optBGCol = color(0,150,255);
         optOLCol = color(45);
         optLblCol = optOLCol;
      }
      
      // Option Background
      fill(optBGCol);
      stroke(optOLCol);
      rect(0, startY, width, optHeight);
      
      // Option Label
      textAlign(CENTER,CENTER);
      textSize(40);
      fill(optLblCol);
      text(options[i], width/2, startY + (optHeight/2));
   }
}