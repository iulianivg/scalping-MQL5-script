//+------------------------------------------------------------------+
//|                                                  KeyTradeEA.mq5  |
//|                      © 2024 Iulian Ivighenie                     |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "© 2024 Iulian Ivighenie"
#property link      "your.email@example.com"
#property version   "1.21"
#property indicator_chart_window

#include <Trade\Trade.mqh>

// Global variables
CTrade trade; // Trade object for executing orders
#define BTN_NAME "CloseAllButton"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Create the 'x' button
   CreateCloseAllButton();

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   // Delete the button when the EA is removed
   ObjectDelete(0, BTN_NAME);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // The EA doesn't need to perform any action on every tick for this functionality
  }
//+------------------------------------------------------------------+
//| Chart event function                                             |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   // Handle key press events
   if(id == CHARTEVENT_KEYDOWN)
     {
      // lparam contains the key code
      int key_code = (int)lparam;
      // Convert the key code to a character
      string key_char = CharToString((ushort)key_code);

      if(key_char == "C" || key_char == "c")
        {
         // Place a market buy order of 0.01 lots
         if(trade.Buy(140.00, NULL, 0, 0, "Buy Order"))
            Print("Buy order placed successfully.");
         else
            Print("Failed to place buy order. Error: ", GetLastError());
        }
      else if(key_char == "Z" || key_char == "z")
        {
         // Place a market sell order of 0.01 lots
         if(trade.Sell(140.00, NULL, 0, 0, "Sell Order"))
            Print("Sell order placed successfully.");
         else
            Print("Failed to place sell order. Error: ", GetLastError());
        }
      else if(key_char == "X" || key_char == "x"){
         CloseAllPositions();
         Print("Everything closed");
      }
     }

   // Check if the button was clicked
   if(id == CHARTEVENT_OBJECT_CLICK)
     {
      if(sparam == BTN_NAME)
        {
         // Close all open positions
         CloseAllPositions();
        }
     }
  }
//+------------------------------------------------------------------+
//| Function to create 'x' button                                    |
//+------------------------------------------------------------------+
void CreateCloseAllButton()
  {
   // Delete existing button if any
   ObjectDelete(0, BTN_NAME);

   // Create a button
   if(!ObjectCreate(0, BTN_NAME, OBJ_BUTTON, 0, 0, 0))
     {
      Print("Failed to create button. Error: ", GetLastError());
      return;
     }

   // Set button properties
   ObjectSetInteger(0, BTN_NAME, OBJPROP_XDISTANCE, 10);
   ObjectSetInteger(0, BTN_NAME, OBJPROP_YDISTANCE, 10);
   ObjectSetInteger(0, BTN_NAME, OBJPROP_XSIZE, 50);
   ObjectSetInteger(0, BTN_NAME, OBJPROP_YSIZE, 20);
   ObjectSetString(0, BTN_NAME, OBJPROP_TEXT, "X");
   ObjectSetInteger(0, BTN_NAME, OBJPROP_CORNER, 0); // Top-left corner
  }
//+------------------------------------------------------------------+
//| Function to close all open positions                             |
//+------------------------------------------------------------------+
void CloseAllPositions()
  {
   int total = PositionsTotal();
   for(int i = total - 1; i >= 0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
        {
         string symbol = PositionGetString(POSITION_SYMBOL);

         if(trade.PositionClose(ticket))
            Print("Closed position on ", symbol, " successfully.");
         else
            Print("Failed to close position on ", symbol, ". Error: ", GetLastError());
        }
     }
  }
//+------------------------------------------------------------------+
