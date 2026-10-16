package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.ui.*;
   
   public class LPFFrameQtySelector extends LPFFrame
   {
      public var bar:MovieClip;
      
      public var handle:MovieClip;
      
      public var t1:TextField;
      
      public var t2:TextField;
      
      private var _min:int = 1;
      
      private var _max:int = 1;
      
      private var isMouseDown:Boolean = false;
      
      private var _p:Point;
      
      private var _n:Number = 0;
      
      private var _w:int = 0;
      
      private var _dx:int = 0;
      
      private var rootClass:MovieClip;
      
      protected var eventType:String = "";
      
      public function LPFFrameQtySelector()
      {
         this._p = new Point();
         super();
         visible = false;
         this._w = this.bar.width - this.handle.width;
         this.t1.restrict = "0123456789";
         this.t1.maxChars = 4;
         this.handle.buttonMode = true;
      }
      
      private function get qty_container() : *
      {
         return MovieClip(MovieClip(parent).parent);
      }
      
      public function get _val() : int
      {
         return this.qty_container.iQty;
      }
      
      public function set _val(param1:int) : void
      {
         this.qty_container.iQty = param1;
         this.t1.text = String(param1);
      }
      
      public function get val() : int
      {
         var _loc1_:int = int(this.t1.text);
         if(getLayout().sMode == "shopBuy")
         {
            _loc1_ = fData.iQty * Math.floor(_loc1_ / fData.iQty);
         }
         if(this._val != _loc1_)
         {
            this._val = _loc1_;
         }
         this._val = Math.max(Math.min(this._val,this._max),this._min);
         return this._val;
      }
      
      public function set val(param1:int) : void
      {
         var _loc2_:int = param1;
         if(getLayout().sMode == "shopBuy")
         {
            _loc2_ = fData.iQty * Math.floor(param1 / fData.iQty);
         }
         this._val = Math.max(Math.min(_loc2_,this._max),this._min);
      }
      
      private function updateValues() : void
      {
         if(this._val == this._max)
         {
            this.t1.htmlText = "<font color=\'#FFFFFF\'>" + this._val + "</font>";
         }
         else
         {
            this.t1.htmlText = "<font color=\'#999999\'>" + this._val + "</font>";
         }
         update({"eventType":"updateQtyValue"});
      }
      
      private function updateHandle() : void
      {
         this.handle.x = Math.round(this.bar.x + this._w * (this._val / this._max));
      }
      
      private function onEF(param1:Event) : void
      {
         if(this.isMouseDown)
         {
            this._p.x = stage.mouseX;
            this._p.y = stage.mouseY;
            this._p = globalToLocal(this._p);
            this._p.x -= this._dx;
            this.handle.x = this._n = Math.max(Math.min(this._p.x,this.bar.x + this._w),this.bar.x);
            this._n -= this.bar.x;
            this._n /= this._w;
            this.val = Math.round(this._n * this._max);
            this.updateValues();
         }
      }
      
      private function onDn(param1:MouseEvent) : void
      {
         this.isMouseDown = true;
         this._p.x = stage.mouseX;
         this._p.y = stage.mouseY;
         this._p = globalToLocal(this._p);
         this._dx = this._p.x - this.handle.x;
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         this.isMouseDown = false;
      }
      
      private function onKey(param1:KeyboardEvent) : void
      {
         if(param1.charCode == Keyboard.ENTER || param1.charCode == Keyboard.ESCAPE)
         {
            this.val;
            this.updateValues();
            this.updateHandle();
            this.rootClass.stage.focus = null;
         }
      }
      
      override public function fOpen(param1:Object) : void
      {
         visible = false;
         this.rootClass = MovieClip(stage.getChildAt(0));
         positionBy(param1.r);
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         if("fData" in param1)
         {
            fData = param1.fData;
         }
         getLayout().registerForEvents(this,eventTypes);
         this.fDraw();
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
         addEventListener(Event.ENTER_FRAME,this.onEF,false,0,true);
         this.handle.addEventListener(MouseEvent.MOUSE_DOWN,this.onDn,false,0,true);
         this.t1.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey,false,0,true);
         this.t2.addEventListener(MouseEvent.CLICK,this.onMax,false,0,true);
      }
      
      private function onMax(param1:MouseEvent) : void
      {
         this.val = this._max;
         this.updateValues();
         this.updateHandle();
      }
      
      override public function fClose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEF);
         this.handle.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDn);
         this.t1.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this.t2.removeEventListener(MouseEvent.CLICK,this.onMax);
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
         }
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      protected function fDraw() : void
      {
         if(fData != null)
         {
            if(getLayout().sMode == "shopSell")
            {
               this._val = this._min = 1;
               this._max = this.rootClass.world.maximumShopSells(fData);
            }
            else
            {
               this._val = this._min = fData.iQty;
               this._max = this.rootClass.world.maximumShopBuys(fData);
            }
            this.val;
            this.updateValues();
            this.updateHandle();
            this.t2.htmlText = "<font color=\'#FFFFFF\'>" + this._max + "</font>";
            visible = true;
         }
         else
         {
            visible = false;
         }
      }
      
      override public function notify(param1:Object) : void
      {
         if(param1.eventType == "listItemASel")
         {
            if("fData" in param1 && Boolean(param1.fData.hasOwnProperty("iSel")))
            {
               if(this.rootClass.ui.mcPopup.currentLabel == "EnhShop")
               {
                  return;
               }
               if(getLayout().sMode == "shopBuy" && (this.rootClass.world.maximumShopBuys(param1.fData.iSel) < 2 || param1.fData.iSel.bCoins == 1 && param1.fData.iSel.iCost > 0))
               {
                  fData = null;
               }
               else if(getLayout().sMode == "shopSell" && this.rootClass.world.maximumShopSells(param1.fData.iSel) < 2)
               {
                  fData = null;
               }
               else
               {
                  fData = param1.fData.iSel;
               }
            }
            this.fDraw();
         }
      }
   }
}

