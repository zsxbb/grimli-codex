package
{
   import flash.events.*;
   import flash.text.*;
   
   public class LPFPanelHousePreview extends LPFPanel
   {
      public function LPFPanelHousePreview()
      {
         super();
         x = 0;
         y = 0;
         frames = [];
         fData = {};
      }
      
      override public function fOpen(param1:Object) : void
      {
         var _loc4_:int = 0;
         while(frames.length > 0)
         {
            if(frames[0].mc != null && frames[0].mc.fClose != null)
            {
               frames[0].mc.fClose();
            }
            frames.shift();
         }
         fData = param1.fData;
         var _loc2_:Object = param1.r;
         x = _loc2_.x;
         if(_loc2_.y > -1)
         {
            y = _loc2_.y;
         }
         else
         {
            _loc4_ = fParent.numChildren;
            if(_loc4_ > 1)
            {
               y = fParent.getChildAt(_loc4_ - 2).y + fParent.getChildAt(_loc4_ - 2).height + 10;
            }
            else
            {
               y = 10;
            }
         }
         w = _loc2_.w;
         h = _loc2_.h;
         xo = x;
         yo = y;
         if("closeType" in param1)
         {
            closeType = param1.closeType;
         }
         if("hideDir" in param1)
         {
            hideDir = param1.hideDir;
         }
         if("hidePad" in param1)
         {
            hidePad = param1.hidePad;
         }
         if("xBuffer" in param1)
         {
            xBuffer = param1.xBuffer;
         }
         var _loc3_:Object = {};
         _loc3_ = {};
         _loc3_.frame = new LPFFrameBackdrop();
         _loc3_.fData = null;
         _loc3_.r = {
            "x":14,
            "y":36,
            "w":w - 26,
            "h":204
         };
         addFrame(_loc3_);
         _loc3_ = {};
         _loc3_.frame = new LPFFrameBackdrop();
         _loc3_.fData = null;
         _loc3_.r = {
            "x":14,
            "y":244,
            "w":w - 26,
            "h":121
         };
         addFrame(_loc3_);
         _loc3_ = {};
         _loc3_.frame = new LPFFrameHousePreview();
         _loc3_.fData = null;
         _loc3_.r = {
            "x":18,
            "y":40,
            "w":w - 20,
            "h":-1
         };
         _loc3_.eventTypes = ["listItemASel","listItemBSel","refreshItems"];
         addFrame(_loc3_);
         _loc3_ = {};
         _loc3_.frame = new LPFFrameHouseDesc();
         _loc3_.fData = null;
         _loc3_.r = {
            "x":18,
            "y":245,
            "w":w - 20,
            "h":-1
         };
         _loc3_.eventTypes = ["listItemASel","listItemBSel","refreshItems"];
         addFrame(_loc3_);
         _loc3_ = {};
         _loc3_.frame = new LPFFrameCostDisplay();
         _loc3_.fData = null;
         _loc3_.r = {
            "x":int(173 + 96 / 2),
            "y":-66,
            "w":-1,
            "h":-1,
            "xPosRule":"centerOnX"
         };
         _loc3_.eventTypes = ["listItemASel","updateQtyValue"];
         addFrame(_loc3_);
         _loc3_ = {};
         _loc3_.frame = new LPFFrameGenericButton();
         _loc3_.fData = null;
         _loc3_.r = {
            "x":46,
            "y":-40,
            "w":-1,
            "h":-1
         };
         _loc3_.eventTypes = ["previewButton1Update"];
         addFrame(_loc3_);
         _loc3_ = {};
         _loc3_.frame = new LPFFrameGenericButton();
         _loc3_.fData = null;
         _loc3_.r = {
            "x":173,
            "y":-40,
            "w":-1,
            "h":-1
         };
         _loc3_.eventTypes = ["previewButton2Update"];
         addFrame(_loc3_);
         if(fParent.sMode.toLowerCase().indexOf("shop") > -1)
         {
            _loc3_ = {};
            _loc3_.frame = new LPFFrameQtySelector();
            _loc3_.fData = null;
            _loc3_.openOn = "shopBuy";
            _loc3_.eventTypes = ["listItemASel"];
            _loc3_.r = {
               "x":40,
               "y":-47.5,
               "w":-1,
               "h":-1
            };
            addFrame(_loc3_);
         }
         drawBG();
         bg.btnClose.addEventListener(MouseEvent.CLICK,onCloseClick,false,0,true);
         if(!("showDragonLeft" in param1 && param1.showDragonLeft == true))
         {
            bg.dragonLeft.visible = false;
         }
         if(!("showDragonRight" in param1 && param1.showDragonRight == true))
         {
            bg.dragonRight.visible = false;
         }
      }
   }
}

