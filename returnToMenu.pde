/************************
                       *************************************************************************************************************************************************************************
    RETURN TO MENU     *************************************************************************************************************************************************************************
                       *************************************************************************************************************************************************************************
************************/
// Indicates to user what key to press to return to main menu
// Sets pagekey to main menu's if the key is pressed

color retToMenuCol;
int retToMenuSize;
PVector menuPos;

void returnToMenu()
{
   fill(retToMenuCol);
   textSize(retToMenuSize);
   textAlign(RIGHT,CENTER);
  
   String menuString = "Return to Main Menu [Press M]";
   text(menuString, menuPos.x, menuPos.y);
   
   if (keyPressed && (key == 'M' || key == 'm'))
   {
      pageKey = 0;
   }
}