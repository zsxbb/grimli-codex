package spider_fla
{
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   
   public dynamic class mcForgotPassword_73 extends MovieClip
   {
      public var btnBack:SimpleButton;
      
      public var btnCancel:SimpleButton;
      
      public var btnContinue:SimpleButton;
      
      public var btnSubmit:SimpleButton;
      
      public var txtResponse:TextField;
      
      public var __setTabDict:Dictionary;
      
      public var __lastFrameTab:int = -1;
      
      public function mcForgotPassword_73()
      {
         this.__setTabDict = new Dictionary(true);
         super();
         addEventListener(Event.FRAME_CONSTRUCTED,this.__setTab_handler,false,0,true);
      }
      
      internal function __setTab_btnSubmit_mcForgotPassword_Layer3_0(param1:int) : *
      {
         if(this.btnSubmit != null && param1 >= 1 && param1 <= 10 && (this.__setTabDict[this.btnSubmit] == undefined || !(int(this.__setTabDict[this.btnSubmit]) >= 1 && int(this.__setTabDict[this.btnSubmit]) <= 10)))
         {
            this.__setTabDict[this.btnSubmit] = param1;
            this.btnSubmit.tabIndex = 3;
         }
      }
      
      internal function __setTab_btnCancel_mcForgotPassword_Layer3_0(param1:int) : *
      {
         if(this.btnCancel != null && param1 >= 1 && param1 <= 10 && (this.__setTabDict[this.btnCancel] == undefined || !(int(this.__setTabDict[this.btnCancel]) >= 1 && int(this.__setTabDict[this.btnCancel]) <= 10)))
         {
            this.__setTabDict[this.btnCancel] = param1;
            this.btnCancel.tabIndex = 3;
         }
      }
      
      internal function __setTab_btnContinue_mcForgotPassword_Layer3_10(param1:int) : *
      {
         if(this.btnContinue != null && param1 >= 11 && param1 <= 22 && (this.__setTabDict[this.btnContinue] == undefined || !(int(this.__setTabDict[this.btnContinue]) >= 11 && int(this.__setTabDict[this.btnContinue]) <= 22)))
         {
            this.__setTabDict[this.btnContinue] = param1;
            this.btnContinue.tabIndex = 3;
         }
      }
      
      internal function __setTab_btnBack_mcForgotPassword_Layer3_10(param1:int) : *
      {
         if(this.btnBack != null && param1 >= 11 && param1 <= 22 && (this.__setTabDict[this.btnBack] == undefined || !(int(this.__setTabDict[this.btnBack]) >= 11 && int(this.__setTabDict[this.btnBack]) <= 22)))
         {
            this.__setTabDict[this.btnBack] = param1;
            this.btnBack.tabIndex = 3;
         }
      }
      
      internal function __setTab_handler(param1:Object) : *
      {
         var _loc2_:int = currentFrame;
         if(this.__lastFrameTab == _loc2_)
         {
            return;
         }
         this.__lastFrameTab = _loc2_;
         this.__setTab_btnSubmit_mcForgotPassword_Layer3_0(_loc2_);
         this.__setTab_btnCancel_mcForgotPassword_Layer3_0(_loc2_);
         this.__setTab_btnContinue_mcForgotPassword_Layer3_10(_loc2_);
         this.__setTab_btnBack_mcForgotPassword_Layer3_10(_loc2_);
      }
   }
}

