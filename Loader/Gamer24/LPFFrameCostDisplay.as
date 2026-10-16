package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class LPFFrameCostDisplay extends LPFFrame
   {
      public var bg:MovieClip;
      
      public var mcCoins:MovieClip;
      
      public var mcGold:MovieClip;
      
      private var rootClass:MovieClip;
      
      private var r:Object;
      
      public function LPFFrameCostDisplay()
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
         if("r" in param1)
         {
            this.r = param1.r;
         }
         this.fDraw();
         this.positionBy(this.r);
         getLayout().registerForEvents(this,eventTypes);
         this.mcCoins.addEventListener(MouseEvent.MOUSE_OVER,this.onCoinsTTOver,false,0,true);
         this.mcCoins.addEventListener(MouseEvent.MOUSE_OUT,this.onTTOut,false,0,true);
         this.mcGold.addEventListener(MouseEvent.MOUSE_OVER,this.onGoldTTOver,false,0,true);
         this.mcGold.addEventListener(MouseEvent.MOUSE_OUT,this.onTTOut,false,0,true);
         this.mcGold.hit.alpha = 0;
         this.mcCoins.hit.alpha = 0;
      }
      
      override public function fClose() : void
      {
         this.mcCoins.removeEventListener(MouseEvent.MOUSE_OVER,this.onCoinsTTOver);
         this.mcCoins.removeEventListener(MouseEvent.MOUSE_OUT,this.onTTOut);
         this.mcGold.removeEventListener(MouseEvent.MOUSE_OVER,this.onGoldTTOver);
         this.mcGold.removeEventListener(MouseEvent.MOUSE_OUT,this.onTTOut);
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      private function get qty_parent() : *
      {
         return !!MovieClip(MovieClip(parent).parent).iQty ? MovieClip(MovieClip(parent).parent) : MovieClip(parent);
      }
      
      private function fDraw() : void
      {
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         visible = false;
         var _loc1_:* = getLayout().sMode == "shopSell";
         var _loc2_:Number = 0;
         var _loc3_:String = "#FFFFFF";
         if(getLayout().sMode.indexOf("shop") > -1 && fData != null)
         {
            visible = true;
            this.mcGold.visible = false;
            this.mcCoins.visible = false;
            this.mcGold.x = 0;
            this.mcCoins.x = 0;
            this.mcGold.ti.text = "";
            this.mcCoins.ti.text = "";
            _loc2_ = Number(fData.iCost);
            if(this.qty_parent.eSel != null && getLayout().sMode == "shopBuy" && Boolean(getLayout().hasOwnProperty("splitPanel")))
            {
               if(getLayout().splitPanel.visible)
               {
                  _loc4_ = int(getLayout().splitPanel.frames[2].mc.getSelected());
                  if(_loc4_ > 1)
                  {
                     _loc2_ *= _loc4_;
                  }
               }
            }
            else if(getLayout().sMode.indexOf("shop") > -1 && this.qty_parent && this.hasSlider() && this.qty_parent.iQty > 1)
            {
               if(fData.sES != "ar")
               {
                  _loc2_ *= this.qty_parent.iQty;
               }
            }
            if(_loc2_ > 0)
            {
               if("bCoins" in fData && fData.bCoins == 1)
               {
                  if(_loc1_)
                  {
                     _loc5_ = new Date().getTime();
                     fData.iHrs = (_loc5_ - fData.tPurchase) / (1000 * 60 * 60);
                     if(fData.ItemID == 8939)
                     {
                        _loc2_ = Math.ceil(_loc2_ / 4);
                     }
                     else if(fData.iHrs < 24)
                     {
                        _loc2_ = Math.ceil(_loc2_ * 9 / 10);
                     }
                     else
                     {
                        _loc2_ = Math.ceil(_loc2_ / 4);
                     }
                  }
                  else if(_loc2_ > this.rootClass.world.myAvatar.objData.intCoins)
                  {
                     _loc3_ = "#FF0000";
                  }
                  this.mcCoins.ti.htmlText = "<font color=\'" + _loc3_ + "\'>" + this.rootClass.strNumWithCommas(_loc2_) + "</font>";
                  this.mcCoins.visible = true;
               }
               else
               {
                  if(_loc1_)
                  {
                     _loc2_ = Math.ceil(_loc2_ / 4);
                  }
                  else if(_loc2_ > this.rootClass.world.myAvatar.objData.intGold)
                  {
                     _loc3_ = "#FF0000";
                  }
                  this.mcGold.ti.htmlText = "<font color=\'" + _loc3_ + "\'>" + this.rootClass.strNumWithCommas(_loc2_) + "</font>";
                  this.mcGold.visible = true;
               }
               this.mcGold.hit.width = this.mcGold.ti.x + this.mcGold.ti.textWidth + 2;
               this.mcCoins.hit.width = this.mcCoins.ti.x + this.mcCoins.ti.textWidth + 2;
               if(this.rootClass.ui.mcPopup.currentLabel == "MergeShop" && Boolean(this.hasSlider()))
               {
                  this.positionBy({
                     "x":450,
                     "y":-102,
                     "w":-1,
                     "h":-1,
                     "xPosRule":"centerOnX"
                  });
               }
               else if(this.rootClass.ui.mcPopup.currentLabel == "MergeShop" && !this.hasSlider())
               {
                  this.positionBy(this.r);
               }
               visible = true;
            }
            else
            {
               visible = false;
            }
         }
      }
      
      private function hasSlider() : Boolean
      {
         if(getLayout().sMode == "shopBuy" && (this.rootClass.world.maximumShopBuys(fData) < 2 || fData.bCoins == 1 && fData.iCost > 0))
         {
            return false;
         }
         if(getLayout().sMode == "shopSell" && this.rootClass.world.maximumShopSells(fData) < 2)
         {
            return false;
         }
         return true;
      }
      
      override protected function positionBy(param1:Object) : *
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         if(this.mcGold.visible)
         {
            this.bg.width = this.mcGold.x + this.mcGold.ti.x + this.mcGold.ti.textWidth + 10;
            w = this.bg.width;
            _loc2_ = 1;
         }
         else
         {
            this.bg.width = this.mcCoins.x + this.mcCoins.ti.x + this.mcCoins.ti.textWidth + 10;
            w = this.bg.width;
         }
         if(param1 != null && "xPosRule" in param1)
         {
            if(param1.xPosRule == "centerOnX")
            {
               x = int(param1.x - w / 2) + _loc2_;
            }
         }
         else if(param1.x > -1)
         {
            x = param1.x;
         }
         else
         {
            x = int(fParent.w / 2 - w / 2) + _loc2_;
         }
         if(param1.y > -1)
         {
            y = param1.y;
         }
         else if(param1.y == -1)
         {
            _loc3_ = fParent.numChildren;
            if(_loc3_ > 1)
            {
               y = fParent.getChildAt(_loc3_ - 2).y + fParent.getChildAt(_loc3_ - 2).height + 10;
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
      
      override public function notify(param1:Object) : void
      {
         if(param1.eventType == "listItemASel" || param1.eventType == "listItemBSel")
         {
            if(param1.fData != null && param1.fData.oSel != null)
            {
               fData = param1.fData.oSel;
            }
            this.fDraw();
         }
         if(param1.eventType == "updateQtyValue")
         {
            this.fDraw();
         }
      }
      
      private function onCoinsTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"Adventure Coins"});
      }
      
      private function onGoldTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"Gold"});
      }
      
      private function onTTOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }
   }
}

