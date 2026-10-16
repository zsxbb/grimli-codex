package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.Rectangle;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   
   public class qRewardPrev extends MovieClip
   {
      public var cnt:MovieClip;
      
      public var world:MovieClip;
      
      public var rootClass:MovieClip;
      
      public var qData:Object = null;
      
      internal var qMode:String = null;
      
      internal var choiceID:int = -1;
      
      internal var isOpen:Boolean = false;
      
      internal var mc:MovieClip;
      
      internal var mDown:Boolean = false;
      
      internal var hRun:int = 0;
      
      internal var dRun:int = 0;
      
      internal var mbY:int = 0;
      
      internal var mhY:int = 0;
      
      internal var mbD:int = 0;
      
      internal var qly:int = 70;
      
      internal var qdy:int = 58;
      
      internal var qla:Array;
      
      internal var qlb:Array;
      
      public var qIDs:Array;
      
      public var sIDs:Array;
      
      public var tIDs:Array;
      
      private var previewArgs:Object;
      
      private var curItem:Object;
      
      private var sLinkArmor:String = "";
      
      private var sLinkCape:String = "";
      
      private var sLinkHelm:String = "";
      
      private var sLinkPet:String = "";
      
      private var sLinkWeapon:String = "";
      
      private var sLinkMisc:String = "";
      
      private var pLoaderD:ApplicationDomain;
      
      private var pLoaderC:LoaderContext;
      
      private var loaderStack:Array;
      
      private var killStack:Array;
      
      internal var mcPreview:MovieClip;
      
      internal var rItem:Object;
      
      public function qRewardPrev(param1:Object)
      {
         this.qla = [];
         this.qlb = [];
         this.qIDs = [];
         this.sIDs = [];
         this.tIDs = [];
         this.previewArgs = {};
         this.pLoaderD = new ApplicationDomain(ApplicationDomain.currentDomain);
         this.pLoaderC = new LoaderContext(false,this.pLoaderD);
         this.loaderStack = [];
         this.killStack = [];
         super();
         this.rItem = param1;
         this.mc = MovieClip(this);
         this.mc.name = "qRewardPrev";
         this.mc.x = 377.1 - 5;
         this.mc.y = 65;
         this.mc.cnt.bg.btnClose.addEventListener(MouseEvent.CLICK,this.xClick);
      }
      
      public function tryClick(param1:MouseEvent) : void
      {
         this.rootClass.xTryMe(this.rItem);
         this.fClose();
      }
      
      public function isDropPreview() : void
      {
         this.mc.x -= 75;
      }
      
      public function open() : *
      {
         this.rootClass = MovieClip(this.stage.getChildAt(0));
         this.world = this.rootClass.world;
         this.mc = MovieClip(this);
         this.mc.cnt.bg.fx.visible = false;
         if(this.rootClass.isDialoqueUp())
         {
            this.mc.cnt.bg.fx.visible = true;
         }
         if(!this.isOpen)
         {
            this.isOpen = true;
            this.mc.cnt.gotoAndPlay("intro");
         }
         else
         {
            this.isOpen = false;
            this.fClose();
         }
         switch(this.rItem.sES)
         {
            case "Weapon":
            case "he":
            case "ba":
            case "pe":
            case "ar":
            case "co":
            case "mi":
               if(this.rItem.bUpg == 1)
               {
                  if(!this.world.myAvatar.isUpgraded())
                  {
                     this.mc.cnt.bg.btnTry.visible = false;
                     break;
                  }
               }
               this.mc.cnt.bg.btnTry.visible = true;
               break;
            case "ho":
            case "hi":
            default:
               this.mc.cnt.bg.btnTry.visible = false;
         }
         this.mc.cnt.bg.btnPin.visible = false;
         this.mc.cnt.bg.btnWiki.visible = true;
         if(this.mc.cnt.bg.btnTry.visible)
         {
            this.mc.cnt.bg.btnWiki.y = 57.3;
         }
         this.mc.cnt.bg.btnWiki.addEventListener(MouseEvent.CLICK,this.onWikiClick,false,0,true);
         this.mc.cnt.bg.btnTry.addEventListener(MouseEvent.CLICK,this.tryClick,false,0,true);
      }
      
      public function onWikiClick(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("http://aqwwiki.wikidot.com/" + this.rItem.sName),"_blank");
      }
      
      public function showQuestList() : *
      {
         this.buildReward();
         this.mc.cnt.strTitle.x = 53;
         this.mc.cnt.strTitle.width = 256;
         this.mc.cnt.strTitle.htmlText = this.rItem.sName;
         this.mc.cnt.strTitle.mouseEnabled = false;
         this.mc.cnt.qList.visible = true;
         this.mc.cnt.qList.mHi.visible = false;
         this.mc.cnt.mouseChildren = true;
         this.mcPreview.mouseEnabled = this.mcPreview.mouseChildren = false;
      }
      
      private function buildReward() : *
      {
         this.mcPreview = this.mc.cnt.qList;
         var _loc1_:* = this.mc.cnt.scr;
         var _loc2_:* = this.mc.cnt.bMask;
         _loc1_.visible = false;
         while(this.mcPreview.numChildren > 0)
         {
            this.mcPreview.removeChildAt(0);
         }
         this.loadPreview(this.rItem);
      }
      
      private function loadPreview(param1:Object) : void
      {
         if(param1.sType.toLowerCase() != "enhancement")
         {
            if(this.curItem != param1)
            {
               this.curItem = param1;
               switch(param1.sES)
               {
                  case "Weapon":
                     this.loadWeapon(param1.sFile,param1.sLink);
                     break;
                  case "he":
                     this.loadHelm(param1.sFile,param1.sLink);
                     break;
                  case "ba":
                     this.loadCape(param1.sFile,param1.sLink);
                     break;
                  case "pe":
                     this.loadPet(param1.sFile,param1.sLink);
                     break;
                  case "ar":
                  case "co":
                     this.loadArmor(param1.sFile,param1.sLink);
                     break;
                  case "ho":
                     this.loadHouse(param1.sFile);
                     break;
                  case "hi":
                     this.loadHouseItem(param1.sFile,param1.sLink);
                     break;
                  case "mi":
                     this.loadMisc(param1.sFile,param1.sLink);
                     break;
                  default:
                     this.loadBag(param1);
               }
            }
         }
         else
         {
            this.loadEnhancement(param1);
         }
      }
      
      private function clearPreview() : void
      {
         var _loc3_:int = 0;
         this.clearLoaderStack();
         var _loc1_:Boolean = true;
         var _loc2_:int = 0;
         while(_loc2_ < this.mcPreview.numChildren)
         {
            _loc1_ = true;
            if("fClose" in MovieClip(this.mcPreview.getChildAt(_loc2_)))
            {
               this.rootClass.recursiveStop(MovieClip(this.mcPreview.getChildAt(_loc2_)));
               _loc3_ = 0;
               while(_loc3_ < this.killStack.length)
               {
                  if(this.killStack[_loc3_].mc == this.mcPreview.getChildAt(_loc2_))
                  {
                     _loc1_ = false;
                  }
                  _loc3_++;
               }
               if(_loc1_)
               {
                  this.killStack.push({
                     "c":0,
                     "mc":this.mcPreview.getChildAt(_loc2_)
                  });
               }
            }
            else
            {
               this.mcPreview.removeChildAt(_loc2_);
               _loc2_--;
            }
            _loc2_++;
         }
         this.curItem = null;
      }
      
      private function loadEnhancement(param1:*) : void
      {
         var mc:MovieClip = null;
         var AssetClass:Class = null;
         var item:* = param1;
         this.clearPreview();
         try
         {
            AssetClass = this.rootClass.world.getClass("iidesign") as Class;
            mc = new AssetClass();
         }
         catch(err:Error)
         {
            trace("[UI] ERR qRewardPrev: iidesign class: " + err.message);
         }
         mc.scaleX = mc.scaleY = 3;
         this.mcPreview.addChild(mc);
         this.addGlow(mc);
      }
      
      private function loadBag(param1:*, param2:Boolean = false) : void
      {
         var _loc3_:MovieClip = null;
         this.clearPreview();
         var _loc4_:Class = this.rootClass.world.getClass("iibag") as Class;
         if(param2 || (param1 == null || !("sFile" in param1) || String(param1.sFile).length < 1 || this.rootClass.world.getClass(param1.sFile) == null))
         {
            _loc4_ = this.rootClass.world.getClass(param1.sIcon) as Class;
         }
         else if(param1 != null && "sFile" in param1 && String(param1.sFile).length > 0 && this.rootClass.world.getClass(param1.sFile) != null)
         {
            _loc4_ = this.rootClass.world.getClass(param1.sFile) as Class;
         }
         try
         {
            _loc3_ = new _loc4_();
            _loc3_.scaleX = _loc3_.scaleY = 3;
            this.mcPreview.addChild(_loc3_);
            this.addGlow(_loc3_);
         }
         catch(e:Error)
         {
         }
      }
      
      private function loadWeapon(param1:*, param2:*) : void
      {
         this.clearPreview();
         this.sLinkWeapon = param2;
         var _loc3_:* = new Loader();
         _loc3_.load(new URLRequest(Game.vurl(Game.serverFilePath + param1)),this.pLoaderC);
         _loc3_.contentLoaderInfo.addEventListener(Event.INIT,this.onLoadWeaponComplete,false,0,true);
         this.addToLoaderStack(_loc3_);
      }
      
      private function loadCape(param1:*, param2:*) : void
      {
         this.clearPreview();
         this.sLinkCape = param2;
         var _loc3_:* = new Loader();
         _loc3_.load(new URLRequest(Game.vurl(Game.serverFilePath + param1)),this.pLoaderC);
         _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadCapeComplete,false,0,true);
         this.addToLoaderStack(_loc3_);
      }
      
      private function loadHelm(param1:*, param2:*) : void
      {
         this.clearPreview();
         this.sLinkHelm = param2;
         var _loc3_:* = new Loader();
         _loc3_.load(new URLRequest(Game.vurl(Game.serverFilePath + param1)),this.pLoaderC);
         _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadHelmComplete,false,0,true);
         this.addToLoaderStack(_loc3_);
      }
      
      private function loadPet(param1:*, param2:*) : void
      {
         this.clearPreview();
         this.sLinkPet = param2;
         var _loc3_:* = new Loader();
         _loc3_.load(new URLRequest(Game.vurl(Game.serverFilePath + param1)),this.pLoaderC);
         _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadPetComplete,false,0,true);
         this.addToLoaderStack(_loc3_);
      }
      
      private function loadMisc(param1:*, param2:*) : void
      {
         this.clearPreview();
         this.sLinkMisc = param2;
         var _loc3_:* = new Loader();
         _loc3_.load(new URLRequest(Game.vurl(Game.serverFilePath + param1)),this.pLoaderC);
         _loc3_.contentLoaderInfo.addEventListener(Event.INIT,this.onLoadMiscComplete,false,0,true);
         this.addToLoaderStack(_loc3_);
      }
      
      private function onLoadMiscComplete(param1:Event) : void
      {
         var mc:MovieClip = null;
         var AssetClass:Class = null;
         var e:Event = param1;
         this.removeFromLoaderStack(e.target);
         try
         {
            AssetClass = this.pLoaderD.getDefinition(this.sLinkMisc) as Class;
            mc = new AssetClass();
         }
         catch(err:Error)
         {
            mc = e.target.content;
         }
         if(mc == null)
         {
            return;
         }
         this.mcPreview.addChild(mc);
         this.addGlow(mc);
      }
      
      private function loadHouse(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         try
         {
            this.clearPreview();
            _loc2_ = "maps/" + this.curItem.sFile.substr(0,-4) + "_preview.swf";
            _loc3_ = new Loader();
            _loc3_.load(new URLRequest(Game.vurl(Game.serverFilePath + _loc2_)),this.pLoaderC);
            _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadHouseComplete,false,0,true);
            this.addToLoaderStack(_loc3_);
         }
         catch(e:*)
         {
         }
      }
      
      private function onLoadHouseComplete(param1:Event) : void
      {
         this.removeFromLoaderStack(param1.target);
         var _loc2_:* = this.curItem.sFile.substr(0,-4).substr(this.curItem.sFile.lastIndexOf("/") + 1).split("-").join("_") + "_preview";
         if(!this.pLoaderD.hasDefinition(_loc2_))
         {
            trace("[Load] ERR missing linkage " + _loc2_ + " " + this.curItem.sFile);
            return;
         }
         var _loc3_:Class = this.pLoaderD.getDefinition(_loc2_) as Class;
         var _loc4_:* = new _loc3_();
         _loc4_.x = 150;
         _loc4_.y = 200;
         this.mcPreview.addChild(_loc4_);
         this.addGlow(_loc4_);
      }
      
      private function loadArmor(param1:*, param2:*) : void
      {
         this.clearPreview();
         this.sLinkArmor = param2;
         var _loc3_:* = new Loader();
         _loc3_.load(new URLRequest(Game.vurl(Game.serverFilePath + "classes/" + this.rootClass.world.myAvatar.objData.strGender + "/" + param1)),this.pLoaderC);
         _loc3_.contentLoaderInfo.addEventListener(Event.INIT,this.onLoadArmorComplete,false,0,true);
         this.addToLoaderStack(_loc3_);
      }
      
      private function onLoadWeaponComplete(param1:Event) : void
      {
         var mc:MovieClip = null;
         var AssetClass:Class = null;
         var e:Event = param1;
         this.removeFromLoaderStack(e.target);
         try
         {
            AssetClass = this.pLoaderD.getDefinition(this.sLinkWeapon) as Class;
            mc = new AssetClass();
         }
         catch(err:Error)
         {
            mc = e.target.content;
         }
         mc.scaleX = mc.scaleY = 0.3;
         this.mcPreview.addChild(mc);
         this.addGlow(mc);
      }
      
      private function onLoadCapeComplete(param1:Event) : void
      {
         var _loc2_:Class = null;
         var _loc3_:* = undefined;
         this.removeFromLoaderStack(param1.target);
         try
         {
            _loc2_ = this.pLoaderD.getDefinition(this.sLinkCape) as Class;
            _loc3_ = new _loc2_();
            _loc3_.scaleX = _loc3_.scaleY = 0.5;
            this.mcPreview.addChild(_loc3_);
            this.addGlow(_loc3_);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onLoadHelmComplete(param1:Event) : void
      {
         var _loc2_:Class = null;
         var _loc3_:* = undefined;
         var _loc4_:Class = null;
         var _loc5_:* = undefined;
         this.removeFromLoaderStack(param1.target);
         try
         {
            _loc2_ = this.pLoaderD.getDefinition(this.sLinkHelm) as Class;
            _loc3_ = new _loc2_();
            _loc3_.scaleX = _loc3_.scaleY = 0.8;
            this.mcPreview.addChild(_loc3_);
            try
            {
               _loc4_ = this.pLoaderD.getDefinition(this.sLinkHelm + "_backhair") as Class;
               if(_loc4_ != null)
               {
                  _loc5_ = new _loc4_();
                  _loc5_.x = _loc3_.getChildAt(0).x + 1;
                  _loc5_.y = _loc3_.getChildAt(0).y - 28;
                  _loc5_.scaleX = _loc5_.scaleY = 3.2;
                  _loc3_.addChild(_loc5_);
                  _loc3_.setChildIndex(_loc5_,0);
               }
            }
            catch(e0:Error)
            {
            }
            this.addGlow(_loc3_);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onLoadArmorComplete(param1:Event) : void
      {
         this.removeFromLoaderStack(param1.target);
         var _loc2_:* = this.mcPreview.addChild(new AvatarMC());
         _loc2_.visible = false;
         _loc2_.strGender = this.rootClass.world.myAvatar.objData.strGender;
         _loc2_.pAV = this.rootClass.world.myAvatar;
         _loc2_.world = MovieClip(Game.root).world;
         _loc2_.hideHPBar();
         _loc2_.name = "previewMCB";
         this.addGlow(_loc2_.mcChar,false);
         _loc2_.loadArmorPiecesFromDomain(this.sLinkArmor,this.pLoaderD);
         _loc2_.visible = true;
         _loc2_.scaleX *= 2;
         _loc2_.scaleY *= 2;
         _loc2_.x = 150;
         _loc2_.y = 250;
      }
      
      private function onLoadPetComplete(param1:Event) : void
      {
         this.removeFromLoaderStack(param1.target);
         if(this.sLinkPet == null || !this.pLoaderD.hasDefinition(this.sLinkPet))
         {
            if(this.sLinkPet != null)
            {
               trace("[Load] ERR missing linkage " + this.sLinkPet + " onLoadPetComplete");
            }
            return;
         }
         var _loc2_:Class = this.pLoaderD.getDefinition(this.sLinkPet) as Class;
         var _loc3_:* = new _loc2_();
         _loc3_.scaleX = _loc3_.scaleY = 2;
         this.mcPreview.addChild(_loc3_);
         this.addGlow(_loc3_);
      }
      
      private function addGlow(param1:MovieClip, param2:Boolean = true) : void
      {
         var _loc3_:* = new GlowFilter(16777215,1,8,8,2,1,false,false);
         param1.filters = [_loc3_];
         param1.mouseEnabled = param1.mouseChildren = false;
         if(param2)
         {
            this.repositionPreview(param1);
         }
      }
      
      public function repositionPreview(param1:MovieClip) : void
      {
         var _loc2_:Rectangle = param1.getBounds(this.mc.cnt.bMask);
         if(_loc2_.height > 175)
         {
            param1.scaleX *= 175 / _loc2_.height;
            param1.scaleY *= 175 / _loc2_.height;
         }
         param1.x -= int(param1.getBounds(this.mc.cnt.bMask).x + param1.getBounds(this.mc.cnt.bMask).width / 2 - this.mc.cnt.bMask.width / 2);
         param1.y -= int(param1.getBounds(this.mc.cnt.bMask).y + param1.getBounds(this.mc.cnt.bMask).height / 2 - this.mc.cnt.bMask.height / 2);
      }
      
      private function loadHouseItem(param1:*, param2:*) : void
      {
         this.clearPreview();
         var _loc3_:* = new Loader();
         this.previewArgs.sLink = param2;
         _loc3_.load(new URLRequest(Game.vurl(Game.serverFilePath + param1)),this.pLoaderC);
         _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onloadHouseItemComplete,false,0,true);
         this.addToLoaderStack(_loc3_);
      }
      
      private function onloadHouseItemComplete(param1:Event) : void
      {
         this.removeFromLoaderStack(param1.target);
         if(this.previewArgs.sLink == null || !this.pLoaderD.hasDefinition(this.previewArgs.sLink))
         {
            if(this.previewArgs.sLink != null)
            {
               trace("[Load] ERR missing linkage " + this.previewArgs.sLink + " onloadHouseItemComplete");
            }
            return;
         }
         var _loc2_:Class = this.pLoaderD.getDefinition(this.previewArgs.sLink) as Class;
         var _loc3_:* = new _loc2_();
         this.mcPreview.addChild(_loc3_);
         this.addGlow(_loc3_);
      }
      
      private function addToLoaderStack(param1:Loader) : void
      {
         this.clearLoaderStack();
         this.loaderStack.push(param1);
      }
      
      private function removeFromLoaderStack(param1:Object) : void
      {
         var _loc2_:Loader = null;
         for each(_loc2_ in this.loaderStack)
         {
            if(_loc2_.contentLoaderInfo == param1)
            {
               this.loaderStack.splice(this.loaderStack.indexOf(_loc2_),1);
            }
         }
      }
      
      private function clearLoaderStack() : void
      {
         var _loc1_:Loader = null;
         while(this.loaderStack.length > 0)
         {
            _loc1_ = this.loaderStack.shift();
            try
            {
               _loc1_.removeEventListener(Event.INIT,this.onLoadWeaponComplete);
               _loc1_.removeEventListener(Event.INIT,this.onLoadArmorComplete);
               _loc1_.removeEventListener(Event.INIT,this.onLoadMiscComplete);
               _loc1_.removeEventListener(Event.COMPLETE,this.onLoadCapeComplete);
               _loc1_.removeEventListener(Event.COMPLETE,this.onLoadHelmComplete);
               _loc1_.removeEventListener(Event.COMPLETE,this.onLoadPetComplete);
               _loc1_.removeEventListener(Event.COMPLETE,this.onLoadHouseComplete);
               _loc1_.removeEventListener(Event.COMPLETE,this.onloadHouseItemComplete);
               _loc1_.close();
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function onEF(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.killStack.length)
         {
            if(this.killStack[_loc2_].c++ > 2)
            {
               this.mcPreview.removeChild(this.killStack[_loc2_].mc);
               this.killStack.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
      }
      
      private function xClick(param1:MouseEvent) : *
      {
         this.fClose();
      }
      
      public function fClose() : void
      {
         this.mc.cnt.bg.btnClose.removeEventListener(MouseEvent.CLICK,this.xClick);
         this.mc.cnt.bg.btnTry.removeEventListener(MouseEvent.CLICK,this.tryClick);
         stage.focus = stage;
         this.mc.parent.removeChild(this.mc);
      }
      
      private function setCT(param1:*, param2:*) : *
      {
         var _loc3_:* = param1.transform.colorTransform;
         _loc3_.color = param2;
         param1.transform.colorTransform = _loc3_;
      }
   }
}

