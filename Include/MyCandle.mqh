﻿//+------------------------------------------------------------------+
//|                                                     MyCandle.mqh |
//|                                           Copyright 2016, fxborg |
//|                                   http://fxborg-labo.hateblo.jp/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, fxborg"
#property link      "http://blog.livedoor.jp/fxborg/"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_CANDLE_BODY_SZ  // candle body size
  {
   CANDLE_BODY_SZ_XL=30,
   CANDLE_BODY_SZ_L=20,
   CANDLE_BODY_SZ_M=10,
   CANDLE_BODY_SZ_S=0
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_CANDLE_HIGE_TYPE  // candle hige_type
  {
   CANDLE_HIGE_TYPE_BOUZU=0,
   CANDLE_HIGE_TYPE_NORM=1,
   CANDLE_HIGE_TYPE_STRONG=2,
   CANDLE_HIGE_TYPE_WEAK=3,
   CANDLE_HIGE_TYPE_KOMA=4
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_CANDLE_TYPE  // candlestick types
  {
   CANDLE_TYPE_NONE=0,
   CANDLE_TYPE_BOUZU_CHOU_DAI_YOUSEN= 30,
   CANDLE_TYPE_BOUZU_CHOU_DAI_INSEN = -30,
   CANDLE_TYPE_BOUZU_DAI_YOUSEN= 20,
   CANDLE_TYPE_BOUZU_DAI_INSEN = -20,
   CANDLE_TYPE_BOUZU_SYOU_YOUSEN= 10,
   CANDLE_TYPE_BOUZU_SYOU_INSEN = -10,

   CANDLE_TYPE_CHOU_DAI_YOUSEN= 31,
   CANDLE_TYPE_CHOU_DAI_INSEN = -31,
   CANDLE_TYPE_DAI_YOUSEN= 21,
   CANDLE_TYPE_DAI_INSEN = -21,
   CANDLE_TYPE_SYOU_YOUSEN= 11,
   CANDLE_TYPE_SYOU_INSEN = -11,

   CANDLE_TYPE_SHITA_HIGE_CHOU_DAI_YOUSEN=32,
   CANDLE_TYPE_UWA_HIGE_CHOU_DAI_INSEN=-32,
   CANDLE_TYPE_SHITA_HIGE_DAI_YOUSEN=22,
   CANDLE_TYPE_UWA_HIGE_DAI_INSEN=-22,
   CANDLE_TYPE_SHITA_HIGE_SYOU_YOUSEN=12,
   CANDLE_TYPE_UWA_HIGE_SYOU_INSEN=-12,

   CANDLE_TYPE_UWA_HIGE_CHOU_DAI_YOUSEN=33,
   CANDLE_TYPE_SHITA_HIGE_CHOU_DAI_INSEN=-33,
   CANDLE_TYPE_UWA_HIGE_DAI_YOUSEN=23,
   CANDLE_TYPE_SHITA_HIGE_DAI_INSEN= -23,
   CANDLE_TYPE_UWA_HIGE_SYOU_YOUSEN= 13,
   CANDLE_TYPE_SHITA_HIGE_SYOU_INSEN=-13

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMyCandle
  {
private:
   double            m_atr_rate_s;
   double            m_atr_rate_m;
   double            m_atr_rate_l;
   double            m_atr_rate_xl;
   double            m_hige_rate_s;
   double            m_hige_rate_m;
   double            m_hige_rate_l;
   double            m_hige_rate_xl;

   double            m_atr_s;
   double            m_atr_m;
   double            m_atr_l;
   double            m_atr_xl;
   double            m_hige_s;
   double            m_hige_m;
   double            m_hige_l;
   double            m_hige_xl;

   double            m_height;
   double            m_body1;
   double            m_body2;
   double            m_dir;
   double            m_hige1;
   double            m_hige2;
   double            m_body;
   double            m_o;
   double            m_h;
   double            m_l;
   double            m_c;
   double            m_atr;

public:
   void              CMyCandle(){};                   // constructor
   void             ~CMyCandle(){};                   // destructor
   void              Init(double atr_s,double atr_m,double atr_l,double atr_xl,double hige_s,double hige_m,double hige_l,double hige_xl)
     {
      m_atr_rate_s = atr_s;
      m_atr_rate_m = atr_m;
      m_atr_rate_l = atr_l;
      m_atr_rate_xl = atr_xl;
      m_hige_rate_s = hige_s;
      m_hige_rate_m = hige_m;
      m_hige_rate_l = hige_l;
      m_hige_rate_xl= hige_xl;
      //--- temporary variable
      m_atr_s      = NULL;
      m_atr_m      = NULL;
      m_atr_l      = NULL;
      m_atr_xl      = NULL;
      m_hige_s      = NULL;
      m_hige_m      = NULL;
      m_hige_l      = NULL;
      m_hige_xl=NULL;

      m_height      = NULL;
      m_body1       = NULL;
      m_body2       = NULL;
      m_dir         = NULL;
      m_hige1       = NULL;
      m_hige2       = NULL;
      m_body        = NULL;
      m_o           = NULL;
      m_h           = NULL;
      m_l           = NULL;
      m_c           = NULL;
      m_atr         = NULL;

     }
   ENUM_CANDLE_TYPE  DetectCancle(const double o,const double h,const double l,const double c,const double atr);

   ENUM_CANDLE_TYPE  CheckInYousen();
   void              SetData(const double o,const double h,const double l,const double c,const double atr);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_CANDLE_TYPE CMyCandle::DetectCancle(const double o,const double h,const double l,const double c,const double atr)
  {
   SetData(o,h,l,c,atr);
   return CheckInYousen();

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_CANDLE_TYPE CMyCandle::CheckInYousen()
  {
   ENUM_CANDLE_BODY_SZ body_sz;
   if(m_body>m_atr_xl)body_sz=CANDLE_BODY_SZ_XL;
   else if(m_body>m_atr_m)body_sz = CANDLE_BODY_SZ_L;
   else if(m_body>m_atr_s)body_sz = CANDLE_BODY_SZ_M;
   else body_sz=CANDLE_BODY_SZ_S;

   ENUM_CANDLE_HIGE_TYPE hige_type;
   if(m_hige1<m_hige_s && m_hige2<m_hige_s) hige_type=CANDLE_HIGE_TYPE_BOUZU;
   else if(m_hige1<m_hige_m && m_hige2>m_hige_l && m_hige2<m_hige_xl) hige_type = CANDLE_HIGE_TYPE_STRONG;
   else if(m_hige2<m_hige_m && m_hige1>m_hige_l && m_hige1<m_hige_xl) hige_type = CANDLE_HIGE_TYPE_WEAK;
   else if(m_hige1<m_hige_l && m_hige2<m_hige_l) hige_type=CANDLE_HIGE_TYPE_NORM;
   else hige_type=CANDLE_HIGE_TYPE_KOMA;

   if(body_sz == CANDLE_BODY_SZ_S || hige_type== CANDLE_HIGE_TYPE_KOMA)return CANDLE_TYPE_NONE;


   int candletype=int(body_sz)+int(hige_type);
   if(m_dir<0)candletype*=-1;

   return ((ENUM_CANDLE_TYPE)candletype);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMyCandle::SetData(const double o,const double h,const double l,const double c,const double atr)
  {
//---
   m_o=o;
   m_h=h;
   m_l=l;
   m_c=c;
//--- body ,hige
   m_height= m_h-m_l;
   m_body1 = fmax(o,c);
   m_body2 = fmin(o,c);
   m_dir   = c-o;
   m_hige1 = (m_dir>0)? h-m_body1 :m_body2-l;
   m_hige2 = (m_dir>0)? m_body2-m_l :m_h-m_body1;
   m_body  = m_body1-m_body2;
   m_atr=atr;

//--- rate
   m_atr_s = m_atr_rate_s * m_atr;
   m_atr_m = m_atr_rate_m * m_atr;
   m_atr_l = m_atr_rate_l * m_atr;
   m_atr_xl= m_atr_rate_xl * m_atr;

   m_hige_s = m_hige_rate_s * m_height;
   m_hige_m = m_hige_rate_m * m_height;
   m_hige_l = m_hige_rate_l * m_height;
   m_hige_xl= m_hige_rate_xl * m_height;

  }
//+------------------------------------------------------------------+
