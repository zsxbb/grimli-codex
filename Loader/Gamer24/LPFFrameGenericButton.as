package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class LPFFrameGenericButton extends LPFFrame
   {
      public var btn1:SimpleButton;
      
      public var btn2:SimpleButton;
      
      public var t1:TextField;
      
      public var t2:TextField;
      
      private var rootClass:MovieClip;
      
      protected var eventType:String = "";
      
      public function LPFFrameGenericButton()
      {
         super();
         this.t1.mouseEnabled = false;
         this.t2.mouseEnabled = false;
         addEventListener(MouseEvent.CLICK,this.onBtnClick,false,0,true);
      }
      
      override public function fOpen(param1:Object) : void
      {
         this.rootClass = MovieClip(stage.getChildAt(0));
         positionBy(param1.r);
         sMode = "grey";
         if("fData" in param1)
         {
            fData = param1.fData;
         }
         if("buttonNewEventType" in param1)
         {
            this.eventType = param1.buttonNewEventType;
         }
         if("sMode" in param1)
         {
            sMode = param1.sMode.toLowerCase();
         }
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         this.fDraw();
         getLayout().registerForEvents(this,eventTypes);
      }
      
      override public function fClose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onBtnClick);
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
            if(sMode == "red")
            {
               this.t1.text = "";
               this.t2.text = fData.sText;
               this.btn1.visible = false;
               this.btn2.visible = true;
            }
            else
            {
               this.t1.text = fData.sText;
               this.t2.text = "";
               this.btn1.visible = true;
               this.btn2.visible = false;
            }
            visible = true;
         }
         else
         {
            this.t1.text = "";
            this.t2.text = "";
            this.btn1.visible = false;
            this.btn2.visible = false;
            visible = false;
         }
      }
      
      override public function notify(param1:Object) : void
      {
         if("fData" in param1)
         {
            fData = param1.fData;
         }
         if("buttonNewEventType" in param1)
         {
            this.eventType = param1.buttonNewEventType;
         }
         if("sMode" in param1)
         {
            sMode = param1.sMode.toLowerCase();
         }
         if("r" in param1)
         {
            positionBy(param1.r);
         }
         this.fDraw();
      }
      
      private function onBtnClick(param1:MouseEvent) : void
      {
         if(this.eventType != "none")
         {
            this.rootClass.mixer.playSound("Click");
            if("sModeBroadcast" in fData)
            {
               update({
                  "eventType":this.eventType,
                  "sModeBroadcast":fData.sModeBroadcast
               });
            }
            else
            {
               update({"eventType":this.eventType});
            }
         }
      }
   }
}

