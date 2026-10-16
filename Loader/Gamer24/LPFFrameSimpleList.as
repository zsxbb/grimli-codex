package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import liteAssets.draw.*;
   
   public class LPFFrameSimpleList extends LPFFrame
   {
      public var bg:MovieClip;
      
      public var iList:MovieClip;
      
      public var ti:TextField;
      
      private var rootClass:MovieClip;
      
      private var r:Object;
      
      internal var maskMC:Shape;
      
      internal var scrollMC:mergeScroll;
      
      internal var mDown:Boolean = false;
      
      internal var hRun:int = 0;
      
      internal var dRun:int = 0;
      
      internal var mbY:int = 0;
      
      internal var mhY:int = 0;
      
      internal var mbD:int = 0;
      
      public function LPFFrameSimpleList()
      {
         super();
         x = 0;
         y = 0;
         fData = null;
      }
      
      override public function fOpen(param1:Object) : void
      {
         this.rootClass = MovieClip(stage.getChildAt(0));
         if("fData" in param1)
         {
            fData = param1.fData;
         }
         this.r = param1.r;
         w = int(this.r.w);
         this.ti.autoSize = "left";
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         if("msg" in fData && fData.msg.length > 0)
         {
            this.ti.htmlText = fData.msg;
         }
         this.fDraw();
         positionBy(this.r);
         getLayout().registerForEvents(this,eventTypes);
      }
      
      override public function fClose() : void
      {
         fData = null;
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      private function fDraw() : void
      {
         var _loc1_:LPFElementSimpleItem = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         while(this.iList.numChildren > 0)
         {
            this.iList.removeChildAt(0);
         }
         if(this.scrollMC)
         {
            this.scrollMC.visible = false;
            this.scrollMC.h.y = 0;
            this.iList.y = 0;
            this.bg.height = this.iList.height + 1;
            this.ti.y = this.bg.height + 2;
            this.scrollMC.hit.removeEventListener(MouseEvent.MOUSE_DOWN,this.merge_scrDown);
            this.scrollMC.h.removeEventListener(Event.ENTER_FRAME,this.merge_hEF);
            this.iList.removeEventListener(Event.ENTER_FRAME,this.merge_dEF);
            removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMergeBoxScroll);
            removeChild(this.scrollMC);
            removeChild(this.maskMC);
            this.scrollMC = null;
            this.maskMC = null;
            this.iList.mask = null;
         }
         if(fData != null && fData.turnin != null)
         {
            _loc4_ = fData.turnin;
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc5_ = _loc4_[_loc6_];
               _loc1_ = new LPFElementSimpleItem();
               _loc2_ = this.iList.addChild(_loc1_);
               _loc1_.fOpen({"fData":_loc5_});
               if(_loc6_ > 0)
               {
                  _loc3_ = this.iList.getChildAt(_loc6_ - 1);
                  _loc2_.y = _loc3_.y + _loc3_.height;
               }
               _loc2_.x = int(w / 2 - _loc2_.width / 2);
               _loc6_++;
            }
            this.bg.height = int(this.iList.height + this.iList.y * 2) + 1;
            this.bg.width = int(w);
            this.ti.width = int(w - 2);
            if(this.ti.htmlText.length > 0)
            {
               this.ti.y = this.bg.height + 2;
               this.ti.visible = true;
            }
            else
            {
               this.ti.visible = false;
            }
            visible = true;
            if(_loc4_.length >= 5)
            {
               this.bg.height = 166;
               this.maskMC = new Shape();
               this.maskMC.graphics.beginFill(0);
               this.maskMC.graphics.drawRect(0,0,this.bg.width,this.bg.height);
               this.maskMC.graphics.endFill();
               addChild(this.maskMC);
               this.maskMC.name = "maskMC";
               this.maskMC.x = this.bg.x;
               this.maskMC.y = this.bg.y;
               this.iList.mask = this.maskMC;
               this.scrollMC = new mergeScroll();
               addChild(this.scrollMC);
               this.scrollMC.name = "scrollMC";
               this.scrollMC.x = this.bg.x + this.bg.width - this.scrollMC.width / 2;
               this.scrollMC.y = this.bg.y + 5;
               this.scrollMC.height = this.bg.height - 10;
               this.scrollMC.h.height /= 2;
               this.hRun = this.scrollMC.b.height - this.scrollMC.h.height;
               this.dRun = int(this.iList.height + this.iList.y * 2) + 1 - this.maskMC.height + 5;
               this.scrollMC.h.y = 0;
               this.iList.y = 0;
               this.iList.oy = this.iList.y;
               this.scrollMC.hit.alpha = 0;
               this.mDown = false;
               this.scrollMC.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.merge_scrDown,false,0,true);
               this.scrollMC.h.addEventListener(Event.ENTER_FRAME,this.merge_hEF,false,0,true);
               this.iList.addEventListener(Event.ENTER_FRAME,this.merge_dEF,false,0,true);
               this.ti.y = this.bg.height + 2;
               addEventListener(MouseEvent.MOUSE_WHEEL,this.onMergeBoxScroll,false,0,true);
            }
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
            fData = null;
            if(param1.fData != null && param1.fData.oSel != null)
            {
               fData = param1.fData.oSel;
            }
            this.fDraw();
            positionBy(this.r);
         }
         if(param1.eventType == "refreshItems")
         {
            this.fDraw();
            positionBy(this.r);
         }
         if(param1.eventType == "updateQtyValue")
         {
            this.fDraw();
            positionBy(this.r);
         }
      }
      
      private function merge_scrDown(param1:MouseEvent) : *
      {
         this.mbY = int(param1.currentTarget.parent.mouseY);
         this.mhY = int(MovieClip(param1.currentTarget.parent).h.y);
         this.mDown = true;
         this.rootClass.stage.addEventListener(MouseEvent.MOUSE_UP,this.merge_scrUp,false,0,true);
      }
      
      private function merge_scrUp(param1:MouseEvent) : *
      {
         this.mDown = false;
         this.rootClass.stage.removeEventListener(MouseEvent.MOUSE_UP,this.merge_scrUp);
      }
      
      private function merge_hEF(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(this.mDown)
         {
            _loc2_ = MovieClip(param1.currentTarget.parent);
            this.mbD = int(param1.currentTarget.parent.mouseY) - this.mbY;
            _loc2_.h.y = this.mhY + this.mbD;
            if(_loc2_.h.y + _loc2_.h.height > _loc2_.b.height)
            {
               _loc2_.h.y = int(_loc2_.b.height - _loc2_.h.height);
            }
            if(_loc2_.h.y < 0)
            {
               _loc2_.h.y = 0;
            }
         }
      }
      
      private function merge_dEF(param1:Event) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget.parent).getChildByName("scrollMC");
         var _loc3_:* = MovieClip(param1.currentTarget);
         var _loc4_:* = -_loc2_.h.y / this.hRun;
         var _loc5_:* = int(_loc4_ * this.dRun) + _loc3_.oy;
         if(Math.abs(_loc5_ - _loc3_.y) > 0.2)
         {
            _loc3_.y += (_loc5_ - _loc3_.y) / 4;
         }
         else
         {
            _loc3_.y = _loc5_;
         }
      }
      
      public function onMergeBoxScroll(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget.getChildByName("scrollMC"));
         _loc2_.h.y += param1.delta * -1 * 6;
         if(_loc2_.h.y < 0)
         {
            _loc2_.h.y = 0;
         }
         if(_loc2_.h.y + _loc2_.h.height > _loc2_.b.height)
         {
            _loc2_.h.y = int(_loc2_.b.height - _loc2_.h.height);
         }
      }
   }
}

