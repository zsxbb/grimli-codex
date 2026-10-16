package
{
   import fl.motion.Color;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   
   public class AvatarMC extends MovieClip
   {
      private static const IAF_BODY_PARTS:Array = ["head","chest","hip","idlefoot","frontfoot","backfoot","frontshoulder","backshoulder","fronthand","backhand","frontthigh","backthigh","frontshin","backshin","robe","backrobe"];
      
      public var Sounds:MovieClip;
      
      public var bubble:MovieClip;
      
      public var cShadow:MovieClip;
      
      public var fx:MovieClip;
      
      public var hpBar:MovieClip;
      
      public var ignore:MovieClip;
      
      public var mcChar:mcSkel;
      
      public var pname:MovieClip;
      
      public var proxy:MovieClip;
      
      public var shadow:MovieClip;
      
      private var xDep:*;
      
      private var yDep:*;
      
      private var xTar:*;
      
      private var yTar:Number;
      
      private var nDuration:*;
      
      private var nXStep:*;
      
      private var nYStep:*;
      
      private var walkSpeed:Number;
      
      private var op:Point;
      
      public var tp:Point;
      
      private var walkTS:Number;
      
      private var walkD:Number;
      
      private var headPoint:Point;
      
      private var cbx:*;
      
      private var cby:Number;
      
      private var bLoadingHelm:Boolean = false;
      
      private var objLinks:Object;
      
      private var heavyAssets:Array;
      
      private var totalTransform:Object;
      
      private var clampedTransform:ColorTransform;
      
      private var animQueue:Array;
      
      public var pAV:Avatar;
      
      public var projClass:Projectile;
      
      public var spFX:Object;
      
      public var spellDur:int = 0;
      
      public var bBackHair:Boolean = false;
      
      public var isLoaded:Boolean = false;
      
      public var STAGE:MovieClip;
      
      public var world:MovieClip;
      
      public var px:*;
      
      public var py:*;
      
      public var tx:*;
      
      public var ty:Number;
      
      public var kv:Killvis = null;
      
      public var defaultCT:ColorTransform;
      
      public var strGender:String;
      
      public var previousframe:int = -1;
      
      public var hitboxR:Rectangle;
      
      public var CT3:ColorTransform;
      
      public var CT2:ColorTransform;
      
      public var CT1:ColorTransform;
      
      private var rootClass:MovieClip;
      
      private const MAX_RATIO:Number = 4.656612875245797e-10;
      
      private var r:int;
      
      private var randNum:Number;
      
      private var weaponLoad:Boolean = true;
      
      private var armorLoad:Boolean = true;
      
      private var classLoad:Boolean = true;
      
      private var helmLoad:Boolean = true;
      
      private var hairLoad:Boolean = true;
      
      private var capeLoad:Boolean = true;
      
      private var miscLoad:Boolean = true;
      
      private var animEvents:Object;
      
      private var mcOrder:Object;
      
      private var testMC:*;
      
      private var topIndex:int = 0;
      
      public var isRasterized:Boolean;
      
      private var rawWepRetries:int = 0;
      
      public var helmBackHair:Boolean = false;
      
      private var queueStallTicks:int = 0;
      
      public var attackFrames:Array;
      
      public var sp:Number = 8;
      
      public var mvts:Number;
      
      public var mvtd:Number;
      
      private var _spFXQueue:Array;
      
      public function AvatarMC(param1:Boolean = true)
      {
         this.objLinks = {};
         this.heavyAssets = [];
         this.totalTransform = {
            "alphaMultiplier":1,
            "alphaOffset":0,
            "redMultiplier":1,
            "redOffset":0,
            "greenMultiplier":1,
            "greenOffset":0,
            "blueMultiplier":1,
            "blueOffset":0
         };
         this.clampedTransform = new ColorTransform();
         this.animQueue = [];
         this.spFX = {};
         this.defaultCT = MovieClip(this).transform.colorTransform;
         this.CT3 = new ColorTransform(1,1,1,1,255,255,255,0);
         this.CT2 = new ColorTransform(1,1,1,1,127,127,127,0);
         this.CT1 = new ColorTransform(1,1,1,1,0,0,0,0);
         this.NEGA_MAX_RATIO = -this.MAX_RATIO;
         this.r = Math.random() * int.MAX_VALUE;
         this.animEvents = new Object();
         this.mcOrder = new Object();
         this.attackFrames = [];
         this._spFXQueue = [];
         super();
         this.Sounds.visible = false;
         this.ignore.visible = false;
         if(param1)
         {
            this.mcChar.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         this.mcChar.buttonMode = true;
         this.mcChar.pvpFlag.mouseEnabled = false;
         this.mcChar.pvpFlag.mouseChildren = false;
         this.pname.mouseChildren = false;
         this.pname.buttonMode = false;
         this.mcChar.mouseChildren = true;
         this.bubble.mouseEnabled = this.bubble.mouseChildren = false;
         if(param1)
         {
            this.shadow.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         this.addEventListener(Event.ENTER_FRAME,this.checkQueue,false,0,true);
         this.bubble.visible = false;
         this.bubble.t = "";
         this.pname.ti.text = "";
         this.headPoint = new Point(0,this.mcChar.head.y - 1.4 * this.mcChar.head.height);
         this.hideOptionalParts();
      }
      
      public function fClose() : void
      {
         var _loc1_:Boolean = false;
         if(this.stage != null)
         {
            this.world = MovieClip(stage.getChildAt(0)).world;
         }
         if(this.world != null && this.world.CHARS != null && Boolean(this.world.CHARS.contains(this)))
         {
            this.world.CHARS.removeChild(this);
         }
         if(this.world != null && this.world.TRASH != null && Boolean(this.world.TRASH.contains(this)))
         {
            this.world.TRASH.removeChild(this);
         }
         if(this.kv != null)
         {
            try
            {
               this.kv.cleanup();
            }
            catch(eKV:Error)
            {
            }
            this.kv = null;
         }
         if(this.pAV != null)
         {
            _loc1_ = this.world != null && this.pAV == this.world.myAvatar || this.pAV != null && this.pAV.isMyAvatar;
            if(!_loc1_)
            {
               try
               {
                  this.pAV.unloadPet();
               }
               catch(ePT:Error)
               {
               }
               try
               {
                  this.unloadEquipment();
               }
               catch(eEQ:Error)
               {
               }
            }
            if(this.world != null && this.pAV == this.world.myAvatar)
            {
               this.world.setTarget(null);
            }
            else if(this.pAV != null)
            {
               this.pAV.target = null;
            }
            this.pAV.pMC = null;
            this.pAV = null;
         }
         try
         {
            this.recursiveStop(this);
         }
         catch(eRS:Error)
         {
         }
         if(this.mcChar != null)
         {
            this.mcChar.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         if(this.pname != null)
         {
            this.pname.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         if(this.shadow != null)
         {
            this.shadow.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         this.hideNameCleanup();
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
         this.removeEventListener(Event.ENTER_FRAME,this.checkQueue);
         try
         {
            if(getChildByName("HealIconMC") != null)
            {
               MovieClip(getChildByName("HealIconMC")).fClose();
            }
         }
         catch(e:Error)
         {
         }
         if(this.fx != null)
         {
            while(this.fx.numChildren > 0)
            {
               this.fx.removeChildAt(0);
            }
         }
         this.clearAnimEvents();
         this.clearSpFXQueue();
         this.spFX = null;
      }
      
      public function unloadEquipment() : void
      {
         var _loc1_:DisplayObject = null;
         if(this.mcChar != null)
         {
            if(this.mcChar.head != null)
            {
               this.unloadSlot(this.mcChar.head.helm,"helm");
               this.unloadSlot(this.mcChar.head.hair,"hair");
               this.unloadSlot(this.mcChar.head.face,"face");
            }
            this.unloadSlot(this.mcChar.weapon,"weapon");
            this.unloadSlot(this.mcChar.weaponOff,"weaponOff");
            this.unloadSlot(this.mcChar.cape,"cape");
            try
            {
               for each(_loc1_ in this.mcChar)
               {
                  if(_loc1_ is MovieClip && _loc1_ != this.mcChar)
                  {
                     this.unloadMovieClip(MovieClip(_loc1_));
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function unloadSlot(param1:*, param2:String) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:DisplayObject = null;
         if(param1 != null)
         {
            try
            {
               if(param1 is DisplayObjectContainer)
               {
                  _loc3_ = param1 as DisplayObjectContainer;
                  while(_loc3_.numChildren > 0)
                  {
                     _loc4_ = _loc3_.removeChildAt(_loc3_.numChildren - 1);
                     if(_loc4_ is MovieClip)
                     {
                        this.unloadMovieClip(MovieClip(_loc4_));
                     }
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function unloadMovieClip(param1:MovieClip) : void
      {
         var _loc2_:DisplayObject = null;
         if(param1 == null)
         {
            return;
         }
         try
         {
            param1.stop();
            while(param1.numChildren > 0)
            {
               _loc2_ = param1.removeChildAt(param1.numChildren - 1);
               if(_loc2_ is MovieClip)
               {
                  MovieClip(_loc2_).stop();
               }
            }
            if(this.world != null)
            {
               this.world.recursiveStop(param1);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      override public function gotoAndPlay(param1:Object, param2:String = null) : void
      {
         this.handleAnimEvent(String(param1));
         super.gotoAndPlay(param1);
      }
      
      public function disablePNameMouse() : void
      {
         mouseEnabled = false;
         this.pname.mouseEnabled = false;
         this.pname.mouseChildren = false;
         this.pname.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
      }
      
      public function hasLabel(param1:String) : Boolean
      {
         var _loc2_:Array = this.mcChar.currentLabels;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].name == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function recursiveStop(param1:MovieClip) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc2_:Array = [param1];
         while(_loc2_.length > 0)
         {
            _loc3_ = _loc2_.pop();
            _loc4_ = 0;
            while(_loc4_ < _loc3_.numChildren)
            {
               _loc5_ = _loc3_.getChildAt(_loc4_);
               if(_loc5_ is MovieClip)
               {
                  MovieClip(_loc5_).stop();
                  _loc2_.push(MovieClip(_loc5_));
               }
               _loc4_++;
            }
         }
      }
      
      public function showHPBar() : void
      {
         this.hpBar.y = this.pname.y - 3;
         this.hpBar.visible = true;
         this.updateHPBar();
      }
      
      public function hideHPBar() : void
      {
         this.hpBar.visible = false;
      }
      
      public function updateHPBar() : void
      {
         var _loc3_:Object = null;
         var _loc1_:MovieClip = this.hpBar.g as MovieClip;
         var _loc2_:MovieClip = this.hpBar.r as MovieClip;
         if(this.hpBar.visible)
         {
            _loc3_ = this.pAV.dataLeaf;
            if(_loc3_ != null && _loc3_.intHP != null)
            {
               _loc1_.visible = true;
               _loc1_.width = Math.round(_loc3_.intHP / _loc3_.intHPMax * _loc2_.width);
               if(_loc3_.intHP < 1)
               {
                  _loc1_.visible = false;
               }
            }
         }
      }
      
      public function updateName() : void
      {
         var _csRoot:* = undefined;
         var uoLeaf:* = this.world.uoTree[this.pAV.pnm];
         if(uoLeaf == null)
         {
            uoLeaf = this.world.uoTree[this.pAV.pnm.toLowerCase()];
         }
         try
         {
            if(uoLeaf.afk)
            {
               this.pname.ti.text = "<AFK> " + this.pAV.objData.strUsername;
            }
            else
            {
               this.pname.ti.text = this.pAV.objData.strUsername;
            }
            if(this.pAV.objData.guild != null)
            {
               this.pname.tg.text = "< " + String(this.pAV.objData.guild.Name) + " >";
            }
            _csRoot = MovieClip(stage.getChildAt(0));
            if(_csRoot.litePreference.data.bComicSans)
            {
               _csRoot.applyComicSansPname(this.pname,true);
            }
            _csRoot.fixInputHeight(this.pname.ti);
            _csRoot.fixInputHeight(this.pname.tg);
         }
         catch(e:Error)
         {
            trace("[Avatar] ERR updateName: " + e.message);
         }
      }
      
      private function hideOptionalParts() : void
      {
         var _loc1_:* = ["cape","backhair","robe","backrobe","pvpFlag"];
         var _loc2_:* = ["weapon","weaponOff","weaponFist","weaponFistOff","shield"];
         var _loc3_:String = "";
         for(_loc3_ in _loc1_)
         {
            if(typeof this.mcChar[_loc1_[_loc3_]] != undefined)
            {
               this.mcChar[_loc1_[_loc3_]].visible = false;
            }
         }
         for(_loc3_ in _loc2_)
         {
            if(typeof this.mcChar[_loc2_[_loc3_]] != undefined)
            {
               this.mcChar[_loc2_[_loc3_]].visible = false;
            }
         }
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         this.world = MovieClip(stage.getChildAt(0)).world as MovieClip;
         var _loc2_:Avatar = param1.currentTarget.parent.pAV;
         if(_loc2_ == null || _loc2_.isCharPage || _loc2_.isCameraTool || this.world == null)
         {
            return;
         }
         if(param1.shiftKey)
         {
            this.world.onWalkClick();
         }
         else if(param1.altKey)
         {
            _loc3_ = stage.getObjectsUnderPoint(new Point(param1.stageX,param1.stageY));
            for(_loc4_ in _loc3_)
            {
               if(Boolean(_loc3_[_loc4_].parent) && _loc3_[_loc4_].parent.name == "mcChar")
               {
                  this.world.setTarget(_loc3_[_loc4_].parent.parent.pAV);
                  break;
               }
            }
         }
         else if(!param1.ctrlKey)
         {
            if(_loc2_ != this.world.myAvatar && this.world.bPvP && _loc2_.dataLeaf.pvpTeam != this.world.myAvatar.dataLeaf.pvpTeam && _loc2_ == this.world.myAvatar.target)
            {
               this.world.approachTarget();
            }
            else if(_loc2_ != this.world.myAvatar.target)
            {
               this.world.setTarget(_loc2_);
            }
         }
      }
      
      public function loadClass(param1:String, param2:String) : void
      {
         if(this.pAV.objData.eqp.co == null)
         {
            this.classLoad = false;
            trace("[Avatar] loadClass: " + param1);
            this.world.queueLoad({
               "strFile":this.world.rootClass.getFilePath() + "classes/" + this.strGender + "/" + param1,
               "callBackA":this.onLoadClassComplete,
               "callBackB":this.classErrorHandler,
               "avt":this.pAV,
               "sES":"ar"
            });
         }
      }
      
      public function onLoadClassComplete(param1:Event = null) : void
      {
         trace("[Avatar] onLoadClassComplete: " + this.pAV.objData.eqp.ar.sLink);
         this.classLoad = true;
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("ar");
         }
         if(this.pAV.objData.eqp.co == null)
         {
            this.loadArmorPieces(this.pAV.objData.eqp.ar.sLink);
         }
      }
      
      public function loadMisc(param1:String, param2:String) : void
      {
         this.miscLoad = false;
         this.objLinks.mi = param2;
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + param1,
            "callBackA":this.onLoadMiscComplete,
            "callBackB":this.miscErrorHandler,
            "avt":this.pAV,
            "sES":"ac"
         });
      }
      
      public function onLoadMiscComplete(param1:Event) : void
      {
         this.miscLoad = true;
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("mi");
         }
         var _loc2_:Class = this.world.getClass(this.objLinks.mi) as Class;
         if(_loc2_ != null)
         {
            this.cShadow.visible = true;
            this.cShadow.removeChildAt(0);
            this.cShadow.addChild(new _loc2_());
            this.cShadow.scaleX = this.mcChar.scaleX;
            this.cShadow.scaleY = this.mcChar.scaleY;
            this.cShadow.mouseEnabled = this.cShadow.mouseChildren = false;
            this.shadow.alpha = 0;
         }
         else
         {
            this.cShadow.visible = false;
            this.shadow.alpha = 1;
         }
         if(this.world.rootClass.litePreference.data.bDisGround)
         {
            if(this.pAV.isMyAvatar && Boolean(this.world.rootClass.litePreference.data.dOptions["groundSelf"]))
            {
               return;
            }
            this.cShadow.visible = false;
            this.shadow.alpha = 1;
         }
      }
      
      public function loadArmor(param1:String, param2:String) : void
      {
         this.objLinks.co = param2;
         this.armorLoad = false;
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + "classes/" + this.strGender + "/" + param1,
            "callBackA":this.onLoadArmorComplete,
            "callBackB":this.armorErrorHandler,
            "avt":this.pAV,
            "sES":"ar"
         });
      }
      
      public function onLoadArmorComplete(param1:Event) : void
      {
         this.armorLoad = true;
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("co");
         }
         this.clearAnimEvents();
         this.loadArmorPieces(this.objLinks.co);
         if(this.name.indexOf("previewMCB") > -1)
         {
            MovieClip(parent.parent).repositionPreview(MovieClip(this.mcChar));
         }
      }
      
      public function ioErrorHandler(param1:*) : void
      {
         trace("[Avatar] ERR ioErrorHandler: " + param1);
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markAnyEquipmentLoaded();
         }
      }
      
      private function markSlotFailed(param1:String) : void
      {
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded(param1);
         }
      }
      
      public function classErrorHandler(param1:*) : void
      {
         this.classLoad = true;
         this.markSlotFailed("ar");
      }
      
      public function miscErrorHandler(param1:*) : void
      {
         this.miscLoad = true;
         this.markSlotFailed("mi");
      }
      
      public function armorErrorHandler(param1:*) : void
      {
         this.armorLoad = true;
         this.markSlotFailed("co");
      }
      
      public function hairErrorHandler(param1:*) : void
      {
         this.hairLoad = true;
         this.markSlotFailed("Hair");
      }
      
      public function weaponErrorHandler(param1:*) : void
      {
         this.weaponLoad = true;
         this.markSlotFailed("Weapon");
      }
      
      public function weaponOffErrorHandler(param1:*) : void
      {
         this.weaponLoad = true;
         this.markSlotFailed("WeaponOff");
         this.markSlotFailed("Weapon");
      }
      
      public function capeErrorHandler(param1:*) : void
      {
         this.capeLoad = true;
         this.markSlotFailed("ba");
      }
      
      public function helmErrorHandler(param1:*) : void
      {
         this.helmLoad = true;
         this.bLoadingHelm = false;
         this.markSlotFailed("he");
      }
      
      public function loadArmorPieces(param1:String) : void
      {
         var _loc2_:Class = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Color = null;
         trace("[Avatar] loadArmorPieces: " + param1);
         try
         {
            _loc2_ = this.world.getClass(param1 + this.strGender + "Head") as Class;
            if(_loc2_ == null)
            {
               _loc2_ = this.world.getClass("mcHead" + this.strGender) as Class;
            }
            if(_loc2_ != null)
            {
               _loc3_ = this.mcChar.head.getChildByName("face");
               if(_loc3_ != null)
               {
                  this.mcChar.head.removeChild(_loc3_);
               }
               this.testMC = this.mcChar.head.addChildAt(new _loc2_(),0);
               this.testMC.name = "face";
            }
         }
         catch(err:Error)
         {
         }
         if(this.pAV == this.world.myAvatar)
         {
            this.world.rootClass.showPortrait(this.pAV);
         }
         else if(this.pAV == this.world.myAvatar.target)
         {
            this.world.rootClass.showPortraitTarget(this.pAV);
         }
         try
         {
            _loc2_ = this.world.getClass(param1 + this.strGender + "Chest") as Class;
            if(_loc2_ != null)
            {
               this.mcChar.chest.removeChildAt(0);
               this.mcChar.chest.addChild(new _loc2_());
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc2_ = this.world.getClass(param1 + this.strGender + "Hip") as Class;
            if(_loc2_ != null)
            {
               this.mcChar.hip.removeChildAt(0);
               this.mcChar.hip.addChild(new _loc2_());
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc2_ = this.world.getClass(param1 + this.strGender + "FootIdle") as Class;
            if(_loc2_ != null)
            {
               this.mcChar.idlefoot.removeChildAt(0);
               this.mcChar.idlefoot.addChild(new _loc2_());
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc2_ = this.world.getClass(param1 + this.strGender + "Foot") as Class;
            if(_loc2_ != null)
            {
               this.mcChar.frontfoot.removeChildAt(0);
               this.mcChar.frontfoot.addChild(new _loc2_());
               this.mcChar.frontfoot.visible = false;
               this.mcChar.backfoot.removeChildAt(0);
               this.mcChar.backfoot.addChild(new _loc2_());
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc2_ = this.world.getClass(param1 + this.strGender + "Shoulder") as Class;
            if(_loc2_ != null)
            {
               this.mcChar.frontshoulder.removeChildAt(0);
               this.mcChar.frontshoulder.addChild(new _loc2_());
               this.mcChar.backshoulder.removeChildAt(0);
               this.mcChar.backshoulder.addChild(new _loc2_());
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc2_ = this.world.getClass(param1 + this.strGender + "Hand") as Class;
            if(_loc2_ != null)
            {
               this.mcChar.fronthand.removeChildAt(0);
               this.mcChar.fronthand.addChildAt(new _loc2_(),0);
               this.mcChar.backhand.removeChildAt(0);
               this.mcChar.backhand.addChildAt(new _loc2_(),0);
               _loc4_ = new Color();
               _loc4_.brightness = -1;
               this.mcChar.backhand.getChildAt(0).transform.colorTransform = _loc4_;
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc2_ = this.world.getClass(param1 + this.strGender + "Thigh") as Class;
            if(_loc2_ != null)
            {
               this.mcChar.frontthigh.removeChildAt(0);
               this.mcChar.frontthigh.addChild(new _loc2_());
               this.mcChar.backthigh.removeChildAt(0);
               this.mcChar.backthigh.addChild(new _loc2_());
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc2_ = this.world.getClass(param1 + this.strGender + "Shin") as Class;
            if(_loc2_ != null)
            {
               this.mcChar.frontshin.removeChildAt(0);
               this.mcChar.frontshin.addChild(new _loc2_());
               this.mcChar.backshin.removeChildAt(0);
               this.mcChar.backshin.addChild(new _loc2_());
            }
         }
         catch(e:Error)
         {
         }
         _loc2_ = this.world.getClass(param1 + this.strGender + "Robe") as Class;
         if(_loc2_ != null)
         {
            this.mcChar.robe.removeChildAt(0);
            this.mcChar.robe.addChild(new _loc2_());
            this.mcChar.robe.visible = true;
         }
         else
         {
            this.mcChar.robe.visible = false;
         }
         _loc2_ = this.world.getClass(param1 + this.strGender + "RobeBack") as Class;
         if(_loc2_ != null)
         {
            this.mcChar.backrobe.removeChildAt(0);
            this.mcChar.backrobe.addChild(new _loc2_());
            this.mcChar.backrobe.visible = true;
         }
         else
         {
            this.mcChar.backrobe.visible = false;
         }
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.gotoAndPlay("hold");
         }
         else if(!this.isLoaded)
         {
            this.isLoaded = true;
            if(this.pAV.isCharPage || this.pAV.dataLeaf != null && this.pAV.dataLeaf.strFrame == this.world.strFrame)
            {
               this.gotoAndPlay("in1");
               this.handleAfterAvatarLoad();
            }
         }
      }
      
      public function handleAfterAvatarLoad() : void
      {
         if(this.pAV.isCameraTool || this.pAV.isCharPage)
         {
            return;
         }
         if(Boolean(this.world.rootClass.litePreference.data.bCachePlayers) && !this.isRasterized)
         {
            if(!this.pAV.isMyAvatar)
            {
               this.mcChar.gotoAndStop("Idle");
               this.world.rootClass.rasterize(this.mcChar);
               this.isRasterized = true;
            }
         }
         if(this.world.rootClass.litePreference.data.bHideNames)
         {
            this.hideNameSetup();
         }
         if(Boolean(this.world.rootClass.litePreference.data.bHidePlayers) && !this.pAV.isMyAvatar)
         {
            this.mcChar.visible = false;
            this.pname.visible = this.world.rootClass.litePreference.data.dOptions["showNames"];
            this.shadow.visible = this.world.rootClass.litePreference.data.dOptions["showShadows"];
         }
      }
      
      public function hideNameSetup() : void
      {
         if(this.world.rootClass.litePreference.data.dOptions["hideSelf"])
         {
            if(this.pAV.isMyAvatar)
            {
               this.pname.visible = false;
            }
            else
            {
               this.hideNameCleanup();
            }
            return;
         }
         this.pname.ti.visible = this.world.rootClass.litePreference.data.dOptions["hideGuild"];
         this.pname.tg.visible = false;
         if(!this.mcChar.hasEventListener(MouseEvent.ROLL_OVER))
         {
            this.mcChar.addEventListener(MouseEvent.ROLL_OVER,this.onNameHover,false,0,true);
            this.mcChar.addEventListener(MouseEvent.ROLL_OUT,this.onNameOut,false,0,true);
         }
      }
      
      public function hideNameCleanup() : void
      {
         if(this.mcChar != null && this.mcChar.hasEventListener(MouseEvent.ROLL_OVER))
         {
            this.mcChar.removeEventListener(MouseEvent.ROLL_OVER,this.onNameHover);
            this.mcChar.removeEventListener(MouseEvent.ROLL_OUT,this.onNameOut);
         }
         if(this.pname != null)
         {
            this.pname.visible = true;
            this.pname.ti.visible = true;
            this.pname.tg.visible = this.pname.tg.text;
         }
      }
      
      public function onNameHover(param1:MouseEvent) : void
      {
         if(this.world.rootClass.litePreference.data.dOptions["hideGuild"])
         {
            this.pname.tg.visible = true;
         }
         else
         {
            this.pname.ti.visible = true;
            this.pname.tg.visible = true;
         }
      }
      
      public function onNameOut(param1:MouseEvent) : void
      {
         if(this.world.rootClass.litePreference.data.dOptions["hideGuild"])
         {
            this.pname.tg.visible = false;
         }
         else
         {
            this.pname.ti.visible = false;
            this.pname.tg.visible = false;
         }
      }
      
      public function loadArmorPiecesFromDomain(param1:String, param2:ApplicationDomain) : void
      {
         var AssetClass:Class = null;
         var child:DisplayObject = null;
         var drk:Color = null;
         var strSkinLinkage:String = param1;
         var pLoaderD:ApplicationDomain = param2;
         trace("[Avatar] loadArmorPiecesFromDomain: " + strSkinLinkage);
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Head") as Class;
            child = this.mcChar.head.getChildByName("face");
            if(child != null)
            {
               this.mcChar.head.removeChild(child);
            }
            this.testMC = this.mcChar.head.addChildAt(new AssetClass(),0);
            this.testMC.name = "face";
         }
         catch(err:Error)
         {
            try
            {
               AssetClass = pLoaderD.getDefinition("mcHead" + strGender) as Class;
               child = mcChar.head.getChildByName("face");
               if(child != null)
               {
                  mcChar.head.removeChild(child);
               }
               testMC = mcChar.head.addChildAt(new AssetClass(),0);
               testMC.name = "face";
            }
            catch(e2:Error)
            {
            }
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Chest") as Class;
            this.mcChar.chest.removeChildAt(0);
            this.mcChar.chest.addChild(new AssetClass());
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Hip") as Class;
            this.mcChar.hip.removeChildAt(0);
            this.mcChar.hip.addChild(new AssetClass());
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "FootIdle") as Class;
            this.mcChar.idlefoot.removeChildAt(0);
            this.mcChar.idlefoot.addChild(new AssetClass());
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Foot") as Class;
            this.mcChar.frontfoot.removeChildAt(0);
            this.mcChar.frontfoot.addChild(new AssetClass());
            this.mcChar.frontfoot.visible = false;
            this.mcChar.backfoot.removeChildAt(0);
            this.mcChar.backfoot.addChild(new AssetClass());
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Shoulder") as Class;
            this.mcChar.frontshoulder.removeChildAt(0);
            this.mcChar.frontshoulder.addChild(new AssetClass());
            this.mcChar.backshoulder.removeChildAt(0);
            this.mcChar.backshoulder.addChild(new AssetClass());
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Hand") as Class;
            this.mcChar.fronthand.removeChildAt(0);
            this.mcChar.fronthand.addChildAt(new AssetClass(),0);
            this.mcChar.backhand.removeChildAt(0);
            this.mcChar.backhand.addChildAt(new AssetClass(),0);
            drk = new Color();
            drk.brightness = -1;
            this.mcChar.backhand.getChildAt(0).transform.colorTransform = drk;
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Thigh") as Class;
            this.mcChar.frontthigh.removeChildAt(0);
            this.mcChar.frontthigh.addChild(new AssetClass());
            this.mcChar.backthigh.removeChildAt(0);
            this.mcChar.backthigh.addChild(new AssetClass());
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Shin") as Class;
            this.mcChar.frontshin.removeChildAt(0);
            this.mcChar.frontshin.addChild(new AssetClass());
            this.mcChar.backshin.removeChildAt(0);
            this.mcChar.backshin.addChild(new AssetClass());
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Robe") as Class;
            if(AssetClass != null)
            {
               this.mcChar.robe.removeChildAt(0);
               this.mcChar.robe.addChild(new AssetClass());
               this.mcChar.robe.visible = true;
            }
            else
            {
               this.mcChar.robe.visible = false;
            }
         }
         catch(e:Error)
         {
            mcChar.robe.visible = false;
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "RobeBack") as Class;
            if(AssetClass != null)
            {
               this.mcChar.backrobe.removeChildAt(0);
               this.mcChar.backrobe.addChild(new AssetClass());
               this.mcChar.backrobe.visible = true;
            }
            else
            {
               this.mcChar.backrobe.visible = false;
            }
         }
         catch(e:Error)
         {
            mcChar.backrobe.visible = false;
         }
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.gotoAndPlay("hold");
         }
         else if(!this.isLoaded)
         {
            this.isLoaded = true;
            if(this.pAV.isCharPage || this.pAV.dataLeaf != null && this.pAV.dataLeaf.strFrame == this.world.strFrame)
            {
               this.gotoAndPlay("in1");
               this.handleAfterAvatarLoad();
            }
         }
      }
      
      public function loadHair() : void
      {
         var _loc1_:* = this.pAV.objData.strHairFilename;
         if(_loc1_ == undefined || _loc1_ == null || _loc1_ == "" || _loc1_ == "none")
         {
            this.mcChar.head.hair.visible = false;
            if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
            {
               this.pAV.markEquipmentLoaded("Hair");
            }
            return;
         }
         this.hairLoad = false;
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + _loc1_,
            "callBackA":this.onHairLoadComplete,
            "callBackB":this.hairErrorHandler,
            "avt":this.pAV,
            "sES":"hair"
         });
      }
      
      public function onHairLoadComplete(param1:Event) : void
      {
         var AssetClass:Class = null;
         var e:Event = param1;
         this.hairLoad = true;
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("Hair");
         }
         try
         {
            AssetClass = this.world.getClass(this.pAV.objData.strHairName + this.pAV.objData.strGender + "Hair") as Class;
            if(AssetClass != null)
            {
               if(this.mcChar.head.hair.numChildren > 0)
               {
                  this.mcChar.head.hair.removeChildAt(0);
               }
               this.mcChar.head.hair.addChild(new AssetClass());
               this.mcChar.head.hair.visible = true;
            }
            else
            {
               this.mcChar.head.hair.visible = false;
            }
            AssetClass = this.world.getClass(this.pAV.objData.strHairName + this.pAV.objData.strGender + "HairBack") as Class;
            if(AssetClass != null)
            {
               if(!this.helmBackHair || this.helmBackHair && !this.pAV.dataLeaf.showHelm)
               {
                  if(this.mcChar.backhair.numChildren > 0)
                  {
                     this.mcChar.backhair.removeChildAt(0);
                  }
                  this.mcChar.backhair.addChild(new AssetClass());
                  this.mcChar.backhair.visible = true;
               }
               this.bBackHair = true;
            }
            else
            {
               this.mcChar.backhair.visible = false;
               this.bBackHair = false;
            }
            if(this.pAV.isMyAvatar && !MovieClip(parent.parent.parent).ui.mcPortrait.visible && !this.bLoadingHelm)
            {
               this.world.rootClass.showPortrait(this.pAV);
            }
            else if(this.pAV == this.world.myAvatar.target)
            {
               this.world.rootClass.showPortraitTarget(this.pAV);
            }
            if("he" in this.pAV.objData.eqp && this.pAV.objData.eqp.he != null)
            {
               if(this.pAV.dataLeaf.showHelm)
               {
                  this.mcChar.head.hair.visible = false;
                  this.mcChar.backhair.visible = this.helmBackHair;
               }
               else
               {
                  this.mcChar.head.hair.visible = true;
                  this.mcChar.backhair.visible = this.bBackHair;
               }
            }
         }
         catch(e:Error)
         {
            trace("[Avatar] ERR onHairLoadComplete: " + pAV.objData.strUsername + " " + e.message);
         }
      }
      
      private function requeueRawWeapon(param1:String, param2:Function, param3:Function) : Boolean
      {
         if(this.rawWepRetries >= 2 || param1 == null)
         {
            return false;
         }
         ++this.rawWepRetries;
         this.weaponLoad = false;
         var _loc4_:String = this.world.rootClass.getFilePath() + param1;
         _loc4_ += (_loc4_.indexOf("?") < 0 ? "?r=" : "&r=") + uint(Math.random() * 16777215);
         this.world.queueLoad({
            "strFile":_loc4_,
            "callBackA":param2,
            "callBackB":param3,
            "avt":this.pAV,
            "sES":"weapon"
         });
         return true;
      }
      
      private function recursivePlay(param1:MovieClip) : void
      {
         var _loc3_:MovieClip = null;
         param1.play();
         var _loc2_:int = 0;
         while(_loc2_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc2_) as MovieClip;
            if(_loc3_ != null)
            {
               this.recursivePlay(_loc3_);
            }
            _loc2_++;
         }
      }
      
      public function loadWeapon(param1:*, param2:*) : void
      {
         this.weaponLoad = false;
         this.rawWepRetries = 0;
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + param1,
            "callBackA":this.onLoadWeaponComplete,
            "callBackB":this.weaponErrorHandler,
            "avt":this.pAV,
            "sES":"weapon"
         });
      }
      
      public function onLoadWeaponComplete(param1:Event) : void
      {
         var isDualWield:Boolean;
         var wItem:Object = null;
         var AssetClass:Class = null;
         var raw:MovieClip = null;
         var wEqp:Object = null;
         var e:Event = param1;
         this.weaponLoad = true;
         wItem = this.pAV.getItemByEquipSlot("Weapon");
         if(this.mcChar.weaponFist.numChildren > 0)
         {
            this.mcChar.weaponFist.removeChildAt(0);
         }
         if(this.mcChar.weaponFistOff.numChildren > 0)
         {
            this.mcChar.weaponFistOff.removeChildAt(0);
         }
         if(this.mcChar.weapon.numChildren > 0)
         {
            this.mcChar.weapon.removeChildAt(0);
         }
         if(this.mcChar.fronthand.numChildren > 1)
         {
            this.mcChar.fronthand.removeChildAt(1);
         }
         if(this.mcChar.backhand.numChildren > 1)
         {
            this.mcChar.backhand.removeChildAt(1);
         }
         try
         {
            AssetClass = this.world.getClass(this.pAV.objData.eqp.Weapon.sLink) as Class;
            if(wItem != null && wItem.sType == "Gauntlet")
            {
               this.mcChar.fronthand.addChildAt(new AssetClass(),1);
               this.mcChar.fronthand.getChildAt(1).scaleX = 0.8;
               this.mcChar.fronthand.getChildAt(1).scaleY = 0.8;
               this.mcChar.fronthand.getChildAt(1).scaleX = this.mcChar.fronthand.getChildAt(1).scaleX * -1;
               this.mcChar.backhand.addChildAt(new AssetClass(),1);
               this.mcChar.backhand.getChildAt(1).scaleX = 0.8;
               this.mcChar.backhand.getChildAt(1).scaleY = 0.8;
               this.mcChar.backhand.getChildAt(1).scaleX = this.mcChar.backhand.getChildAt(1).scaleX * -1;
               this.mcChar.weapon.mcWeapon = new MovieClip();
            }
            else
            {
               this.mcChar.weapon.mcWeapon = new AssetClass();
               this.mcChar.weapon.addChild(this.mcChar.weapon.mcWeapon);
            }
         }
         catch(err:Error)
         {
            trace("[Avatar] ERR onLoadWeaponComplete: linkage miss, added raw content");
            if(wItem == null || wItem.sType != "Gauntlet")
            {
               raw = null;
               try
               {
                  raw = MovieClip(e.target.content);
               }
               catch(errRaw:Error)
               {
               }
               if(raw != null && raw.parent != null)
               {
                  wEqp = null;
                  try
                  {
                     wEqp = pAV.objData.eqp.Weapon;
                  }
                  catch(eEqp:Error)
                  {
                  }
                  if(wEqp != null && requeueRawWeapon(wEqp.sFile,onLoadWeaponComplete,weaponErrorHandler))
                  {
                     return;
                  }
               }
               if(raw != null)
               {
                  recursivePlay(raw);
                  mcChar.weapon.mcWeapon = raw;
                  mcChar.weapon.addChild(raw);
               }
            }
         }
         this.mcChar.weapon.visible = false;
         this.mcChar.weaponOff.visible = false;
         this.mcChar.weaponFist.visible = false;
         this.mcChar.weaponFistOff.visible = false;
         if(wItem == null || wItem.sType != "Gauntlet")
         {
            this.mcChar.weapon.visible = true;
         }
         isDualWield = wItem != null && wItem.sType == "Dagger";
         if(isDualWield)
         {
            if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
            {
               this.pAV.registerPendingEquipment("WeaponOff");
            }
            this.loadWeaponOff(this.pAV.objData.eqp.Weapon.sFile,this.pAV.objData.eqp.Weapon.sLink);
         }
         if(!isDualWield && this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("Weapon");
         }
         if(this.world.rootClass.litePreference.data.bDisWepAnim && wItem != null && wItem.ItemID != 4711 && wItem.ItemID != 31273)
         {
            if(!this.pAV.isMyAvatar && this.world.rootClass.litePreference.data.dOptions["wepSelf"] || !this.world.rootClass.litePreference.data.dOptions["wepSelf"])
            {
               this.world.rootClass.movieClipStopAll(this.mcChar.weapon);
            }
         }
      }
      
      public function loadWeaponOff(param1:*, param2:*) : void
      {
         this.weaponLoad = false;
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + param1,
            "callBackA":this.onLoadWeaponOffComplete,
            "callBackB":this.weaponOffErrorHandler,
            "avt":this.pAV,
            "sES":"weapon"
         });
      }
      
      public function onLoadWeaponOffComplete(param1:Event) : void
      {
         var wItem:Object;
         var AssetClass:Class = null;
         var rawOff:MovieClip = null;
         var wEqpOff:Object = null;
         var e:Event = param1;
         this.weaponLoad = true;
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("WeaponOff");
            this.pAV.markEquipmentLoaded("Weapon");
         }
         wItem = this.pAV.getItemByEquipSlot("Weapon");
         if(this.mcChar.weaponOff.numChildren > 0)
         {
            this.mcChar.weaponOff.removeChildAt(0);
         }
         try
         {
            AssetClass = this.world.getClass(this.pAV.objData.eqp.Weapon.sLink) as Class;
            this.mcChar.weaponOff.addChild(new AssetClass());
         }
         catch(err:Error)
         {
            trace("[Avatar] ERR onLoadWeaponOffComplete: linkage miss, added raw content");
            rawOff = null;
            try
            {
               rawOff = MovieClip(e.target.content);
            }
            catch(errRaw:Error)
            {
            }
            if(rawOff != null && rawOff.parent != null)
            {
               wEqpOff = null;
               try
               {
                  wEqpOff = pAV.objData.eqp.Weapon;
               }
               catch(eEqp2:Error)
               {
               }
               if(wEqpOff != null && requeueRawWeapon(wEqpOff.sFile,onLoadWeaponOffComplete,weaponOffErrorHandler))
               {
                  return;
               }
            }
            if(rawOff != null)
            {
               recursivePlay(rawOff);
               mcChar.weaponOff.addChild(rawOff);
            }
         }
         this.mcChar.weaponOff.visible = true;
         if(this.world.rootClass.litePreference.data.bDisWepAnim)
         {
            if(!this.pAV.isMyAvatar && this.world.rootClass.litePreference.data.dOptions["wepSelf"] || !this.world.rootClass.litePreference.data.dOptions["wepSelf"])
            {
               this.world.rootClass.movieClipStopAll(this.mcChar.weaponOff);
            }
         }
      }
      
      public function loadCape(param1:*, param2:*) : void
      {
         this.capeLoad = false;
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + param1,
            "callBackA":this.onLoadCapeComplete,
            "callBackB":this.capeErrorHandler,
            "avt":this.pAV,
            "sES":"cape"
         });
      }
      
      public function onLoadCapeComplete(param1:Event) : void
      {
         var AssetClass:Class = null;
         var e:Event = param1;
         this.capeLoad = true;
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("ba");
         }
         try
         {
            AssetClass = this.world.getClass(this.pAV.objData.eqp.ba.sLink) as Class;
            this.mcChar.cape.removeChildAt(0);
            this.mcChar.cape.cape = new AssetClass();
            this.mcChar.cape.addChild(this.mcChar.cape.cape);
            this.setCloakVisibility(this.pAV.dataLeaf.showCloak);
         }
         catch(e:*)
         {
            trace("[Avatar] ERR onLoadCapeComplete: " + e.message);
         }
      }
      
      public function loadHelm(param1:*, param2:*) : void
      {
         this.helmLoad = false;
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + param1,
            "callBackA":this.onLoadHelmComplete,
            "callBackB":this.helmErrorHandler,
            "avt":this.pAV,
            "sES":"helm"
         });
         this.bLoadingHelm = true;
      }
      
      public function onLoadHelmComplete(param1:Event) : void
      {
         this.helmLoad = true;
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("he");
         }
         var _loc2_:Class = this.world.getClass(this.pAV.objData.eqp.he.sLink) as Class;
         var _loc3_:Class = this.world.getClass(this.pAV.objData.eqp.he.sLink + "_backhair") as Class;
         if(_loc2_ != null)
         {
            if(this.mcChar.head.helm.numChildren > 0)
            {
               this.mcChar.head.helm.removeChildAt(0);
            }
            this.mcChar.head.helm.visible = this.pAV.dataLeaf.showHelm;
            this.mcChar.head.hair.visible = !this.mcChar.head.helm.visible;
            this.mcChar.backhair.visible = Boolean(this.mcChar.head.hair.visible) && this.bBackHair;
            if(_loc3_ != null)
            {
               if(this.pAV.dataLeaf.showHelm)
               {
                  if(this.mcChar.backhair.numChildren > 0)
                  {
                     this.mcChar.backhair.removeChildAt(0);
                  }
                  this.mcChar.backhair.visible = true;
                  this.mcChar.backhair.addChild(new _loc3_());
               }
               this.helmBackHair = true;
            }
            else
            {
               this.helmBackHair = false;
            }
            this.mcChar.head.helm.addChild(new _loc2_());
            if(this.pAV == this.world.myAvatar)
            {
               this.world.rootClass.showPortrait(this.pAV);
            }
            if(this.pAV == this.world.myAvatar.target)
            {
               this.world.rootClass.showPortraitTarget(this.pAV);
            }
         }
         this.bLoadingHelm = false;
      }
      
      public function setHelmVisibility(param1:Boolean) : void
      {
         if(this.pAV.objData.eqp.he != null && this.pAV.objData.eqp.he.sLink != null)
         {
            if(param1)
            {
               if(this.helmBackHair && this.bBackHair)
               {
                  this.pAV.loadMovieAtES("he",this.pAV.objData.eqp["he"].sFile,this.pAV.objData.eqp["he"].sLink);
                  return;
               }
               this.mcChar.head.helm.visible = true;
               this.mcChar.head.hair.visible = false;
               this.mcChar.backhair.visible = this.helmBackHair;
            }
            else
            {
               if(this.helmBackHair && this.bBackHair)
               {
                  this.loadHair();
                  return;
               }
               this.mcChar.head.helm.visible = false;
               this.mcChar.head.hair.visible = true;
               this.mcChar.backhair.visible = this.bBackHair;
            }
            if(this.pAV == this.world.myAvatar)
            {
               this.world.rootClass.showPortrait(this.pAV);
            }
            if(this.pAV == this.world.myAvatar.target)
            {
               this.world.rootClass.showPortraitTarget(this.pAV);
            }
         }
      }
      
      public function setCloakVisibility(param1:Boolean) : void
      {
         if(this.pAV.objData.eqp.ba != null && this.pAV.objData.eqp.ba.sLink != null)
         {
            if(this.pAV.isMyAvatar)
            {
               this.mcChar.cape.visible = param1;
            }
            else if(this.pAV.isCharPage)
            {
               this.mcChar.cape.visible = param1;
            }
            else
            {
               this.mcChar.cape.visible = param1 && !this.world.hideAllCapes;
            }
         }
      }
      
      public function setColor(param1:MovieClip, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:Number = Number(this.pAV.objData["intColor" + param3]);
         if(param1.isColored === true && param1.intColor === _loc5_ && param1.strShade === param4 && param1.strLocation === param3)
         {
            return;
         }
         param1.isColored = true;
         param1.intColor = _loc5_;
         param1.strLocation = param3;
         param1.strShade = param4;
         this.changeColor(param1,_loc5_,param4);
      }
      
      public function changeColor(param1:MovieClip, param2:Number, param3:String, param4:String = "") : void
      {
         var _loc5_:ColorTransform = new ColorTransform();
         if(param4 == "")
         {
            _loc5_.color = param2;
         }
         switch(param3.toUpperCase())
         {
            case "LIGHT":
               _loc5_.redOffset += 100;
               _loc5_.greenOffset += 100;
               _loc5_.blueOffset += 100;
               break;
            case "DARK":
               _loc5_.redOffset -= param1.strLocation == "Skin" ? 25 : 50;
               _loc5_.greenOffset -= 50;
               _loc5_.blueOffset -= 50;
               break;
            case "DARKER":
               _loc5_.redOffset -= 125;
               _loc5_.greenOffset -= 125;
               _loc5_.blueOffset -= 125;
         }
         if(param4 == "-")
         {
            _loc5_.redOffset *= -1;
            _loc5_.greenOffset *= -1;
            _loc5_.blueOffset *= -1;
         }
         var _loc6_:ColorTransform = param1.transform.colorTransform;
         if(param4 == "" || _loc6_.redOffset != _loc5_.redOffset || _loc6_.greenOffset != _loc5_.greenOffset || _loc6_.blueOffset != _loc5_.blueOffset || _loc6_.color != _loc5_.color)
         {
            param1.transform.colorTransform = _loc5_;
         }
      }
      
      public function modulateColor(param1:ColorTransform, param2:String) : void
      {
         if(this.stage == null)
         {
            return;
         }
         var _loc3_:MovieClip = this.stage.getChildAt(0) as MovieClip;
         if(param2 == "+")
         {
            this.totalTransform.alphaMultiplier += param1.alphaMultiplier;
            this.totalTransform.alphaOffset += param1.alphaOffset;
            this.totalTransform.redMultiplier += param1.redMultiplier;
            this.totalTransform.redOffset += param1.redOffset;
            this.totalTransform.greenMultiplier += param1.greenMultiplier;
            this.totalTransform.greenOffset += param1.greenOffset;
            this.totalTransform.blueMultiplier += param1.blueMultiplier;
            this.totalTransform.blueOffset += param1.blueOffset;
         }
         else if(param2 == "-")
         {
            this.totalTransform.alphaMultiplier -= param1.alphaMultiplier;
            this.totalTransform.alphaOffset -= param1.alphaOffset;
            this.totalTransform.redMultiplier -= param1.redMultiplier;
            this.totalTransform.redOffset -= param1.redOffset;
            this.totalTransform.greenMultiplier -= param1.greenMultiplier;
            this.totalTransform.greenOffset -= param1.greenOffset;
            this.totalTransform.blueMultiplier -= param1.blueMultiplier;
            this.totalTransform.blueOffset -= param1.blueOffset;
         }
         this.clampedTransform.alphaMultiplier = _loc3_.clamp(this.totalTransform.alphaMultiplier,-1,1);
         this.clampedTransform.alphaOffset = _loc3_.clamp(this.totalTransform.alphaOffset,-255,255);
         this.clampedTransform.redMultiplier = _loc3_.clamp(this.totalTransform.redMultiplier,-1,1);
         this.clampedTransform.redOffset = _loc3_.clamp(this.totalTransform.redOffset,-255,255);
         this.clampedTransform.greenMultiplier = _loc3_.clamp(this.totalTransform.greenMultiplier,-1,1);
         this.clampedTransform.greenOffset = _loc3_.clamp(this.totalTransform.greenOffset,-255,255);
         this.clampedTransform.blueMultiplier = _loc3_.clamp(this.totalTransform.blueMultiplier,-1,1);
         this.clampedTransform.blueOffset = _loc3_.clamp(this.totalTransform.blueOffset,-255,255);
         this.transform.colorTransform = this.clampedTransform;
      }
      
      public function updateColor(param1:Object = null) : *
      {
         var _loc5_:* = undefined;
         var _loc2_:* = this.pAV.objData;
         if(param1 != null)
         {
            _loc2_ = param1;
         }
         var _loc3_:* = MovieClip(stage.getChildAt(0)).ui;
         this.scanColor(this,_loc2_);
         if(this.pAV != null && _loc3_.mcPortrait.pAV != null && _loc3_.mcPortrait.pAV == this.pAV)
         {
            this.scanColor(_loc3_.mcPortrait.mcHead,_loc2_);
         }
         if(this.pAV != null && _loc3_.mcPortraitTarget.pAV != null && _loc3_.mcPortraitTarget.pAV == this.pAV)
         {
            this.scanColor(_loc3_.mcPortraitTarget.mcHead,_loc2_);
         }
         if(!this.pAV.isMyAvatar)
         {
            return;
         }
         var _loc4_:int = 1;
         while(_loc4_ < 6)
         {
            _loc5_ = _loc3_.mcInterface.actBar.getChildByName("i" + _loc4_);
            if(_loc5_ != null)
            {
               this.scanColor(_loc5_,_loc2_);
            }
            _loc4_++;
         }
      }
      
      private function scanColor(param1:MovieClip, param2:*) : void
      {
         var _loc4_:DisplayObject = null;
         if("isColored" in param1)
         {
            this.changeColor(param1,Number(param2["intColor" + param1.strLocation]),param1.strShade);
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ is MovieClip)
            {
               this.scanColor(MovieClip(_loc4_),param2);
            }
            _loc3_++;
         }
      }
      
      public function queueAnim(param1:String) : void
      {
         var world:MovieClip;
         var wItem:Object;
         var petSplit:Array = null;
         var p:String = null;
         var pItem:Object = null;
         var sType:* = undefined;
         var wAnims:Array = null;
         var wAvail:Array = null;
         var wi:int = 0;
         var l:String = null;
         var sES:* = undefined;
         var s:String = param1;
         if(this.stage == null)
         {
            return;
         }
         world = MovieClip(stage.getChildAt(0)).world as MovieClip;
         if(this.pAV.isMyAvatar && world.rootClass.litePreference.data.bDisSelfMAnim && s != "Walk")
         {
            return;
         }
         if(!this.pAV.isMyAvatar && !world.showAnimations && s != "Walk")
         {
            return;
         }
         if(s.indexOf("Pet") > -1 && this.pAV.petMC && this.pAV.petMC.stage != null)
         {
            pItem = this.pAV.getItemByEquipSlot("pe");
            if(s.indexOf(":") > -1)
            {
               petSplit = s.split(":");
               s = petSplit[0];
               try
               {
                  if(pItem != null)
                  {
                     if(petSplit[1] == "PetAttack")
                     {
                        p = ["Attack1","Attack2"][Math.round(Math.random() * 1)];
                        if(this.pAV.petMC.mcChar.currentLabel == "Idle")
                        {
                           this.pAV.petMC.mcChar.gotoAndPlay(p);
                        }
                     }
                     else
                     {
                        p = petSplit[1].slice(3);
                        if(this.pAV.petMC.mcChar.currentLabel == "Idle")
                        {
                           this.pAV.petMC.mcChar.gotoAndPlay(p);
                        }
                     }
                  }
               }
               catch(e:*)
               {
               }
            }
            else if(pItem != null)
            {
               try
               {
                  p = ["Attack1","Attack2"][Math.round(Math.random() * 1)];
                  if(this.pAV.petMC.mcChar.currentLabel == "Idle")
                  {
                     this.pAV.petMC.mcChar.gotoAndPlay(p);
                  }
                  return;
               }
               catch(e:*)
               {
                  s = ["Attack1","Attack2"][Math.round(Math.random() * 1)];
               }
            }
            else
            {
               s = s.indexOf("1") > -1 ? "Attack1" : "Attack2";
            }
         }
         wItem = this.pAV.getItemByEquipSlot("Weapon");
         if(s == "Attack1" || s == "Attack2")
         {
            if(wItem != null && wItem.sType != null)
            {
               sType = wItem.sType;
               if(wItem.ItemID == 156 || wItem.ItemID == 12583)
               {
                  sType = "Unarmed";
               }
               wAnims = null;
               switch(sType)
               {
                  case "Unarmed":
                     wAnims = ["UnarmedAttack1","UnarmedAttack2","KickAttack","FlipAttack"];
                     break;
                  case "Polearm":
                     wAnims = ["PolearmAttack1","PolearmAttack2"];
                     break;
                  case "Dagger":
                     wAnims = ["DuelWield/DaggerAttack1","DuelWield/DaggerAttack2"];
                     break;
                  case "Bow":
                     wAnims = ["RangedAttack3"];
                     break;
                  case "Whip":
                     wAnims = ["WhipAttack"];
                     break;
                  case "HandGun":
                     wAnims = ["GunAttack","GunAttack2"];
                     break;
                  case "Rifle":
                     wAnims = ["RifleAttack2"];
                     break;
                  case "Gauntlet":
                     wAnims = ["UnarmedAttack1","UnarmedAttack2","FistweaponAttack1","FistweaponAttack2"];
               }
               if(wAnims != null)
               {
                  wAvail = [];
                  wi = 0;
                  while(wi < wAnims.length)
                  {
                     if(this.hasLabel(wAnims[wi]))
                     {
                        wAvail.push(wAnims[wi]);
                     }
                     wi++;
                  }
                  if(wAvail.length > 0)
                  {
                     s = wAvail[Math.floor(Math.random() * wAvail.length)];
                  }
               }
            }
         }
         if(this.hasLabel(s) && this.pAV.dataLeaf.intState > 0)
         {
            this.pAV.handleItemAnimation();
            l = this.mcChar.currentLabel;
            if(world.combatAnims.indexOf(s) > -1 && world.combatAnims.indexOf(l) > -1)
            {
               this.animQueue.push(s);
               if(this.animQueue.length > 2)
               {
                  this.animQueue.shift();
               }
            }
            else
            {
               this.mcChar.gotoAndPlay(s);
               if(this.pAV.dataLeaf.intState == 2)
               {
                  if(this.pAV.objData.eqp != null)
                  {
                     for(sES in this.pAV.objData.eqp)
                     {
                        this.handleAttack(sES);
                     }
                  }
               }
            }
         }
      }
      
      private function checkQueue(param1:Event) : Boolean
      {
         var _loc2_:MovieClip = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(this.stage == null)
         {
            return false;
         }
         if(this.animQueue.length > 0)
         {
            _loc2_ = MovieClip(stage.getChildAt(0)).world as MovieClip;
            _loc3_ = this.mcChar.currentLabel;
            _loc4_ = this.mcChar.emoteLoopFrame();
            if(_loc2_.combatAnims.indexOf(_loc3_) > -1 && this.mcChar.currentFrame > _loc4_ + 4)
            {
               _loc5_ = this.animQueue[0];
               this.queueStallTicks = 0;
               this.mcChar.gotoAndPlay(_loc5_);
               if(this.pAV.dataLeaf.intState == 2)
               {
                  if(this.pAV.objData.eqp != null)
                  {
                     for(_loc6_ in this.pAV.objData.eqp)
                     {
                        this.handleAttack(_loc6_);
                     }
                  }
               }
               this.animQueue.shift();
               return true;
            }
            if(param1 != null && ++this.queueStallTicks > 90)
            {
               this.animQueue = [];
               this.queueStallTicks = 0;
            }
         }
         else
         {
            this.queueStallTicks = 0;
         }
         return false;
      }
      
      public function performAttack(param1:*) : void
      {
         var _loc2_:int = 0;
         if(!(param1 is MovieClip))
         {
            return;
         }
         param1 = MovieClip(param1);
         while(true)
         {
            if(!(_loc2_ < 4 && param1))
            {
               return;
            }
            if(param1.hasOwnProperty("bAttack"))
            {
               param1.gotoAndPlay("Attack");
               break;
            }
            if(!(param1.numChildren > 0 && param1.getChildAt(0) is MovieClip))
            {
               break;
            }
            param1 = MovieClip(param1.getChildAt(0));
            _loc2_++;
         }
      }
      
      public function handleAttack(param1:String) : void
      {
         var _loc3_:* = undefined;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc2_:Object = this.pAV.getItemByEquipSlot(param1);
         if(param1 == "Weapon")
         {
            if(_loc2_.sType == "Gauntlet")
            {
               _loc5_ = [(this.mcChar.fronthand.getChildAt(1) as MovieClip).getChildAt(1),(this.mcChar.backhand.getChildAt(1) as MovieClip).getChildAt(0)];
               for each(_loc6_ in _loc5_)
               {
                  this.performAttack(_loc6_);
               }
               return;
            }
            if(_loc2_.sType == "Dagger")
            {
               _loc5_ = [this.mcChar.weapon.mcWeapon,this.mcChar.weaponOff];
               if(this.mcChar.weapon.mcWeapon.numChildren > 1)
               {
                  _loc5_ = [(this.mcChar.weapon.mcWeapon as MovieClip).getChildAt(1),(this.mcChar.weaponOff as MovieClip).getChildAt(0)];
               }
               for each(_loc6_ in _loc5_)
               {
                  this.performAttack(_loc6_);
               }
               return;
            }
            _loc3_ = this.mcChar.weapon.mcWeapon;
            this.performAttack(_loc3_);
            return;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this.attackFrames.length)
         {
            _loc7_ = this.attackFrames[_loc4_];
            if(!_loc7_)
            {
               this.attackFrames.splice(_loc4_,1);
               _loc4_--;
            }
            else if(_loc7_ is MovieClip)
            {
               MovieClip(_loc7_).gotoAndPlay("Attack");
            }
            _loc4_++;
         }
      }
      
      public function clearQueue() : void
      {
         this.animQueue = [];
      }
      
      private function linearTween(param1:*, param2:*, param3:*, param4:*) : Number
      {
         return param3 * param1 / param4 + param2;
      }
      
      public function walkTo(param1:int, param2:int, param3:int) : void
      {
         var isOK:Boolean;
         var dist:Number = NaN;
         var turned:Boolean = false;
         var dx:Number = NaN;
         var toX:int = param1;
         var toY:int = param2;
         var walkSpeed:int = param3;
         if(this.pAV.isMyAvatar && this.pAV.isWorldCamera)
         {
            return;
         }
         isOK = true;
         try
         {
            this.STAGE = MovieClip(parent.parent);
         }
         catch(e:Error)
         {
            isOK = false;
         }
         if(isOK)
         {
            this.op = new Point(this.x,this.y);
            this.tp = new Point(toX,toY);
            if(this.pAV.petMC != null && this.pAV.petMC.mcChar != null)
            {
               turned = false;
               if(this.op.x - this.tp.x < 0)
               {
                  if(this.pAV.petMC.mcChar.scaleX < 0)
                  {
                     this.pAV.petMC.turn("right");
                     turned = true;
                  }
               }
               else if(this.pAV.petMC.mcChar.scaleX > 0)
               {
                  this.pAV.petMC.turn("left");
                  turned = true;
               }
               this.pAV.petMC.walkTo(toX - 20,toY + 5,walkSpeed - 3);
            }
            this.walkSpeed = walkSpeed;
            dist = Point.distance(this.op,this.tp);
            this.walkTS = new Date().getTime();
            this.walkD = Math.round(1000 * (dist / (walkSpeed * 22)));
            if(this.walkD > 0)
            {
               dx = this.op.x - this.tp.x;
               if(dx < 0)
               {
                  this.turn("right");
               }
               else
               {
                  this.turn("left");
               }
               if(!this.mcChar.onMove)
               {
                  this.mcChar.onMove = true;
                  if(this.mcChar.currentLabel != "Walk")
                  {
                     this.mcChar.gotoAndPlay("Walk");
                  }
               }
               this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
               this.addEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk,false,0,true);
            }
         }
      }
      
      private function lerp(param1:*, param2:*, param3:*) : Number
      {
         return param1 + (param2 - param1) * param3;
      }
      
      public function calculateNewPxPy() : void
      {
         var _loc1_:* = MovieClip(stage.getChildAt(0));
         var _loc2_:Number = (_loc1_.mtcidNow - this.mvts) / this.mvtd;
         if(_loc2_ > 1)
         {
            this.x = this.tx;
            this.y = this.ty;
            this.resetSyncVars();
            return;
         }
         this.x = Math.floor(this.lerp(this.px,this.tx,_loc2_));
         this.y = Math.floor(this.lerp(this.py,this.ty,_loc2_));
      }
      
      public function resetSyncVars() : void
      {
         this.px = 0;
         this.py = 0;
         this.mvts = 0;
         this.mvtd = 0;
         this.mcChar.onMove = false;
      }
      
      public function destroyWalkFrame() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
         if(this.mcChar != null && this.mcChar.onMove)
         {
            this.stopWalking();
         }
      }
      
      private function onEnterFrameWalk(param1:Event) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:Boolean = false;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:int = 0;
         var _loc12_:Boolean = false;
         var _loc13_:Point = null;
         var _loc14_:Rectangle = null;
         if(this.mcChar == null || this.pAV == null || stage == null)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
            if(this.mcChar != null)
            {
               this.mcChar.onMove = false;
            }
            return;
         }
         var _loc2_:Number = Number(new Date().getTime());
         var _loc3_:Number = (_loc2_ - this.walkTS) / this.walkD;
         if(_loc3_ > 1)
         {
            _loc3_ = 1;
         }
         if(Point.distance(this.op,this.tp) > 0.5 && this.mcChar.onMove)
         {
            _loc4_ = this.x;
            _loc5_ = this.y;
            this.x = Point.interpolate(this.tp,this.op,_loc3_).x;
            this.y = Point.interpolate(this.tp,this.op,_loc3_).y;
            _loc6_ = false;
            _loc7_ = 0;
            while(_loc7_ < this.STAGE.arrSolid.length)
            {
               if(!(this.STAGE.arrSolid[_loc7_] == null || this.STAGE.arrSolid[_loc7_].shadow == null || this.STAGE.arrSolid[_loc7_].stage == null))
               {
                  if(this.shadow.hitTestObject(this.STAGE.arrSolid[_loc7_].shadow))
                  {
                     _loc6_ = true;
                     _loc7_ = this.STAGE.arrSolid.length;
                  }
               }
               _loc7_++;
            }
            if(_loc6_)
            {
               _loc8_ = this.y;
               this.y = _loc5_;
               _loc6_ = false;
               _loc9_ = 0;
               while(_loc9_ < this.STAGE.arrSolid.length)
               {
                  if(!(this.STAGE.arrSolid[_loc9_] == null || this.STAGE.arrSolid[_loc9_].shadow == null || this.STAGE.arrSolid[_loc9_].stage == null))
                  {
                     if(this.shadow.hitTestObject(this.STAGE.arrSolid[_loc9_].shadow))
                     {
                        this.y = _loc8_;
                        _loc6_ = true;
                        break;
                     }
                  }
                  _loc9_++;
               }
               if(_loc6_)
               {
                  this.x = _loc4_;
                  _loc6_ = false;
                  _loc10_ = 0;
                  while(_loc10_ < this.STAGE.arrSolid.length)
                  {
                     if(!(this.STAGE.arrSolid[_loc10_] == null || this.STAGE.arrSolid[_loc10_].shadow == null || this.STAGE.arrSolid[_loc10_].stage == null))
                     {
                        if(this.shadow.hitTestObject(this.STAGE.arrSolid[_loc10_].shadow))
                        {
                           _loc6_ = true;
                           break;
                        }
                     }
                     _loc10_++;
                  }
                  if(_loc6_)
                  {
                     this.x = _loc4_;
                     this.y = _loc5_;
                     this.stopWalking();
                  }
               }
            }
            if(Math.round(_loc4_) == Math.round(this.x) && Math.round(_loc5_) == Math.round(this.y) && _loc2_ > this.walkTS + 50)
            {
               this.stopWalking();
            }
            if(this.pAV.isMyAvatar)
            {
               this.checkPadLabels();
               _loc11_ = 0;
               while(_loc11_ < this.STAGE.arrEvent.length)
               {
                  if(!(this.STAGE.arrEvent[_loc11_] == null || this.STAGE.arrEvent[_loc11_].shadow == null || this.STAGE.arrEvent[_loc11_].stage == null))
                  {
                     _loc12_ = false;
                     this.world = MovieClip(stage.getChildAt(0)).world;
                     if(this.world.bPvP)
                     {
                        _loc13_ = this.shadow.localToGlobal(new Point(0,0));
                        _loc14_ = this.STAGE.arrEvent[_loc11_].shadow.getBounds(stage);
                        if(_loc14_.containsPoint(_loc13_))
                        {
                           _loc12_ = true;
                        }
                     }
                     else if(this.shadow.hitTestObject(this.STAGE.arrEvent[_loc11_].shadow))
                     {
                        _loc12_ = true;
                     }
                     if(_loc12_)
                     {
                        if(!this.STAGE.arrEvent[_loc11_]._entered && Boolean(MovieClip(this.STAGE.arrEvent[_loc11_]).isEvent))
                        {
                           this.STAGE.arrEvent[_loc11_]._entered = true;
                           if(this == MovieClip(parent.parent).myAvatar.pMC)
                           {
                              this.STAGE.arrEvent[_loc11_].dispatchEvent(new Event("enter"));
                           }
                        }
                     }
                     else if(this.STAGE.arrEvent[_loc11_]._entered)
                     {
                        this.STAGE.arrEvent[_loc11_]._entered = false;
                     }
                  }
                  _loc11_++;
               }
            }
         }
         else
         {
            this.stopWalking();
         }
      }
      
      public function simulateTo(param1:int, param2:int, param3:int) : Point
      {
         this.STAGE = MovieClip(parent.parent);
         this.xDep = this.x;
         this.yDep = this.y;
         this.xTar = param1;
         this.yTar = param2;
         this.walkSpeed = param3;
         this.nDuration = Math.round(Math.sqrt(Math.pow(this.xTar - this.x,2) + Math.pow(this.yTar - this.y,2)) / param3);
         var _loc4_:* = new Point();
         if(this.nDuration)
         {
            this.nXStep = 0;
            this.nYStep = 0;
            if(!this.mcChar.onMove)
            {
               this.mcChar.onMove = true;
            }
            _loc4_ = this.simulateWalkLoop();
         }
         else
         {
            _loc4_ = null;
         }
         this.x = this.xDep;
         this.y = this.yDep;
         this.mcChar.onMove = false;
         return _loc4_;
      }
      
      private function simulateWalkLoop() : Point
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:Boolean = false;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         while(true)
         {
            if(!((this.nXStep <= this.nDuration || this.nYStep <= this.nDuration) && this.mcChar.onMove))
            {
               this.mcChar.onMove = false;
               this.nDuration = -1;
               return new Point(this.x,this.y);
            }
            _loc1_ = this.x;
            _loc2_ = this.y;
            this.x = this.linearTween(this.nXStep,this.xDep,this.xTar - this.xDep,this.nDuration);
            this.y = this.linearTween(this.nYStep,this.yDep,this.yTar - this.yDep,this.nDuration);
            _loc3_ = false;
            _loc4_ = 0;
            while(_loc4_ < this.STAGE.arrSolid.length)
            {
               if(!(this.STAGE.arrSolid[_loc4_] == null || this.STAGE.arrSolid[_loc4_].shadow == null || this.STAGE.arrSolid[_loc4_].stage == null))
               {
                  if(this.shadow.hitTestObject(this.STAGE.arrSolid[_loc4_].shadow))
                  {
                     _loc3_ = true;
                     _loc4_ = this.STAGE.arrSolid.length;
                  }
               }
               _loc4_++;
            }
            if(_loc3_)
            {
               _loc5_ = this.y;
               this.y = _loc2_;
               _loc3_ = false;
               _loc6_ = 0;
               while(_loc6_ < this.STAGE.arrSolid.length)
               {
                  if(!(this.STAGE.arrSolid[_loc6_] == null || this.STAGE.arrSolid[_loc6_].shadow == null || this.STAGE.arrSolid[_loc6_].stage == null))
                  {
                     if(this.shadow.hitTestObject(this.STAGE.arrSolid[_loc6_].shadow))
                     {
                        this.y = _loc5_;
                        _loc3_ = true;
                        break;
                     }
                  }
                  _loc6_++;
               }
               if(_loc3_)
               {
                  this.x = _loc1_;
                  _loc3_ = false;
                  _loc7_ = 0;
                  while(_loc7_ < this.STAGE.arrSolid.length)
                  {
                     if(!(this.STAGE.arrSolid[_loc7_] == null || this.STAGE.arrSolid[_loc7_].shadow == null || this.STAGE.arrSolid[_loc7_].stage == null))
                     {
                        if(this.shadow.hitTestObject(this.STAGE.arrSolid[_loc7_].shadow))
                        {
                           _loc3_ = true;
                           break;
                        }
                     }
                     _loc7_++;
                  }
                  if(_loc3_)
                  {
                     break;
                  }
                  if(this.nYStep <= this.nDuration)
                  {
                     ++this.nYStep;
                  }
               }
               else if(this.nXStep <= this.nDuration)
               {
                  ++this.nXStep;
               }
            }
            else
            {
               if(this.nXStep <= this.nDuration)
               {
                  ++this.nXStep;
               }
               if(this.nYStep <= this.nDuration)
               {
                  ++this.nYStep;
               }
            }
            if(Math.round(_loc1_) == Math.round(this.x) && Math.round(_loc2_) == Math.round(this.y) && (this.nXStep > 1 || this.nYStep > 1))
            {
               this.mcChar.onMove = false;
               this.nDuration = -1;
               return new Point(this.x,this.y);
            }
         }
         this.x = _loc1_;
         this.y = _loc2_;
         this.mcChar.onMove = false;
         this.nDuration = -1;
         return new Point(this.x,this.y);
      }
      
      public function stopWalking() : void
      {
         if(stage == null || this.mcChar == null || this.pAV == null)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
            if(this.mcChar != null)
            {
               this.mcChar.onMove = false;
            }
            return;
         }
         this.world = MovieClip(stage.getChildAt(0)).world;
         if(this.mcChar.onMove)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
            if(this.pAV.isMyAvatar && this.world != null && parent != null && parent.parent != null && Boolean(MovieClip(parent.parent).actionReady))
            {
               this.world.testAction(this.world.getAutoAttack());
            }
         }
         this.mcChar.onMove = false;
         this.mcChar.gotoAndPlay("Idle");
         this.px = 0;
         this.py = 0;
      }
      
      public function checkPadLabels() : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc1_:* = MovieClip(stage.getChildAt(0));
         var _loc2_:* = _loc1_.ui;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.mcPadNames.numChildren)
         {
            _loc4_ = MovieClip(_loc2_.mcPadNames.getChildAt(_loc3_));
            _loc5_ = new Point(4,8);
            _loc5_ = _loc4_.cnt.localToGlobal(_loc5_);
            if(_loc1_.distanceO(this,_loc5_) < 200)
            {
               if(!_loc4_.isOn)
               {
                  _loc4_.isOn = true;
                  _loc4_.gotoAndPlay("in");
               }
            }
            else if(_loc4_.isOn)
            {
               _loc4_.isOn = false;
               _loc4_.gotoAndPlay("out");
            }
            _loc3_++;
         }
      }
      
      public function turn(param1:String) : void
      {
         if(param1 == "right" && this.mcChar.scaleX < 0 || param1 == "left" && this.mcChar.scaleX > 0)
         {
            this.mcChar.scaleX *= -1;
            if(this.pAV.morphMC != null && this.pAV.morphMC.visible)
            {
               this.pAV.morphMC.scaleX *= -1;
            }
         }
      }
      
      public function scale(param1:Number) : void
      {
         if(this.mcChar.scaleX >= 0)
         {
            this.mcChar.scaleX = param1;
         }
         else
         {
            this.mcChar.scaleX = -param1;
         }
         this.mcChar.scaleY = param1;
         this.shadow.scaleX = this.shadow.scaleY = param1;
         this.cShadow.scaleX = this.cShadow.scaleY = param1;
         var _loc2_:Point = this.mcChar.localToGlobal(this.headPoint);
         _loc2_ = this.globalToLocal(_loc2_);
         this.pname.y = int(_loc2_.y);
         this.bubble.y = int(this.pname.y - this.bubble.height);
         this.ignore.y = int(this.pname.y - this.ignore.height - 2);
         this.drawHitBox();
      }
      
      public function endAction() : void
      {
         var tChar:*;
         var dx:Number = NaN;
         var s:String = null;
         var wItem:Object = null;
         var sType:* = undefined;
         if(this.mcChar == null)
         {
            return;
         }
         if(this.pAV == null)
         {
            this.mcChar.stop();
            return;
         }
         tChar = null;
         if(this.pAV.target != null && this.pAV.target.pMC != null)
         {
            tChar = this.pAV.target.pMC.mcChar;
         }
         try
         {
            if(tChar == null && this.pAV.target != null && this.pAV.target.dataLeaf != null && this.pAV.target.dataLeaf.intState == 0 && this.world != null && this.pAV == this.world.myAvatar)
            {
               this.world.setTarget(null);
            }
            if(!this.checkQueue(null))
            {
               if(this.mcChar.onMove)
               {
                  this.mcChar.gotoAndPlay("Walk");
                  dx = this.x - this.xTar;
                  if(dx < 0)
                  {
                     this.turn("right");
                  }
                  else
                  {
                     this.turn("left");
                  }
               }
               else if(tChar == null || tChar != null && (tChar.currentLabel == "Die" || tChar.currentLabel == "Feign" || tChar.currentLabel == "Dead" || this.pAV.target.npcType == "player" && (!("pvpTeam" in this.pAV.dataLeaf) || this.pAV.dataLeaf.pvpTeam == this.pAV.target.dataLeaf.pvpTeam)))
               {
                  if(this.mcChar.currentLabel != "Jump")
                  {
                     this.mcChar.gotoAndPlay("Idle");
                  }
                  if(tChar != null)
                  {
                     if(this.pAV.target.dataLeaf.intState == 0)
                     {
                        if(this.pAV == this.world.myAvatar)
                        {
                           this.world.setTarget(null);
                        }
                     }
                  }
               }
               else
               {
                  s = "Fight";
                  wItem = this.pAV.getItemByEquipSlot("Weapon");
                  if(wItem != null && wItem.sType != null)
                  {
                     sType = wItem.sType;
                     if(wItem.ItemID == 156)
                     {
                        sType = "Unarmed";
                     }
                     switch(sType)
                     {
                        case "Bow":
                           s = "RangedFight";
                           break;
                        case "Rifle":
                           s = "RifleFight";
                           break;
                        case "Gauntlet":
                           s = "UnarmedFight";
                           break;
                        case "Unarmed":
                           s = "UnarmedFight";
                           break;
                        case "Polearm":
                           s = "PolearmFight";
                           break;
                        case "Dagger":
                           s = "DuelWield/DaggerFight";
                     }
                  }
                  this.mcChar.gotoAndPlay(s);
               }
            }
         }
         catch(eEnd:Error)
         {
            try
            {
               this.mcChar.gotoAndPlay("Idle");
            }
            catch(eEnd2:Error)
            {
            }
         }
      }
      
      private function drawHitBox() : void
      {
         this.mcChar.hitbox.graphics.clear();
         var _loc1_:int = -30;
         var _loc2_:int = 60;
         var _loc3_:int = this.mcChar.head.y;
         var _loc4_:int = -_loc3_ * 0.8;
         this.hitboxR = new Rectangle(_loc1_,_loc3_,_loc2_,_loc4_);
         var _loc5_:Graphics = this.mcChar.hitbox.graphics;
         _loc5_.lineStyle(0,16777215,0);
         _loc5_.beginFill(11141375,0);
         _loc5_.moveTo(_loc1_,_loc3_);
         _loc5_.lineTo(_loc1_ + _loc2_,_loc3_);
         _loc5_.lineTo(_loc1_ + _loc2_,_loc3_ + _loc4_);
         _loc5_.lineTo(_loc1_,_loc3_ + _loc4_);
         _loc5_.lineTo(_loc1_,_loc3_);
         _loc5_.endFill();
      }
      
      public function showHealIcon() : void
      {
         var _loc1_:HealIconMC = null;
         if(this.rootClass.litePreference.data.bDisHealBubble)
         {
            return;
         }
         if(!getChildByName("HealIconMC"))
         {
            _loc1_ = new HealIconMC(this.pAV,this.world);
            _loc1_.name = "HealIconMC";
            addChild(_loc1_);
         }
      }
      
      private function randomNumber(param1:Number, param2:Number) : Number
      {
         this.randNum = param1 + (param2 + 1 - param1) * this.XORandom();
         return this.randNum < param2 ? this.randNum : param2;
      }
      
      private function XORandom() : Number
      {
         this.r ^= this.r << 21;
         this.r ^= this.r >>> 35;
         this.r ^= this.r << 4;
         if(this.r > 0)
         {
            return this.r * this.MAX_RATIO;
         }
         return this.r * this.NEGA_MAX_RATIO;
      }
      
      public function iaF(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         for each(_loc2_ in IAF_BODY_PARTS)
         {
            try
            {
               _loc3_ = this.mcChar[_loc2_] as MovieClip;
               if(_loc3_ != null && _loc3_.numChildren > 0)
               {
                  _loc4_ = _loc3_.getChildAt(0) as MovieClip;
                  if(_loc4_ != null)
                  {
                     _loc4_.iaF(param1);
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function clearSpFXQueue() : void
      {
         this._spFXQueue = [];
      }
      
      public function canCastSpFX() : void
      {
         if(this._spFXQueue.length < 1)
         {
            return;
         }
         this.world.castSpellFX(this.pAV,this.nextSpFX,null,0);
      }
      
      public function get nextSpFX() : Object
      {
         return this._spFXQueue.shift();
      }
      
      public function queueSpFX(param1:Object) : void
      {
         if(this.spFX.strl != "")
         {
            this._spFXQueue.push(param1);
         }
         else
         {
            this.spFX = param1;
         }
      }
      
      public function playSound() : void
      {
      }
      
      public function addAnimationListener(param1:String, param2:Function, param3:Boolean = true) : void
      {
         if(this.animEvents[param1] == null)
         {
            this.animEvents[param1] = [];
         }
         if(!this.hasAnimationListener(param1,param2))
         {
            this.animEvents[param1].push(param2);
            this.animEvents[param1].push(param3);
         }
      }
      
      public function removeAnimationListener(param1:String, param2:Function) : void
      {
         if(this.animEvents[param1] == null)
         {
            return;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < this.animEvents[param1].length)
         {
            if(this.animEvents[param1][_loc3_] == param2)
            {
               this.animEvents[param1].splice(_loc3_,2);
               break;
            }
            _loc3_ += 2;
         }
      }
      
      public function hasAnimationListener(param1:String, param2:Function) : Boolean
      {
         if(this.animEvents[param1] == null)
         {
            return false;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < this.animEvents[param1].length)
         {
            if(this.animEvents[param1][_loc3_] == param2)
            {
               return true;
            }
            _loc3_ += 2;
         }
         return false;
      }
      
      private function handleAnimEvent(param1:String) : void
      {
         var _loc2_:Function = null;
         if(this.animEvents[param1] == null)
         {
            return;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < this.animEvents[param1].length)
         {
            _loc2_ = this.animEvents[param1][_loc3_];
            _loc2_();
            _loc3_ += 2;
         }
      }
      
      public function clearAnimEvents() : void
      {
         this.animEvents = new Object();
      }
      
      public function get AnimEvent() : Object
      {
         return this.animEvents;
      }
      
      public function artLoaded() : Boolean
      {
         return this.weaponLoad && this.capeLoad && this.helmLoad && this.armorLoad && this.classLoad && this.hairLoad && this.miscLoad;
      }
      
      private function disposeAllBitmaps(param1:DisplayObjectContainer) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Bitmap = null;
         var _loc2_:int = param1.numChildren - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            if(_loc3_ is Bitmap)
            {
               _loc4_ = _loc3_ as Bitmap;
               if(_loc4_.bitmapData != null)
               {
                  _loc4_.bitmapData.dispose();
               }
            }
            else if(_loc3_ is DisplayObjectContainer)
            {
               this.disposeAllBitmaps(DisplayObjectContainer(_loc3_));
            }
            _loc2_--;
         }
      }
   }
}

