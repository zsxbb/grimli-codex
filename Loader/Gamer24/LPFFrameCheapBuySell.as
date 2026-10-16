package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class LPFFrameCheapBuySell extends LPFFrame
   {
      public var btnBuy:MovieClip;
      
      public var btnSell:MovieClip;
      
      private var rootClass:MovieClip;
      
      protected var eventType:String = "";
      
      public function LPFFrameCheapBuySell()
      {
         super();
         this.btnBuy.addEventListener(MouseEvent.CLICK,this.onBtnBuyClick,false,0,true);
         this.btnBuy.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         this.btnBuy.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         this.btnSell.addEventListener(MouseEvent.CLICK,this.onBtnSellClick,false,0,true);
         this.btnSell.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         this.btnSell.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         this.btnBuy.buttonMode = true;
         this.btnSell.buttonMode = true;
         this.btnBuy.sel = this.btnBuy.bg2.visible = this.btnBuy.bg3.visible = false;
         this.btnSell.sel = this.btnSell.bg2.visible = this.btnSell.bg3.visible = false;
      }
      
      override public function fOpen(param1:Object) : void
      {
         this.rootClass = MovieClip(stage.getChildAt(0));
         positionBy(param1.r);
         if("eventType" in param1)
         {
            this.eventType = param1.eventType;
         }
         if("openOn" in param1)
         {
            if(param1.openOn == "shopBuy")
            {
               this.select(this.btnBuy);
            }
            if(param1.openOn == "shopSell")
            {
               this.select(this.btnSell);
            }
         }
      }
      
      override public function fClose() : void
      {
         this.btnBuy.removeEventListener(MouseEvent.CLICK,this.onBtnBuyClick);
         this.btnBuy.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.btnBuy.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.btnSell.removeEventListener(MouseEvent.CLICK,this.onBtnSellClick);
         this.btnSell.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.btnSell.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      protected function fDraw() : void
      {
      }
      
      override public function notify(param1:Object) : void
      {
      }
      
      private function onBtnSellClick(param1:MouseEvent) : void
      {
         if(!this.btnSell.sel)
         {
            this.rootClass.mixer.playSound("Click");
            this.unselect(this.btnBuy);
            this.select(this.btnSell);
            update({
               "eventType":this.eventType,
               "sModeBroadcast":"shopSell"
            });
         }
      }
      
      private function onBtnBuyClick(param1:MouseEvent) : void
      {
         if(!this.btnBuy.sel)
         {
            this.rootClass.mixer.playSound("Click");
            this.unselect(this.btnSell);
            this.select(this.btnBuy);
            update({
               "eventType":this.eventType,
               "sModeBroadcast":"shopBuy"
            });
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(!_loc2_.sel)
         {
            _loc2_.bg2.visible = true;
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(!_loc2_.sel)
         {
            _loc2_.bg2.visible = false;
         }
      }
      
      private function select(param1:MovieClip) : void
      {
         param1.sel = true;
         param1.bg2.visible = false;
         param1.bg3.visible = true;
         setChildIndex(param1,1);
      }
      
      private function unselect(param1:MovieClip) : void
      {
         param1.sel = false;
         param1.bg2.visible = false;
         param1.bg3.visible = false;
         setChildIndex(param1,0);
      }
   }
}

