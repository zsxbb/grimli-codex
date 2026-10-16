package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.net.*;
   import flash.text.TextField;
   import flash.utils.*;
   
   public class ConnDetailMC extends MovieClip
   {
      public var btnBack:SimpleButton;
      
      public var btnContact:SimpleButton;
      
      public var mcPct:TextField;
      
      public var mcSpinner:MovieClip;
      
      public var mcSpinner2:MovieClip;
      
      public var txtBack:TextField;
      
      public var txtContact:TextField;
      
      public var txtDetail:TextField;
      
      private var timerConnDetail:Timer;
      
      public var rootClass:MovieClip;
      
      private var minutes:int;
      
      private var countDownTimer:Timer;
      
      private var firstJoin:Boolean = false;
      
      public function ConnDetailMC(param1:MovieClip)
      {
         this.timerConnDetail = new Timer(10000,1);
         super();
         this.rootClass = param1;
         this.txtBack.mouseEnabled = false;
         this.mcPct.visible = false;
         this.txtDetail.mouseEnabled = false;
         this.txtContact.mouseEnabled = false;
         this.setBtnContact(false);
         this.btnBack.addEventListener(MouseEvent.CLICK,this.onBackClick,false,0,true);
         this.timerConnDetail.removeEventListener(TimerEvent.TIMER,this.showBackButton);
         this.timerConnDetail.addEventListener(TimerEvent.TIMER,this.showBackButton,false,0,true);
         this.btnContact.addEventListener(MouseEvent.CLICK,this.onContactClick,false,0,true);
      }
      
      internal function setBtnContact(param1:Boolean) : void
      {
         this.txtContact.visible = param1;
         this.btnContact.visible = param1;
         if(param1)
         {
            this.btnBack.x = 397.25;
            this.txtBack.x = 340.9;
            this.txtDetail.y = 397.3;
         }
         else
         {
            this.btnBack.x = 476.7;
            this.txtBack.x = 420.35;
            this.txtDetail.y = 364.7;
         }
      }
      
      internal function logout() : void
      {
         trace("[Game] ConnDetail logout at: " + this.rootClass.currentLabel);
         if(this.rootClass.sfc.isConnected)
         {
            this.rootClass.sfc.disconnect();
         }
         if(this.rootClass.currentLabel == "Login" && this.rootClass.mcLogin != null)
         {
            this.rootClass.mcLogin.gotoAndStop("Init");
         }
         else
         {
            this.rootClass.gotoAndPlay("Login");
         }
      }
      
      internal function onContactClick(param1:MouseEvent) : void
      {
         this.logout();
         navigateToURL(new URLRequest("https://www.aq.com/help/aw-accounts-locked.asp"),"_blank");
         this.hideConn();
         FacebookConnect.StopPoll();
      }
      
      internal function onBackClick(param1:MouseEvent = null) : void
      {
         if(this.rootClass.currentLabel == "Game" && this.rootClass.sfc.isConnected && Boolean(this.rootClass.litePreference.data.bDebugger) && this.rootClass.world != null)
         {
            this.hideConn();
            return;
         }
         this.logout();
         this.hideConn();
         FacebookConnect.StopPoll();
      }
      
      public function showConn(param1:String, param2:Boolean = false, param3:Boolean = false) : void
      {
         this.setBtnContact(false);
         this.mcSpinner.visible = true;
         this.mcSpinner2.visible = true;
         this.btnBack.visible = false;
         this.txtBack.visible = false;
         this.txtBack.text = "Cancel";
         this.txtDetail.text = param1;
         this.firstJoin = param2;
         if(stage == null)
         {
            this.rootClass.addChild(this);
         }
         this.rootClass.setChildIndex(this,this.rootClass.numChildren - 1);
         if(!this.timerConnDetail.running && !param3)
         {
            this.timerConnDetail.reset();
            this.timerConnDetail.start();
         }
      }
      
      public function showDisconnect(param1:String) : void
      {
         this.setBtnContact(false);
         this.btnBack.visible = true;
         this.txtBack.visible = true;
         this.txtBack.text = "Back";
         this.txtDetail.text = param1;
         this.mcSpinner.visible = false;
         this.mcPct.visible = false;
         if(stage == null)
         {
            this.rootClass.addChild(this);
         }
         if(this.timerConnDetail.running)
         {
            this.timerConnDetail.stop();
         }
      }
      
      public function showBackButton(param1:TimerEvent = null) : void
      {
         this.btnBack.visible = true;
         this.txtBack.visible = true;
      }
      
      public function showError(param1:String) : void
      {
         if(stage == null)
         {
            this.rootClass.addChild(this);
         }
         this.setBtnContact(true);
         this.txtDetail.htmlText = param1;
         this.mcSpinner.visible = false;
         this.mcSpinner2.visible = false;
         this.txtBack.text = "Back";
         this.showBackButton();
      }
      
      public function hideConn() : void
      {
         this.setBtnContact(false);
         if(stage != null)
         {
            this.rootClass.removeChild(this);
         }
      }
      
      public function showCountDown(param1:int) : void
      {
         this.countDownTimer = new Timer(60000,1);
         this.minutes = param1;
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemove,false,0,true);
         this.countDownTimer.addEventListener(TimerEvent.TIMER,this.onCountdown,false,0,true);
         this.countDownTimer.start();
      }
      
      private function onRemove(param1:Event) : void
      {
         this.countDownTimer.removeEventListener(TimerEvent.TIMER,this.onCountdown);
      }
      
      private function onCountdown(param1:TimerEvent) : void
      {
         --this.minutes;
         this.countDownTimer.stop();
         if(this.minutes > 0)
         {
            this.countDownTimer.reset();
            this.countDownTimer.start();
         }
         else
         {
            this.countDownTimer.removeEventListener(TimerEvent.TIMER,this.onCountdown);
         }
      }
   }
}

