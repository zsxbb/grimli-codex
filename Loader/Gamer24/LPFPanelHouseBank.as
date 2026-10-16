package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import liteAssets.draw.*;
   
   public class LPFPanelHouseBank extends LPFPanel
   {
      public function LPFPanelHouseBank()
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
         var _loc7_:int = 0;
         while(frames.length > 0)
         {
            if(frames[0].mc != null && frames[0].mc.fClose != null)
            {
               frames[0].mc.fClose();
            }
            frames.shift();
         }
         fData = param1.fData;
         drawBG(LPFPanelBg3);
         bg.tTitle.text = "Bank";
         bg.tPane1.text = "Bank Items";
         bg.tPane2.text = "";
         bg.tPane3.text = "House Items";
         bg.tSearch.visible = true;
         bg.btnSearch.visible = true;
         bg.btnSearch.addEventListener(MouseEvent.CLICK,this.onMSearch,false,0,true);
         bg.tSearch.addEventListener(KeyboardEvent.KEY_DOWN,this.onSearch,false,0,true);
         bg.tSearch.addEventListener(FocusEvent.FOCUS_IN,this.clearText,false,0,true);
         _loc2_ = param1.r;
         x = _loc2_.x;
         if(_loc2_.y > -1)
         {
            y = _loc2_.y;
         }
         else
         {
            _loc7_ = fParent.numChildren;
            if(_loc7_ > 1)
            {
               y = fParent.getChildAt(_loc7_ - 2).y + fParent.getChildAt(_loc7_ - 2).height + 10;
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
            "x":14 + 1,
            "y":40,
            "w":290,
            "h":310
         };
         addFrame(_loc4_);
         var _loc5_:int = 46;
         _loc4_ = {};
         _loc4_.frame = new LPFFrameListViewTabbed();
         _loc4_.fData = {
            "list":fData.itemsB,
            "isBank":true
         };
         _loc4_.r = {
            "x":20 + 1,
            "y":_loc5_,
            "w":265,
            "h":304
         };
         _loc4_.tabStates = MovieClip(fParent).getTabStates(null,["*"]);
         _loc4_.sortOrder = ["House","Wall Item","Floor Item"];
         _loc4_.filterMap = {
            "House":["House"],
            "Wall Item":["Wall Item"],
            "Floor Item":["Floor Item"]
         };
         _loc4_.sName = "bank";
         _loc4_.itemEventType = "bankSel";
         _loc4_.tabEventType = "categorySel";
         _loc4_.eventTypes = ["refreshItems","refreshBank","categorySel"];
         _loc4_.onDemand = true;
         _loc4_.openBlank = true;
         _loc4_.allowDesel = true;
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameSlotDisplay();
         _loc4_.fData = {};
         _loc4_.fData.avatar = fData.avatar;
         _loc4_.r = {
            "x":47,
            "y":-40,
            "w":-1,
            "h":24
         };
         _loc4_.eventTypes = ["refreshItems","refreshBank","refreshSlots"];
         _loc4_.isBank = true;
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameGenericButton();
         _loc4_.fData = {"sText":"Regular Bank"};
         _loc4_.r = {
            "x":170,
            "y":-38,
            "w":-1,
            "h":-1
         };
         _loc4_.buttonNewEventType = ["switchBank"];
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameBackdrop();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":14 + 581,
            "y":40,
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
         _loc4_.fData.list = fData.itemsI;
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
         _loc5_ = 46;
         _loc4_ = {};
         _loc4_.frame = new LPFFrameListViewTabbed();
         _loc4_.fData = {"list":fData.itemsI};
         _loc4_.r = {
            "x":20 + 581,
            "y":_loc5_,
            "w":265,
            "h":270
         };
         _loc4_.tabStates = MovieClip(fParent).getTabStates();
         _loc4_.sortOrder = ["House","Wall Item","Floor Item"];
         _loc4_.filterMap = {
            "House":["House"],
            "Wall Item":["Wall Item"],
            "Floor Item":["Floor Item"]
         };
         _loc4_.sName = "inventory";
         _loc4_.itemEventType = "inventorySel";
         _loc4_.eventTypes = ["refreshItems","refreshInventory","refreshInv"];
         _loc4_.allowDesel = true;
         _loc4_.refreshTabs = true;
         addFrame(_loc4_);
         var _loc6_:bankFilters = new bankFilters(MovieClip(stage.getChildAt(0)));
         _loc6_.x = 360;
         _loc6_.y = 14;
         addChild(_loc6_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameGenericButton();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":455,
            "y":363.5,
            "w":-1,
            "h":-1,
            "center":false
         };
         _loc4_.eventTypes = ["previewButton1Update"];
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
      
      internal function onMSearch(param1:MouseEvent) : void
      {
         MovieClip(stage.getChildAt(0)).world.bankinfo.search(bg.tSearch.text.toLowerCase());
      }
      
      internal function onSearch(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            MovieClip(stage.getChildAt(0)).world.bankinfo.search(bg.tSearch.text.toLowerCase());
         }
      }
      
      internal function clearText(param1:FocusEvent) : void
      {
         if(bg.tSearch.text == "search")
         {
            bg.tSearch.text = "";
         }
      }
   }
}

