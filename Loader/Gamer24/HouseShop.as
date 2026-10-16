package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   
   public class HouseShop extends MovieClip
   {
      public var bg1:MovieClip;
      
      public var bg2:MovieClip;
      
      public var btnAction:SimpleButton;
      
      public var btnPreview:SimpleButton;
      
      public var mcCoin:MovieClip;
      
      public var mcItemList:ItemList;
      
      public var mcShopList:ItemList;
      
      public var mcUpgrade:MovieClip;
      
      public var strCoins:TextField;
      
      public var strCost:TextField;
      
      public var strGold:TextField;
      
      public var strInfo:TextField;
      
      public var tabInv:MovieClip;
      
      public var tabShop:MovieClip;
      
      public var txtAction:TextField;
      
      public var txtTitle:TextField;
      
      internal var rootClass:*;
      
      internal var bitShop:Boolean = true;
      
      public function HouseShop()
      {
         this.rootClass = MovieClip(parent.parent.parent);
         super();
         this.bg1.btnClose.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
         this.btnPreview.addEventListener(MouseEvent.CLICK,this.onPreviewClick,false,0,true);
         this.btnAction.addEventListener(MouseEvent.CLICK,this.onActionClick,false,0,true);
         this.tabShop.addEventListener(MouseEvent.CLICK,this.onClickShop,false,0,true);
         this.tabInv.addEventListener(MouseEvent.CLICK,this.onClickInv,false,0,true);
         this.mcShopList.inventorySlot = this.rootClass.world.shopinfo.items.length;
         this.mcShopList.init(this.rootClass.world.shopinfo.items);
         this.mcItemList.inventorySlot = this.rootClass.world.myAvatar.houseitems.length;
         this.mcItemList.init(this.rootClass.world.myAvatar.houseitems);
         this.txtAction.mouseEnabled = false;
         this.updateGoldCoin();
         this.onClickShop(null);
      }
      
      internal function onCloseClick(param1:Event) : *
      {
         MovieClip(parent).onClose();
      }
      
      public function fClose() : void
      {
         this.bg1.btnClose.removeEventListener(MouseEvent.CLICK,this.onCloseClick);
         this.btnPreview.removeEventListener(MouseEvent.CLICK,this.onPreviewClick);
         this.btnAction.removeEventListener(MouseEvent.CLICK,this.onActionClick);
         this.tabShop.removeEventListener(MouseEvent.CLICK,this.onClickShop);
         this.tabInv.removeEventListener(MouseEvent.CLICK,this.onClickInv);
      }
      
      public function refreshDetail() : void
      {
         if(this.selectedItem == null)
         {
            this.strInfo.htmlText = "Please select an item to view details.";
            this.txtAction.visible = false;
            this.btnAction.visible = false;
            this.btnPreview.visible = false;
            this.strCost.text = "";
            this.mcCoin.visible = this.mcUpgrade.visible = false;
         }
         else
         {
            this.showItemDetail();
         }
      }
      
      public function get selectedItem() : Object
      {
         if(this.bitShop)
         {
            return this.mcShopList.selectedItem;
         }
         return this.mcItemList.selectedItem;
      }
      
      public function showItemDetail() : void
      {
         var _loc1_:Object = null;
         var _loc2_:* = "#CC9900";
         if(this.bitShop)
         {
            _loc1_ = this.mcShopList.selectedItem;
            this.strInfo.htmlText = this.rootClass.getItemInfoString(_loc1_);
            if(_loc1_.bCoins == 0 && _loc1_.iCost > this.rootClass.world.myAvatar.objData.intGold || _loc1_.bCoins == 1 && _loc1_.iCost > this.rootClass.world.myAvatar.objData.intCoins)
            {
               _loc2_ = "#CC0000";
            }
            if(_loc1_.bCoins == 0)
            {
               this.strCost.htmlText = "<font size=\'14\' color=\'" + _loc2_ + "\'><b>" + Number(_loc1_.iCost) + " Gold</b></font>";
            }
            else
            {
               this.strCost.htmlText = "<font size=\'14\' color=\'" + _loc2_ + "\'><b>" + Number(_loc1_.iCost) + " ACs</b></font>";
            }
            this.txtAction.text = "Buy";
            this.btnPreview.visible = true;
         }
         else
         {
            _loc1_ = this.mcItemList.selectedItem;
            this.strInfo.htmlText = this.rootClass.getItemInfoString(_loc1_);
            if(_loc1_.bCoins == 0)
            {
               if(this.rootClass.world.myAvatar.objData.intGold > 100000000)
               {
                  this.strCost.htmlText = "<font size=\'14\' color=\'" + _loc2_ + "\'><b>0 Gold</b></font>";
               }
               else
               {
                  this.strCost.htmlText = "<font size=\'14\' color=\'" + _loc2_ + "\'><b>" + Math.ceil(_loc1_.iCost / 4) + " Gold</b></font>";
               }
            }
            else if(_loc1_.iHrs < 24)
            {
               this.strCost.htmlText = "<font size=\'14\' color=\'" + _loc2_ + "\'><b>" + Math.ceil(_loc1_.iCost * 9 / 10) + " ACs</b></font>";
            }
            else
            {
               this.strCost.htmlText = "<font size=\'14\' color=\'" + _loc2_ + "\'><b>" + Math.ceil(_loc1_.iCost / 4) + " ACs</b></font>";
            }
            this.txtAction.text = "Sell";
            this.btnPreview.visible = false;
         }
         this.txtAction.visible = true;
         this.btnAction.visible = true;
         this.mcCoin.visible = _loc1_.bCoins == 1;
         this.mcUpgrade.visible = _loc1_.bUpg == 1;
      }
      
      public function updateGoldCoin() : void
      {
         this.strGold.text = this.rootClass.world.myAvatar.objData.intGold;
         this.strCoins.text = this.rootClass.world.myAvatar.objData.intCoins;
      }
      
      internal function onClickShop(param1:Event) : *
      {
         this.tabShop.select();
         this.tabInv.unselect();
         this.mcShopList.visible = true;
         this.mcItemList.visible = false;
         this.txtTitle.text = "Shop";
         this.bitShop = true;
         this.refreshDetail();
      }
      
      internal function onClickInv(param1:Event) : *
      {
         this.tabShop.unselect();
         this.tabInv.select();
         this.mcShopList.visible = false;
         this.mcItemList.visible = true;
         this.txtTitle.text = "Inventory";
         this.bitShop = false;
         this.refreshDetail();
      }
      
      public function onActionClick(param1:Event) : *
      {
         if(this.bitShop)
         {
            this.onBuyClick();
         }
         else
         {
            this.onSellClick();
         }
      }
      
      public function onBuyClick() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if((this.rootClass.world.shopinfo.bStaff == 1 || this.mcShopList.selectedItem.bStaff == 1) && this.rootClass.world.myAvatar.objData.intAccessLevel < 40)
         {
            this.rootClass.MsgBox.notify("Test Item.. cannot be purchased yet!");
         }
         else if(this.rootClass.world.shopinfo.sField != "" && this.rootClass.world.getAchievement(this.rootClass.world.shopinfo.sField,this.rootClass.world.shopinfo.iIndex) != 1)
         {
            this.rootClass.MsgBox.notify("Item requires special requirement!");
         }
         else if(this.mcShopList.selectedItem.bUpg == 1 && !this.rootClass.world.myAvatar.isUpgraded())
         {
            this.rootClass.showUpgradeWindow();
         }
         else if(this.mcShopList.selectedItem.FactionID > 1 && this.rootClass.world.myAvatar.getRep(this.mcShopList.selectedItem.FactionID) < this.mcShopList.selectedItem.iReqRep)
         {
            this.rootClass.MsgBox.notify("Item Locked: Reputation Requirement not met.");
         }
         else if(this.mcShopList.selectedItem.iClass > 0 && this.rootClass.world.myAvatar.getCPByID(this.mcShopList.selectedItem.iClass) < this.mcShopList.selectedItem.iReqCP)
         {
            this.rootClass.MsgBox.notify("Item Locked: Class Requirement not met.");
         }
         else if((Boolean(this.rootClass.world.myAvatar.isItemInInventory(this.mcShopList.selectedItem.ItemID)) || Boolean(this.rootClass.world.myAvatar.isItemInBank(this.mcShopList.selectedItem.ItemID))) && Boolean(this.rootClass.world.myAvatar.isItemStackMaxed(this.mcShopList.selectedItem.ItemID)))
         {
            _loc1_ = ["zero","one","two","three","four","five","six","seven","eight","nine"];
            this.rootClass.MsgBox.notify("You cannot have more than " + _loc1_[this.mcShopList.selectedItem.iStk] + " of that item!");
         }
         else if(this.mcShopList.selectedItem.bCoins == 0 && this.mcShopList.selectedItem.iCost > this.rootClass.world.myAvatar.objData.intGold || this.mcShopList.selectedItem.bCoins == 1 && this.mcShopList.selectedItem.iCost > this.rootClass.world.myAvatar.objData.intCoins)
         {
            this.rootClass.MsgBox.notify("Insufficient Funds!");
         }
         else if(this.rootClass.world.myAvatar.houseitems.length >= this.rootClass.world.myAvatar.objData.iHouseSlots)
         {
            this.rootClass.MsgBox.notify("House Inventory Full!");
         }
         else
         {
            _loc2_ = new ModalMC();
            _loc3_ = {};
            _loc3_.strBody = "Are you sure you want to buy \"" + this.mcShopList.selectedItem.sName + "\"?";
            _loc3_.params = {};
            _loc3_.params.item = this.mcShopList.selectedItem;
            _loc3_.callback = this.buyRequest;
            this.rootClass.ui.ModalStack.addChild(_loc2_);
            _loc2_.init(_loc3_);
         }
      }
      
      public function buyRequest(param1:*) : void
      {
         if(param1.accept)
         {
            this.rootClass.world.sendBuyItemRequest(param1.item);
         }
      }
      
      public function onSellClick() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this.mcItemList.selectedItem.bEquip)
         {
            this.rootClass.MsgBox.notify("Item is currently equipped!");
         }
         else if(this.mcItemList.selectedItem.bTemp == 0)
         {
            _loc1_ = new ModalMC();
            _loc2_ = {};
            _loc2_.strBody = "Are you sure you want to sell \"" + this.mcItemList.selectedItem.sName + "\"?";
            _loc2_.params = {};
            _loc2_.params.item = this.mcItemList.selectedItem;
            _loc2_.callback = this.sellRequest;
            this.rootClass.ui.ModalStack.addChild(_loc1_);
            _loc1_.init(_loc2_);
         }
      }
      
      public function sellRequest(param1:*) : void
      {
         if(param1.accept)
         {
            this.rootClass.world.sendSellItemRequest(param1.item);
         }
      }
      
      public function onPreviewClick(param1:Event) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = this.mcShopList.selectedItem;
         if(_loc2_.sType == "Floor Item" || _loc2_.sType == "Wall Item" || _loc2_.sType == "House")
         {
            _loc3_ = this.rootClass.attachOnModalStack("ItemPreview");
            _loc3_.loadItem(_loc2_);
         }
      }
      
      public function reset() : void
      {
         this.mcItemList.inventorySlot = this.rootClass.world.myAvatar.houseitems.length;
         this.mcItemList.init(this.rootClass.world.myAvatar.houseitems);
         this.updateGoldCoin();
      }
   }
}

