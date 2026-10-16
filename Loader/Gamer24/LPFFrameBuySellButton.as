package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class LPFFrameBuySellButton extends LPFFrame
   {
      public var btn:MovieClip;
      
      public var ti:TextField;
      
      private var rootClass:MovieClip;
      
      protected var eventType:String = "";
      
      public function LPFFrameBuySellButton()
      {
         super();
         this.ti.mouseEnabled = false;
         this.btn.addEventListener(MouseEvent.CLICK,this.onBtnClick,false,0,true);
      }
      
      override public function fOpen(param1:Object) : void
      {
         this.rootClass = MovieClip(stage.getChildAt(0));
         positionBy(param1.r);
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         if("eventType" in param1)
         {
            this.eventType = param1.eventType;
         }
         if("fData" in param1)
         {
            fData = param1.fData;
         }
         this.fDraw();
         getLayout().registerForEvents(this,eventTypes);
      }
      
      override public function fClose() : void
      {
         this.btn.removeEventListener(MouseEvent.CLICK,this.onBtnClick);
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      protected function fDraw() : void
      {
         if(fData != null && fData.sText != "")
         {
            this.ti.text = fData.sText;
            visible = true;
         }
         else
         {
            this.ti.text = "";
            visible = false;
         }
      }
      
      override public function notify(param1:Object) : void
      {
         if("buttonNewEventType" in param1)
         {
            this.eventType = param1.buttonNewEventType;
         }
         if("fData" in param1)
         {
            fData = param1.fData;
         }
         this.fDraw();
      }
      
      private function onBtnClick(param1:MouseEvent) : void
      {
         this.rootClass.mixer.playSound("Click");
         update({
            "eventType":this.eventType,
            "sModeBroadcast":fData.sModeBroadcast
         });
      }
   }
}

