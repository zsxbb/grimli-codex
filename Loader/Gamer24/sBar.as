package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class sBar extends MovieClip
   {
      public var h:MovieClip;
      
      public var b:MovieClip;
      
      public var hit:MovieClip;
      
      private var hRun:Number;
      
      private var dRun:Number;
      
      private var mbY:int;
      
      private var mhY:int;
      
      private var display:MovieClip;
      
      private var rootClass:MovieClip;
      
      private var bMask:MovieClip;
      
      private var scrTgt:MovieClip;
      
      private var mbD:int;
      
      private var mDown:Boolean = false;
      
      private var oy:Number;
      
      public function sBar(param1:MovieClip, param2:MovieClip, param3:MovieClip)
      {
         super();
         this.height = param2.height - 10;
         this.display = param1;
         this.bMask = param2;
         this.display.mask = this.bMask;
         this.h.y = 0;
         this.visible = false;
         this.hit.alpha = 0;
         this.rootClass = param3;
         if(this.display.height > this.b.height)
         {
            this.h.height = int(this.b.height / this.display.height * this.b.height);
            this.hRun = this.b.height - this.h.height;
            this.dRun = this.display.height - (this.bMask.height - 95) - this.b.height + 10;
            this.oy = this.display.y = this.bMask.y;
            this.visible = true;
            this.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.scrDown,false,0,true);
            this.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
            this.display.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
            this.rootClass.addEventListener(MouseEvent.MOUSE_UP,this.scrUp,false,0,true);
            this.rootClass.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheel,false,0,true);
         }
      }
      
      private function mouseWheel(param1:MouseEvent) : void
      {
         this.h.y -= param1.delta;
         if(this.h.y + this.h.height > this.b.height)
         {
            this.h.y = int(this.b.height - this.h.height);
         }
         if(this.h.y < 0)
         {
            this.h.y = 0;
         }
      }
      
      private function scrDown(param1:MouseEvent) : *
      {
         this.mbY = int(mouseY);
         this.mhY = int(this.h.y);
         this.mDown = true;
      }
      
      private function scrUp(param1:MouseEvent) : *
      {
         this.mDown = false;
      }
      
      private function hEF(param1:Event) : *
      {
         if(this.mDown)
         {
            this.mbD = int(mouseY) - this.mbY;
            this.h.y = this.mhY + this.mbD;
            if(this.h.y + this.h.height > this.b.height)
            {
               this.h.y = int(this.b.height - this.h.height);
            }
            if(this.h.y < 0)
            {
               this.h.y = 0;
            }
         }
      }
      
      private function dEF(param1:Event) : *
      {
         var _loc2_:Number = -this.h.y / this.hRun;
         var _loc3_:Number = int(_loc2_ * this.dRun) + this.oy;
         if(Math.abs(_loc3_ - this.display.y) > 0.2)
         {
            this.display.y += _loc3_ - this.display.y >> 2;
         }
         else
         {
            this.display.y = _loc3_;
         }
      }
      
      public function Destroy() : void
      {
         this.hit.removeEventListener(MouseEvent.MOUSE_DOWN,this.scrDown);
         this.h.removeEventListener(Event.ENTER_FRAME,this.hEF);
         this.display.removeEventListener(Event.ENTER_FRAME,this.dEF);
         this.rootClass.removeEventListener(MouseEvent.MOUSE_UP,this.scrUp);
      }
   }
}

