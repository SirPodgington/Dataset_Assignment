/*********************************
                                *************************************************************************************************************************************************************************
     Format To 2 Decimals       *************************************************************************************************************************************************************************
                                *************************************************************************************************************************************************************************
*********************************/
// Converts the inputted float to string and limits it to 2 decimal places

String twoDecimals(float val)
{
   String formatted = String.format("%.02f", val);
   return formatted;
}