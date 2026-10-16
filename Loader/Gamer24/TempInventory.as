package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   
   public class TempInventory extends MovieClip
   {
      public var bg1:MovieClip;
      
      public var btnEquip:SimpleButton;
      
      public var mcItemList:ItemList;
      
      public var strCoins:TextField;
      
      public var strGold:TextField;
      
      public var strInfo:TextField;
      
      public var txtEquip:TextField;
      
      internal var rootClass:MovieClip;
      
      public function TempInventory()
      {
         this.rootClass = MovieClip(parent.parent.parent);
         super();
         this.bg1.btnClose.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
         this.btnEquip.addEventListener(MouseEvent.CLICK,this.onEquipClick,false,0,true);
         this.txtEquip.mouseEnabled = false;
         this.init();
      }
      
      public function onDeleteClick(param1:Event) : void
      {
      }
      
      public function onEquipClick(param1:Event) : *
      {
         this.rootClass.mixer.playSound("Click");
         var _loc2_:* = this.rootClass.world.getUoLeafById(this.rootClass.world.myAvatar.uid);
         if(_loc2_.intState != 1)
         {
            this.rootClass.MsgBox.notify("Action cannot be performed during combat!");
         }
         else if(this.mcItemList.selectedItem.bEquip == 1)
         {
            if(this.mcItemList.selectedItem.sES == "Weapon" || this.mcItemList.selectedItem.sES == "ar")
            {
               this.rootClass.MsgBox.notify("Selected Item cannot be unequipped!");
            }
            else
            {
               this.rootClass.world.sendUnequipItemRequest(this.mcItemList.selectedItem);
            }
         }
         else if(this.mcItemList.selectedItem.bUpg == 1 && !this.rootClass.world.myAvatar.isUpgraded())
         {
            this.rootClass.showUpgradeWindow();
         }
         else if(int(this.mcItemList.selectedItem.iEnhLvl) > int(this.rootClass.world.myAvatar.objData.intLevel))
         {
            this.rootClass.MsgBox.notify("Level requirement not met!");
         }
         else if(this.mcItemList.selectedItem.sES != "mi" && this.mcItemList.selectedItem.sES != "co" && this.mcItemList.selectedItem.EnhID <= 0)
         {
            this.rootClass.MsgBox.notify("Selected item requires enhancement!");
         }
         else
         {
            this.rootClass.world.sendEquipItemRequest(this.mcItemList.selectedItem);
         }
      }
      
      internal function onCloseClick(param1:Event) : *
      {
         MovieClip(parent).onClose();
      }
      
      public function fClose() : void
      {
         this.bg1.btnClose.removeEventListener(MouseEvent.CLICK,this.onCloseClick);
         this.btnEquip.removeEventListener(MouseEvent.CLICK,this.onEquipClick);
      }
      
      public function toggleInventory() : void
      {
         this.visible = !this.visible;
      }
      
      public function refreshDetail() : void
      {
         if(this.selectedItem == null)
         {
            this.strInfo.htmlText = "Please select an item to view details.";
            this.btnEquip.visible = this.txtEquip.visible = false;
         }
         else
         {
            if(this.selectedItem.bEquip == 1)
            {
               this.txtEquip.text = "Unequip";
            }
            else
            {
               this.txtEquip.text = "Equip";
            }
            this.btnEquip.visible = this.txtEquip.visible = this.selectedItem.sES == "co";
            this.strInfo.htmlText = this.getItemInfoString(this.selectedItem);
         }
      }
      
      public function get selectedItem() : Object
      {
         return this.mcItemList.selectedItem;
      }
      
      public function init() : void
      {
         this.mcItemList.init(MovieClip(parent.parent.parent).world.myAvatar.tempitems);
         this.updateGold();
         this.refreshDetail();
      }
      
      public function updateGold() : void
      {
         this.strGold.text = MovieClip(parent.parent.parent).world.myAvatar.objData.intGold;
         this.strCoins.text = MovieClip(parent.parent.parent).world.myAvatar.objData.intCoins;
      }
      
      internal function getItemInfoString(param1:Object) : String
      {
         var _loc4_:Number = NaN;
         var _loc2_:* = "<font size=\'14\'><b>" + param1.sName + "</b></font><br>";
         var _loc3_:* = "#009900";
         _loc2_ += "<font color=\'" + _loc3_ + "\'><b>" + param1.sType;
         if(param1.iStk > 1)
         {
            _loc2_ += " - " + param1.iQty + "/" + param1.iStk;
         }
         if(param1.sES == "Weapon")
         {
            if(param1.iEnh > 0)
            {
               _loc2_ += ", Lvl " + param1.iLvl + "<br>";
               _loc4_ = Math.sqrt(param1.iLvl) * 20 * param1.iDPS / 100;
               _loc2_ += Math.ceil(_loc4_ * (100 - Number(param1.iRng)) / 100) + " - " + Math.ceil(_loc4_ * (100 + Number(param1.iRng)) / 100) + " " + param1.sElmt;
            }
            else
            {
               _loc2_ += " Design";
            }
         }
         return _loc2_ + ("</b></font><br>" + param1.sDesc + "<br>");
      }
   }
}

