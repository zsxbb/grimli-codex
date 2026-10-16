package
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class MonsterMC extends MovieClip
   {
      public var bubble:MovieClip;
      
      public var fx:MovieClip;
      
      public var mc:MovieClip;
      
      public var pname:MovieClip;
      
      public var shadow:MovieClip;
      
      internal var WORLD:MovieClip;
      
      internal var xDep:*;
      
      internal var yDep:*;
      
      internal var xTar:*;
      
      internal var yTar:Number;
      
      internal var op:Point;
      
      internal var tp:Point;
      
      internal var walkTS:Number;
      
      internal var walkD:Number;
      
      internal var ox:*;
      
      internal var oy:*;
      
      internal var px:*;
      
      internal var py:*;
      
      internal var tx:*;
      
      internal var ty:Number;
      
      internal var nDuration:*;
      
      internal var nXStep:*;
      
      internal var nYStep:Number;
      
      internal var cbx:*;
      
      internal var cby:Number;
      
      internal var defaultCT:ColorTransform;
      
      internal var iniTimer:Timer;
      
      public var hitbox:Rectangle;
      
      public var hitboxDO:DisplayObject;
      
      public var spFX:Object;
      
      public var pAV:Avatar;
      
      internal var mcChar:MovieClip;
      
      public var isMonster:Boolean = true;
      
      public var isStatic:Boolean = false;
      
      public var noMove:Boolean = false;
      
      private var despawnTimer:Timer;
      
      private var totalTransform:Object;
      
      private var clampedTransform:ColorTransform;
      
      private var animQueue:Array;
      
      private var attacks:Array;
      
      private var queueStallTicks:int = 0;
      
      public function MonsterMC(param1:String)
      {
         this.defaultCT = MovieClip(this).transform.colorTransform;
         this.spFX = {};
         this.despawnTimer = new Timer(5000,1);
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
         this.attacks = new Array("Attack1","Attack2","Buff","Cast");
         super();
         this.bubble.visible = false;
         this.bubble.t = "";
         this.pname.ti.text = param1;
      }
      
      public function init() : *
      {
         this.WORLD = MovieClip(parent.parent);
         this.mcChar = MovieClip(this.getChildAt(1));
         this.mcChar.addEventListener(MouseEvent.CLICK,this.onClickHandler,false,0,true);
         this.pname.addEventListener(MouseEvent.CLICK,this.onClickHandler,false,0,true);
         this.despawnTimer.addEventListener(TimerEvent.TIMER,this.despawn,false,0,true);
         this.addEventListener(Event.ENTER_FRAME,this.checkQueue,false,0,true);
         this.pname.mouseChildren = false;
         this.mcChar.buttonMode = true;
         this.pname.buttonMode = true;
         this.shadow.addEventListener(MouseEvent.CLICK,this.onClickHandler,false,0,true);
         this.shadow.mouseEnabled = this.shadow.mouseChildren = true;
         this.mcChar.mouseEnabled = true;
         this.mcChar.mouseChildren = true;
         this.mcChar.cacheAsBitmap = true;
         this.setVisible();
         if(MovieClip(stage.getChildAt(0)).litePreference.data.bDisMonAnim)
         {
            MovieClip(stage.getChildAt(0)).movieClipStopAll(this.mcChar);
         }
         this.mcChar.visible = !MovieClip(stage.getChildAt(0)).litePreference.data.bHideMons;
         this.noMove = MovieClip(stage.getChildAt(0)).litePreference.data.bFreezeMons;
         var _loc1_:* = MovieClip(stage.getChildAt(0));
         if(_loc1_.litePreference.data.bComicSans)
         {
            _loc1_.applyComicSansPname(this.pname,true);
         }
         _loc1_.fixInputHeight(this.pname.ti);
         _loc1_.fixInputHeight(this.pname.typ);
      }
      
      public function setVisible() : *
      {
         this.visible = this.WORLD.showMonsters;
      }
      
      public function setData() : *
      {
         this.pAV.objData.strMonName = this.pname.ti.text;
      }
      
      public function updateNamePlate() : void
      {
         this.WORLD = MovieClip(parent.parent);
         if(this.WORLD.bPvP && this.pAV.dataLeaf != null && this.pAV.dataLeaf.react != null && this.pAV.dataLeaf.react[this.WORLD.myAvatar.dataLeaf.pvpTeam] == 1)
         {
            this.pname.ti.textColor = 16777215;
            this.pname.typ.textColor = 16777215;
         }
      }
      
      public function fClose() : *
      {
         var _loc1_:MovieClip = this.WORLD;
         try
         {
            if(stage != null)
            {
               _loc1_ = MovieClip(stage.getChildAt(0)).world;
            }
         }
         catch(eW:Error)
         {
         }
         try
         {
            if(_loc1_ != null && _loc1_.CHARS != null && Boolean(_loc1_.CHARS.contains(this)))
            {
               _loc1_.CHARS.removeChild(this);
            }
            if(_loc1_ != null && _loc1_.TRASH != null && Boolean(_loc1_.TRASH.contains(this)))
            {
               _loc1_.TRASH.removeChild(this);
            }
            if(this.parent != null)
            {
               this.parent.removeChild(this);
            }
         }
         catch(eR:Error)
         {
         }
         try
         {
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
         }
         catch(eL:Error)
         {
         }
         if(this.despawnTimer != null)
         {
            try
            {
               this.despawnTimer.stop();
               this.despawnTimer.removeEventListener(TimerEvent.TIMER,this.despawn);
            }
            catch(eT:Error)
            {
            }
         }
         if(this.iniTimer != null)
         {
            try
            {
               this.iniTimer.stop();
            }
            catch(eI:Error)
            {
            }
            this.iniTimer = null;
         }
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
         this.removeEventListener(Event.ENTER_FRAME,this.onDespawn);
         this.removeEventListener(Event.ENTER_FRAME,this.checkQueue);
         try
         {
            if(_loc1_ != null && this.mcChar != null)
            {
               _loc1_.rootClass.recursiveStop(this.mcChar);
            }
         }
         catch(e:Error)
         {
         }
         if(this.mcChar != null)
         {
            this.mcChar.cacheAsBitmap = false;
         }
         this.animQueue = null;
         this.spFX = null;
         this.pAV = null;
         this.mcChar = null;
         this.WORLD = null;
         this.hitbox = null;
         this.hitboxDO = null;
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
      
      public function onClickHandler(param1:MouseEvent) : *
      {
         if(param1.shiftKey)
         {
            this.WORLD.onWalkClick();
         }
         else if(param1.ctrlKey)
         {
            if(this.WORLD.myAvatar.objData.intAccessLevel >= 40)
            {
               if(this.pAV.npcType == "monster")
               {
                  this.WORLD.rootClass.sfc.sendXtMessage("zm","cmd",["km","m:" + this.pAV.objData.MonMapID],"str",1);
               }
               if(this.pAV.npcType == "player")
               {
                  this.WORLD.rootClass.sfc.sendXtMessage("zm","cmd",["km","p:" + this.pAV.objData.unm.toLowerCase()],"str",1);
               }
            }
         }
         else if(param1.currentTarget.parent == this)
         {
            if(this.WORLD.myAvatar.target != this.pAV)
            {
               this.WORLD.setTarget(this.pAV);
            }
            else if(!this.WORLD.bPvP || (this.pAV.dataLeaf.react == null || this.pAV.dataLeaf.react[this.WORLD.myAvatar.dataLeaf.pvpTeam] == 0))
            {
               this.WORLD.approachTarget();
            }
         }
      }
      
      public function modulateColor(param1:ColorTransform, param2:String) : void
      {
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
      
      public function queueAnim(param1:String) : void
      {
         if(Boolean(MovieClip(stage.getChildAt(0)).litePreference.data.bDisMonAnim) && param1.toLowerCase() != "idle")
         {
            return;
         }
         var _loc2_:MovieClip = MovieClip(stage.getChildAt(0)).world as MovieClip;
         var _loc3_:String = this.mcChar.currentLabel;
         if(this.hasLabel(param1) && this.pAV.dataLeaf.intState > 0 && _loc2_.staticAnims.indexOf(_loc3_) == -1)
         {
            if(_loc2_.combatAnims.indexOf(param1) > -1 && _loc2_.combatAnims.indexOf(_loc3_) > -1)
            {
               this.animQueue.push(param1);
               if(this.animQueue.length > 2)
               {
                  this.animQueue.shift();
               }
            }
            else
            {
               this.mcChar.gotoAndPlay(param1);
            }
         }
      }
      
      private function checkQueue(param1:Event) : Boolean
      {
         var _loc2_:MovieClip = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         if(stage == null || this.mcChar == null || this.animQueue == null)
         {
            return false;
         }
         if(this.animQueue.length > 0)
         {
            _loc2_ = MovieClip(stage.getChildAt(0)).world as MovieClip;
            _loc3_ = this.mcChar.currentLabel;
            _loc4_ = this.emoteLoopFrame();
            if(_loc2_.combatAnims.indexOf(_loc3_) > -1 && this.mcChar.currentFrame >= _loc4_ + 4)
            {
               this.mcChar.gotoAndPlay(this.animQueue[0]);
               this.animQueue.shift();
               this.queueStallTicks = 0;
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
      
      public function clearQueue() : void
      {
         this.animQueue = [];
      }
      
      private function emoteLoopFrame() : int
      {
         var _loc1_:Array = this.mcChar.currentLabels;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_].name == currentLabel)
            {
               return _loc1_[_loc2_].frame;
            }
            _loc2_++;
         }
         return 8;
      }
      
      private function linearTween(param1:*, param2:*, param3:*, param4:*) : Number
      {
         return param3 * param1 / param4 + param2;
      }
      
      public function walkTo(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(!this.noMove)
         {
            if(this.pAV.petMC != null && this.pAV.petMC.mcChar != null)
            {
               this.pAV.petMC.walkTo(param1 - 20,param2 + 5,param3 - 3);
            }
            this.op = new Point(this.x,this.y);
            this.tp = new Point(param1,param2);
            _loc4_ = Point.distance(this.op,this.tp);
            this.walkTS = new Date().getTime();
            this.walkD = Math.round(1000 * (_loc4_ / (param3 * 22)));
            if(this.walkD > 0)
            {
               _loc5_ = this.op.x - this.tp.x;
               if(_loc5_ < 0)
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
                  if(this.mcChar.currentLabel != "Walk" && !MovieClip(stage.getChildAt(0)).litePreference.data.bDisMonAnim)
                  {
                     this.mcChar.gotoAndPlay("Walk");
                  }
               }
               this.addEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk,false,0,true);
            }
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
         var _loc2_:Number = Number(new Date().getTime());
         var _loc3_:Number = (_loc2_ - this.walkTS) / this.walkD;
         if(_loc3_ > 1)
         {
            _loc3_ = 1;
         }
         if(Point.distance(this.op,this.tp) > 0.5 && Boolean(this.mcChar.onMove))
         {
            _loc4_ = this.x;
            _loc5_ = this.y;
            this.x = Point.interpolate(this.tp,this.op,_loc3_).x;
            this.y = Point.interpolate(this.tp,this.op,_loc3_).y;
            _loc6_ = false;
            _loc7_ = 0;
            while(_loc7_ < this.WORLD.arrSolid.length)
            {
               if(!(this.WORLD.arrSolid[_loc7_] == null || this.WORLD.arrSolid[_loc7_].shadow == null || this.WORLD.arrSolid[_loc7_].stage == null))
               {
                  if(this.shadow.hitTestObject(this.WORLD.arrSolid[_loc7_].shadow))
                  {
                     _loc6_ = true;
                     _loc7_ = this.WORLD.arrSolid.length;
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
               while(_loc9_ < this.WORLD.arrSolid.length)
               {
                  if(!(this.WORLD.arrSolid[_loc9_] == null || this.WORLD.arrSolid[_loc9_].shadow == null || this.WORLD.arrSolid[_loc9_].stage == null))
                  {
                     if(this.shadow.hitTestObject(this.WORLD.arrSolid[_loc9_].shadow))
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
                  while(_loc10_ < this.WORLD.arrSolid.length)
                  {
                     if(!(this.WORLD.arrSolid[_loc10_] == null || this.WORLD.arrSolid[_loc10_].shadow == null || this.WORLD.arrSolid[_loc10_].stage == null))
                     {
                        if(this.shadow.hitTestObject(this.WORLD.arrSolid[_loc10_].shadow))
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
         }
         else
         {
            this.stopWalking();
         }
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
         if(this.mcChar.onMove)
         {
            this.mcChar.onMove = false;
            if(this.pAV.dataLeaf != null && this.pAV.dataLeaf.intState != 2)
            {
               this.mcChar.gotoAndPlay("Idle");
               if(!this.isStatic)
               {
                  if(this.x < MovieClip(stage.getChildAt(0)).world.myAvatar.pMC.x)
                  {
                     this.turn("right");
                  }
                  else
                  {
                     this.turn("left");
                  }
               }
            }
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
         }
         if(MovieClip(stage.getChildAt(0)).litePreference.data.bDisMonAnim)
         {
            this.mcChar.gotoAndStop("Idle");
         }
      }
      
      public function turn(param1:String) : void
      {
         if(!this.isStatic)
         {
            if(param1 == "right" && this.mcChar.scaleX < 0 || param1 == "left" && this.mcChar.scaleX > 0)
            {
               this.mcChar.scaleX *= -1;
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
         this.bubble.y = -this.mcChar.height - 10;
         this.pname.y = -this.mcChar.height - 10;
         var _loc2_:Point = new Point(0,-this.mcChar.height - 10);
         var _loc3_:Point = this.localToGlobal(_loc2_);
         if(_loc3_.y < 50)
         {
            _loc3_.y = 50;
         }
         _loc2_ = this.globalToLocal(_loc3_);
         this.pname.y = _loc2_.y;
         this.drawHitBox();
      }
      
      public function die() : void
      {
         this.animQueue = [];
         MovieClip(this.getChildAt(1)).gotoAndPlay("Die");
         this.mcChar.mouseEnabled = false;
         this.mcChar.mouseChildren = false;
         this.despawnTimer.reset();
         this.despawnTimer.start();
      }
      
      private function despawn(param1:TimerEvent) : void
      {
         if(stage == null)
         {
            return;
         }
         var _loc2_:* = MovieClip(stage.getChildAt(0)).world;
         if(_loc2_.myAvatar.target == this.pAV)
         {
            _loc2_.setTarget(null);
         }
         this.addEventListener(Event.ENTER_FRAME,this.onDespawn,false,0,true);
      }
      
      private function onDespawn(param1:Event) : void
      {
         this.alpha -= 0.05;
         if(this.alpha < 0)
         {
            this.visible = false;
            this.alpha = 1;
            this.removeEventListener(Event.ENTER_FRAME,this.onDespawn);
         }
      }
      
      public function respawn(param1:String = "") : void
      {
         this.despawnTimer.reset();
         this.removeEventListener(Event.ENTER_FRAME,this.onDespawn);
         if(this.hasLabel("Start"))
         {
            MovieClip(this.getChildAt(1)).gotoAndPlay("Start");
         }
         else if(MovieClip(this.getChildAt(1)).currentLabel != "Walk")
         {
            MovieClip(this.getChildAt(1)).gotoAndStop("Idle");
         }
         if(param1 != "")
         {
            this.pname.ti.text = param1;
         }
         this.alpha = 1;
         this.visible = true;
         this.mcChar.mouseEnabled = true;
         this.mcChar.mouseChildren = true;
         var _loc2_:* = MovieClip(stage.getChildAt(0)).world;
         if(MovieClip(stage.getChildAt(0)).litePreference.data.bDisMonAnim)
         {
            MovieClip(stage.getChildAt(0)).movieClipStopAll(this.mcChar);
         }
         this.setVisible();
      }
      
      private function drawHitBox() : void
      {
         if(this.hitboxDO != null)
         {
            this.mcChar.removeChild(this.hitboxDO);
         }
         this.hitboxDO = null;
         var _loc1_:Rectangle = this.mcChar.getBounds(stage);
         var _loc2_:Point = _loc1_.topLeft;
         var _loc3_:Point = _loc1_.bottomRight;
         _loc2_ = this.mcChar.globalToLocal(_loc2_);
         _loc3_ = this.mcChar.globalToLocal(_loc3_);
         _loc1_ = new Rectangle(_loc2_.x,_loc2_.y,_loc3_.x - _loc2_.x,_loc3_.y - _loc2_.y);
         var _loc4_:int = _loc1_.x + _loc1_.width * 0.2;
         if(_loc4_ > this.shadow.x - this.shadow.width)
         {
            _loc4_ = this.shadow.x - this.shadow.width;
         }
         var _loc5_:int = _loc1_.width * 0.6;
         if(_loc5_ < 2 * this.shadow.width)
         {
            _loc5_ = 2 * this.shadow.width;
         }
         var _loc6_:int = _loc1_.y + _loc1_.height * 0.2;
         var _loc7_:int = _loc1_.height * 0.6;
         this.hitbox = new Rectangle(_loc4_,_loc6_,_loc5_,_loc7_);
         var _loc8_:Sprite = new Sprite();
         var _loc9_:Graphics = _loc8_.graphics;
         _loc9_.lineStyle(0,16777215,0);
         _loc9_.beginFill(11141375,0);
         _loc9_.moveTo(_loc4_,_loc6_);
         _loc9_.lineTo(_loc4_ + _loc5_,_loc6_);
         _loc9_.lineTo(_loc4_ + _loc5_,_loc6_ + _loc7_);
         _loc9_.lineTo(_loc4_,_loc6_ + _loc7_);
         _loc9_.lineTo(_loc4_,_loc6_);
         _loc9_.endFill();
         this.hitboxDO = this.mcChar.addChild(_loc8_);
      }
      
      public function get Animation() : String
      {
         if(this.WORLD.getAchievement("ia1",21) == 1 || this.WORLD.getAchievement("ia1",22) == 1)
         {
            return this.attacks[Math.round(Math.random() * (this.attacks.length - 1))];
         }
         return this.attacks[Math.round(Math.random())];
      }
   }
}

