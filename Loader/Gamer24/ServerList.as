package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.TextField;
   import flash.utils.*;
   
   public class ServerList extends MovieClip
   {
      public var bg:MovieClip;
      
      public var iList:MovieClip;
      
      public var l1:MovieClip;
      
      public var l2:MovieClip;
      
      public var legend:MovieClip;
      
      public var liveLink:MovieClip;
      
      public var txtServerSelect:TextField;
      
      public var uCount:MovieClip;
      
      private var objLogin:Object;
      
      private var rootClass:MovieClip;
      
      private var arrServers:Array;
      
      private var blackCT:ColorTransform;
      
      private var iCap:int = 0;
      
      private var mDown:Boolean = false;
      
      private var hRun:int = 0;
      
      private var dRun:int = 0;
      
      private var mbY:int = 0;
      
      private var mhY:int = 0;
      
      private var mbD:int = 0;
      
      private var ox:int = 0;
      
      private var oy:int = 0;
      
      private var mox:int = 0;
      
      private var moy:int = 0;
      
      private var scrTgt:MovieClip;
      
      private var whiteListA:Array;
      
      private var whiteListB:Array;
      
      private var langMap:Object;
      
      private var iTotal:int = 0;
      
      internal var tRefresh:Timer;
      
      public function ServerList()
      {
         var drawnItems:int;
         var i:*;
         var bgh:int;
         var ts:String;
         var legendKeep:Array;
         var li:int;
         var itemClass:Class = null;
         var server:MovieClip = null;
         var n:int = 0;
         var lch:DisplayObject = null;
         this.blackCT = new ColorTransform();
         this.whiteListA = ["74.53.22.26","74.53.7.201"];
         this.whiteListB = ["74.53.7.201"];
         this.langMap = {
            "xx":"Canned-Chat",
            "en":"English",
            "pt":"Portuguese",
            "ph":"Philippines",
            "it":"Global"
         };
         this.tRefresh = new Timer(1000,5);
         super();
         visible = false;
         this.objLogin = Game.objLogin;
         this.rootClass = MovieClip(root);
         this.legend.fbWindow.btnFBID.visible = false;
         if(FacebookConnect.isLoggedIn)
         {
            this.legend.fbNoLink.visible = false;
            this.legend.fbWindow.visible = true;
            this.legend.fbWindow.fbImg.visible = true;
            this.legend.fbWindow.btnFBLogout.visible = true;
            try
            {
               this.legend.fbWindow.txtFBName.text = FacebookConnect.Me.name;
            }
            catch(e:*)
            {
               trace("[Game] ERR ServerList fbName: " + e);
            }
         }
         else
         {
            this.legend.fbWindow.visible = false;
            this.legend.fbNoLink.visible = true;
            this.legend.fbWindow.addEventListener(MouseEvent.CLICK,this.onBackClick,false,0,true);
         }
         this.txtServerSelect.text = Game.loginInfo.strUsername + ", please select a server.";
         if(this.objLogin.iAccess >= 70)
         {
            this.arrServers = this.whiteList(this.objLogin.servers,[]);
         }
         else if(Game.bPTR)
         {
            if(this.objLogin.iAccess >= 40)
            {
               this.arrServers = this.whiteList(this.objLogin.servers,this.whiteListA);
            }
            else
            {
               this.arrServers = this.whiteList(this.objLogin.servers,this.whiteListB);
            }
            this.liveLink.alpha = 100;
         }
         else
         {
            this.arrServers = this.whiteList(this.objLogin.servers,[]);
         }
         this.rootClass.serialCmd.servers = this.objLogin.servers;
         this.blackCT.color = 0;
         drawnItems = 0;
         i = 0;
         while(i < this.arrServers.length)
         {
            itemClass = this.iList.iProto.constructor as Class;
            server = this.iList.addChildAt(new itemClass(),0) as MovieClip;
            if(this.objLogin.iLevel >= this.arrServers[i].iLevel)
            {
               server.ttStr = "";
               if(drawnItems % 2 > 0)
               {
                  server.x = 286;
               }
               else
               {
                  server.x = 0;
               }
               server.y = Math.floor(drawnItems / 2) * 32;
               server.obj = this.arrServers[i];
               server.tName.ti.text = this.arrServers[i].sName;
               try
               {
                  server.mcPop.txtLang.text = this.langMap[this.arrServers[i].sLang];
               }
               catch(e:*)
               {
                  server.mcPop.txtLang.text = "English";
               }
               if(this.arrServers[i].bUpg == 1)
               {
                  server.mcPop.txtLang.text = "Member";
               }
               this.iTotal += int(this.arrServers[i].iCount);
               if(this.objLogin.iAccess >= 40)
               {
                  this.iCap = parseInt(this.arrServers[i].iMax) + 10000;
               }
               else if(this.objLogin.iUpgDays >= 0)
               {
                  this.iCap = parseInt(this.arrServers[i].iMax) + 1000;
               }
               else
               {
                  this.iCap = parseInt(this.arrServers[i].iMax);
               }
               this.arrServers[i].iMax = this.iCap;
               server.iconStandard.visible = false;
               server.iconSafe.visible = false;
               server.iconLegen.visible = false;
               server.iconChat.visible = true;
               server.iconChat.nullset.visible = false;
               server.iconTest.visible = false;
               if(this.arrServers[i].bUpg == 0)
               {
                  server.ttStr += "This is a free server. ";
               }
               else
               {
                  server.ttStr += "This is an upgrade-only server. ";
                  server.tName.ti.textColor = 16763955;
               }
               if(this.arrServers[i].iChat == 0)
               {
                  server.iconSafe.visible = true;
                  server.iconChat.nullset.visible = true;
                  server.ttStr += "Only Canned Chat enabled.";
               }
               else
               {
                  if(this.arrServers[i].iChat == 1)
                  {
                     server.iconChat.alpha = 0.5;
                     server.ttStr += "Chat is limited.";
                  }
                  else
                  {
                     server.ttStr += "Chat is enabled.";
                  }
                  if(this.arrServers[i].bUpg == 1)
                  {
                     server.iconLegen.visible = true;
                  }
                  else
                  {
                     server.iconStandard.visible = true;
                  }
                  server.iconChat.visible = true;
               }
               if(this.arrServers[i].sName == "Class Test Realm")
               {
                  server.iconStandard.visible = false;
                  server.iconTest.visible = true;
               }
               n = int(this.arrServers[i].iCount);
               server.mcPop.visible = true;
               server.iconFull.visible = false;
               if(n < this.iCap)
               {
                  server.mcPop.txtPopulation.text = n;
               }
               else
               {
                  server.mcPop.visible = false;
                  server.iconFull.visible = true;
                  server.ttStr = "Server is full.";
               }
               if(this.arrServers[i].bOnline == 1)
               {
                  if(this.langMap[this.rootClass.params.sLang] == null)
                  {
                     this.rootClass.params.sLang = "en";
                  }
                  server.bgOn.gotoAndStop("Online");
                  server.mcNonPreferred.visible = false;
                  server.iconOffline.visible = false;
               }
               else
               {
                  server.bgOn.gotoAndStop("Offline");
                  server.iconOffline.visible = true;
                  server.iconStandard.visible = false;
                  server.iconSafe.visible = false;
                  server.iconLegen.visible = false;
                  server.iconChat.visible = false;
                  server.iconTest.visible = false;
                  server.mcPop.visible = false;
                  server.tName.alpha = 0.8;
                  server.ttStr = "Server is temporarily offline.";
               }
               server.mouseChildren = false;
               server.addEventListener(MouseEvent.CLICK,this.onServerClick,false,0,true);
               server.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
               server.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
               if(this.arrServers[i].bOnline == 0 || n >= this.iCap || this.arrServers[i].bUpg == 1 && this.objLogin.iUpgDays < 0 || this.arrServers[i].iChat > 0 && this.objLogin.iAge < 13 && this.objLogin.iUpgDays < 0 || this.arrServers[i].iChat > 0 && this.objLogin.bCCOnly == 1)
               {
                  server.buttonMode = true;
               }
               else
               {
                  server.mouseChildren = false;
                  server.buttonMode = true;
               }
               drawnItems++;
            }
            i++;
         }
         this.iList.iProto.visible = false;
         this.l2.y = this.iList.y + this.iList.height + 10;
         this.legend.y = this.l2.y + 8;
         bgh = int(this.bg.height);
         this.bg.height = int(this.legend.y + this.legend.height + 7);
         this.bg.y += int((this.bg.height - bgh) / 2);
         ts = "";
         if(this.iTotal > 0)
         {
            this.uCount.ti.htmlText = "<font color=\"#FFBB3E\">";
            this.uCount.ti.htmlText += this.rootClass.strNumWithCommas(this.iTotal);
            this.uCount.ti.htmlText += "</font>";
            this.uCount.t2.x = this.uCount.ti.textWidth + 7;
         }
         else
         {
            this.uCount.visible = false;
         }
         MovieClip(this).y = int(275 - MovieClip(this).height / 2);
         this.legend.btnRefresh.addEventListener(MouseEvent.CLICK,this.onRefreshClick,false,0,true);
         this.legend.txtRefresh.mouseEnabled = false;
         this.tRefresh.addEventListener(TimerEvent.TIMER,this.onRefreshCooldown,false,0,true);
         this.tRefresh.start();
         this.legend.btnBack.addEventListener(MouseEvent.CLICK,this.onBackClick,false,0,true);
         this.legend.btnHelp.addEventListener(MouseEvent.CLICK,this.onHelpClick,false,0,true);
         this.legend.btnManage.addEventListener(MouseEvent.CLICK,this.onManageClick,false,0,true);
         legendKeep = ["btnBack","btnHelp","btnManage","btnRefresh","fbWindow"];
         li = 0;
         while(li < this.legend.numChildren)
         {
            lch = this.legend.getChildAt(li);
            if(lch is MovieClip && legendKeep.indexOf(lch.name) < 0)
            {
               MovieClip(lch).mouseEnabled = false;
               MovieClip(lch).mouseChildren = false;
            }
            li++;
         }
         this.legend.addEventListener(MouseEvent.CLICK,this.onLegendClick,false,0,true);
         this.legend.fbWindow.btnFBLogout.addEventListener(MouseEvent.CLICK,this.onFBLogoutClick,false,0,true);
         this.legend.fbWindow.btnFBLogout.buttonMode = true;
         if(FacebookConnect.isLoggedIn)
         {
            try
            {
               if(this.rootClass.FBApi.FBImage != null)
               {
                  this.legend.fbImg.removeChildAt(0);
                  this.legend.fbWindow.fbImg.addChildAt(this.rootClass.FBApi.FBImage,1);
               }
            }
            catch(e:*)
            {
            }
         }
      }
      
      private function onRefreshCooldown(param1:TimerEvent) : void
      {
         this.legend.txtRefresh.text = this.tRefresh.currentCount > 4 ? "Refresh" : "Refresh (" + (5 - this.tRefresh.currentCount) + ")";
         if(this.tRefresh.currentCount > 4)
         {
            this.tRefresh.removeEventListener(TimerEvent.TIMER,this.onRefreshClick);
         }
      }
      
      private function onRefreshClick(param1:MouseEvent) : *
      {
         var _loc5_:URLVariables = null;
         if(this.tRefresh.running)
         {
            return;
         }
         this.rootClass.mcLogin.gotoAndStop("Init");
         var _loc2_:URLLoader = new URLLoader();
         var _loc3_:String = Game.serverGamePath + (Game.objLogin.iAccess >= 24 ? "api/data/serversext" : "api/data/servers") + "?v=" + Math.random();
         var _loc4_:URLRequest = new URLRequest(_loc3_);
         _loc2_.addEventListener(Event.COMPLETE,this.onServerListComplete,false,0,true);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onServerListError,false,0,true);
         _loc2_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onServerListSecurityError,false,0,true);
         if(Game.objLogin.iAccess >= 24)
         {
            _loc5_ = new URLVariables();
            _loc5_.uid = Game.objLogin.userid;
            _loc5_.token = Game.objLogin.sToken;
            _loc4_.data = _loc5_;
            _loc4_.method = URLRequestMethod.POST;
         }
         else
         {
            _loc4_.method = URLRequestMethod.GET;
         }
         _loc2_.load(_loc4_);
      }
      
      private function cleanupServerListLoader(param1:URLLoader) : void
      {
         if(param1 != null)
         {
            param1.removeEventListener(Event.COMPLETE,this.onServerListComplete);
            param1.removeEventListener(IOErrorEvent.IO_ERROR,this.onServerListError);
            param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onServerListSecurityError);
         }
      }
      
      private function onServerListComplete(param1:Event) : void
      {
         this.cleanupServerListLoader(param1.target as URLLoader);
         if(param1.target.data.indexOf("{notused}") == -1)
         {
            trace("[Game] server list refreshed");
            Game.objLogin.servers = JSON.parse(param1.target.data);
         }
         else
         {
            trace("[Game] ERR server list refresh failed");
         }
         this.rootClass.mcLogin.gotoAndStop("Servers");
      }
      
      private function onServerListError(param1:IOErrorEvent) : void
      {
         this.cleanupServerListLoader(param1.target as URLLoader);
         trace("[Game] ERR server list refresh IO: " + param1.text);
         this.rootClass.mcLogin.gotoAndStop("Servers");
      }
      
      private function onServerListSecurityError(param1:SecurityErrorEvent) : void
      {
         this.cleanupServerListLoader(param1.target as URLLoader);
         trace("[Game] ERR server list refresh security: " + param1.text);
         this.rootClass.mcLogin.gotoAndStop("Servers");
      }
      
      private function onIDClick(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://www.facebook.com/profile.php?id=" + this.objLogin.FBID),"_blank");
      }
      
      private function onFBLogoutClick(param1:MouseEvent) : void
      {
         FacebookConnect.Logout();
         MovieClip(parent).gotoAndPlay("Login");
      }
      
      private function onHelpClick(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://www.aq.com/help/"),"_blank");
      }
      
      private function onManageClick(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://account.aq.com/"),"_blank");
      }
      
      private function onBackClick(param1:MouseEvent) : *
      {
         this.rootClass.gotoAndPlay("Login");
      }
      
      private function onLegendClick(param1:MouseEvent) : void
      {
         if(param1.target == this.legend && Boolean(this.legend.btnBack.getRect(this.legend).contains(this.legend.mouseX,this.legend.mouseY)))
         {
            this.onBackClick(param1);
         }
      }
      
      private function onServerClick(param1:MouseEvent) : *
      {
         var _loc2_:ModalMC = null;
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         this.rootClass.showTracking("4");
         if(!this.rootClass.serialCmdMode)
         {
            _loc4_ = MovieClip(param1.currentTarget);
            if(_loc4_.obj.bOnline == 0)
            {
               this.rootClass.MsgBox.notify("Server currently offline!");
            }
            else if(_loc4_.obj.iCount >= _loc4_.obj.iMax)
            {
               this.rootClass.MsgBox.notify("Server is Full!");
            }
            else if(_loc4_.obj.iChat > 0 && this.objLogin.bCCOnly == 1)
            {
               this.rootClass.MsgBox.notify("Account Restricted to Moglin Sage Server Only.");
            }
            else if(_loc4_.obj.iChat > 0 && this.objLogin.iAge < 13 && this.objLogin.iUpgDays < 0)
            {
               this.rootClass.MsgBox.notify("Ask your parent to upgrade your account in order to play on chat enabled servers.");
            }
            else if(_loc4_.obj.bUpg == 1 && this.objLogin.iUpgDays < 0)
            {
               _loc2_ = new ModalMC();
               _loc3_ = {};
               _loc3_.strBody = "Member Server! Do you want to upgrade your account to access this premium server now?";
               _loc3_.params = {};
               _loc3_.callback = this.onModalClickUpgrade;
               _loc3_.glow = "white,medium";
               _loc3_.btns = "dual";
               this.rootClass.mcLogin.ModalStack.addChild(_loc2_);
               _loc2_.init(_loc3_);
            }
            else if(_loc4_.obj.iMax % 2 > 0)
            {
               _loc2_ = new ModalMC();
               _loc3_ = {};
               _loc3_.strBody = "Testing Server! Do you want to switch to the testing game client?";
               _loc3_.params = {};
               _loc3_.callback = this.onModalClickTest;
               _loc3_.glow = "white,medium";
               _loc3_.btns = "dual";
               this.rootClass.mcLogin.ModalStack.addChild(_loc2_);
               _loc2_.init(_loc3_);
            }
            else if(_loc4_.obj.iLevel > 0 && this.objLogin.iEmailStatus <= 2)
            {
               _loc2_ = new ModalMC();
               _loc3_ = {};
               _loc3_.strBody = "This server requires a confirmed email address.";
               _loc3_.params = {};
               _loc3_.glow = "red,medium";
               _loc3_.btns = "mono";
               this.rootClass.mcLogin.ModalStack.addChild(_loc2_);
               _loc2_.init(_loc3_);
            }
            else
            {
               this.rootClass.objServerInfo = _loc4_.obj;
               this.rootClass.chatF.iChat = _loc4_.obj.iChat;
               this.fClose();
               this.rootClass.connectTo(_loc4_.obj.sIP,_loc4_.obj.iPort);
            }
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         if(_loc2_.obj.bOnline > 0 && _loc2_.frame.currentLabel != "in")
         {
            _loc2_.frame.gotoAndPlay("in");
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         if(_loc2_.obj.bOnline > 0 && _loc2_.frame.currentLabel == "in")
         {
            _loc2_.frame.gotoAndPlay("out");
         }
      }
      
      private function onModalClickUpgrade(param1:Object) : void
      {
         if(param1.accept)
         {
            navigateToURL(new URLRequest("https://aq.com/order-now/direct"),"_blank");
         }
      }
      
      private function onModalClickPTR(param1:Object) : void
      {
         if(param1.accept)
         {
            this.fClose();
         }
      }
      
      private function onModalClickTest(param1:Object) : void
      {
      }
      
      private function onLiveLinkClick(param1:MouseEvent) : *
      {
         this.fClose();
      }
      
      public function fClose() : void
      {
         this.killModals();
      }
      
      private function killModals() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:MovieClip = this.rootClass.mcLogin.ModalStack;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.numChildren)
         {
            _loc2_ = _loc1_.getChildAt(_loc3_) as MovieClip;
            if("fClose" in _loc2_)
            {
               _loc2_.fClose();
            }
            _loc3_++;
         }
      }
      
      public function getServerTabByIP(param1:String) : MovieClip
      {
         var _loc2_:* = numChildren;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = getChildAt(_loc4_);
            if(_loc3_.constructor.toString().indexOf("MCServerItem") > -1 && MovieClip(_loc3_).obj != null && _loc3_.obj.sIP == param1)
            {
               return MovieClip(_loc3_);
            }
            _loc4_++;
         }
         return null;
      }
      
      private function whiteList(param1:Array, param2:Array, param3:Boolean = false) : Array
      {
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc4_:Array = [];
         if(param1.length > 0)
         {
            _loc6_ = 0;
            while(_loc6_ < param1.length)
            {
               _loc5_ = false;
               if(param2.length == 0 || param2.indexOf(param1[_loc6_].sIP) > -1)
               {
                  _loc5_ = true;
                  if(param3 && this.rootClass.objLogin.iUpgDays < 1)
                  {
                     _loc5_ = false;
                  }
               }
               if(_loc5_)
               {
                  _loc4_.push(param1[_loc6_]);
               }
               _loc6_++;
            }
         }
         return _loc4_;
      }
      
      private function ccWhiteList(param1:Array, param2:String) : Array
      {
         if(param2 == "")
         {
            return param1;
         }
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_].sLang == param2 || param1[_loc4_].bUpg == 1 || param1[_loc4_].sLang == "it")
            {
               _loc3_.push(param1[_loc4_]);
            }
            else
            {
               this.iTotal += int(this.arrServers[_loc4_].iCount);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function sortServers(param1:Array, param2:String) : Array
      {
         var _loc3_:Object = {
            "upg":[],
            "it":[]
         };
         _loc3_[param2] = [];
         var _loc4_:uint = 0;
         while(_loc4_ < param1.length)
         {
            switch(param1[_loc4_].sLang)
            {
               case "ph":
               case "pt":
               case "it":
                  _loc3_[param1[_loc4_].sLang].push(param1[_loc4_]);
                  break;
               default:
                  _loc3_["upg"].push(param1[_loc4_]);
                  break;
            }
            _loc4_++;
         }
         var _loc5_:Array = [];
         _loc5_ = this.pushServers(_loc5_,"it",_loc3_);
         _loc5_ = this.pushServers(_loc5_,"upg",_loc3_);
         return this.pushServers(_loc5_,param2,_loc3_);
      }
      
      private function pushServers(param1:Array, param2:String, param3:Object) : Array
      {
         var _loc4_:uint = 0;
         while(_loc4_ < param3[param2].length)
         {
            param1.push(param3[param2][_loc4_]);
            _loc4_++;
         }
         return param1;
      }
   }
}

