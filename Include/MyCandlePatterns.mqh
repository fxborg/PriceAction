//+------------------------------------------------------------------+
//|                                              MyCandlePattern.mqh |
//|                                           Copyright 2016, fxborg |
//|                                   http://fxborg-labo.hateblo.jp/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, fxborg"
#property link      "http://blog.livedoor.jp/fxborg/"
#property version   "1.00"
#include <MyCandle.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMyCandlePattern
  {
private:
   double            m_atr_rate;
public:

   void              CMyCandlePattern(){};                   // constructor
   void             ~CMyCandlePattern(){};                   // destructor
   void              Init(double rate)
     {
      m_atr_rate=rate;
     }
   bool              CheckEvningStar(const double &o[],const double &h[],const double &l[],const double &c[],
                                     const double &size[],const double &body[],const double &balance[],const int i,const double ema,const double atr);

   bool              CheckMoningStar(const double &o[],const double &h[],const double &l[],const double &c[],
                                     const double &size[],const double &body[],const double &balance[],const int i,const double ema,const double atr);

   bool              CheckTweezerBottom(const double &o[],const double &h[],const double &l[],const double &c[],
                                        const double &size[],const double &body[],const double &balance[],const int i,const double ema,const double atr);

   bool              CheckTweezerTop(const double &o[],const double &h[],const double &l[],const double &c[],
                                     const double &size[],const double &body[],const double &balance[],const int i,const double ema,const double atr);

   bool              CheckHammer(const double &o[],const double &h[],const double &l[],const double &c[],
                                 const double &size[],const double &body[],const double &balance[],const int i,const double ema,const double atr);
   bool              CheckShootingStar(const double &o[],const double &h[],const double &l[],const double &c[],
                                       const double &size[],const double &body[],const double &balance[],const int i,const double ema,const double atr);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMyCandlePattern::CheckMoningStar(
                                       const double &o[],const double &h[],const double &l[],const double &c[],
                                       const double &size[],const double &body[],const double &balance[],const int i,const double ema,const double atr)
  {

   if(c[i]>o[i])
     {
      //---
      if(size[i]<double(CANDLE_SIZE_S) || 
         size[i-2]<double(CANDLE_SIZE_S) || 
         size[i-1]==double(CANDLE_SIZE_XS) ) return false;
      //---
      if(body[i-2]>double(CANDLE_BODYSIZE_S) && 
         body[i-1]<double(CANDLE_BODYSIZE_M) && 
         body[i]>double(CANDLE_BODYSIZE_XS))
        {
         if((h[i-1]+l[i-1])/2>ema)return false;
         double scale=atr*m_atr_rate;
         double mid=(o[i-1]+c[i-1])/2;

         if(l[i-1]<fmin(l[i],l[i-2]) && 
            mid<c[i-3] && 
            mid< l[i-4] && c[i]>h[i-1]  )  return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMyCandlePattern::CheckEvningStar(
                                       const double &o[],const double &h[],const double &l[],const double &c[],
                                       const double &size[],const double &body[],const double &balance[],const int i,const double ema,const double atr)
  {

   if(c[i]<o[i])
     {
      //---
      if(size[i]<double(CANDLE_SIZE_S) || 
         size[i-2]<double(CANDLE_SIZE_S) || 
         size[i-1]==double(CANDLE_SIZE_XS)) return false;
      //---
      if(body[i-2]>double(CANDLE_BODYSIZE_S) && 
         body[i-1]<double(CANDLE_BODYSIZE_M) && 
         body[i]>double(CANDLE_BODYSIZE_XS))
        {
         if((h[i-1]+l[i-1])/2<ema)return false;
         double mid=(o[i-1]+c[i-1])/2;

         if(h[i-1]>fmax(h[i-2],h[i]) && 
            mid>c[i-3] && 
            mid> h[i-4] && c[i]<l[i-1])  return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMyCandlePattern::CheckTweezerBottom(
                                          const double &o[],const double &h[],const double &l[],const double &c[],
                                          const double &size[],const double &body[],const double &balance[],const int i,const double ema,const double atr)
  {

   if(c[i]>o[i])
     {
      if(c[i-1]>o[i-1])return false;
      //---
      //---
      if(size[i]<double(CANDLE_SIZE_S) || 
         size[i-1]<double(CANDLE_SIZE_M) || 
         size[i-1]==double(CANDLE_SIZE_XL)) return false;
      //---
      if(body[i-1]>double(CANDLE_BODYSIZE_S) && 
         body[i]>double(CANDLE_BODYSIZE_S))
        {
         if((h[i]+l[i])/2>ema)return false;
         double scale=atr*m_atr_rate;
         if((l[i-1]-l[i])>scale*0.3) return false;
         double mid=(o[i-1]+c[i-1])/2;
         if(mid< l[i-2] && mid< l[i-3] && c[i]>mid  )  return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMyCandlePattern::CheckTweezerTop(
                                       const double &o[],const double &h[],const double &l[],const double &c[],
                                       const double &size[],const double &body[],const double &balance[],const int i,const double ema,const double atr)
  {

   if(c[i]<o[i])
     {
      if(c[i-1]<o[i-1])return false;
      //---

      if(size[i]<double(CANDLE_SIZE_S) || 
         size[i-1]<double(CANDLE_SIZE_M) || 
         size[i-1]==double(CANDLE_SIZE_XL)) return false;
      //---
      if(body[i-1]>double(CANDLE_BODYSIZE_S) && 
         body[i]>double(CANDLE_BODYSIZE_S))
        {
         if((h[i]+l[i])/2<ema)return false;
         double scale=atr*m_atr_rate;
         if((h[i-1]-h[i])>scale*0.3) return false;

         double mid=(o[i-1]+c[i-1])/2;
         if(mid> h[i-2] && mid> h[i-3] && c[i]<mid )  return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMyCandlePattern::CheckHammer(
                                   const double &o[],const double &h[],const double &l[],const double &c[],
                                   const double &size[],const double &body[],const double &balance[],const int i,const double ema,const double atr)
  {

   if(c[i]>o[i])
     {
      if(size[i]==double(CANDLE_SIZE_XS) || size[i]==double(CANDLE_SIZE_S) ||
         size[i]==double(CANDLE_SIZE_XL)) return false;
      if(balance[i]>double(CANDLE_BALANCE_NEUTRAL)
         && body[i]>double(CANDLE_BODYSIZE_XS)
         && body[i]<=double(CANDLE_BODYSIZE_M))
        {
         if((h[i]+l[i])/2>ema)return false;
         if((o[i]+c[i])/2 < l[i-2] && h[i]< l[i-3] )  return true;


        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMyCandlePattern::CheckShootingStar(
                                         const double &o[],const double &h[],const double &l[],const double &c[],
                                         const double &size[],const double &body[],const double &balance[],const int i,const double ema,const double atr)
  {
   if(size[i]==double(CANDLE_SIZE_XS) || size[i]==double(CANDLE_SIZE_S) ||
      size[i]==double(CANDLE_SIZE_XL)) return false;

   if(c[i]<o[i])
     {
      if(balance[i]>double(CANDLE_BALANCE_NEUTRAL)
         && body[i]>double(CANDLE_BODYSIZE_XS)
         && body[i]<=double(CANDLE_BODYSIZE_M))
        {
         if((h[i]+l[i])/2<ema)return false;
         if((o[i]+c[i])/2> h[i-2] && l[i] > h[i-3] ) return true;
        }
     }
   return false;
  } 
//+------------------------------------------------------------------+
