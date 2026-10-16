package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.text.TextField;
   import flash.utils.*;
   import liteAssets.draw.*;
   import liteAssets.listOptionsItem.*;
   
   public class mcOption extends MovieClip
   {
      public var bg:MovieClip;
      
      public var bg2:MovieClip;
      
      public var bgProf:MovieClip;
      
      public var btnAcc:SimpleButton;
      
      public var btnAccount:MovieClip;
      
      public var btnAdvOptions:SimpleButton;
      
      public var btnAllSound:SimpleButton;
      
      public var btnCameraTool:SimpleButton;
      
      public var btnChange:SimpleButton;
      
      public var btnChat:MovieClip;
      
      public var btnFBFriends:SimpleButton;
      
      public var btnFX:SimpleButton;
      
      public var btnFriend:SimpleButton;
      
      public var btnFullscreen:SimpleButton;
      
      public var btnGame:MovieClip;
      
      public var btnGeneral:MovieClip;
      
      public var btnGuild:SimpleButton;
      
      public var btnHelp:SimpleButton;
      
      public var btnIgnore:SimpleButton;
      
      public var btnLeftAllCloak:MovieClip;
      
      public var btnLeftAnim:MovieClip;
      
      public var btnLeftCloak:MovieClip;
      
      public var btnLeftDuel:MovieClip;
      
      public var btnLeftFriend:MovieClip;
      
      public var btnLeftGoto:MovieClip;
      
      public var btnLeftGuild:MovieClip;
      
      public var btnLeftHelm:MovieClip;
      
      public var btnLeftOtherPet:MovieClip;
      
      public var btnLeftParty:MovieClip;
      
      public var btnLeftPet:MovieClip;
      
      public var btnLeftProf:MovieClip;
      
      public var btnLeftTool:MovieClip;
      
      public var btnLeftWhisp:MovieClip;
      
      public var btnLink:SimpleButton;
      
      public var btnLogout:SimpleButton;
      
      public var btnLogoutFB:MovieClip;
      
      public var btnLore:SimpleButton;
      
      public var btnMusic:SimpleButton;
      
      public var btnPlayer:SimpleButton;
      
      public var btnRightAllCloak:MovieClip;
      
      public var btnRightAnim:MovieClip;
      
      public var btnRightCloak:MovieClip;
      
      public var btnRightDuel:MovieClip;
      
      public var btnRightFriend:MovieClip;
      
      public var btnRightGoto:MovieClip;
      
      public var btnRightGuild:MovieClip;
      
      public var btnRightHelm:MovieClip;
      
      public var btnRightOtherPet:MovieClip;
      
      public var btnRightParty:MovieClip;
      
      public var btnRightPet:MovieClip;
      
      public var btnRightProf:MovieClip;
      
      public var btnRightTool:MovieClip;
      
      public var btnRightWhisp:MovieClip;
      
      public var btnScreen:SimpleButton;
      
      public var btnShare:SimpleButton;
      
      public var btnShowAdv:SimpleButton;
      
      public var fbText:TextField;
      
      public var latencyStatus:MovieClip;
      
      public var mcServer:MovieClip;
      
      public var mcVis:MovieClip;
      
      public var txtAllCloak:TextField;
      
      public var txtAnim:TextField;
      
      public var txtBGProf:TextField;
      
      public var txtCVersion:TextField;
      
      public var txtCloak:TextField;
      
      public var txtDuel:TextField;
      
      public var txtFBLink:TextField;
      
      public var txtFriend:TextField;
      
      public var txtFriendsList:TextField;
      
      public var txtGoto:TextField;
      
      public var txtGuild:TextField;
      
      public var txtHelm:TextField;
      
      public var txtLatency:TextField;
      
      public var txtOtherPet:TextField;
      
      public var txtParty:TextField;
      
      public var txtPet:TextField;
      
      public var txtProf:TextField;
      
      public var txtShare:TextField;
      
      public var txtTool:TextField;
      
      public var txtWhisp:TextField;
      
      private var rootClass:MovieClip;
      
      private var ptrQ:uint = 0;
      
      private var serverTimer:Timer;
      
      private var strFriend:String = "{app_id:163679093835836, redirect_uri:\'www.aq.com/?something=something\', title=\'title 50 max characters\', data=\'requestTrackingID=5125136\'}";
      
      private var strExclude:String = "";
      
      private var passMC:MovieClip;
      
      private var ArrowButtons:Object;
      
      public var optObj:*;
      
      public var optItem:*;
      
      public var Len:*;
      
      public var optionList:*;
      
      public var hRun:Number;
      
      public var dRun:Number;
      
      public var oy:Number;
      
      public var mDown:Boolean;
      
      public var mbY:int;
      
      public var mbD:int;
      
      public var mhY:int;
      
      public var pos:int;
      
      public var i:int;
      
      private var toolTip:ToolTipMC;
      
      private var toolTipMC:*;
      
      public var latency:Number;
      
      internal var sDown:Boolean;
      
      public function mcOption(param1:MovieClip)
      {
         this.arrQuality = new Array("AUTO","LOW","MEDIUM","HIGH");
         this.serverTimer = new Timer(1000);
         super();
         this.rootClass = param1;
      }
      
      public function Init() : void
      {
         this.btnGeneral.gotoAndStop(1);
         this.btnChat.gotoAndStop(1);
         this.btnAccount.gotoAndStop(1);
         this.btnGame.gotoAndStop(1);
         if(this.currentLabel != "General")
         {
            this.gotoAndStop("General");
         }
         this.btnGeneral.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnGeneral.gotoAndStop(2);
         this.btnGeneral.buttonMode = true;
         this.btnChat.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnChat.buttonMode = true;
         this.btnAccount.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnAccount.buttonMode = true;
         this.btnGame.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnGame.buttonMode = true;
         this.bg.btnClose.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.btnChange.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.btnLogout.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.setUpFrame("General");
         this.btnShowAdv.visible = false;
         this.btnAdvOptions.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.bg2.visible = this.rootClass.litePreference.data.bVisible;
         this.bg2.bg.btnClose.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.bg2.bg.btnClose.visible = true;
         this.toolTipMC = this.rootClass.ui.ToolTip;
         this.rootClass.initlitePref();
         this.redraw(this.rootClass.litePref);
         this.bg2.SBar.h.addEventListener(MouseEvent.MOUSE_DOWN,this.onScrDown,false,0,true);
         this.bg2.addEventListener(MouseEvent.MOUSE_UP,this.onScrUp,false,0,true);
         this.bg2.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,false,0,true);
         this.optionList.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
         this.optionList.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
         this.bg2.txtSearch.addEventListener(Event.CHANGE,this.onSearch,false,0,true);
         this.bg2.txtSearch.text = "";
         this.serverTimer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this.serverTimer.start();
         this.txtCVersion.visible = true;
         this.txtCVersion.text = this.rootClass.cVersion;
         if(int(this.rootClass.world.myAvatar.objData.iAge) < 18)
         {
            this.rootClass.uoPref.bProf = true;
         }
         this.latency = new Date().getTime();
         var _loc1_:ColorTransform = new ColorTransform();
         _loc1_.color = 16711680;
         this.latencyStatus.transform.colorTransform = _loc1_;
         this.rootClass.sfc.sendXtMessage("zm","hi",[],"str",1);
      }
      
      public function fClose() : void
      {
         this.serverTimer.stop();
         this.serverTimer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         var _loc1_:MovieClip = MovieClip(parent);
         _loc1_.removeChild(this);
         if(_loc1_.currentLabel != "Init")
         {
            _loc1_.gotoAndPlay("Init");
         }
      }
      
      public function setProfanity(param1:Boolean) : void
      {
         this.bgProf.visible = param1;
         this.txtBGProf.visible = param1;
         this.txtProf.visible = param1;
         this.btnLeftProf.visible = param1;
         this.btnRightProf.visible = param1;
      }
      
      public function InitAccount() : void
      {
         this.btnGeneral.gotoAndStop(1);
         this.btnChat.gotoAndStop(1);
         this.btnAccount.gotoAndStop(1);
         this.btnGame.gotoAndStop(1);
         if(this.currentLabel != "Account")
         {
            this.gotoAndPlay("Account");
         }
         this.btnGeneral.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnGeneral.buttonMode = true;
         this.btnChat.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnChat.buttonMode = true;
         this.btnGame.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnGame.buttonMode = true;
         this.btnAccount.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnAccount.buttonMode = true;
         this.btnChange.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.btnLogout.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.bg.btnClose.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.btnAccount.gotoAndStop(2);
         this.serverTimer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this.serverTimer.start();
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         if(stage == null)
         {
            this.serverTimer.stop();
            this.serverTimer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         else if(this.mcServer != null)
         {
            this.mcServer.txtTime.text = this.rootClass.date_server.toLocaleTimeString();
         }
         if(MovieClip(parent) != null)
         {
            if(MovieClip(parent).currentLabel != "Option")
            {
               MovieClip(parent).removeChild(this);
               this.serverTimer.stop();
               this.serverTimer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            }
         }
      }
      
      public function updateLatency() : void
      {
         this.txtLatency.text = String(this.latency) + " ms";
         var _loc1_:ColorTransform = new ColorTransform();
         if(Number(this.latency) < 100)
         {
            _loc1_.color = 65280;
         }
         else if(Number(this.latency) < 200)
         {
            _loc1_.color = 16776960;
         }
         else
         {
            _loc1_.color = 16711680;
         }
         this.latencyStatus.transform.colorTransform = _loc1_;
      }
      
      private function wireTabs() : void
      {
         var _loc4_:MovieClip = null;
         var _loc1_:Array = [this.btnGeneral,this.btnGame,this.btnChat,this.btnAccount];
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc4_ = MovieClip(_loc1_[_loc2_]);
            if(_loc4_ != null)
            {
               _loc4_.buttonMode = true;
               if(!_loc4_.hasEventListener(MouseEvent.CLICK))
               {
                  _loc4_.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
               }
               _loc4_.gotoAndStop(1);
            }
            _loc2_++;
         }
         var _loc3_:MovieClip = null;
         switch(this.currentLabel)
         {
            case "General":
               _loc3_ = MovieClip(this.btnGeneral);
               break;
            case "Gameplay":
               _loc3_ = MovieClip(this.btnGame);
               break;
            case "Social":
               _loc3_ = MovieClip(this.btnChat);
               break;
            case "Account":
               _loc3_ = MovieClip(this.btnAccount);
         }
         if(_loc3_ != null)
         {
            _loc3_.gotoAndStop(2);
         }
      }
      
      private function setUpFrame(param1:String) : void
      {
         var _loc2_:uint = 0;
         this.wireTabs();
         switch(param1)
         {
            case "General":
               if(this.mcVis == null || this.mcServer == null)
               {
                  break;
               }
               this.rootClass.userPreference.data.bSoundOn = true;
               this.mcVis.txtQuality.text = this.rootClass.userPreference.data.quality;
               this.mcServer.txtServer.text = this.rootClass.objServerInfo.sName;
               if(!this.mcVis.btnLeftQual.hasEventListener(MouseEvent.CLICK))
               {
                  this.mcVis.btnLeftQual.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.mcVis.btnRightQual.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnScreen.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnFullscreen.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnMusic.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnFX.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnAllSound.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnCameraTool.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnFriend.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnGuild.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnIgnore.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnAdvOptions.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  _loc2_ = 0;
                  while(_loc2_ < this.arrQuality.length)
                  {
                     if(this.mcVis.txtQuality.text == this.arrQuality[_loc2_])
                     {
                        this.ptrQ = _loc2_;
                        break;
                     }
                     _loc2_++;
                  }
               }
               this.setQual();
               break;
            case "Gameplay":
               if(this.btnRightTool == null)
               {
                  break;
               }
               if(!this.btnRightTool.hasEventListener(MouseEvent.CLICK))
               {
                  this.btnRightTool.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftTool.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightPet.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftPet.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightHelm.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftHelm.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightCloak.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftCloak.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftAllCloak.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightAllCloak.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightGoto.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftGoto.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftOtherPet.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightOtherPet.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightAnim.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftAnim.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
               }
               this.txtTool.text = !!this.rootClass.uoPref.bTT ? "On" : "Off";
               this.txtPet.text = !!this.rootClass.uoPref.bPet ? "Yes" : "No";
               this.txtHelm.text = !!this.rootClass.uoPref.bHelm ? "Yes" : "No";
               this.txtCloak.text = !!this.rootClass.uoPref.bCloak ? "Yes" : "No";
               this.txtGoto.text = !!this.rootClass.uoPref.bGoto ? "On" : "Off";
               this.txtAnim.text = !!this.rootClass.world.showAnimations ? "On" : "Off";
               this.txtAllCloak.text = !!this.rootClass.world.hideAllCapes ? "Yes" : "No";
               this.txtOtherPet.text = !!this.rootClass.world.hideOtherPets ? "Yes" : "No";
               break;
            case "Social":
               if(this.btnRightParty == null)
               {
                  break;
               }
               this.setProfanity(int(this.rootClass.world.myAvatar.objData.iAge) >= 18);
               if(!this.btnRightParty.hasEventListener(MouseEvent.CLICK))
               {
                  this.btnRightParty.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftParty.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightFriend.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftFriend.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightDuel.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftDuel.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightGuild.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftGuild.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightWhisp.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftWhisp.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightProf.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftProf.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
               }
               this.txtParty.text = !!this.rootClass.uoPref.bParty ? "On" : "Off";
               this.txtFriend.text = !!this.rootClass.uoPref.bFriend ? "On" : "Off";
               this.txtDuel.text = !!this.rootClass.uoPref.bDuel ? "On" : "Off";
               this.txtGuild.text = !!this.rootClass.uoPref.bGuild ? "On" : "Off";
               this.txtWhisp.text = !!this.rootClass.uoPref.bWhisper ? "On" : "Off";
               this.txtProf.text = !!this.rootClass.uoPref.bProf ? "On" : "Off";
               break;
            case "Account":
               if(this.btnAcc == null)
               {
                  break;
               }
               if(!this.btnAcc.hasEventListener(MouseEvent.CLICK))
               {
                  this.btnAcc.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnHelp.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnPlayer.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLore.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  if(this.rootClass.world.myAvatar.objData.iAge < 13 || Game.objLogin.FBID > 0 && !FacebookConnect.isLoggedIn)
                  {
                     this.btnLink.visible = false;
                     this.txtFBLink.visible = false;
                     this.fbText.visible = false;
                  }
                  else
                  {
                     this.btnLink.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  }
                  this.btnLink.visible = false;
                  this.txtFBLink.visible = false;
               }
               this.checkFBStatus();
               this.txtFBLink.mouseEnabled = false;
               this.btnLogoutFB.visible = FacebookConnect.isLoggedIn;
               this.btnLogoutFB.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
               this.btnLogoutFB.buttonMode = true;
               this.btnFBFriends.visible = false;
               this.txtFriendsList.visible = false;
               this.btnShare.visible = false;
               this.txtShare.visible = false;
               break;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.btnGeneral.gotoAndStop(1);
         this.btnChat.gotoAndStop(1);
         this.btnAccount.gotoAndStop(1);
         this.btnGame.gotoAndStop(1);
         param1.currentTarget.gotoAndStop(2);
         var _loc2_:String = "";
         switch(param1.currentTarget.name)
         {
            case "btnGeneral":
               _loc2_ = "General";
               break;
            case "btnGame":
               _loc2_ = "Gameplay";
               break;
            case "btnChat":
               _loc2_ = "Social";
               break;
            case "btnAccount":
               _loc2_ = "Account";
         }
         if(_loc2_ != "")
         {
            if(this.currentLabel != _loc2_)
            {
               this.gotoAndStop(_loc2_);
            }
            this.setUpFrame(_loc2_);
         }
      }
      
      public function musicVolume(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.litePreference.data.dOptions["iSoundMusic"] = Number(param1.iQty / 100);
            this.rootClass.litePreference.flush();
            if(Boolean(this.rootClass.world.sController) && Boolean(this.rootClass.world.sController.mChannel))
            {
               this.rootClass.world.sController.mChannel.soundTransform = new SoundTransform(param1.iQty / 100);
            }
         }
      }
      
      public function fxVolume(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.litePreference.data.dOptions["iSoundFX"] = Number(param1.iQty / 100);
            this.rootClass.litePreference.flush();
            this.rootClass.mixer.stf = new SoundTransform(param1.iQty / 100);
         }
      }
      
      public function allVolume(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.litePreference.data.dOptions["iSoundAll"] = Number(param1.iQty / 100);
            this.rootClass.litePreference.flush();
            SoundMixer.soundTransform = new SoundTransform(param1.iQty / 100);
         }
      }
      
      private function onArrowClick(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.rootClass.mixer.playSound("Click");
         switch(param1.currentTarget.name)
         {
            case "btnAdvOptions":
               this.bg2.visible = !this.bg2.visible;
               this.rootClass.litePreference.data.bVisible = this.bg2.visible;
               break;
            case "btnLeftQual":
               this.ptrQ = --this.ptrQ < 0 ? 3 : uint(this.ptrQ);
               this.setQual();
               break;
            case "btnRightQual":
               this.ptrQ = ++this.ptrQ > 3 ? 0 : uint(this.ptrQ);
               this.setQual();
               break;
            case "btnScreen":
               this.rootClass.stage.addChild(new worldCamera(this.rootClass));
               break;
            case "btnFullscreen":
               this.rootClass.toggleFullScreen();
               break;
            case "btnMusic":
               _loc2_ = new ModalMC();
               _loc3_ = {};
               _loc3_.params = {};
               _loc3_.strBody = "Change Music Volume?";
               _loc3_.callback = this.musicVolume;
               _loc3_.qtySel = {
                  "min":0,
                  "max":100,
                  "base":(this.rootClass.litePreference.data.dOptions["iSoundMusic"] != null ? this.rootClass.litePreference.data.dOptions["iSoundMusic"] * 100 : 35)
               };
               _loc3_.glow = "white,medium";
               _loc3_.greedy = true;
               this.rootClass.ui.ModalStack.addChild(_loc2_);
               _loc2_.init(_loc3_);
               break;
            case "btnFX":
               _loc2_ = new ModalMC();
               _loc3_ = {};
               _loc3_.params = {};
               _loc3_.strBody = "Change Sound FX Volume?";
               _loc3_.callback = this.fxVolume;
               _loc3_.qtySel = {
                  "min":0,
                  "max":100,
                  "base":(this.rootClass.litePreference.data.dOptions["iSoundFX"] != null ? this.rootClass.litePreference.data.dOptions["iSoundFX"] * 100 : 100)
               };
               _loc3_.glow = "white,medium";
               _loc3_.greedy = true;
               this.rootClass.ui.ModalStack.addChild(_loc2_);
               _loc2_.init(_loc3_);
               break;
            case "btnAllSound":
               _loc2_ = new ModalMC();
               _loc3_ = {};
               _loc3_.params = {};
               _loc3_.strBody = "Change Other Sounds Volume? This will affect the volume of Music and SoundFX as well";
               _loc3_.callback = this.allVolume;
               _loc3_.qtySel = {
                  "min":0,
                  "max":100,
                  "base":(this.rootClass.litePreference.data.dOptions["iSoundAll"] != null ? this.rootClass.litePreference.data.dOptions["iSoundAll"] * 100 : 100)
               };
               _loc3_.glow = "white,medium";
               _loc3_.greedy = true;
               this.rootClass.ui.ModalStack.addChild(_loc2_);
               _loc2_.init(_loc3_);
               break;
            case "btnLeftPet":
            case "btnRightPet":
               this.txtPet.text = this.txtPet.text == "Yes" ? "No" : "Yes";
               if(this.rootClass.uoPref.bPet)
               {
                  this.rootClass.uoPref.bPet = false;
                  this.rootClass.world.hideAllPets();
               }
               else
               {
                  this.rootClass.uoPref.bPet = true;
                  this.rootClass.world.showAllPets();
                  if(this.rootClass.world.hideOtherPets)
                  {
                     this.rootClass.world.hideAllPets(false);
                  }
               }
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bPet",String(this.rootClass.uoPref.bPet)],"str",1);
               break;
            case "btnLeftOtherPet":
            case "btnRightOtherPet":
               this.txtOtherPet.text = this.txtOtherPet.text == "Yes" ? "No" : "Yes";
               if(this.rootClass.world.hideOtherPets)
               {
                  this.rootClass.world.hideOtherPets = false;
                  this.rootClass.world.showAllPets(false);
               }
               else
               {
                  this.rootClass.world.hideOtherPets = true;
                  this.rootClass.world.hideAllPets(false);
               }
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bOtherPets",String(this.rootClass.world.hideOtherPets)],"str",1);
               break;
            case "btnLeftHelm":
            case "btnRightHelm":
               this.txtHelm.text = this.txtHelm.text == "Yes" ? "No" : "Yes";
               this.rootClass.uoPref.bHelm = !this.rootClass.uoPref.bHelm;
               this.rootClass.world.myAvatar.dataLeaf.showHelm = this.rootClass.uoPref.bHelm;
               this.rootClass.world.myAvatar.pMC.setHelmVisibility(this.rootClass.uoPref.bHelm);
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bHelm",String(this.rootClass.uoPref.bHelm)],"str",1);
               break;
            case "btnLeftCloak":
            case "btnRightCloak":
               this.txtCloak.text = this.txtCloak.text == "Yes" ? "No" : "Yes";
               this.rootClass.uoPref.bCloak = !this.rootClass.uoPref.bCloak;
               this.rootClass.world.myAvatar.dataLeaf.showCloak = this.rootClass.uoPref.bCloak;
               this.rootClass.world.myAvatar.pMC.setCloakVisibility(this.rootClass.uoPref.bCloak);
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bCloak",String(this.rootClass.uoPref.bCloak)],"str",1);
               break;
            case "btnLeftAllCloak":
            case "btnRightAllCloak":
               this.txtAllCloak.text = this.txtAllCloak.text == "Yes" ? "No" : "Yes";
               this.rootClass.world.hideAllCapes = !this.rootClass.world.hideAllCapes;
               this.rootClass.world.setAllCloakVisibility();
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bAllCloak",String(this.rootClass.world.hideAllCapes)],"str",1);
               break;
            case "btnLeftTool":
            case "btnRightTool":
               this.txtTool.text = this.txtTool.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bTT = !this.rootClass.uoPref.bTT;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bTT",String(this.rootClass.uoPref.bTT)],"str",1);
               break;
            case "btnLeftGoto":
            case "btnRightGoto":
               this.txtGoto.text = this.txtGoto.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bGoto = !this.rootClass.uoPref.bGoto;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bGoto",String(this.rootClass.uoPref.bGoto)],"str",1);
               break;
            case "btnLeftParty":
            case "btnRightParty":
               this.txtParty.text = this.txtParty.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bParty = !this.rootClass.uoPref.bParty;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bParty",String(this.rootClass.uoPref.bParty)],"str",1);
               break;
            case "btnLeftDuel":
            case "btnRightDuel":
               this.txtDuel.text = this.txtDuel.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bDuel = !this.rootClass.uoPref.bDuel;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bDuel",String(this.rootClass.uoPref.bDuel)],"str",1);
               break;
            case "btnLeftAnim":
            case "btnRightAnim":
               this.txtAnim.text = this.txtAnim.text == "On" ? "Off" : "On";
               this.rootClass.world.showAnimations = !this.rootClass.world.showAnimations;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bAnim",String(this.rootClass.world.showAnimations)],"str",1);
               break;
            case "btnLeftFriend":
            case "btnRightFriend":
               this.txtFriend.text = this.txtFriend.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bFriend = !this.rootClass.uoPref.bFriend;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bFriend",String(this.rootClass.uoPref.bFriend)],"str",1);
               break;
            case "btnLeftGuild":
            case "btnRightGuild":
               this.txtGuild.text = this.txtGuild.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bGuild = !this.rootClass.uoPref.bGuild;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bGuild",String(this.rootClass.uoPref.bGuild)],"str",1);
               break;
            case "btnLeftWhisp":
            case "btnRightWhisp":
               this.txtWhisp.text = this.txtWhisp.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bWhisper = !this.rootClass.uoPref.bWhisper;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bWhisper",String(this.rootClass.uoPref.bWhisper)],"str",1);
               break;
            case "btnLeftProf":
            case "btnRightProf":
               this.txtProf.text = this.txtProf.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bProf = !this.rootClass.uoPref.bProf;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bProf",String(this.rootClass.uoPref.bProf)],"str",1);
               break;
            case "btnFriend":
               this.rootClass.world.showFriendsList();
               break;
            case "btnGuild":
               this.rootClass.world.showGuildList();
               break;
            case "btnIgnore":
               this.rootClass.world.showIgnoreList();
               break;
            case "btnAcc":
               navigateToURL(new URLRequest("https://account.aq.com/"),"_blank");
               break;
            case "btnChar":
               break;
            case "btnHelp":
               navigateToURL(new URLRequest("https://www.aq.com/help/"),"_blank");
               break;
            case "btnCameraTool":
               this.rootClass.cameraToolMC = new cameraTool(this.rootClass);
               this.rootClass.cameraToolMC.x = -7;
               this.rootClass.addChild(this.rootClass.cameraToolMC);
               this.rootClass.world.visible = false;
               break;
            case "btnLogout":
               this.rootClass.logout();
               break;
            case "btnClose":
               this.rootClass.ui.mcPopup.onClose();
               this.rootClass.stage.focus = null;
               break;
            case "btnLore":
               navigateToURL(new URLRequest("https://www.aq.com/lore"),"_blank");
               break;
            case "btnChange":
               this.rootClass.showServerList();
               break;
            case "btnPlayer":
               navigateToURL(new URLRequest("https://www.aq.com/info/handbook/"),"_blank");
               break;
            case "btnLink":
               if(FacebookConnect.isLoggedIn)
               {
                  this.passMC = new mcFBPassword(this.rootClass) as MovieClip;
                  this.passMC.x = 268;
                  this.passMC.y = 30;
                  this.rootClass.ui.addChild(this.passMC);
               }
               break;
            case "btnLogoutFB":
               FacebookConnect.Logout();
               this.rootClass.logout();
         }
      }
      
      private function setQual() : void
      {
         this.mcVis.txtQuality.text = this.rootClass.userPreference.data.quality = this.arrQuality[this.ptrQ];
         if(this.rootClass.userPreference.data.quality == "AUTO")
         {
            stage.quality = "HIGH";
         }
         else
         {
            stage.quality = this.rootClass.userPreference.data.quality;
         }
         try
         {
            this.rootClass.userPreference.flush();
         }
         catch(e:Error)
         {
            trace("[Game] ERR userPreference flush: " + e.message);
         }
      }
      
      public function checkFBStatus() : void
      {
         if(this.currentLabel == "Account")
         {
            this.txtFBLink.text = FacebookConnect.isLoggedIn ? "Unlink" : "Link";
         }
      }
      
      public function closeUnlink() : void
      {
         try
         {
            this.rootClass.ui.removeChild(this.passMC);
         }
         catch(e:*)
         {
         }
      }
      
      public function onOver(param1:MouseEvent) : void
      {
         try
         {
            if(!param1.target.parent.sDesc)
            {
               return;
            }
            this.toolTipMC.openWith({"str":param1.target.parent.sDesc});
         }
         catch(e:*)
         {
         }
      }
      
      public function onOut(param1:MouseEvent) : *
      {
         try
         {
            this.toolTipMC.close();
         }
         catch(e:*)
         {
         }
      }
      
      public function orderName(param1:*, param2:*) : int
      {
         var _loc3_:* = param1["strName"];
         var _loc4_:* = param2["strName"];
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public function redraw(param1:Array) : void
      {
         var _loc2_:* = undefined;
         var _loc4_:int = 0;
         this.bg2.SBar.h.y = 0;
         if(this.optionList != null)
         {
            this.bg2.removeChild(this.optionList);
            this.optionList = null;
         }
         this.optionList = this.bg2.addChild(new MovieClip());
         this.Len = param1.length;
         param1.sort(this.orderName);
         this.i = 0;
         var _loc3_:* = 0;
         while(this.i < this.Len)
         {
            this.optObj = param1[this.i];
            if(this.optObj.hasOwnProperty("minAccess"))
            {
               if(Game.objLogin.iAccess < this.optObj.minAccess)
               {
                  this.i += 1;
                  continue;
               }
            }
            switch(true)
            {
               case this.optObj.hasOwnProperty("special"):
                  this.optItem = new listOptionsItemTxt(this.rootClass,this.optObj.sDesc);
                  this.optItem.txtName.text = this.optObj.strName;
                  _loc2_ = this.optionList.addChild(this.optItem);
                  _loc2_.x = this.bg2.cntMask.x;
                  _loc2_.y = this.bg2.cntMask.y + 35 * _loc3_;
                  _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
                  _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
                  break;
               case this.optObj.hasOwnProperty("extra") && this.optObj.extra is String:
                  this.optItem = new listOptionsItemBtn(this.rootClass,this.optObj.sDesc);
                  this.optItem.txtName.text = this.optObj.strName;
                  _loc2_ = this.optionList.addChild(this.optItem);
                  _loc2_.x = this.bg2.cntMask.x;
                  _loc2_.y = this.bg2.cntMask.y + 35 * _loc3_;
                  _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
                  _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
                  break;
               case this.optObj.hasOwnProperty("extra") && this.optObj.extra is Array:
                  this.optItem = new listOptionsItem(this.rootClass,this.optObj.bEnabled,this.optObj.sDesc);
                  this.optItem.txtName.text = this.optObj.strName;
                  _loc2_ = this.optionList.addChild(this.optItem);
                  _loc2_.x = this.bg2.cntMask.x;
                  _loc2_.y = this.bg2.cntMask.y + 35 * _loc3_;
                  _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
                  _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
                  _loc4_ = 0;
                  while(_loc4_ < this.optObj.extra.length)
                  {
                     _loc3_++;
                     if(this.optObj.extra[_loc4_].hasOwnProperty("extra"))
                     {
                        this.optItem = new listOptionsItemExtraBtn(this.rootClass,this.optObj.extra[_loc4_].sDesc);
                     }
                     else
                     {
                        this.optItem = new listOptionsItemExtra(this.rootClass,this.optObj.extra[_loc4_].bEnabled,this.optObj.extra[_loc4_].sDesc);
                     }
                     this.optItem.txtName.text = this.optObj.extra[_loc4_].strName;
                     _loc2_ = this.optionList.addChild(this.optItem);
                     _loc2_.x = this.bg2.cntMask.x + 9;
                     _loc2_.y = this.bg2.cntMask.y + 35 * _loc3_;
                     _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
                     _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
                     _loc4_++;
                  }
                  break;
               default:
                  this.optItem = new listOptionsItem(this.rootClass,this.optObj.bEnabled,this.optObj.sDesc);
                  this.optItem.txtName.text = this.optObj.strName;
                  _loc2_ = this.optionList.addChild(this.optItem);
                  _loc2_.x = this.bg2.cntMask.x;
                  _loc2_.y = this.bg2.cntMask.y + 35 * _loc3_;
                  _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
                  _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
            }
            ++this.i;
            _loc3_++;
         }
         this.optionList.mask = this.bg2.cntMask;
         this.mDown = false;
         this.hRun = this.bg2.SBar.b.height - this.bg2.SBar.h.height;
         this.dRun = this.optionList.height - this.bg2.cntMask.height + 5;
         this.oy = this.optionList.y;
         this.optionList.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
         this.optionList.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
      }
      
      public function onSearch(param1:Event) : void
      {
         this.rootClass.initlitePref();
         var _loc2_:Number = 0;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < this.rootClass.litePref.length)
         {
            if(this.rootClass.litePref[_loc4_].strName.toLowerCase().indexOf(this.bg2.txtSearch.text.toLowerCase()) > -1)
            {
               _loc3_.push(this.rootClass.litePref[_loc4_]);
               _loc2_ += !!this.rootClass.litePref[_loc4_].extra ? 1 + this.rootClass.litePref[_loc4_].extra.length : 1;
            }
            _loc4_++;
         }
         if(_loc2_ <= 9)
         {
            this.bg2.SBar.h.removeEventListener(MouseEvent.MOUSE_DOWN,this.onScrDown);
            this.bg2.removeEventListener(MouseEvent.MOUSE_UP,this.onScrUp);
            this.bg2.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
         }
         else if(_loc2_ > 9 && !this.bg2.SBar.h.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this.bg2.SBar.h.addEventListener(MouseEvent.MOUSE_DOWN,this.onScrDown,false,0,true);
            this.bg2.addEventListener(MouseEvent.MOUSE_UP,this.onScrUp,false,0,true);
            this.bg2.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,false,0,true);
         }
         this.redraw(!this.bg2.txtSearch.text ? this.rootClass.litePref : _loc3_);
         _loc3_ = null;
      }
      
      private function onWheel(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         _loc2_ = this.bg2.SBar;
         _loc2_.h.y = int(this.bg2.SBar.h.y) + param1.delta * 3 * -1;
         if(_loc2_.h.y + _loc2_.h.height > _loc2_.b.height)
         {
            _loc2_.h.y = int(_loc2_.b.height - _loc2_.h.height);
         }
         if(_loc2_.h.y < 0)
         {
            _loc2_.h.y = 0;
         }
      }
      
      private function onScrDown(param1:MouseEvent) : *
      {
         this.mbY = int(mouseY);
         this.mhY = int(this.bg2.SBar.h.y);
         this.mDown = true;
      }
      
      private function onScrUp(param1:MouseEvent) : void
      {
         this.mDown = false;
      }
      
      private function hEF(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(this.mDown)
         {
            _loc2_ = this.bg2.SBar;
            this.mbD = int(mouseY) - this.mbY;
            _loc2_.h.y = this.mhY + this.mbD;
            if(_loc2_.h.y + 1 + _loc2_.h.height > _loc2_.b.height + 1)
            {
               _loc2_.h.y = int(_loc2_.b.height + 1 - _loc2_.h.height);
            }
            if(_loc2_.h.y < 1)
            {
               _loc2_.h.y = 1;
            }
         }
      }
      
      private function dEF(param1:Event) : *
      {
         var _loc2_:* = this.bg2.SBar;
         var _loc3_:* = this.optionList;
         var _loc4_:* = -(_loc2_.h.y - 1) / this.hRun;
         var _loc5_:* = int(_loc4_ * this.dRun) + this.oy;
         if(Math.abs(_loc5_ - _loc3_.y) > 0.2)
         {
            _loc3_.y += (_loc5_ - _loc3_.y) / 4;
         }
         else
         {
            _loc3_.y = _loc5_;
         }
      }
   }
}

