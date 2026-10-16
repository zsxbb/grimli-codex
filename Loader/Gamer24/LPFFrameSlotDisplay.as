package
{
   import flash.display.*;
   import flash.text.*;
   
   public class LPFFrameSlotDisplay extends LPFFrame
   {
      public var ti:TextField;
      
      private var rootClass:MovieClip;
      
      private var isBank:Boolean = false;
      
      public function LPFFrameSlotDisplay()
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
         positionBy(param1.r);
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         if("isBank" in param1)
         {
            this.isBank = param1.isBank == true || param1.isBank == "true" || param1.isBank == 1;
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
         if(this.isBank)
         {
            this.ti.htmlText = "<font color=\'#FFFFFF\'>";
            this.ti.htmlText += fData.avatar.iBankCount;
            this.ti.htmlText += "</font><font color=\'#CCCCCC\'> / </font>";
            this.ti.htmlText += "<font color=\'#FFFFFF\'>";
            this.ti.htmlText += fData.avatar.objData.iBankSlots;
            this.ti.htmlText += " </font><font color=\'#CCCCCC\'>Bank Spaces</font>";
         }
         else
         {
            this.ti.htmlText = "<font color=\'#FFFFFF\'>";
            this.ti.htmlText += fData.list.length;
            this.ti.htmlText += "</font><font color=\'#CCCCCC\'> / </font>";
            this.ti.htmlText += "<font color=\'#FFFFFF\'>";
            this.ti.htmlText += this.rootClass.ui.mcPopup.currentLabel == "HouseInventory" || this.rootClass.ui.mcPopup.currentLabel == "HouseBank" || this.rootClass.ui.mcPopup.currentLabel == "HouseShop" ? fData.iHouseSlots : fData.iBagSlots;
            this.ti.htmlText += " </font><font color=\'#CCCCCC\'>Backpack Spaces</font>";
         }
      }
      
      override public function notify(param1:Object) : void
      {
         this.fDraw();
      }
   }
}

