package
{
   import flash.display.*;
   import flash.text.*;
   
   public class LPFFrameBackdrop extends LPFFrame
   {
      public var bg:MovieClip;
      
      private var rootClass:MovieClip;
      
      public function LPFFrameBackdrop()
      {
         super();
         x = 0;
         y = 0;
         fData = {};
      }
      
      override public function fOpen(param1:Object) : void
      {
         this.rootClass = MovieClip(stage.getChildAt(0));
         fData = param1.fData;
         this.positionBy(param1.r);
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         this.fDraw();
         getLayout().registerForEvents(this,eventTypes);
      }
      
      override public function fClose() : void
      {
         fData = {};
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      private function fDraw() : void
      {
      }
      
      override public function notify(param1:Object) : void
      {
         this.fDraw();
      }
      
      override protected function positionBy(param1:Object) : *
      {
         var _loc2_:int = 0;
         w = param1.w;
         h = param1.h;
         this.bg.width = w;
         this.bg.height = h;
         if(param1.x > -1)
         {
            x = param1.x;
         }
         else
         {
            x = int(fParent.w / 2 - width / 2);
         }
         if(param1.y > -1)
         {
            y = param1.y;
         }
         else if(param1.y == -1)
         {
            _loc2_ = fParent.numChildren;
            if(_loc2_ > 1)
            {
               y = fParent.getChildAt(_loc2_ - 2).y + fParent.getChildAt(_loc2_ - 2).height + 10;
            }
            else
            {
               y = 10;
            }
         }
         else
         {
            y = fParent.h + param1.y;
         }
      }
   }
}

