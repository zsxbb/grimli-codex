package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class QTrackerMC extends MovieClip
   {
      public var bMask:MovieClip;
      
      public var bg:MovieClip;
      
      public var close:SimpleButton;
      
      public var scr:MovieClip;
      
      public var txtDetail:TextField;
      
      public var rootClass:MovieClip;
      
      internal var mDown:Boolean = false;
      
      internal var mbY:*;
      
      internal var mhY:*;
      
      internal var drag:Object;
      
      public function QTrackerMC()
      {
         this.drag = new Object();
         super();
         visible = false;
      }
      
      private function initOpen() : void
      {
         this.rootClass = MovieClip(this.stage.getChildAt(0));
         this.scr.hit.alpha = 0;
         this.txtDetail.autoSize = "left";
         this.close.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver,false,0,true);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMoveClick,false,0,true);
      }
      
      private function onCloseClick(param1:MouseEvent) : void
      {
         visible = false;
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this.bg.visible = true;
         this.scr.visible = this.txtDetail.height > this.scr.height;
         this.close.visible = true;
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this.bg.visible = false;
         this.scr.visible = false;
         this.close.visible = false;
      }
      
      public function updateQuest() : void
      {
         var _loc2_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         this.txtDetail.htmlText = "";
         var _loc1_:int = 0;
         for(_loc2_ in this.rootClass.world.questTree)
         {
            _loc4_ = this.rootClass.world.questTree[_loc2_];
            if(_loc4_.status != null)
            {
               _loc1_++;
               this.txtDetail.htmlText += "<font color=\'#00CC00\'><b>" + _loc4_.sName + "</b></font>";
               if(_loc4_.turnin != null && _loc4_.turnin.length > 0)
               {
                  _loc5_ = "";
                  _loc6_ = 0;
                  while(_loc6_ < _loc4_.turnin.length)
                  {
                     _loc7_ = this.rootClass.world.invTree[_loc4_.turnin[_loc6_].ItemID];
                     _loc8_ = _loc7_.sName;
                     _loc9_ = int(_loc4_.turnin[_loc6_].iQty);
                     if(_loc6_ > 0)
                     {
                        _loc5_ += ",<br>";
                     }
                     _loc5_ += "    " + _loc8_ + " " + _loc7_.iQty + "/" + _loc9_;
                     _loc6_++;
                  }
                  this.txtDetail.htmlText += _loc5_;
               }
            }
         }
         if(_loc1_ == 0)
         {
            this.txtDetail.htmlText = "You are not on any quest!";
         }
         this.close.x = this.txtDetail.x + this.txtDetail.textWidth + 10;
         this.bg.width = this.close.x + 20;
         var _loc3_:* = this.txtDetail.y + this.txtDetail.textHeight + 10;
         if(_loc3_ > 108)
         {
            _loc3_ = 108;
         }
         this.bg.height = _loc3_;
         if(this.txtDetail.height > this.scr.height)
         {
            this.scr.visible = true;
            this.scr.x = this.close.x + 5;
            this.scr.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.scrDown,false,0,true);
         }
         else
         {
            this.scr.visible = false;
         }
      }
      
      private function scrDown(param1:MouseEvent) : *
      {
         this.mDown = true;
         this.mbY = int(mouseY);
         this.mhY = int(MovieClip(param1.currentTarget.parent).h.y);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.scrUp,false,0,true);
         this.scr.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
      }
      
      private function scrUp(param1:MouseEvent) : *
      {
         this.mDown = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.scrUp);
         this.scr.h.addEventListener(Event.ENTER_FRAME,this.hEF);
      }
      
      private function hEF(param1:Event) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this.mDown)
         {
            this.scr.h.y = this.mhY + (int(mouseY) - this.mbY);
            if(this.scr.h.y + this.scr.h.height > this.scr.b.height)
            {
               this.scr.h.y = int(this.scr.b.height - this.scr.h.height);
            }
            if(this.scr.h.y < 0)
            {
               this.scr.h.y = 0;
            }
            _loc2_ = -this.scr.h.y / (this.scr.b.height - this.scr.h.height);
            _loc3_ = this.txtDetail.height - this.scr.b.height;
            _loc4_ = int(_loc2_ * _loc3_) + 22;
            this.txtDetail.y = _loc4_;
         }
      }
      
      public function toggle() : void
      {
         if(this.rootClass.litePreference.data.bDisQTracker)
         {
            visible = false;
            return;
         }
         if(visible)
         {
            this.scr.hit.removeEventListener(MouseEvent.MOUSE_DOWN,this.scrDown);
            this.scr.h.removeEventListener(Event.ENTER_FRAME,this.hEF);
            if(stage)
            {
               stage.removeEventListener(MouseEvent.MOUSE_UP,this.scrUp);
            }
            if(stage)
            {
               stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMoveRelease);
            }
            this.removeEventListener(Event.ENTER_FRAME,this.onMoveEnterFrame);
         }
         visible = !visible;
         if(visible)
         {
            this.updateQuest();
         }
      }
      
      public function onMoveClick(param1:MouseEvent) : void
      {
         if(param1.target != this.close && param1.target != this.scr.hit)
         {
            this.drag.ox = this.x;
            this.drag.oy = this.y;
            this.drag.mox = stage.mouseX;
            this.drag.moy = stage.mouseY;
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onMoveRelease,false,0,true);
            this.addEventListener(Event.ENTER_FRAME,this.onMoveEnterFrame,false,0,true);
         }
      }
      
      public function onMoveRelease(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMoveRelease);
         this.removeEventListener(Event.ENTER_FRAME,this.onMoveEnterFrame);
      }
      
      public function onMoveEnterFrame(param1:Event) : *
      {
         this.x = this.drag.ox + (stage.mouseX - this.drag.mox);
         if(this.x < 0)
         {
            this.x = 0;
         }
         if(this.x + this.bg.width > 960)
         {
            this.x = 960 - this.bg.width;
         }
         this.y = this.drag.oy + (stage.mouseY - this.drag.moy);
         if(this.y < 0)
         {
            this.y = 0;
         }
         if(this.y + this.bg.height > 500)
         {
            this.y = 500 - this.bg.height;
         }
      }
   }
}

