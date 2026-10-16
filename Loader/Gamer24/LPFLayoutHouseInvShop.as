package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class LPFLayoutHouseInvShop extends LPFLayout
   {
      public var iQty:int = 1;
      
      private var aSel:String = "";
      
      private var bSel:String = "";
      
      public var iSel:Object;
      
      public var eSel:Object;
      
      public var shopinfo:Object;
      
      public var itemsInv:Array;
      
      public var itemsShop:Array;
      
      public var multiPanel:MovieClip;
      
      public var splitPanel:MovieClip;
      
      public var previewPanel:MovieClip;
      
      public var rootClass:MovieClip;
      
      public function LPFLayoutHouseInvShop()
      {
         super();
         x = 0;
         y = 0;
         panels = [];
         fData = {};
      }
      
      override public function fOpen(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:MovieClip = null;
         this.rootClass = MovieClip(stage.getChildAt(0));
         fData = param1.fData;
         sMode = param1.sMode;
         if("itemsInv" in fData)
         {
            this.itemsInv = fData.itemsInv;
         }
         if("itemsShop" in fData)
         {
            this.itemsShop = fData.itemsShop;
         }
         if("shopinfo" in fData)
         {
            this.shopinfo = fData.shopinfo;
         }
         _loc2_ = param1.r;
         var _loc3_:String = "";
         x = _loc2_.x;
         y = _loc2_.y;
         w = _loc2_.w;
         h = _loc2_.h;
         tempFill();
         _loc4_ = {};
         _loc4_.panel = new LPFPanelListShopInvB();
         _loc3_ = "House Inventory";
         _loc4_.fData = {
            "items":this.itemsInv,
            "sName":_loc3_
         };
         _loc4_.r = {
            "x":322,
            "y":3,
            "w":316,
            "h":495
         };
         _loc4_.closeType = "hide";
         _loc4_.hideDir = "right";
         _loc4_.hidePad = 3;
         _loc4_.isOpen = false;
         this.splitPanel = addPanel(_loc4_);
         this.splitPanel.visible = false;
         this.splitPanel.fHide();
         _loc4_ = {};
         _loc4_.panel = new LPFPanelHousePreview();
         _loc3_ = "Preview";
         _loc4_.fData = {"sName":_loc3_};
         _loc4_.r = {
            "x":322,
            "y":78,
            "w":316,
            "h":420
         };
         _loc4_.closeType = "hide";
         _loc4_.xBuffer = 3;
         _loc4_.showDragonLeft = true;
         _loc4_.isOpen = false;
         this.previewPanel = addPanel(_loc4_);
         this.previewPanel.visible = false;
         this.previewPanel.addEventListener(Event.ENTER_FRAME,this.previewPanelEF,false,0,true);
         _loc4_ = {};
         _loc4_.panel = new LPFPanelListShopInvA();
         _loc3_ = sMode.toLowerCase().indexOf("shop") > -1 ? this.rootClass.world.shopinfo.sName : "House Inventory";
         _loc4_.fData = {
            "items":(this.itemsShop != null ? this.itemsShop : this.itemsInv),
            "itemsInv":this.itemsInv,
            "objData":fData.objData,
            "sName":_loc3_
         };
         if(this.shopinfo != null)
         {
            _loc4_.fData.shopinfo = this.shopinfo;
         }
         _loc4_.r = {
            "x":641,
            "y":3,
            "w":316,
            "h":495
         };
         _loc4_.closeType = "close";
         _loc4_.showDragonRight = true;
         _loc4_.isOpen = true;
         this.multiPanel = addPanel(_loc4_);
         this.updatePreviewButtons();
         this.rootClass.dropStackBoost();
      }
      
      override public function fClose() : void
      {
         var _loc1_:MovieClip = null;
         this.rootClass.dropStackReset();
         this.previewPanel.removeEventListener(Event.ENTER_FRAME,this.previewPanelEF);
         while(panels.length > 0)
         {
            panels[0].mc.fClose();
            panels.shift();
         }
         if(parent != null)
         {
            _loc1_ = MovieClip(parent);
            _loc1_.removeChild(this);
            _loc1_.onClose();
         }
      }
      
      override protected function handleUpdate(param1:Object) : Object
      {
         var _loc3_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:* = undefined;
         var _loc10_:Object = null;
         var _loc11_:* = null;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:Object = null;
         var _loc2_:Boolean = false;
         var _loc4_:Object = this.iSel;
         var _loc5_:Object = this.eSel;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         if(this.iSel != null && this.eSel != null)
         {
            this.previewPanel.bg.tTitle.text = "Create";
         }
         else
         {
            this.previewPanel.bg.tTitle.text = "Preview";
         }
         if(param1.eventType == "equipHouse")
         {
            if(!this.rootClass.isGreedyModalInStack())
            {
               if(this.iSel != null)
               {
                  this.rootClass.world.equipHouse(this.iSel);
                  this.splitPanel.fHide();
                  this.previewPanel.fHide();
               }
            }
            else
            {
               _loc2_ = true;
            }
         }
         if(param1.eventType == "sModeSet")
         {
            if(sMode != param1.sModeBroadcast)
            {
               sMode = param1.sModeBroadcast;
               this.iSel = null;
               this.eSel = null;
               param1.iSel = this.iSel;
               _loc8_ = this.itemsInv;
               if(sMode == "shopBuy")
               {
                  _loc8_ = this.itemsShop;
               }
               param1.fData = {"list":_loc8_};
               this.splitPanel.fHide();
               this.previewPanel.fHide();
            }
         }
         if(param1.eventType == "listItemASel")
         {
            if(!this.rootClass.isGreedyModalInStack())
            {
               this.iQty = 1;
               this.eSel = null;
               this.iSel = param1.fData;
               this.aSel = param1.fData.sType.toLowerCase();
               this.bSel = "";
               param1.fData = {
                  "iSel":this.iSel,
                  "eSel":this.eSel,
                  "oSel":param1.fData
               };
               this.previewPanel.fShow();
            }
            else
            {
               _loc2_ = true;
            }
         }
         if(param1.eventType == "listItemBSel")
         {
            if(!this.rootClass.isGreedyModalInStack())
            {
               _loc3_ = this.rootClass.copyObj(param1);
               _loc3_.eventType = "listItemBSolo";
               _loc3_.fData = {
                  "iSel":_loc3_.fData,
                  "eSel":null
               };
               this.iSel = null;
               this.bSel = param1.fData.sType.toLowerCase();
               this.iSel = param1.fData;
               param1.fData = {
                  "iSel":this.iSel,
                  "eSel":this.eSel
               };
               if(_loc4_ != this.iSel || _loc5_ != this.eSel)
               {
                  notifyByEventType(_loc3_);
               }
               this.previewPanel.fShow();
            }
            else
            {
               _loc2_ = true;
            }
         }
         if(param1.eventType == "refreshItems")
         {
            if(this.itemsInv.indexOf(this.iSel) == -1)
            {
               this.iSel = null;
            }
            if(this.itemsInv.indexOf(this.eSel) == -1)
            {
               this.eSel = null;
            }
            param1.fData = {
               "iSel":this.iSel,
               "eSel":this.eSel
            };
            if("sInstruction" in param1)
            {
               if(param1.sInstruction == "closeWindows")
               {
                  this.splitPanel.fHide();
                  this.previewPanel.fHide();
               }
               if(param1.sInstruction == "previewEquipOnly")
               {
                  this.splitPanel.fHide();
                  if(this.iSel != null && this.iSel.bEquip != 1)
                  {
                     _loc6_ = {};
                     _loc6_.eventType = "previewButton1Update";
                     _loc6_.fData = {};
                     _loc6_.fData.sText = "Equip";
                     _loc6_.sMode = "red";
                     _loc6_.r = {
                        "x":-1,
                        "y":-40,
                        "w":-1,
                        "h":-1
                     };
                     _loc6_.buttonNewEventType = "equipItem";
                     _loc7_ = {};
                     _loc7_.eventType = "previewButton2Update";
                     _loc7_.fData = {};
                     _loc7_.fData.sText = "";
                     _loc7_.sMode = "grey";
                     _loc7_.r = {
                        "x":173,
                        "y":-40,
                        "w":-1,
                        "h":-1
                     };
                  }
                  else
                  {
                     this.previewPanel.fHide();
                  }
               }
            }
            if(this.iSel == null && this.eSel == null)
            {
               this.splitPanel.fHide();
               this.previewPanel.fHide();
            }
         }
         if(param1.eventType == "refreshShop")
         {
            this.rootClass.world.sendReloadShopRequest(this.shopinfo.ShopID);
            _loc2_ = true;
         }
         if(param1.eventType == "showItemListB")
         {
            if(!this.rootClass.isGreedyModalInStack())
            {
               this.splitPanel.fShow();
            }
            else
            {
               _loc2_ = true;
            }
         }
         if(param1.eventType == "showItemListBNoBtns")
         {
            if(!this.rootClass.isGreedyModalInStack())
            {
               _loc6_ = {};
               _loc6_.eventType = "previewButton1Update";
               _loc6_.fData = {};
               _loc6_.fData.sText = "";
               _loc7_ = {};
               param1.eventType = "showItemListB";
               this.splitPanel.fShow();
            }
            else
            {
               _loc2_ = true;
            }
         }
         if(param1.eventType == "buyItem")
         {
            _loc9_ = this.iSel != null ? this.iSel : this.eSel;
            if(_loc9_ != null)
            {
               if(_loc9_.iCost <= 0)
               {
                  _loc10_ = {
                     "accept":true,
                     "iSel":_loc9_,
                     "iQty":this.iQty
                  };
                  this.rootClass.world.sendBuyItemRequestWithQuantity(_loc10_);
               }
               else
               {
                  _loc11_ = "Are you sure you want to buy \'" + _loc9_.sName + "\'?";
                  if(this.iQty > 1)
                  {
                     _loc11_ = "Are you sure you want to buy " + String(this.iQty) + "x \'" + _loc9_.sName + "\'?";
                  }
                  _loc12_ = new ModalMC();
                  _loc13_ = {};
                  _loc13_.strBody = _loc11_;
                  _loc13_.params = {
                     "iSel":_loc9_,
                     "iQty":this.iQty
                  };
                  _loc13_.callback = this.rootClass.world.sendBuyItemRequestWithQuantity;
                  _loc13_.glow = "white,medium";
                  _loc13_.greedy = false;
                  this.rootClass.ui.ModalStack.addChild(_loc12_);
                  _loc12_.init(_loc13_);
               }
            }
         }
         if(param1.eventType == "sellItem")
         {
            if(this.iSel != null)
            {
               _loc14_ = this.iSel;
            }
            else if(this.eSel != null)
            {
               _loc14_ = this.eSel;
            }
            if(_loc14_.bEquip && _loc14_.sType != "Floor Item" && _loc14_.sType != "Wall Item" || _loc14_.bEquip >= _loc14_.iQty)
            {
               if(_loc14_.sType == "Floor Item" || _loc14_.sType == "Wall Item")
               {
                  this.rootClass.MsgBox.notify("Item is currently placed in your house!");
               }
               else
               {
                  this.rootClass.MsgBox.notify("Item is currently equipped!");
               }
            }
            else if(_loc14_.bCoins == 1 && _loc14_.iHrs == null && _loc14_.ItemID != 8939 && _loc14_.iCost != 0)
            {
               this.rootClass.MsgBox.notify("Cannot be sold, free storage in your bank!");
            }
            else if(_loc14_ && _loc14_.hasOwnProperty("sMeta") && _loc14_.sMeta.toString().indexOf("NoSell") > -1)
            {
               this.rootClass.MsgBox.notify("This item cannot be sold!");
            }
            else
            {
               _loc11_ = "Are you sure you want to sell \'" + _loc14_.sName + "\'?";
               if(this.iQty > 1)
               {
                  _loc11_ = "Are you sure you want to sell " + String(this.iQty) + "x \'" + _loc14_.sName + "\'?";
               }
               _loc12_ = new ModalMC();
               _loc13_ = {};
               _loc13_.strBody = _loc11_;
               _loc13_.params = {
                  "iSel":_loc14_,
                  "iQty":this.iQty
               };
               _loc13_.callback = this.rootClass.world.sendSellItemRequestWithQuantity;
               _loc13_.glow = "white,medium";
               _loc13_.greedy = false;
               this.rootClass.ui.ModalStack.addChild(_loc12_);
               _loc12_.init(_loc13_);
            }
         }
         if(param1.eventType == "buyBagSlots")
         {
            _loc2_ = true;
            this.rootClass.world.loadMovieFront(this.rootClass.bagSpace,"Inline Asset");
            this.fClose();
         }
         if(param1.eventType == "toggleHouseInventory")
         {
            if(!this.rootClass.world.uiLock)
            {
               this.rootClass.ui.mcPopup.fOpen("Inventory");
            }
         }
         if(param1.eventType == "helpAC")
         {
            _loc2_ = true;
            this.rootClass.world.loadMovieFront("interface/goldAC5.swf","Inline Asset");
         }
         this.updatePreviewButtons(_loc6_,_loc7_);
         _loc4_ = null;
         _loc5_ = null;
         if(!_loc2_)
         {
            return param1;
         }
         return null;
      }
      
      private function updatePreviewButtons(param1:Object = null, param2:Object = null) : void
      {
         var _loc3_:Object = {};
         var _loc4_:Object = {};
         if(param1 != null && param2 != null)
         {
            _loc3_ = param1;
            _loc4_ = param2;
         }
         else
         {
            _loc3_.eventType = "previewButton1Update";
            _loc3_.fData = {};
            _loc3_.fData.sText = "";
            _loc3_.sMode = "grey";
            _loc3_.r = {
               "x":46,
               "y":-40,
               "w":-1,
               "h":-1
            };
            _loc3_.buttonNewEventType = "";
            _loc4_.eventType = "previewButton2Update";
            _loc4_.fData = {};
            _loc4_.fData.sText = "";
            _loc4_.sMode = "grey";
            _loc4_.r = {
               "x":173,
               "y":-40,
               "w":-1,
               "h":-1
            };
            _loc4_.buttonNewEventType = "";
            if(sMode == "inventory")
            {
               if(this.iSel == null && this.eSel == null)
               {
                  _loc3_.fData.sText = "";
                  _loc3_.buttonNewEventType = "";
                  _loc4_.fData.sText = "";
                  _loc4_.buttonNewEventType = "";
               }
               else if(this.iSel != null)
               {
                  if(this.iSel.sES == "ho")
                  {
                     if(this.iSel.bEquip != 1)
                     {
                        _loc4_.fData.sText = "Equip";
                        _loc4_.buttonNewEventType = "equipHouse";
                     }
                     _loc4_.sMode = "red";
                  }
               }
            }
            if(sMode == "shopBuy")
            {
               if(this.iSel == null && this.eSel == null)
               {
                  _loc3_.fData.sText = "";
                  _loc3_.buttonNewEventType = "";
                  _loc4_.fData.sText = "";
                  _loc4_.buttonNewEventType = "";
               }
               else if(this.iSel != null && this.eSel != null)
               {
                  _loc3_.fData.sText = "";
                  _loc3_.buttonNewEventType = "";
                  _loc4_.fData.sText = "Enhance!";
                  _loc4_.buttonNewEventType = "enhanceItem";
                  _loc4_.sMode = "red";
               }
               else if(this.eSel != null)
               {
                  _loc3_.fData.sText = "Buy and Hold";
                  _loc3_.buttonNewEventType = "buyItem";
                  _loc4_.fData.sText = "Apply Now";
                  _loc4_.buttonNewEventType = "showItemListBNoBtns";
                  _loc4_.sMode = "red";
               }
               else if(this.iSel != null)
               {
                  if("bLimited" in this.shopinfo && this.shopinfo.bLimited && this.iSel.iQtyRemain <= 0)
                  {
                     _loc3_.fData.sText = "";
                     _loc3_.buttonNewEventType = "";
                     _loc4_.fData.sText = "Sold Out!";
                     _loc4_.buttonNewEventType = "none";
                     _loc4_.sMode = "grey";
                  }
                  else
                  {
                     _loc3_.fData.sText = "";
                     _loc3_.buttonNewEventType = "";
                     _loc4_.fData.sText = "Buy";
                     _loc4_.buttonNewEventType = "buyItem";
                     _loc4_.sMode = "red";
                  }
               }
            }
            if(sMode == "shopSell")
            {
               if(this.iSel == null && this.eSel == null)
               {
                  _loc3_.fData.sText = "";
                  _loc3_.buttonNewEventType = "";
                  _loc4_.fData.sText = "";
                  _loc4_.buttonNewEventType = "";
               }
               else
               {
                  _loc3_.fData.sText = "";
                  _loc3_.buttonNewEventType = "";
                  _loc4_.fData.sText = "Sell";
                  _loc4_.buttonNewEventType = "sellItem";
                  _loc4_.sMode = "red";
               }
            }
         }
         notifyByEventType(_loc3_);
         notifyByEventType(_loc4_);
      }
      
      private function onSellRequest(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.world.sendSellItemRequest(param1.iSel);
         }
      }
      
      public function getTabStates(param1:Object = null) : Array
      {
         var _loc3_:Object = null;
         var _loc2_:Array = [{
            "sTag":"Show All",
            "icon":"iipack",
            "state":-1,
            "filter":"*",
            "mc":{}
         },{
            "sTag":"Show only houses",
            "icon":"ihhouse",
            "state":-1,
            "filter":"House",
            "mc":{}
         },{
            "sTag":"Show only walls",
            "icon":"ihwall",
            "state":-1,
            "filter":"Wall Item",
            "mc":{}
         },{
            "sTag":"Show only floors",
            "icon":"ihfloor",
            "state":-1,
            "filter":"Floor Item",
            "mc":{}
         }];
         if(param1 != null)
         {
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.filter == param1.sType)
               {
                  return [_loc3_];
               }
            }
            return [_loc2_[0]];
         }
         return _loc2_;
      }
      
      private function previewPanelEF(param1:Event) : void
      {
         var _loc2_:Number = this.previewPanel.x;
         var _loc3_:Number = this.splitPanel.x - this.previewPanel.w - this.previewPanel.xBuffer;
         var _loc4_:Number = _loc3_ - _loc2_;
         if(_loc4_ > 20 || this.splitPanel.visible)
         {
            this.previewPanel.x = this.splitPanel.x - this.previewPanel.w - this.previewPanel.xBuffer;
         }
      }
   }
}

