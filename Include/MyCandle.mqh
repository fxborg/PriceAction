//+------------------------------------------------------------------+
//|                                                     MyCandle.mqh |
//|                                           Copyright 2016, fxborg |
//|                                   http://fxborg-labo.hateblo.jp/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, fxborg"
#property link      "http://blog.livedoor.jp/fxborg/"
#property version   "1.01"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_CANDLE_BALANCE
  {
   CANDLE_BALANCE_CLOSESIDE3=3,
   CANDLE_BALANCE_CLOSESIDE2=2,
   CANDLE_BALANCE_CLOSESIDE1=1,
   CANDLE_BALANCE_NEUTRAL=0,
   CANDLE_BALANCE_OPENSIDE1=-1,
   CANDLE_BALANCE_OPENSIDE2=-2,
   CANDLE_BALANCE_OPENSIDE3=-3,
   CANDLE_BALANCE_NONE=INT_MIN
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_CANDLE_BODYSIZE
  {
   CANDLE_BODYSIZE_NONE=INT_MIN,
   CANDLE_BODYSIZE_XS=1,
   CANDLE_BODYSIZE_S=2,
   CANDLE_BODYSIZE_M=3,
   CANDLE_BODYSIZE_L=4,
   CANDLE_BODYSIZE_XL=5
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_CANDLE_SIZE
  {
   CANDLE_SIZE_NONE=INT_MIN,
   CANDLE_SIZE_XS=1,   
   CANDLE_SIZE_S =2,    
   CANDLE_SIZE_MS=3,   
   CANDLE_SIZE_M =4,   
   CANDLE_SIZE_ML=5,   
   CANDLE_SIZE_L =6,   
   CANDLE_SIZE_XL=7   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMyCandle
  {
private:
   ENUM_CANDLE_BALANCE m_balance;
   ENUM_CANDLE_BODYSIZE m_bodysize;
   ENUM_CANDLE_SIZE  m_size;
   double            m_scale;
   double            m_atr_rate;

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

public:
   void              CMyCandle(){};                   // constructor
   void             ~CMyCandle(){};                   // destructor
   ENUM_CANDLE_BALANCE        Barance(){return m_balance;}
   ENUM_CANDLE_BODYSIZE       BodySize(){return m_bodysize;}
   ENUM_CANDLE_SIZE           Size(){return m_size;}
   void              Init(const double rate)
     {
      //--- variable
      m_atr_rate=rate;

      //--- temporary variable
      m_balance     = CANDLE_BALANCE_NONE;
      m_bodysize    = CANDLE_BODYSIZE_NONE;
      m_size        = CANDLE_SIZE_NONE;
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
      m_scale       = NULL;

     }
   void              DetectCandle(const double o,const double h,const double l,const double c,const double atr);
   void              SetData(const double o,const double h,const double l,const double c,const double atr);
   void              GetOHLC(double &o,double &h,double &l,double &c);
   ENUM_CANDLE_BALANCE CMyCandle::CheckBarance(const double sz,const  double threshold,const bool isCloseSide);
   double            CMyCandle::CalcBodySize(const double h,const double l);
   void              CalcOpenClose(double &o,double &c,const double body,const double h,const double l);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMyCandle::DetectCandle(const double o,const double h,const double l,const double c,const double atr)
  {
//---
   SetData(o,h,l,c,atr);
   if(m_height<m_scale*0.1)
     {
      m_size=CANDLE_SIZE_XS;
      m_bodysize=CANDLE_BODYSIZE_XS;
      m_balance=CANDLE_BALANCE_NEUTRAL;
      return;
     }

   double hr=m_height/m_scale;
   if(hr<=0.2) m_size=CANDLE_SIZE_XS;
   else if( hr > 0.2 && hr<=0.5)       m_size = CANDLE_SIZE_S;
   else if( hr > 0.5 && hr<=1.0)       m_size = CANDLE_SIZE_MS;
   else if( hr > 1.0 && hr<=1.5)       m_size = CANDLE_SIZE_M;
   else if( hr > 1.5 && hr<=2.0)       m_size = CANDLE_SIZE_ML;
   else if( hr > 2.0 && hr<=4.0)       m_size = CANDLE_SIZE_L;
   else                                m_size = CANDLE_SIZE_XL;

   double r=m_body/m_height;
   if(m_size == CANDLE_SIZE_XS && r<0.5)m_bodysize = CANDLE_BODYSIZE_XS;
   if(m_size == CANDLE_SIZE_XS && r>0.5)m_bodysize = CANDLE_BODYSIZE_S;
   else if( r<=0.1)                    m_bodysize = CANDLE_BODYSIZE_XS;
   else if( r>=0.9)                    m_bodysize = CANDLE_BODYSIZE_XL;
   else if(r>0.1 && r<=0.3333) m_bodysize = CANDLE_BODYSIZE_S;
   else if(r<0.9 && r>=0.6667) m_bodysize = CANDLE_BODYSIZE_L;
   else                                m_bodysize=CANDLE_BODYSIZE_M;


//---

   double shadow=(m_height-m_body)/2;
//---
   if(m_size==CANDLE_SIZE_XS) m_balance=CANDLE_BALANCE_NEUTRAL;
   else if(shadow<0.1*m_scale) m_balance=CANDLE_BALANCE_NEUTRAL;
   else
     {
      if(m_dir>=0)
         m_balance=(m_hige1<=m_hige2)? CheckBarance(m_hige1,shadow,true): CheckBarance(m_hige2,shadow,false);
      else
         m_balance=(m_hige2<=m_hige1) ? CheckBarance(m_hige2,shadow,false): CheckBarance(m_hige1,shadow,true);
     }

//---

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMyCandle::GetOHLC(double &o,double &h,double &l,double &c)
  {
   double body;
   if(m_size==CANDLE_SIZE_NONE) return;
   if(m_bodysize==CANDLE_BODYSIZE_NONE) return;
   if(m_balance ==CANDLE_BALANCE_NONE) return;

   if(m_size==CANDLE_SIZE_XS)
     {
      l=48.0;
      h=52.0;
     }
   else if(m_size==CANDLE_SIZE_S)
     {
      l=45.0;
      h=55.0;
     }
   else if(m_size==CANDLE_SIZE_MS)
     {
      l=40.3;
      h=60.7;
     }
   else if(m_size==CANDLE_SIZE_M)
     {
      l=33.3;
      h=66.7;
     }
   else if(m_size==CANDLE_SIZE_ML)
     {
      l=27;
      h=73;
     }
   else if(m_size==CANDLE_SIZE_L)
     {
      l=20.0;
      h=80.0;
     }
   else if(m_size==CANDLE_SIZE_XL)
     {
      l=5.0;h=95.0;
     }
   body=CalcBodySize(h,l);
   CalcOpenClose(o,c,body,h,l);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMyCandle::CalcBodySize(const double h,const double l)
  {
   double sz;

   if(m_bodysize==CANDLE_BODYSIZE_XS) sz=(h-l)*0.05;
   else if(m_bodysize==CANDLE_BODYSIZE_S)  sz = (h-l)*0.25;
   else if(m_bodysize==CANDLE_BODYSIZE_M)  sz = (h-l)*0.5;
   else if(m_bodysize==CANDLE_BODYSIZE_L)  sz = (h-l)*0.75;
   else if(m_bodysize==CANDLE_BODYSIZE_XL) sz = (h-l)*0.95;
   else                                    sz=0.0;
   return fmax(1.0,sz);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMyCandle::CalcOpenClose(double &o,double &c,const double body,const double h,const double l)
  {
   double shadow=((h-l)-body) / 2;
   double offset=0;
   if(m_balance==CANDLE_BALANCE_CLOSESIDE3) offset=0;
   if(m_balance==CANDLE_BALANCE_CLOSESIDE2) offset=shadow*0.3333;
   if(m_balance==CANDLE_BALANCE_CLOSESIDE1) offset=shadow*0.6667;
   if(m_balance==CANDLE_BALANCE_NEUTRAL)    offset=shadow;
   if(m_balance==CANDLE_BALANCE_OPENSIDE1)  offset=shadow+shadow*0.3333;
   if(m_balance==CANDLE_BALANCE_OPENSIDE2)  offset=shadow+shadow*0.6667;
   if(m_balance==CANDLE_BALANCE_OPENSIDE3)  offset=shadow*2;

   if(m_dir>=0)
     {
      c=h-offset;
      o=c-body;
     }
   else
     {
      c=l+offset;
      o=c+body;
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_CANDLE_BALANCE CMyCandle::CheckBarance(const double sz,const  double shadow,const bool isCloseSide)
  {

   if(isCloseSide)
     {
      if(sz < 0.1 * m_scale)return CANDLE_BALANCE_CLOSESIDE3;
      if(sz < shadow*0.5)  return CANDLE_BALANCE_CLOSESIDE2;
      if(sz < shadow*0.8333)return CANDLE_BALANCE_CLOSESIDE1;
      return CANDLE_BALANCE_NEUTRAL;
     }
   else
     {
      if(sz < 0.1 * m_scale)return CANDLE_BALANCE_OPENSIDE3;
      if(sz < shadow*0.5)  return CANDLE_BALANCE_OPENSIDE2;
      if(sz < shadow*0.8333) return CANDLE_BALANCE_OPENSIDE1;
      return CANDLE_BALANCE_NEUTRAL;
     }
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
   m_hige1 = (m_dir>=0)? h-m_body1 :m_body2-l;
   m_hige2 = (m_dir>=0)? m_body2-m_l :m_h-m_body1;
   m_body  = m_body1-m_body2;
   m_scale=atr*m_atr_rate;

//--- rate

  }
//+------------------------------------------------------------------+
