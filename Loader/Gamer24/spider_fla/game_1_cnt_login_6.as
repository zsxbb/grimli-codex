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
   
   public dynamic class game_1_cnt_login_6 extends MovieClip
   {
      public var ModalStack:MovieClip;
      
      public var btnCreate:SimpleButton;
      
      public var btnFBLogin:SimpleButton;
      
      public var btnLogin:SimpleButton;
      
      public var btnMac:SimpleButton;
      
      public var btnWindows:SimpleButton;
      
      public var chkPassword:MovieClip;
      
      public var chkUserName:MovieClip;
      
      public var fbConnect:MovieClip;
      
      public var il:MovieClip;
      
      public var mcDisplay:MovieClip;
      
      public var mcForgotPassword:SimpleButton;
      
      public var mcLogo:MovieClip;
      
      public var mcManageAccount:SimpleButton;
      
      public var mcOr:MovieClip;
      
      public var mcPassword:MovieClip;
      
      public var mcTitle:MovieClip;
      
      public var ni:TextField;
      
      public var pi:TextField;
      
      public var sl:ServerList;
      
      public var testClientAssets:MovieClip;
      
      public var warning:MovieClip;
      
      public var __setTabDict:Dictionary;
      
      public var __lastFrameTab:int = -1;
      
      public function game_1_cnt_login_6()
      {
         this.__setTabDict = new Dictionary(true);
         super();
         addEventListener(Event.FRAME_CONSTRUCTED,this.__setTab_handler,false,0,true);
      }
      
      public function onCreateClick(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://www.aq.com/landing/"),"_blank");
         this.btnCreate.removeEventListener(MouseEvent.CLICK,this.onCreateClick);
      }
      
      public function getWin(param1:Event) : *
      {
         navigateToURL(new URLRequest("http://launch.artix.com/latest/ArtixSetup.msi"),"_blank");
      }
      
      public function getMac(param1:Event) : *
      {
         navigateToURL(new URLRequest("http://launch.artix.com/latest/ArtixGames.dmg"),"_blank");
      }
      
      internal function __setTab_btnCreate_game_1_cnt_login_fields_0(param1:int) : *
      {
         if(this.btnCreate != null && param1 >= 1 && param1 <= 9 && (this.__setTabDict[this.btnCreate] == undefined || !(int(this.__setTabDict[this.btnCreate]) >= 1 && int(this.__setTabDict[this.btnCreate]) <= 9)))
         {
            this.__setTabDict[this.btnCreate] = param1;
            this.btnCreate.tabIndex = 3;
         }
      }
      
      internal function __setTab_btnLogin_game_1_cnt_login_fields_0(param1:int) : *
      {
         if(this.btnLogin != null && param1 >= 1 && param1 <= 9 && (this.__setTabDict[this.btnLogin] == undefined || !(int(this.__setTabDict[this.btnLogin]) >= 1 && int(this.__setTabDict[this.btnLogin]) <= 9)))
         {
            this.__setTabDict[this.btnLogin] = param1;
            this.btnLogin.tabIndex = 3;
         }
      }
      
      internal function __setTab_btnFBLogin_game_1_cnt_login_loginbtn_0(param1:int) : *
      {
         if(this.btnFBLogin != null && param1 >= 1 && param1 <= 9 && (this.__setTabDict[this.btnFBLogin] == undefined || !(int(this.__setTabDict[this.btnFBLogin]) >= 1 && int(this.__setTabDict[this.btnFBLogin]) <= 9)))
         {
            this.__setTabDict[this.btnFBLogin] = param1;
            this.btnFBLogin.tabIndex = 3;
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
         this.__setTab_btnCreate_game_1_cnt_login_fields_0(_loc2_);
         this.__setTab_btnLogin_game_1_cnt_login_fields_0(_loc2_);
         this.__setTab_btnFBLogin_game_1_cnt_login_loginbtn_0(_loc2_);
      }
   }
}

