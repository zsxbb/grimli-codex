package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class LPFPanelListShopInvB extends LPFPanel
   {
      public function LPFPanelListShopInvB()
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
         var _loc3_:Object = {};
         _loc3_ = {};
         _loc3_.frame = new LPFFrameBackdrop();
         _loc3_.fData = null;
         _loc3_.r = {
            "x":14,
            "y":44,
            "w":w - 26,
            "h":271
         };
         addFrame(_loc3_);
         _loc3_ = {};
         _loc3_.frame = new LPFFrameBackdrop();
         _loc3_.fData = null;
         _loc3_.r = {
            "x":14,
            "y":320,
            "w":w - 26,
            "h":121
         };
         addFrame(_loc3_);
         _loc3_ = {};
         _loc3_.frame = new LPFFrameListViewTabbed();
         _loc3_.fData = {"list":fData.items};
         _loc3_.r = {
            "x":20,
            "y":50,
            "w":265,
            "h":258
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
            "House":["House"],
            "Wall Item":["Wall Item"],
            "Floor Item":["Floor Item"]
         };
         _loc3_.sName = "itemListB";
         _loc3_.itemEventType = "listItemBSel";
         _loc3_.eventTypes = ["listItemASel","refreshInv","refreshItems"];
         _loc3_.filter = "sES";
         _loc3_.multiSelect = MovieClip(fParent).sMode == "shopBuy";
         addFrame(_loc3_);
         _loc3_ = {};
         _loc3_.frame = new LPFFrameEnhText();
         _loc3_.fData = null;
         _loc3_.r = {
            "x":18,
            "y":321,
            "w":w - 20,
            "h":-1
         };
         _loc3_.eventTypes = ["listItemBSolo","showItemListB","refreshItems"];
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
      
      override public function fHide() : void
      {
         var _loc1_:MovieClip = null;
         isOpen = false;
         visible = false;
         switch(hideDir.toLowerCase())
         {
            case "left":
               x = xo - w - hidePad;
               break;
            case "right":
               x = xo + w + hidePad;
               break;
            case "top":
               y = yo - h - hidePad;
               break;
            case "bottom":
               y = yo + h + hidePad;
               break;
            case "":
         }
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < numChildren)
         {
            try
            {
               _loc1_ = MovieClip(getChildAt(_loc2_));
               _loc1_.notify({"eventType":"clearState"});
            }
            catch(e:Error)
            {
            }
            _loc2_++;
         }
      }
   }
}

