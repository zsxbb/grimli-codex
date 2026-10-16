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
   
   public dynamic class mcPopup_355 extends MovieClip
   {
      public var GuildBG:MovieClip;
      
      public var cnt:FactionsMC;
      
      public var mcBag:SimpleButton;
      
      public var mcBook:MovieClip;
      
      public var mcCharpanel:CharpanelMC;
      
      public var mcCustomize:MovieClip;
      
      public var mcCustomizeArmor:MovieClip;
      
      public var mcHouseItemHandle:HouseItemHandleMC;
      
      public var mcHouseMenu:HouseMenu;
      
      public var mcHouseOptions:MovieClip;
      
      public var mcHouseShop:HouseShop;
      
      public var mcMap:MovieClip;
      
      public var mcNews:MovieClip;
      
      public var mcPVPPanel:PVPPanelMC;
      
      public var mcTempInventory:TempInventory;
      
      public var reportMC:MovieClip;
      
      public var rootClass:MovieClip;
      
      public var world:MovieClip;
      
      public var fData:Object;
      
      public var layout:LPFLayout;
      
      public var guild:*;
      
      public var li:mcGuildListItem;
      
      public var onlineCount:int;
      
      public var Rank:int;
      
      public var maxGuildSlots:int;
      
      public var i:*;
      
      public var hRun:Number;
      
      public var dRun:Number;
      
      public var oy:Number;
      
      public var mbY:int;
      
      public var mhY:int;
      
      public var mbD:int;
      
      public var mDown:Boolean;
      
      public function mcPopup_355()
      {
         super();
      }
      
      public function initRefs() : void
      {
         if(stage)
         {
            this.rootClass = stage.getChildAt(0) as MovieClip;
            this.world = !!this.rootClass ? this.rootClass.world as MovieClip : null;
         }
      }
      
      public function fOpen(param1:String, param2:Object = null) : void
      {
         trace("fOpen > " + param1);
         if(currentLabel != param1)
         {
            this.fClose();
            if(param2 != null)
            {
               this.fData = param2;
            }
            gotoAndPlay(param1);
            visible = true;
         }
      }
      
      public function fClose() : *
      {
         var _loc1_:MovieClip = MovieClip(this);
         if(_loc1_.mcHouseMenu != null && _loc1_.mcHouseMenu.fClose != null)
         {
            _loc1_.mcHouseMenu.fClose();
         }
         var _loc2_:MovieClip = getChildByName("mcInventory") as MovieClip;
         if(Boolean(_loc2_) && _loc2_.fClose != null)
         {
            _loc2_.fClose();
         }
         var _loc3_:MovieClip = getChildByName("mcShop") as MovieClip;
         if(Boolean(_loc3_) && _loc3_.fClose != null)
         {
            _loc3_.fClose();
         }
         var _loc4_:MovieClip = getChildByName("mcBank") as MovieClip;
         if((Boolean(_loc4_)) && _loc4_.fClose != null)
         {
            _loc4_.fClose();
         }
         var _loc5_:MovieClip = getChildByName("mcCharpanel") as MovieClip;
         if((Boolean(_loc5_)) && _loc5_.fClose != null)
         {
            _loc5_.fClose();
         }
         var _loc6_:MovieClip = getChildByName("mcO") as MovieClip;
         if((Boolean(_loc6_)) && _loc6_.fClose != null)
         {
            _loc6_.fClose();
         }
      }
      
      public function onClose(param1:Event = null) : void
      {
         trace("mcPopup.onClose >");
         if(currentLabel != "Init" && currentFrame != 1)
         {
            this.fClose();
            if(MovieClip(Game.root) != null && MovieClip(Game.root).mixer != null)
            {
               MovieClip(Game.root).mixer.playSound("Click");
            }
            if(this.world && this.world.isMyHouse != null && this.world.isMyHouse() && !this.world.mapLoadInProgress && currentLabel != "House")
            {
               gotoAndPlay("House");
            }
            else
            {
               trace(" > init");
               gotoAndPlay("Init");
            }
         }
      }
      
      public function loadMap(param1:String) : *
      {
         this.mcMap.removeChildAt(0);
         var _loc2_:Loader = new Loader();
         _loc2_.load(new URLRequest(Game.serverFilePath + param1),new LoaderContext(false,ApplicationDomain.currentDomain));
         this.mcMap.addChild(_loc2_);
      }
      
      public function loadNews(param1:String) : *
      {
         this.mcNews.removeChildAt(0);
         var _loc2_:Loader = new Loader();
         _loc2_.load(new URLRequest(Game.serverFilePath + param1),new LoaderContext(false,ApplicationDomain.currentDomain));
         this.mcNews.addChild(_loc2_);
      }
      
      public function loadBook(param1:String) : *
      {
         trace(Game.serverFilePath + param1);
         this.mcBook.removeChildAt(0);
         if(this.rootClass.newInstance)
         {
            this.rootClass.newInstance = false;
            this.rootClass.bolContent.gotoAndStop("NavMenu");
         }
         this.mcBook.addChild(this.rootClass.bolContent);
      }
      
      public function updateGuildWindow() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         if(this.rootClass.world.myAvatar.objData.guildRank == 3 && this.rootClass.world.myAvatar.objData.guild.MaxMembers < this.maxGuildSlots)
         {
            _loc1_ = this.GuildBG.mcBuyButtons;
            _loc2_ = this.maxGuildSlots - int(this.rootClass.world.myAvatar.objData.guild.MaxMembers);
            this.GuildBG.tSlots.text = String(this.rootClass.world.myAvatar.objData.guild.MaxMembers) + "/" + String(this.maxGuildSlots);
            _loc1_.txtRest.text = "(" + String(_loc2_) + ")";
            _loc1_.txtRestCost.text = String(_loc2_ * 200) + " AC";
            _loc1_.txtCoins.text = String(this.rootClass.world.myAvatar.objData.intCoins);
            _loc1_.btnOne.addEventListener(MouseEvent.CLICK,this.onBuyClick,false,0,true);
            _loc1_.btnRest.addEventListener(MouseEvent.CLICK,this.onBuyClick,false,0,true);
         }
         else
         {
            this.GuildBG.tSlots.text = String(this.rootClass.world.myAvatar.objData.guild.MaxMembers) + "/" + String(this.maxGuildSlots);
            this.GuildBG.mcBuyButtons.visible = false;
         }
      }
      
      public function onBuyClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         switch(param1.currentTarget.name)
         {
            case "btnOne":
               _loc2_ = 1;
               break;
            case "btnRest":
               _loc2_ = this.maxGuildSlots - int(this.rootClass.world.myAvatar.objData.guild.MaxMembers);
         }
         if(_loc2_ * 200 > this.rootClass.world.myAvatar.objData.intCoins)
         {
            this.rootClass.MsgBox.notify("You do not have enough ACs to purchase this.");
         }
         else
         {
            this.rootClass.world.addMemSlots(_loc2_);
         }
      }
      
      public function getRank(param1:int) : String
      {
         var _loc2_:String = "";
         switch(Number(param1))
         {
            case 0:
               _loc2_ = "Duffer";
               break;
            case 1:
               _loc2_ = "Member";
               break;
            case 2:
               _loc2_ = "Officer";
               break;
            case 3:
               _loc2_ = "Leader";
         }
         return _loc2_;
      }
      
      public function onGClose(param1:MouseEvent) : void
      {
         this.GuildBG.scr.hit.removeEventListener(MouseEvent.MOUSE_DOWN,this.onScrDown);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onScrUp);
         this.GuildBG.scr.h.removeEventListener(Event.ENTER_FRAME,this.hEF);
         this.GuildBG.guildDisplay.removeEventListener(Event.ENTER_FRAME,this.dEF);
         this.GuildBG.mcBuyButtons.btnOne.removeEventListener(MouseEvent.CLICK,this.onBuyClick);
         this.GuildBG.mcBuyButtons.btnFive.removeEventListener(MouseEvent.CLICK,this.onBuyClick);
         this.GuildBG.mcBuyButtons.btnRest.removeEventListener(MouseEvent.CLICK,this.onBuyClick);
         this.onClose();
      }
      
      public function onScrDown(param1:MouseEvent) : *
      {
         this.mbY = int(mouseY);
         this.mhY = int(this.GuildBG.scr.h.y);
         this.mDown = true;
      }
      
      public function onScrUp(param1:MouseEvent) : void
      {
         this.mDown = false;
      }
      
      public function hEF(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(this.mDown)
         {
            _loc2_ = this.GuildBG.scr;
            this.mbD = int(mouseY) - this.mbY;
            _loc2_.h.y = this.mhY + this.mbD;
            if(_loc2_.h.y + _loc2_.h.height > _loc2_.b.height)
            {
               _loc2_.h.y = int(_loc2_.b.height - _loc2_.h.height);
            }
            if(_loc2_.h.y < 0)
            {
               _loc2_.h.y = 0;
            }
         }
      }
      
      public function dEF(param1:Event) : *
      {
         var _loc2_:* = this.GuildBG.scr;
         var _loc3_:* = this.GuildBG.guildDisplay;
         var _loc4_:* = -_loc2_.h.y / this.hRun;
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

