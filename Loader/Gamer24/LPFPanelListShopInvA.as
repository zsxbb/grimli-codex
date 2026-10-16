package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class LPFPanelListShopInvA extends LPFPanel
   {
      public function LPFPanelListShopInvA()
      {
         super();
         x = 0;
         y = 0;
         frames = [];
         fData = {};
      }
      
      override public function fOpen(param1:Object) : void
      {
         var _loc8_:int = 0;
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
            _loc8_ = fParent.numChildren;
            if(_loc8_ > 1)
            {
               y = fParent.getChildAt(_loc8_ - 2).y + fParent.getChildAt(_loc8_ - 2).height + 10;
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
         var _loc3_:Object = {};
         _loc3_ = {};
         _loc3_.frame = new LPFFrameBackdrop();
         _loc3_.fData = null;
         _loc3_.r = {
            "x":14,
            "y":44,
            "w":w - 26,
            "h":396
         };
         addFrame(_loc3_);
         _loc3_ = {};
         _loc3_.frame = new LPFFrameGoldDisplay();
         _loc3_.fData = fData.objData;
         _loc3_.r = {
            "x":-1,
            "y":-79,
            "w":-1,
            "h":24,
            "center":true,
            "shiftAmount":45
         };
         _loc3_.eventTypes = ["refreshCoins"];
         addFrame(_loc3_);
         _loc3_ = {};
         _loc3_.frame = new LPFFrameSlotDisplay();
         _loc3_.fData = fData.objData;
         _loc3_.fData.list = fData.itemsInv;
         _loc3_.r = {
            "x":32,
            "y":-40,
            "w":-1,
            "h":24
         };
         _loc3_.eventTypes = ["refreshItems","refreshSlots"];
         addFrame(_loc3_);
         var _loc4_:Boolean = MovieClip(fParent).rootClass.ui.mcPopup.currentLabel == "Inventory" || MovieClip(fParent).rootClass.ui.mcPopup.currentLabel == "HouseInventory";
         _loc3_ = {};
         _loc3_.frame = new LPFFrameGenericButton();
         _loc3_.fData = {"sText":"Add Space"};
         _loc3_.r = {
            "x":185,
            "y":(_loc4_ ? -29 : -38),
            "w":-1,
            "h":-1
         };
         _loc3_.buttonNewEventType = ["buyBagSlots"];
         addFrame(_loc3_);
         if(_loc4_)
         {
            _loc3_ = {};
            _loc3_.frame = new LPFFrameGenericButton();
            _loc3_.fData = {"sText":(MovieClip(fParent).rootClass.ui.mcPopup.currentLabel == "Inventory" ? "House Inventory" : "Item Inventory")};
            _loc3_.r = {
               "x":185,
               "y":-48,
               "w":-1,
               "h":-1
            };
            _loc3_.buttonNewEventType = ["toggleHouseInventory"];
            addFrame(_loc3_);
         }
         var _loc5_:int = 353;
         var _loc6_:int = 50;
         if(fParent.sMode.indexOf("shop") > -1)
         {
            _loc5_ -= 38;
            _loc3_ = {};
            _loc3_.frame = new LPFFrameCheapBuySell();
            _loc3_.fData = null;
            _loc3_.eventType = "sModeSet";
            _loc3_.openOn = "shopBuy";
            _loc3_.r = {
               "x":20,
               "y":_loc6_ + _loc5_,
               "w":-1,
               "h":-1
            };
            addFrame(_loc3_);
         }
         _loc3_ = {};
         _loc3_.frame = new LPFFrameListViewTabbed();
         var _loc7_:Object = {
            "list":fData.items,
            "bLimited":false
         };
         if("shopinfo" in fData)
         {
            if("bLimited" in fData.shopinfo)
            {
               _loc7_.bLimited = fData.shopinfo.bLimited;
            }
         }
         _loc3_.fData = _loc7_;
         _loc3_.r = {
            "x":20,
            "y":_loc6_,
            "w":265,
            "h":_loc5_
         };
         _loc3_.tabStates = MovieClip(fParent).getTabStates();
         _loc3_.sortOrder = ["Note","Resource","Item","Quest Item","ServerUse","Enhancement","Sword","Axe","Gauntlet","Dagger","HandGun","Rifle","Gun","Whip","Bow","Mace","Polearm","Staff","Wand","Class","Armor","Helm","Cape","Misc","Earring","Amulet","Necklace","Belt","Ring","Pet"];
         _loc3_.filterMap = {
            "Weapon":["Sword","Axe","Gauntlet","Dagger","HandGun","Rifle","Gun","Whip","Bow","Mace","Polearm","Staff","Wand"],
            "ar":["Class","Armor"],
            "he":["Helm"],
            "ba":["Cape"],
            "pe":["Pet"],
            "am":["Misc","Earring","Amulet","Necklace","Belt","Ring"],
            "it":["Note","Resource","Item","Quest Item","ServerUse"],
            "enh":["Enhancement"],
            "houseitems":["House","Wall Item","Floor Item"],
            "pots":["Item"]
         };
         _loc3_.sName = "itemListA";
         _loc3_.itemEventType = "listItemASel";
         _loc3_.eventTypes = ["refreshItems","refreshInv","sModeSet"];
         addFrame(_loc3_);
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

