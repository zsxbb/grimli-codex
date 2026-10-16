package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   
   public class LPFPanelMergeShop extends LPFPanel
   {
      public function LPFPanelMergeShop()
      {
         super();
         x = 0;
         y = 0;
         frames = [];
         fData = {};
      }
      
      override public function fOpen(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc6_:int = 0;
         while(frames.length > 0)
         {
            if(frames[0].mc != null && frames[0].mc.fClose != null)
            {
               frames[0].mc.fClose();
            }
            frames.shift();
         }
         fData = param1.fData;
         drawBG(LPFPanelBg2);
         bg.tPane1.text = "Preview";
         bg.tPane2.text = "Cost";
         bg.tPane3.text = "Item List";
         bg.tSearch.visible = false;
         bg.mcHouse.visible = false;
         _loc2_ = param1.r;
         x = _loc2_.x;
         if(_loc2_.y > -1)
         {
            y = _loc2_.y;
         }
         else
         {
            _loc6_ = fParent.numChildren;
            if(_loc6_ > 1)
            {
               y = fParent.getChildAt(_loc6_ - 2).y + fParent.getChildAt(_loc6_ - 2).height + 10;
            }
            else
            {
               y = 10;
            }
         }
         var _loc3_:Point = new Point(0,0);
         _loc3_ = bg.localToGlobal(_loc3_);
         bg.y -= int(_loc2_.y - _loc3_.y);
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
         if("isOpen" in param1)
         {
            isOpen = param1.isOpen;
         }
         var _loc4_:Object = {};
         _loc4_ = {};
         _loc4_.frame = new LPFFrameBackdrop();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":15,
            "y":36,
            "w":290,
            "h":204
         };
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameBackdrop();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":15,
            "y":244,
            "w":290,
            "h":121
         };
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameItemPreview();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":19,
            "y":40,
            "w":284,
            "h":-1
         };
         _loc4_.eventTypes = ["listItemASel"];
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameEnhText();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":19,
            "y":245,
            "w":284,
            "h":-1
         };
         _loc4_.eventTypes = ["listItemASel"];
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameBackdrop();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":14 + 581,
            "y":44,
            "w":290,
            "h":310
         };
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameGoldDisplay();
         _loc4_.fData = fData.objData;
         _loc4_.r = {
            "x":-1,
            "y":-70,
            "w":-1,
            "h":24,
            "center":true,
            "centerOn":740,
            "shiftAmount":0
         };
         _loc4_.eventTypes = ["refreshCoins"];
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameSlotDisplay();
         _loc4_.fData = fData.objData;
         _loc4_.fData.list = fData.itemsInv;
         _loc4_.r = {
            "x":32 + 581,
            "y":-40,
            "w":-1,
            "h":24
         };
         _loc4_.eventTypes = ["refreshItems","refreshSlots"];
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameGenericButton();
         _loc4_.fData = {"sText":"Add Space"};
         _loc4_.r = {
            "x":185 + 581,
            "y":-38,
            "w":-1,
            "h":-1
         };
         _loc4_.buttonNewEventType = ["buyBagSlots"];
         addFrame(_loc4_);
         var _loc5_:int = 50;
         _loc4_ = {};
         _loc4_.frame = new LPFFrameListViewTabbed();
         _loc4_.fData = {"list":fData.items};
         _loc4_.r = {
            "x":20 + 581,
            "y":_loc5_,
            "w":265,
            "h":270
         };
         _loc4_.tabStates = MovieClip(fParent).getTabStates();
         _loc4_.sortOrder = ["Note","Resource","Item","Quest Item","ServerUse","Enhancement","Sword","Axe","Gauntlet","Dagger","HandGun","Rifle","Gun","Whip","Bow","Mace","Polearm","Staff","Wand","Class","Armor","Helm","Cape","Misc","Earring","Amulet","Necklace","Belt","Ring","Pet"];
         _loc4_.filterMap = {
            "Weapon":["Sword","Axe","Gauntlet","Dagger","HandGun","Rifle","Gun","Whip","Bow","Mace","Polearm","Staff","Wand"],
            "ar":["Class","Armor"],
            "he":["Helm"],
            "ba":["Cape"],
            "pe":["Pet"],
            "am":["Misc","Earring","Amulet","Necklace","Belt","Ring"],
            "it":["Note","Resource","Item","Quest Item","ServerUse"],
            "enh":["Enhancement"],
            "houseitems":["House","Wall Item","Floor Item"]
         };
         _loc4_.sName = "itemListA";
         _loc4_.itemEventType = "listItemASel";
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameSimpleText();
         _loc4_.fData = {"msg":"<p align=\'center\'>Select an item from the list. Below are the required parts to buy the desired item.</p>"};
         _loc4_.r = {
            "x":-1,
            "y":71,
            "w":200,
            "h":-1,
            "center":true
         };
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameSimpleList();
         _loc4_.fData = {"msg":"<p align=\'center\'>*Items must be in your backpack to appear.</p>"};
         _loc4_.r = {
            "x":-1,
            "y":140,
            "w":240,
            "h":-1,
            "center":true
         };
         _loc4_.eventTypes = ["refreshItems","listItemASel","updateQtyValue"];
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameCostDisplay();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":450,
            "y":-70,
            "w":-1,
            "h":-1,
            "xPosRule":"centerOnX"
         };
         _loc4_.eventTypes = ["listItemASel","updateQtyValue"];
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameGenericButton();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":-1,
            "y":-40,
            "w":250,
            "h":-1,
            "center":true
         };
         _loc4_.eventTypes = ["previewButton1Update"];
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameQtySelector();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":-1,
            "y":-80,
            "w":-1,
            "h":-1,
            "center":true
         };
         _loc4_.eventTypes = ["listItemASel"];
         addFrame(_loc4_);
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

