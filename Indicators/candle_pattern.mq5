//+------------------------------------------------------------------+
//|                                               candle_pattern.mq5 |
//| candle_pattern                            Copyright 2016, fxborg |
//|                                   http://fxborg-labo.hateblo.jp/ |
//+------------------------------------------------------------------+
#include <MyCandlePatterns.mqh>

#property copyright "Copyright 2016, fxborg"
#property link      "http://fxborg-labo.hateblo.jp/"
#property version   "1.05"

#property indicator_buffers 28
#property indicator_plots  21
#property indicator_chart_window


#property indicator_type1 DRAW_COLOR_CANDLES
#property indicator_color1 clrDodgerBlue,clrRed
#property indicator_width1 1

//+------------------------------------------------------------------+

//--- input parameters
input      double InpScaleRate = 1.0;
input int  InpEMAPeriod=12;    //EMA Period  

double EmaAlpha=2.0/(InpEMAPeriod+1.0);
double AtrAlpha=0.98;

//---- will be used as indicator buffers
double ATR[];
double EMA[];
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
double BALANCE[];
double SIZE[];
double BODY[];

CMyCandle MyCandle;
CMyCandlePattern MyCandlePattern;

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
   SetIndexBuffer(i++,BODY,INDICATOR_DATA);
   SetIndexBuffer(i++,BALANCE,INDICATOR_DATA);
   SetIndexBuffer(i++,SIZE,INDICATOR_DATA);

   SetIndexBuffer(i++,BAR,INDICATOR_CALCULATIONS);
   SetIndexBuffer(i++,ATR,INDICATOR_CALCULATIONS);
   SetIndexBuffer(i++,EMA,INDICATOR_CALCULATIONS);
 
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(1,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(2,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(3,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(4,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(5,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(6,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(7,PLOT_EMPTY_VALUE,EMPTY_VALUE);


//---
   MyCandle.Init(InpScaleRate);
   MyCandlePattern.Init(InpScaleRate);
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
      if(i==begin_pos)
        {
         ATR[i]=MathMax(high[i],close[i-1])-MathMin(low[i],close[i-1]);
         EMA[i]=close[i];
        }
      else
        {
         double atr=MathMax(high[i],close[i-1])-MathMin(low[i],close[i-1]);
         atr=fmax(ATR[i-1]*0.667,fmin(atr,ATR[i-1]*1.333));
         ATR[i]=(1-AtrAlpha)*atr+AtrAlpha*ATR[i-1];
         EMA[i]=EmaAlpha*close[i]+(1-EmaAlpha)*EMA[i-1];
        }
      //---
      set_candle(EMPTY_VALUE,EMPTY_VALUE,EMPTY_VALUE,EMPTY_VALUE,i);

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
      MyCandle.DetectCandle(open[i],high[i],low[i],close[i],ATR[i]);
      BALANCE[i]=MyCandle.Barance();
      BODY[i]=MyCandle.BodySize();
      SIZE[i]=MyCandle.Size();      
      //---
      if(MyCandlePattern.CheckHammer(open,high,low,close,SIZE,BODY,BALANCE,i,EMA[i],ATR[i]))
      {
         set_candle(open[i],high[i],low[i],close[i],i);
           
      }
      else if(MyCandlePattern.CheckShootingStar(open,high,low,close,SIZE,BODY,BALANCE,i,EMA[i],ATR[i]))
      {
         set_candle(open[i],high[i],low[i],close[i],i);
         
      }
       if(MyCandlePattern.CheckTweezerBottom(open,high,low,close,SIZE,BODY,BALANCE,i,EMA[i],ATR[i]))
      {
         set_candle(open[i-1],high[i-1],low[i-1],close[i-1],i-1);
         set_candle(open[i],high[i],low[i],close[i],i);
           
      }
      else if(MyCandlePattern.CheckTweezerTop(open,high,low,close,SIZE,BODY,BALANCE,i,EMA[i],ATR[i]))
      {
         set_candle(open[i-1],high[i-1],low[i-1],close[i-1],i-1);
         set_candle(open[i],high[i],low[i],close[i],i);
      }   
      if(MyCandlePattern.CheckMoningStar(open,high,low,close,SIZE,BODY,BALANCE,i,EMA[i],ATR[i]))
      {
         set_candle(open[i-1],high[i-1],low[i-1],close[i-1],i-1);
           
      }
      else if(MyCandlePattern.CheckEvningStar(open,high,low,close,SIZE,BODY,BALANCE,i,EMA[i],ATR[i]))
      {
         set_candle(open[i-1],high[i-1],low[i-1],close[i-1],i-1);
      }   
      
     }

//----    

   return(rates_total);
  }
//---
//---
void set_candle(const double o,const double h,const double l,const double c,const int i)
{

      OPEN[i]=o;
      HIGH[i]=h;
      LOW[i]=l;
      CLOSE[i]=c;
      COLOR[i]=(c>=o)?0:1;
}