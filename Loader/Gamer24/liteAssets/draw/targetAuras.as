package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class targetAuras extends Sprite
   {
      protected static const STACKS_GLOW:GlowFilter = new GlowFilter(0,5,0,0,5,5);
      
      protected static const ICON_CT:ColorTransform = new ColorTransform(0.5,0.5,0.5,1,-50,-50,-50,0);
      
      protected var rootClass:MovieClip;
      
      protected var auraContainer:Sprite;
      
      public var icons:Object;
      
      public var auras:Object;
      
      public var scalar:Number = 0.6;
      
      protected var iconPriority:Array;
      
      public function targetAuras(param1:MovieClip)
      {
         super();
         this.visible = true;
         this.name = "targetAuras";
         this.rootClass = param1;
         this.auras = new Object();
         this.auraContainer = new Sprite();
         this.auraContainer.mouseEnabled = this.auraContainer.mouseChildren = false;
         param1.ui.addChild(this.auraContainer);
         param1.ui.setChildIndex(this.auraContainer,0);
         this.auraContainer.name = "tAuraContainer";
         this.auraContainer.x = 320;
         this.auraContainer.y = 95;
         this.x = 85;
         this.y = 93;
      }
      
      public function handleAura(param1:Object) : void
      {
         var _loc2_:Date = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(!this.rootClass.world.myAvatar.target)
         {
            return;
         }
         if(param1.a == null)
         {
            return;
         }
         for each(_loc4_ in param1.a)
         {
            if(this.rootClass.world.myAvatar.target)
            {
               if(this.rootClass.world.myAvatar.target.dataLeaf.MonID)
               {
                  if(_loc4_.tInf != "m:" + this.rootClass.world.myAvatar.target.dataLeaf.MonMapID.toString())
                  {
                     continue;
                  }
               }
               else if(_loc4_.tInf != "p:" + this.rootClass.world.myAvatar.target.dataLeaf.entID.toString())
               {
                  continue;
               }
            }
            if(_loc4_.auras)
            {
               for each(_loc5_ in _loc4_.auras)
               {
                  if(_loc4_.cmd.indexOf("+") > -1)
                  {
                     if(!this.auras.hasOwnProperty(_loc5_.nam))
                     {
                        this.auras[_loc5_.nam] = 1;
                        this.createIconMC(_loc5_.nam,1,_loc5_.icon);
                        if(this.icons != null && this.icons[_loc5_.nam] != null)
                        {
                           this.icons[_loc5_.nam].persistAura = _loc5_.persist == true;
                        }
                        this.coolDownAct(this.icons[_loc5_.nam],_loc5_.dur * 1000,new Date().getTime());
                     }
                     else
                     {
                        this.auras[_loc5_.nam] += 1;
                        if(!this.rootClass.world.myAvatar.target)
                        {
                           this.auras = new Object();
                           this.clearMCs();
                        }
                        for each(_loc6_ in this.rootClass.world.myAvatar.target.dataLeaf.auras)
                        {
                           if(_loc6_.nam == _loc5_.nam)
                           {
                              if(_loc5_.ts != null)
                              {
                                 _loc6_.ts = _loc5_.ts;
                              }
                              this.createIconMC(_loc5_.nam,this.auras[_loc5_.nam]);
                              this.coolDownAct(this.icons[_loc5_.nam],_loc5_.dur * 1000,_loc6_.ts != null ? Number(_loc6_.ts) : Number(new Date().getTime()));
                              break;
                           }
                        }
                     }
                  }
                  else if(_loc4_.cmd.indexOf("-") > -1)
                  {
                     delete this.auras[_loc5_.nam];
                  }
               }
            }
            else if(_loc4_.cmd.indexOf("+") > -1)
            {
               if(!this.auras.hasOwnProperty(_loc4_.aura.nam))
               {
                  this.auras[_loc4_.aura.nam] = 1;
                  this.createIconMC(_loc4_.aura.nam,1,_loc4_.aura.icon);
                  if(this.icons != null && this.icons[_loc4_.aura.nam] != null)
                  {
                     this.icons[_loc4_.aura.nam].persistAura = _loc4_.aura.persist == true;
                  }
                  this.coolDownAct(this.icons[_loc4_.aura.nam],_loc4_.aura.dur * 1000,new Date().getTime());
               }
               else
               {
                  this.auras[_loc4_.aura.nam] += 1;
                  if(!this.rootClass.world.myAvatar.target)
                  {
                     this.auras = new Object();
                     this.clearMCs();
                  }
                  for each(_loc7_ in this.rootClass.world.myAvatar.target.dataLeaf.auras)
                  {
                     if(_loc7_.nam == _loc4_.aura.nam)
                     {
                        if(_loc4_.aura.ts != null)
                        {
                           _loc7_.ts = _loc4_.aura.ts;
                        }
                        this.auras[_loc4_.aura.nam] = 1;
                        this.createIconMC(_loc4_.aura.nam,this.auras[_loc4_.aura.nam]);
                        this.coolDownAct(this.icons[_loc4_.aura.nam],_loc4_.aura.dur * 1000,_loc7_.ts != null ? Number(_loc7_.ts) : Number(new Date().getTime()));
                        break;
                     }
                  }
               }
            }
            else if(_loc4_.cmd.indexOf("-") > -1)
            {
               delete this.auras[_loc4_.aura.nam];
            }
         }
      }
      
      public function createIconMC(param1:String, param2:Number, param3:String = null) : void
      {
         var _loc4_:Class = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Class = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:Shape = null;
         var _loc10_:MovieClip = null;
         if(this.rootClass.world.myAvatar.target == null || Boolean(this.rootClass.litePreference.data.bHideUI))
         {
            return;
         }
         if(this.icons == null)
         {
            this.icons = new Object();
            this.iconPriority = [];
         }
         if(!this.icons.hasOwnProperty(param1))
         {
            if(Boolean(param3) && param3 != "undefined")
            {
               if(param3.indexOf(",") > -1)
               {
                  _loc4_ = this.rootClass.world.getClass(param3.split(",")[param3.split(",").length - 1]) as Class;
               }
               else
               {
                  _loc4_ = this.rootClass.world.getClass(param3) as Class;
               }
            }
            else
            {
               _loc4_ = this.rootClass.world.getClass("isp2") as Class;
            }
            if(_loc4_ == null)
            {
               _loc4_ = this.rootClass.world.getClass("isp2") as Class;
            }
            _loc5_ = new _loc4_();
            if(!ApplicationDomain.currentDomain.hasDefinition("ib3"))
            {
               trace("[Load] ERR missing linkage ib3 createIconMC " + param1);
               return;
            }
            _loc6_ = getDefinitionByName("ib3") as Class;
            _loc7_ = new _loc6_();
            this.icons[param1] = this.auraContainer.addChild(_loc7_);
            this.icons[param1].name = "aura@" + param1;
            this.icons[param1].auraName = param1;
            _loc8_ = new MovieClip();
            _loc9_ = new Shape();
            _loc9_.graphics.beginFill(16777215);
            _loc9_.graphics.drawRect(0,0,23,21);
            _loc9_.graphics.endFill();
            _loc8_.addChild(_loc9_);
            _loc8_.alpha = 0;
            addChild(_loc8_);
            this.icons[param1].hitbox = _loc8_;
            this.icons[param1].hitbox.auraName = param1;
            this.icons[param1].width = 42;
            this.icons[param1].height = 39;
            this.icons[param1].cnt.removeChildAt(0);
            this.icons[param1].scaleX = this.scalar;
            this.icons[param1].scaleY = this.scalar;
            this.icons[param1].tQty.visible = false;
            _loc10_ = this.icons[param1].cnt.addChild(_loc5_);
            if(_loc10_.width > _loc10_.height)
            {
               _loc10_.scaleX = _loc10_.scaleY = 34 / _loc10_.width;
            }
            else
            {
               _loc10_.scaleX = _loc10_.scaleY = 31 / _loc10_.height;
            }
            _loc10_.x = this.icons[param1].bg.width / 2 - _loc10_.width / 2;
            _loc10_.y = this.icons[param1].bg.height / 2 - _loc10_.height / 2;
            this.iconPriority.push(param1);
            if(!this.rootClass.litePreference.data.dOptions["disAuraTips"])
            {
               this.icons[param1].hitbox.addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
               this.icons[param1].hitbox.addEventListener(MouseEvent.MOUSE_OUT,this.onExit,false,0,true);
            }
            else
            {
               this.mouseChildren = this.mouseEnabled = false;
            }
         }
         this.icons[param1].auraStacks = param2;
         this.icons[param1].hitbox.auraStacks = param2;
      }
      
      public function onOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":param1.currentTarget.auraName + " (" + param1.currentTarget.auraStacks + ")"});
      }
      
      public function onExit(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }
      
      public function rearrangeIconMC() : void
      {
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.iconPriority.length)
         {
            if(_loc3_ != 0 && _loc3_ % 4 == 0)
            {
               _loc1_ += 28;
               _loc2_++;
            }
            this.icons[this.iconPriority[_loc3_]].x = 32 * (_loc3_ - 4 * _loc2_) + 3;
            this.icons[this.iconPriority[_loc3_]].y = _loc1_;
            this.icons[this.iconPriority[_loc3_]].hitbox.x = this.icons[this.iconPriority[_loc3_]].x + 2;
            this.icons[this.iconPriority[_loc3_]].hitbox.y = this.icons[this.iconPriority[_loc3_]].y + 1;
            _loc3_++;
         }
      }
      
      public function cleanup() : void
      {
         while(numChildren > 0)
         {
            removeChildAt(numChildren - 1);
         }
         this.rootClass.ui.removeChild(this.rootClass.ui.getChildByName("tAuraContainer"));
         parent.removeChild(this);
      }
      
      public function clearMCs() : void
      {
         if(!this.rootClass.ui)
         {
            return;
         }
         while(numChildren > 0)
         {
            removeChildAt(numChildren - 1);
         }
         while(this.auraContainer.numChildren > 0)
         {
            this.auraContainer.removeChildAt(this.auraContainer.numChildren - 1);
         }
         this.icons = new Object();
         this.iconPriority = [];
      }
      
      public function classChanged() : void
      {
         var _loc3_:String = null;
         if(this.icons == null)
         {
            this.auras = new Object();
            this.clearMCs();
            return;
         }
         var _loc1_:Object = new Object();
         var _loc2_:Array = this.iconPriority.slice();
         for each(_loc3_ in _loc2_)
         {
            if(this.icons[_loc3_] != null && Boolean(this.icons[_loc3_].persistAura))
            {
               _loc1_[_loc3_] = this.auras[_loc3_] != null ? this.auras[_loc3_] : 1;
            }
            else
            {
               this.removeIconMC(_loc3_);
            }
         }
         this.auras = _loc1_;
         this.rearrangeIconMC();
      }
      
      public function removeIconMC(param1:String) : void
      {
         var iMask:* = undefined;
         var auraName:String = param1;
         var icon1:* = this.icons != null ? this.icons[auraName] : null;
         if(icon1 == null)
         {
            return;
         }
         try
         {
            icon1.removeEventListener(Event.ENTER_FRAME,this.countDownAct);
            if(icon1.icon2 != null)
            {
               iMask = icon1.icon2.mask;
               icon1.icon2.mask = null;
               if(iMask != null && iMask.parent != null)
               {
                  iMask.parent.removeChild(iMask);
               }
               stopDrag();
               if(icon1.icon2.parent != null)
               {
                  icon1.icon2.parent.removeChild(icon1.icon2);
               }
               icon1.icon2.bitmapData.dispose();
               icon1.icon2 = null;
            }
            if(icon1.hitbox != null && icon1.hitbox.parent == this)
            {
               removeChild(icon1.hitbox);
            }
            if(icon1.parent == this.auraContainer)
            {
               this.auraContainer.removeChild(icon1);
            }
            if(this.iconPriority.indexOf(auraName) > -1)
            {
               this.iconPriority.splice(this.iconPriority.indexOf(auraName),1);
            }
            delete this.icons[auraName];
         }
         catch(exception:*)
         {
            trace("[UI] ERR target skill auras: " + exception);
         }
      }
      
      public function coolDownAct(param1:*, param2:int = -1, param3:Number = 127) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:MovieClip = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:int = 0;
         var _loc11_:DisplayObject = null;
         var _loc12_:TextField = null;
         var _loc13_:TextFormat = null;
         if(!this.rootClass.world.myAvatar.target || Boolean(this.rootClass.litePreference.data.bHideUI))
         {
            this.auras = new Object();
            this.clearMCs();
            return;
         }
         _loc4_ = param1;
         _loc6_ = null;
         _loc7_ = null;
         if(_loc4_.icon2 == null)
         {
            _loc8_ = new BitmapData(50,50,true,0);
            _loc8_.draw(_loc4_,null,ICON_CT);
            _loc9_ = new Bitmap(_loc8_);
            _loc6_ = _loc4_.addChild(_loc9_);
            _loc4_.icon2 = _loc6_;
            _loc6_.transform = _loc4_.transform;
            _loc6_.scaleX = 1;
            _loc6_.scaleY = 1;
            _loc4_.ts = param3;
            _loc4_.cd = param2;
            _loc4_.auraName = _loc4_.auraName;
            _loc7_ = _loc4_.addChild(new ActMaskReverse()) as MovieClip;
            _loc7_.scaleX = 1;
            _loc7_.scaleY = 1;
            _loc7_.x = int(_loc6_.x + _loc6_.width / 2 - 244 / 2);
            _loc7_.y = int(_loc6_.y + _loc6_.height / 2 - 244 / 2);
            _loc10_ = 0;
            while(_loc10_ < 4)
            {
               _loc7_["e" + _loc10_ + "oy"] = _loc7_["e" + _loc10_].y;
               _loc10_++;
            }
            _loc6_.mask = _loc7_;
            _loc12_ = new TextField();
            _loc13_ = new TextFormat();
            _loc13_.size = 12;
            _loc13_.bold = true;
            _loc13_.font = "Arial";
            _loc13_.color = 16777215;
            _loc13_.align = "right";
            _loc12_.defaultTextFormat = _loc13_;
            _loc4_.stacks = _loc4_.addChild(_loc12_);
            _loc4_.stacks.x = 3.25;
            _loc4_.stacks.y = 28.1;
            _loc4_.stacks.width = 42.7;
            _loc4_.stacks.height = 16.25;
            _loc4_.stacks.mouseEnabled = false;
            _loc4_.stacks.filters = [STACKS_GLOW];
         }
         else
         {
            _loc6_ = _loc4_.icon2;
            _loc7_ = _loc6_.mask;
            _loc4_.ts = param3;
            _loc4_.cd = param2;
            _loc4_.auraName = _loc4_.auraName;
         }
         _loc4_.stacks.text = _loc4_.auraStacks;
         _loc7_.e0.stop();
         _loc7_.e1.stop();
         _loc7_.e2.stop();
         _loc7_.e3.stop();
         _loc4_.removeEventListener(Event.ENTER_FRAME,this.countDownAct);
         _loc4_.addEventListener(Event.ENTER_FRAME,this.countDownAct,false,0,true);
         this.rearrangeIconMC();
      }
      
      public function countDownAct(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         if(!this.rootClass.world.myAvatar.target || Boolean(this.rootClass.litePreference.data.bHideUI))
         {
            this.auras = new Object();
            this.clearMCs();
            return;
         }
         _loc2_ = new Date();
         _loc3_ = _loc2_.getTime();
         _loc4_ = MovieClip(param1.target);
         _loc5_ = _loc4_.icon2;
         _loc6_ = _loc4_.cd + 350;
         _loc7_ = (_loc3_ - _loc4_.ts) / _loc6_;
         _loc8_ = Math.floor(_loc7_ * 4);
         _loc9_ = int(_loc7_ * 360 % 90) + 1;
         if(this.auras[_loc4_.auraName] == null)
         {
            _loc7_ = 1;
         }
         if(_loc7_ < 0.99 && Boolean(this.rootClass.world.myAvatar.target))
         {
            _loc10_ = 0;
            while(_loc10_ < 4)
            {
               if(_loc10_ >= _loc8_)
               {
                  _loc5_.mask["e" + _loc10_].y = _loc5_.mask["e" + _loc10_ + "oy"];
                  if(_loc10_ > _loc8_)
                  {
                     _loc5_.mask["e" + _loc10_].gotoAndStop(0);
                  }
               }
               _loc10_++;
            }
            MovieClip(_loc5_.mask["e" + _loc8_]).gotoAndStop(_loc9_);
         }
         else
         {
            if(!this.rootClass.world.myAvatar.target)
            {
               this.auras = new Object();
               this.clearMCs();
               return;
            }
            this.removeIconMC(_loc4_.auraName);
            this.rearrangeIconMC();
         }
      }
   }
}

