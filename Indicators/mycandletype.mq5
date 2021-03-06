//+------------------------------------------------------------------+
//|                                                 long_candles.mq5 |
//| long_candles                              Copyright 2016, fxborg |
//|                                   http://fxborg-labo.hateblo.jp/ |
//+------------------------------------------------------------------+
#include <MyCandle.mqh>

#property copyright "Copyright 2016, fxborg"
#property link      "http://fxborg-labo.hateblo.jp/"
#property version   "1.05"

#property indicator_buffers 28
#property indicator_plots  21
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100

#property indicator_type1 DRAW_COLOR_CANDLES
#property indicator_color1 clrDodgerBlue,clrRed
#property indicator_width1 1

//+------------------------------------------------------------------+

//--- input parameters
input      double InpBodyS = 0.33;
input      double InpBodyM = 0.75;
input      double InpBodyL = 1.5;
input      double InpBodyXL = 3;
input      double InpHigeS = 0.1;
input      double InpHigeM = 0.2;
input      double InpHigeL = 0.3;
input      double InpHigeXL = 0.6;

double AtrAlpha=0.99;
//---- will be used as indicator buffers
double ATR[];
double BAR[];


double LWC[]; // long wite candle
double LBC[]; // long black candle
double LWC2[]; // long wite candle
double LBC2[]; // long black candle
static const double EV = EMPTY_VALUE;

double OPEN[];
double HIGH[];
double LOW[];
double CLOSE[];
double COLOR[];

CMyCandle MyCandle;

//---- declaration of global variables
int min_rates_total=5;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//---- Initialization of variables of data calculation starting point
//--- indicator buffers
   int i=0;
   SetIndexBuffer(i++,OPEN,INDICATOR_DATA);
   SetIndexBuffer(i++,HIGH,INDICATOR_DATA);
   SetIndexBuffer(i++,LOW,INDICATOR_DATA);
   SetIndexBuffer(i++,CLOSE,INDICATOR_DATA);
   SetIndexBuffer(i++,COLOR,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(i++,BAR,INDICATOR_CALCULATIONS);
   SetIndexBuffer(i++,ATR,INDICATOR_CALCULATIONS);

   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(1,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(2,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(3,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(4,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(5,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(6,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(7,PLOT_EMPTY_VALUE,EMPTY_VALUE);


//---
   MyCandle.Init(InpBodyS,InpBodyM,InpBodyL,InpBodyXL,InpHigeS,InpHigeM,InpHigeL,InpHigeXL);
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {

//---
   int first;
   if(rates_total<=min_rates_total)
      return(0);
//---

//+----------------------------------------------------+
//|Set Median Buffeer                                |
//+----------------------------------------------------+
   int begin_pos=min_rates_total;

   first=begin_pos;
   if(first<prev_calculated) first=prev_calculated-1;

//---
   for(int bar=first; bar<rates_total && !IsStopped(); bar++)
     {
      //---
      int i=bar;
      //---
      if(bar==begin_pos)
        {
        }
      //---
      //---
      //---
      //Status.LastBarTime(new_time);
      if(i==begin_pos)
        {
         ATR[i]=MathMax(high[i],close[i-1])-MathMin(low[i],close[i-1]);
        }
      else
        {
         double atr=MathMax(high[i],close[i-1])-MathMin(low[i],close[i-1]);
         atr=fmax(ATR[i-1]*0.667,fmin(atr,ATR[i-1]*1.333));
         ATR[i]=(1-AtrAlpha)*atr+AtrAlpha*ATR[i-1];
        }
      //---
      ENUM_CANDLE_TYPE candle= MyCandle.DetectCancle(open[i],high[i],low[i],close[i],ATR[i]);
      BAR[i]=candle;      
      if(candle==CANDLE_TYPE_BOUZU_CHOU_DAI_INSEN) set_candle(0,0,100,100,0,i);
      else if(candle==CANDLE_TYPE_BOUZU_CHOU_DAI_INSEN)set_candle(100,0,100,0,1,i);
      else if(candle==CANDLE_TYPE_CHOU_DAI_YOUSEN) set_candle(15,0,100,85,0,i);
      else if(candle==CANDLE_TYPE_CHOU_DAI_INSEN)set_candle(85,0,100,15,1,i);
      else if(candle==CANDLE_TYPE_SHITA_HIGE_CHOU_DAI_YOUSEN) set_candle(40,0,100,90,0,i);
      else if(candle==CANDLE_TYPE_UWA_HIGE_CHOU_DAI_INSEN)set_candle(60,0,100,10,1,i);
      else if(candle==CANDLE_TYPE_UWA_HIGE_CHOU_DAI_YOUSEN) set_candle(60,0,100,10,0,i);
      else if(candle==CANDLE_TYPE_SHITA_HIGE_CHOU_DAI_INSEN)set_candle(40,0,100,90,1,i);
      
      else if(candle==CANDLE_TYPE_BOUZU_DAI_YOUSEN)set_candle(25,25,75,75,0,i);
      else if(candle==CANDLE_TYPE_BOUZU_DAI_INSEN)set_candle(75,25,75,25,1,i);
      else if(candle==CANDLE_TYPE_DAI_YOUSEN)set_candle(35,25,75,65,0,i);
      else if(candle==CANDLE_TYPE_DAI_INSEN)set_candle(65,25,75,35,1,i);
      else if(candle==CANDLE_TYPE_SHITA_HIGE_DAI_YOUSEN)set_candle(45,25,75,70,0,i);
      else if(candle==CANDLE_TYPE_UWA_HIGE_DAI_INSEN)set_candle(55,25,75,30,1,i);
      else if(candle==CANDLE_TYPE_UWA_HIGE_DAI_YOUSEN)set_candle(30,25,75,55,0,i);
      else if(candle==CANDLE_TYPE_SHITA_HIGE_DAI_INSEN)set_candle(70,25,75,45,1,i);

      else if(candle==CANDLE_TYPE_BOUZU_SYOU_YOUSEN)set_candle(40,40,60,60,0,i);
      else if(candle==CANDLE_TYPE_BOUZU_SYOU_INSEN)set_candle(60,40,60,40,1,i);
      else if(candle==CANDLE_TYPE_SYOU_YOUSEN)set_candle(45,40,60,55,0,i);
      else if(candle==CANDLE_TYPE_SYOU_INSEN)set_candle (55,40,60,45,1,i);
      else if(candle==CANDLE_TYPE_SHITA_HIGE_SYOU_YOUSEN)set_candle(50,40,60,57.5,0,i);
      else if(candle==CANDLE_TYPE_UWA_HIGE_SYOU_INSEN)set_candle (50,40,60,42.5,1,i);
      else if(candle==CANDLE_TYPE_UWA_HIGE_SYOU_YOUSEN)set_candle(42.5,40,60,50,0,i);
      else if(candle==CANDLE_TYPE_SHITA_HIGE_SYOU_INSEN)set_candle (57.5,40,60,50,1,i);
      else set_candle(EMPTY_VALUE,EMPTY_VALUE,EMPTY_VALUE,EMPTY_VALUE,EMPTY_VALUE,i);
      //---
     }

//----    

   return(rates_total);
  }
//---
void set_candle(const double o,const double l,const double h,const double c,const double clr,const int i)
{
      OPEN[i]=o;
      HIGH[i]=h;
      LOW[i]=l;
      CLOSE[i]=c;
      COLOR[i]=clr;
}