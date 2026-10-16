package liteAssets.draw
{
   import fl.data.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.text.*;
   
   public class dEntry extends MovieClip
   {
      public var btNo:MovieClip;
      
      public var btPreview:MovieClip;
      
      public var btYes:MovieClip;
      
      public var entryBar:MovieClip;
      
      public var icon:MovieClip;
      
      public var iconAC:MovieClip;
      
      public var overEntryBar:MovieClip;
      
      public var txtDrop:TextField;
      
      public var itemObj:Object;
      
      internal var format:TextFormat;
      
      internal var rootClass:MovieClip;
      
      internal var allowPass:Boolean = false;
      
      public function dEntry(param1:MovieClip, param2:Object, param3:int)
      {
         var sIcon:String;
         var AssetClass:Class = null;
         var mcIcon:* = undefined;
         var check:detailedCheck = null;
         var lb:Rectangle = null;
         var ib:Rectangle = null;
         var gb:Rectangle = null;
         var r:MovieClip = param1;
         var resObj:Object = param2;
         var relQty:int = param3;
         this.format = new TextFormat();
         super();
         this.rootClass = r;
         this.allowPass = false;
         this.gotoAndStop("idle");
         this.btYes.visible = false;
         this.btNo.visible = false;
         this.btPreview.visible = false;
         this.itemObj = resObj;
         this.iconAC.visible = resObj.bCoins == 1;
         this.txtDrop.text = "";
         this.txtDrop.htmlText = "";
         if(resObj.bUpg == 1)
         {
            this.txtDrop.htmlText = "<font color=\'#FCC749\'>" + resObj.sName + " x " + relQty + "</font>";
         }
         else
         {
            this.txtDrop.text = resObj.sName + " x " + relQty;
         }
         this.txtDrop.autoSize = TextFieldAutoSize.LEFT;
         if(this.txtDrop.width > this.entryBar.width - this.txtDrop.x - 20)
         {
            this.txtDrop.autoSize = TextFieldAutoSize.NONE;
            this.txtDrop.width = this.entryBar.width - this.txtDrop.x - 20 - (this.iconAC.visible ? this.iconAC.width : 0);
         }
         if(this.iconAC.visible)
         {
            this.iconAC.x = this.txtDrop.x + this.txtDrop.width;
         }
         sIcon = "";
         if(resObj.sType.toLowerCase() == "enhancement")
         {
            sIcon = this.rootClass.getIconBySlot(resObj.sES);
         }
         else if(resObj.sType.toLowerCase() == "serveruse" || resObj.sType.toLowerCase() == "clientuse")
         {
            if("sFile" in resObj && resObj.sFile.length > 0 && this.rootClass.world.getClass(resObj.sFile) != null)
            {
               sIcon = resObj.sFile;
            }
            else
            {
               sIcon = resObj.sIcon;
            }
         }
         else if(resObj.sIcon == null || resObj.sIcon == "" || resObj.sIcon == "none")
         {
            if(resObj.sLink.toLowerCase() != "none")
            {
               sIcon = "iidesign";
            }
            else
            {
               sIcon = "iibag";
            }
         }
         else
         {
            sIcon = resObj.sIcon;
         }
         try
         {
            AssetClass = this.rootClass.world.getClass(sIcon) as Class;
            mcIcon = this.icon.addChild(new AssetClass());
         }
         catch(e:Error)
         {
            AssetClass = rootClass.world.getClass("iibag") as Class;
            mcIcon = this.icon.addChild(new AssetClass());
         }
         mcIcon.scaleX = mcIcon.scaleY = 16 / mcIcon.height;
         if(this.isOwned(resObj.bHouse,resObj.ItemID))
         {
            check = new detailedCheck();
            this.icon.addChild(check);
            lb = check.getBounds(check);
            ib = mcIcon.getBounds(this.icon);
            if(lb.height > 0)
            {
               check.scaleX = check.scaleY = ib.height / lb.height;
            }
            gb = check.getBounds(this.icon);
            check.x += ib.x + ib.width / 2 - (gb.x + gb.width / 2) + ib.height / 2;
            check.y += ib.y + ib.height / 2 - (gb.y + gb.height / 2);
         }
         this.addEventListener(MouseEvent.ROLL_OVER,this.onHighlight,false,0,true);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onDeHighlight,false,0,true);
         this.addEventListener(MouseEvent.CLICK,this.onShiftClick,false,0,true);
         this.btYes.addEventListener(MouseEvent.CLICK,this.onBtYes,false,0,true);
         this.btNo.addEventListener(MouseEvent.CLICK,this.onBtNo,false,0,true);
         this.btPreview.addEventListener(MouseEvent.CLICK,this.onBtPreview,false,0,true);
      }
      
      internal function onShiftClick(param1:MouseEvent) : void
      {
         var _loc2_:Class = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1.shiftKey)
         {
            if(this.itemObj.sName.indexOf("Item of Digital Awesomeness.") > -1)
            {
               _loc2_ = this.rootClass.world.getClass("ModalMC");
               _loc3_ = new _loc2_();
               _loc4_ = {};
               _loc4_.strBody = "You can NOT block IoDAs!";
               _loc4_.callback = null;
               _loc4_.glow = "red,medium";
               _loc4_.btns = "mono";
               this.rootClass.stage.addChild(_loc3_);
               _loc3_.init(_loc4_);
               return;
            }
            _loc2_ = this.rootClass.world.getClass("ModalMC");
            _loc3_ = new _loc2_();
            _loc4_ = {};
            _loc4_.strBody = "Are you sure you want to add " + this.itemObj.sName + " to the item block list?";
            _loc4_.callback = this.onModifyBlacklist;
            _loc4_.params = {
               "sName":this.itemObj.sName,
               "ItemID":this.itemObj.ItemID
            };
            _loc4_.glow = "red,medium";
            _loc4_.btns = "dual";
            this.rootClass.stage.addChild(_loc3_);
            _loc3_.init(_loc4_);
         }
      }
      
      internal function onModifyBlacklist(param1:Object) : void
      {
         var _loc2_:DataProvider = null;
         if(param1.accept)
         {
            _loc2_ = new DataProvider(this.rootClass.litePreference.data.blackList);
            _loc2_.addItem({
               "label":param1.sName.toUpperCase(),
               "value":param1.ItemID
            });
            this.rootClass.litePreference.data.blackList = _loc2_.toArray();
            this.rootClass.litePreference.flush();
            this.btNo.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
         this.rootClass.stage.focus = null;
      }
      
      internal function isOwned(param1:Boolean, param2:*) : Boolean
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in param1 ? this.rootClass.world.myAvatar.houseitems : this.rootClass.world.myAvatar.items)
         {
            if(_loc3_.ItemID == param2)
            {
               return true;
            }
         }
         if(this.rootClass.world.bankinfo.isItemInBank(param2))
         {
            return true;
         }
         return false;
      }
      
      internal function updateFormat(param1:int) : void
      {
         this.format.size = param1;
         this.txtDrop.setTextFormat(this.format);
      }
      
      internal function onBtYes(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Boolean = true;
         for each(_loc3_ in this.rootClass.world.myAvatar.items)
         {
            if(_loc3_.ItemID == this.itemObj.ItemID && _loc3_.iQty < _loc3_.iStk)
            {
               _loc2_ = false;
            }
         }
         if(_loc2_ && this.rootClass.world.myAvatar.items.length < this.rootClass.world.myAvatar.objData.iBagSlots)
         {
            _loc2_ = false;
         }
         if(Boolean(this.rootClass.isHouseItem(this.itemObj)) && this.rootClass.world.myAvatar.houseitems.length >= this.rootClass.world.myAvatar.objData.iHouseSlots)
         {
            this.rootClass.MsgBox.notify("House Inventory Full!");
         }
         else if(!this.rootClass.isHouseItem(this.itemObj) && _loc2_)
         {
            this.rootClass.MsgBox.notify("Item Inventory Full!");
         }
         else
         {
            this.rootClass.sfc.sendXtMessage("zm","getDrop",[this.itemObj.ItemID],"str",this.rootClass.world.curRoom);
         }
         this.rootClass.stage.focus = null;
      }
      
      internal function onDeclineDrop(param1:Object) : void
      {
         if(param1.accept)
         {
            this.allowPass = true;
            this.btNo.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      internal function onBtNo(param1:MouseEvent) : void
      {
         var _loc2_:Class = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this.rootClass.litePreference.data.dOptions["warnDecline"])
         {
            if(!this.allowPass)
            {
               _loc2_ = this.rootClass.world.getClass("ModalMC");
               _loc3_ = new _loc2_();
               _loc4_ = {};
               _loc4_.strBody = "Are you sure you want to decline the drop for " + this.itemObj.sName + "?";
               _loc4_.callback = this.onDeclineDrop;
               _loc4_.params = {"sName":this.itemObj.sName};
               _loc4_.glow = "red,medium";
               _loc4_.btns = "dual";
               this.rootClass.stage.addChild(_loc3_);
               _loc3_.init(_loc4_);
               return;
            }
         }
         this.rootClass.cDropsUI.onBtNo(this.itemObj);
         this.allowPass = false;
         this.rootClass.stage.focus = null;
      }
      
      internal function onBtPreview(param1:MouseEvent) : void
      {
         if(this.rootClass.ui.getChildByName("qRewardPrev"))
         {
            this.rootClass.ui.getChildByName("qRewardPrev").fClose();
         }
         var _loc2_:* = this.rootClass.ui.addChild(new qRewardPrev(this.itemObj));
         _loc2_.world = this.rootClass.world;
         _loc2_.rootClass = this.rootClass;
         _loc2_.isDropPreview();
         _loc2_.open();
         this.rootClass.stage.focus = null;
      }
      
      internal function onHighlight(param1:MouseEvent) : void
      {
         this.gotoAndStop("hover");
         this.btYes.visible = true;
         this.btNo.visible = true;
         this.btPreview.visible = true;
      }
      
      internal function onDeHighlight(param1:MouseEvent) : void
      {
         this.gotoAndStop("idle");
         this.btYes.visible = false;
         this.btNo.visible = false;
         this.btPreview.visible = false;
      }
   }
}

