package
{
   import flash.display.*;
   import flash.text.*;
   
   public class LPFFrameSimpleText extends LPFFrame
   {
      public var ti:TextField;
      
      private var rootClass:MovieClip;
      
      public function LPFFrameSimpleText()
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
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         positionBy(param1.r);
         this.fDraw();
         positionBy(param1.r);
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
      
      private function fDraw(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.ti.width = w;
            this.ti.autoSize = "left";
            this.ti.wordWrap = true;
            this.ti.htmlText = fData.msg;
         }
         else
         {
            visible = false;
         }
      }
      
      override public function notify(param1:Object) : void
      {
         if("fData" in param1 && "msg" in param1.fData)
         {
            fData = param1.fData;
         }
         if("r" in param1)
         {
            positionBy(param1.r);
         }
         if(param1.eventType == "listItemASel")
         {
            this.fDraw(param1.fData.iSel != null);
         }
      }
   }
}

