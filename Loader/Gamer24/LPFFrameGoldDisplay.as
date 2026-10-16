package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class LPFFrameGoldDisplay extends LPFFrame
   {
      public var btnHelp:MovieClip;
      
      public var mcCoins:MovieClip;
      
      public var mcGold:MovieClip;
      
      private var rootClass:MovieClip;
      
      public function LPFFrameGoldDisplay()
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
         this.fDraw();
         positionBy(param1.r);
         getLayout().registerForEvents(this,eventTypes);
         this.mcCoins.addEventListener(MouseEvent.MOUSE_OVER,this.onCoinsTTOver,false,0,true);
         this.mcCoins.addEventListener(MouseEvent.MOUSE_OUT,this.onTTOut,false,0,true);
         this.mcGold.addEventListener(MouseEvent.MOUSE_OVER,this.onGoldTTOver,false,0,true);
         this.mcGold.addEventListener(MouseEvent.MOUSE_OUT,this.onTTOut,false,0,true);
         this.btnHelp.addEventListener(MouseEvent.CLICK,this.onHelpClick,false,0,true);
         this.btnHelp.addEventListener(MouseEvent.MOUSE_OVER,this.onHelpTTOver,false,0,true);
         this.btnHelp.addEventListener(MouseEvent.MOUSE_OUT,this.onTTOut,false,0,true);
      }
      
      override public function fClose() : void
      {
         this.mcCoins.removeEventListener(MouseEvent.MOUSE_OVER,this.onCoinsTTOver);
         this.mcCoins.removeEventListener(MouseEvent.MOUSE_OUT,this.onTTOut);
         this.mcGold.removeEventListener(MouseEvent.MOUSE_OVER,this.onGoldTTOver);
         this.mcGold.removeEventListener(MouseEvent.MOUSE_OUT,this.onTTOut);
         this.btnHelp.removeEventListener(MouseEvent.CLICK,this.onHelpClick);
         this.btnHelp.removeEventListener(MouseEvent.MOUSE_OVER,this.onHelpTTOver);
         this.btnHelp.removeEventListener(MouseEvent.MOUSE_OUT,this.onTTOut);
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      private function fDraw() : void
      {
         this.mcGold.ti.htmlText = "<font color=\'#FFFFFF\'>" + this.rootClass.strNumWithCommas(fData.intGold) + "</font><font color=\'#E0B300\'>g</font>";
         this.mcCoins.ti.text = this.rootClass.strNumWithCommas(fData.intCoins);
         this.mcGold.hit.width = this.mcGold.ti.x + this.mcGold.ti.textWidth + 2;
         this.mcGold.hit.alpha = 0;
         this.mcCoins.hit.width = this.mcCoins.ti.x + this.mcCoins.ti.textWidth + 2;
         this.mcCoins.hit.alpha = 0;
         this.btnHelp.x = this.mcCoins.x + this.mcCoins.hit.width + 20;
      }
      
      override public function notify(param1:Object) : void
      {
         if(param1.eventType == "refreshCoins")
         {
            this.fDraw();
         }
      }
      
      private function onHelpClick(param1:MouseEvent) : void
      {
         this.onTTOut();
         update({"eventType":"helpAC"});
      }
      
      private function onHelpTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"How do I get Adventure Coins?"});
      }
      
      private function onCoinsTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"Adventure Coins"});
      }
      
      private function onGoldTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"Gold"});
      }
      
      private function onTTOut(param1:MouseEvent = null) : void
      {
         this.rootClass.ui.ToolTip.close();
      }
   }
}

