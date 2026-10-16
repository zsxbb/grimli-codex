package
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   
   public class LPFElementScrollBar extends MovieClip
   {
      public var a1:MovieClip;
      
      public var a2:MovieClip;
      
      public var b:MovieClip;
      
      public var h:MovieClip;
      
      public var hit:MovieClip;
      
      private var mDown:Boolean = false;
      
      private var subjectMask:MovieClip;
      
      private var subject:MovieClip;
      
      private var hRun:int = 0;
      
      private var dRun:int = 0;
      
      private var mbY:int = 0;
      
      private var mhY:int = 0;
      
      private var mbD:int = 0;
      
      private var qly:int = 70;
      
      private var qdy:int = 58;
      
      private var defaultCT:ColorTransform;
      
      private var greyCT:ColorTransform;
      
      public var fParent:LPFFrame;
      
      public function LPFElementScrollBar()
      {
         this.defaultCT = new ColorTransform(1,1,1,1,0,0,0,0);
         this.greyCT = new ColorTransform(0.4,0.4,0.4,1,-20,-20,-20,0);
         super();
         this.hit.buttonMode = true;
         this.a1.buttonMode = true;
         this.a2.buttonMode = true;
      }
      
      public function fOpen(param1:Object) : void
      {
         this.subjectMask = param1.subjectMask;
         this.subject = param1.subject;
         this.hRun = this.b.height - this.h.height;
         this.dRun = this.subject.height - this.subjectMask.height + 20;
         if(param1.reset || !("oy" in this.subject) || this.subject.height <= this.subjectMask.height)
         {
            if(this.subject.height <= this.subjectMask.height)
            {
               this.subject.y = 24;
            }
            this.subject.oy = this.subject.y;
            this.h.y = 0;
         }
         this.h.removeEventListener(Event.ENTER_FRAME,this.hEF);
         this.hit.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMDown);
         this.a1.removeEventListener(MouseEvent.CLICK,this.onUpArrowClick);
         this.a2.removeEventListener(MouseEvent.CLICK,this.onDnArrowClick);
         this.hit.alpha = 0;
         if(this.subject.height > this.subjectMask.height)
         {
            this.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
            this.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.onMDown,false,0,true);
            this.a1.addEventListener(MouseEvent.CLICK,this.onUpArrowClick,false,0,true);
            this.a2.addEventListener(MouseEvent.CLICK,this.onDnArrowClick,false,0,true);
            transform.colorTransform = this.defaultCT;
         }
         else
         {
            transform.colorTransform = this.greyCT;
         }
         parent.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,false,0,true);
      }
      
      public function fClose() : void
      {
         this.h.removeEventListener(Event.ENTER_FRAME,this.hEF);
         this.hit.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMDown);
         this.a1.removeEventListener(MouseEvent.CLICK,this.onUpArrowClick);
         this.a2.removeEventListener(MouseEvent.CLICK,this.onDnArrowClick);
         if(parent != null)
         {
            parent.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
         }
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMUp);
         }
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      protected function fDraw() : void
      {
      }
      
      public function subscribeTo(param1:LPFFrame) : void
      {
         this.fParent = param1;
      }
      
      private function onWheel(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1.delta > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.delta)
            {
               this.a1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               _loc2_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < param1.delta * -1)
            {
               this.a2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               _loc3_++;
            }
         }
      }
      
      private function onUpArrowClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 1.1 * this.subject.height / (this.subject.numChildren - 1);
         var _loc3_:int = Math.ceil(this.hRun * (_loc2_ / this.subject.height));
         this.h.y -= _loc3_;
         if(this.h.y + this.h.height > this.b.height)
         {
            this.h.y = int(this.b.height - this.h.height);
         }
         if(this.h.y < 0)
         {
            this.h.y = 0;
         }
      }
      
      private function onDnArrowClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 1.1 * this.subject.height / this.subject.numChildren;
         var _loc3_:int = Math.ceil(this.hRun * (_loc2_ / this.subject.height));
         this.h.y += _loc3_;
         if(this.h.y + this.h.height > this.b.height)
         {
            this.h.y = int(this.b.height - this.h.height);
         }
         if(this.h.y < 0)
         {
            this.h.y = 0;
         }
      }
      
      private function onMDown(param1:MouseEvent) : *
      {
         if(!this.h.hitTestPoint(mouseX,mouseY))
         {
            this.h.y = mouseY - int(this.h.height / 2);
            if(this.h.y + this.h.height > this.b.height)
            {
               this.h.y = int(this.b.height - this.h.height);
            }
            if(this.h.y < 0)
            {
               this.h.y = 0;
            }
         }
         this.mbY = int(mouseY);
         this.mhY = int(this.h.y);
         this.mDown = true;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMUp,false,0,true);
      }
      
      private function onMUp(param1:MouseEvent) : *
      {
         this.mDown = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMUp);
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
         var _loc2_:* = -this.h.y / this.hRun;
         var _loc3_:* = int(_loc2_ * this.dRun) + this.subject.oy;
         if(Math.abs(_loc3_ - this.subject.y) > 0.2)
         {
            this.subject.y += (_loc3_ - this.subject.y) / 1.1;
         }
         else
         {
            this.subject.y = _loc3_;
         }
      }
   }
}

