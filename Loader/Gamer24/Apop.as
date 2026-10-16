package
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.media.SoundTransform;
   import flash.text.*;
   
   public class Apop extends MovieClip
   {
      public var npc:MovieClip;
      
      public var btnClose:MovieClip;
      
      public var nMask:MovieClip;
      
      public var placement:MovieClip;
      
      public var cnt:MovieClip;
      
      public var world:MovieClip;
      
      public var rootClass:MovieClip;
      
      public var o:Object = null;
      
      private var mc:MovieClip;
      
      public function Apop()
      {
         super();
         this.mc = MovieClip(this);
         this.mc.btnClose.addEventListener(MouseEvent.CLICK,this.xClick,false,0,true);
      }
      
      public function update(param1:Object) : *
      {
         var _loc7_:Class = null;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         var _loc10_:Class = null;
         var _loc11_:* = undefined;
         var _loc12_:MovieClip = null;
         var _loc13_:Boolean = false;
         var _loc14_:int = 0;
         this.rootClass = MovieClip(this.stage.getChildAt(0));
         this.world = this.rootClass.world;
         this.o = param1;
         var _loc2_:String = "none";
         var _loc3_:String = "none";
         var _loc4_:String = "none";
         var _loc5_:String = "none";
         var _loc6_:String = "none";
         if("npcLinkage" in this.o)
         {
            _loc2_ = this.o.npcLinkage;
         }
         if("npcEntry" in this.o)
         {
            _loc3_ = this.o.npcEntry;
         }
         if("cnt" in this.o)
         {
            _loc5_ = this.o.cnt;
         }
         if("scene" in this.o)
         {
            _loc4_ = this.o.scene;
         }
         if("frame" in this.o)
         {
            _loc6_ = this.o.frame;
         }
         if(_loc2_ != "none")
         {
            _loc7_ = this.world.ldr_map.contentLoaderInfo.applicationDomain.getDefinition(_loc2_) as Class;
            if(_loc7_ != null)
            {
               if(_loc3_ == "right")
               {
                  _loc8_ = this.mc.npc.npcRight;
                  _loc9_ = this.mc.npc.npcLeft;
                  if(_loc9_.currentLabel != "init")
                  {
                     _loc9_.gotoAndPlay("slide-out");
                  }
                  else
                  {
                     _loc9_.visible = false;
                  }
               }
               else
               {
                  _loc8_ = this.mc.npc.npcLeft;
                  _loc9_ = this.mc.npc.npcRight;
                  if(_loc9_.currentLabel != "init")
                  {
                     _loc9_.gotoAndPlay("slide-out");
                  }
                  else
                  {
                     _loc9_.visible = false;
                  }
               }
               _loc8_.visible = true;
               _loc8_.npc.removeChildAt(0);
               _loc8_.npc.addChild(new _loc7_());
               if(_loc8_.currentLabel != "init")
               {
                  _loc8_.gotoAndPlay("slide-hook");
               }
               else
               {
                  _loc8_.gotoAndPlay("slide-in");
               }
            }
            else
            {
               this.mc.npc.npcRight.visible = false;
               this.mc.npc.npcLeft.visible = false;
            }
         }
         if(_loc5_ != "none")
         {
            _loc10_ = this.world.ldr_map.contentLoaderInfo.applicationDomain.getDefinition(_loc5_) as Class;
            if(_loc10_ != null)
            {
               this.mc.cnt.removeChildAt(0);
               _loc11_ = this.mc.cnt.addChild(new _loc10_());
               _loc11_.name = "cnt";
               if(_loc4_ != "none")
               {
                  _loc11_.gotoAndPlay(_loc4_);
               }
            }
         }
         if(_loc6_ != "none")
         {
            _loc12_ = MovieClip(this.mc.cnt.getChildByName("cnt"));
            _loc13_ = false;
            _loc14_ = 0;
            while(_loc14_ < _loc12_.currentLabels.length)
            {
               if(_loc12_.currentLabels[_loc14_].name == _loc6_)
               {
                  _loc13_ = true;
               }
               _loc14_++;
            }
            if(_loc13_)
            {
               _loc12_.gotoAndPlay(_loc6_);
            }
            else
            {
               this.rootClass.addUpdate("Label " + _loc6_ + " not found!");
            }
         }
         if(this.mc.currentLabel == "init")
         {
            this.mc.gotoAndPlay("in");
         }
      }
      
      public function updateWithClasses(param1:Object, param2:Class, param3:Class) : void
      {
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:* = undefined;
         var _loc10_:MovieClip = null;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         this.rootClass = MovieClip(this.stage.getChildAt(0));
         this.world = this.rootClass.world;
         this.o = param1;
         var _loc4_:String = "none";
         var _loc5_:String = "none";
         var _loc6_:String = "none";
         if("npcEntry" in this.o)
         {
            _loc4_ = this.o.npcEntry;
         }
         if("scene" in this.o)
         {
            _loc5_ = this.o.scene;
         }
         if("frame" in this.o)
         {
            _loc6_ = this.o.frame;
         }
         if(param2 != null)
         {
            if(_loc4_ == "right")
            {
               _loc7_ = this.mc.npc.npcRight;
               _loc8_ = this.mc.npc.npcLeft;
               if(_loc8_.currentLabel != "init")
               {
                  _loc8_.gotoAndPlay("slide-out");
               }
               else
               {
                  _loc8_.visible = false;
               }
            }
            else
            {
               _loc7_ = this.mc.npc.npcLeft;
               _loc8_ = this.mc.npc.npcRight;
               if(_loc8_.currentLabel != "init")
               {
                  _loc8_.gotoAndPlay("slide-out");
               }
               else
               {
                  _loc8_.visible = false;
               }
            }
            _loc7_.visible = true;
            _loc7_.npc.removeChildAt(0);
            _loc7_.npc.addChild(new param2());
            if(_loc7_.currentLabel != "init")
            {
               _loc7_.gotoAndPlay("slide-hook");
            }
            else
            {
               _loc7_.gotoAndPlay("slide-in");
            }
         }
         else
         {
            this.mc.npc.npcRight.visible = false;
            this.mc.npc.npcLeft.visible = false;
         }
         if(param3 != null)
         {
            this.mc.cnt.removeChildAt(0);
            _loc9_ = this.mc.cnt.addChild(new param3());
            _loc9_.name = "cnt";
            if(_loc5_ != "none")
            {
               _loc9_.gotoAndPlay(_loc5_);
            }
         }
         if(_loc6_ != "none")
         {
            _loc10_ = MovieClip(this.mc.cnt.getChildByName("cnt"));
            _loc11_ = false;
            _loc12_ = 0;
            while(_loc12_ < _loc10_.currentLabels.length)
            {
               if(_loc10_.currentLabels[_loc12_].name == _loc6_)
               {
                  _loc11_ = true;
               }
               _loc12_++;
            }
            if(_loc11_)
            {
               _loc10_.gotoAndPlay(_loc6_);
            }
            else
            {
               this.rootClass.addUpdate("Label " + _loc6_ + " not found!");
            }
         }
         if(this.mc.currentLabel == "init")
         {
            this.mc.gotoAndPlay("in");
         }
      }
      
      public function fClose() : void
      {
         var _loc1_:MovieClip = MovieClip(this.mc.cnt.getChildByName("cnt"));
         _loc1_.soundTransform = new SoundTransform(0);
         _loc1_.stop();
         this.mc.btnClose.removeEventListener(MouseEvent.CLICK,this.xClick);
         this.mc.parent.removeChild(this);
      }
      
      private function xClick(param1:MouseEvent) : void
      {
         this.fClose();
      }
      
      public function exit() : void
      {
         this.fClose();
      }
      
      public function warn(param1:String) : *
      {
         trace("");
         trace("*^*^* NPC DIALOGUE ERROR *^*^*");
         trace("  > " + param1);
         trace("");
      }
   }
}

