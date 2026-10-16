package
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.Rectangle;
   import flash.text.*;
   import liteAssets.draw.*;
   
   public class DFrame2MC extends MovieClip
   {
      private static const RARITY_GLOWS:Array = [new GlowFilter(6710886,1,8,8,2,1,false,false),new GlowFilter(16777215,1,8,8,2,1,false,false),new GlowFilter(6749952,1,8,8,2,1,false,false),new GlowFilter(2663679,1,8,8,2,1,false,false),new GlowFilter(16711935,1,8,8,2,1,false,false),new GlowFilter(16763904,1,8,8,2,1,false,false),new GlowFilter(16711680,1,8,8,2,1,false,false)];
      
      public var cnt:MovieClip;
      
      internal var world:MovieClip;
      
      internal var rootClass:MovieClip;
      
      internal var fData:Object = null;
      
      internal var isOpen:Boolean = false;
      
      internal var isClosing:Boolean = false;
      
      internal var iniFrameT:int = 0;
      
      internal var iniFrameC:int = 0;
      
      internal var durFrameT:int = 35;
      
      internal var durFrameC:int = 0;
      
      internal var mc:MovieClip;
      
      internal var rarityCA:Array;
      
      public var fWidth:int = 250;
      
      public var fHeight:int = 86;
      
      public var fX:int = 0;
      
      public var fY:int = 0;
      
      public function DFrame2MC(param1:Object)
      {
         this.rarityCA = [6710886,16777215,6749952,2663679,16711935,16763904,16711680];
         super();
         this.fData = param1;
      }
      
      public function init() : *
      {
         var mcFilter:*;
         var sIcon:String;
         var iconB:Rectangle;
         var rarityIdx:int;
         var AssetClass:Class = null;
         var mcIcon:DisplayObject = null;
         var iconFit:Number = NaN;
         var check:detailedCheck = null;
         var lb:Rectangle = null;
         var ib:Rectangle = null;
         var gb:Rectangle = null;
         var legend_format:TextFormat = null;
         this.mc = MovieClip(this);
         this.rootClass = MovieClip(stage.getChildAt(0));
         this.applyLayout();
         this.mc.cnt.ybtn.ti.mouseEnabled = false;
         this.mc.cnt.nbtn.ti.mouseEnabled = false;
         this.mc.cnt.strType.text = this.rootClass.getDisplaysType(this.fData);
         mcFilter = this.mc.cnt.bg.filters;
         this.mc.cnt.icon.removeAllChildren();
         sIcon = "";
         if(this.fData.sType.toLowerCase() == "enhancement")
         {
            sIcon = this.rootClass.getIconBySlot(this.fData.sES);
         }
         else if(this.fData.sType.toLowerCase() == "serveruse" || this.fData.sType.toLowerCase() == "clientuse")
         {
            if("sFile" in this.fData && this.fData.sFile.length > 0 && this.rootClass.world.getClass(this.fData.sFile) != null)
            {
               sIcon = this.fData.sFile;
            }
            else
            {
               sIcon = this.fData.sIcon;
            }
         }
         else if(this.fData.sIcon == null || this.fData.sIcon == "" || this.fData.sIcon == "none")
         {
            if(this.fData.sLink.toLowerCase() != "none")
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
            sIcon = this.fData.sIcon;
         }
         try
         {
            AssetClass = this.rootClass.world.getClass(sIcon) as Class;
            mcIcon = this.mc.cnt.icon.addChild(new AssetClass());
         }
         catch(e:Error)
         {
            AssetClass = rootClass.world.getClass("iibag") as Class;
            mcIcon = mc.cnt.icon.addChild(new AssetClass());
         }
         mcIcon.scaleX = mcIcon.scaleY = String(this.fData.sType).toLowerCase() == "misc" ? 0.25 : 0.5;
         iconB = mcIcon.getBounds(this.mc.cnt.icon);
         if(iconB.width > 30 || iconB.height > 30)
         {
            iconFit = 30 / Math.max(iconB.width,iconB.height);
            mcIcon.scaleX *= iconFit;
            mcIcon.scaleY *= iconFit;
         }
         rarityIdx = this.fData.iRty >= 0 && this.fData.iRty < RARITY_GLOWS.length ? int(this.fData.iRty) : 0;
         this.mc.cnt.icon.filters = [RARITY_GLOWS[rarityIdx]];
         if(this.isOwned(this.fData.bHouse,this.fData.ItemID))
         {
            check = new detailedCheck();
            this.mc.cnt.icon.addChild(check);
            lb = check.getBounds(check);
            ib = mcIcon.getBounds(this.mc.cnt.icon);
            if(lb.height > 0)
            {
               check.scaleX = check.scaleY = ib.height / lb.height;
            }
            gb = check.getBounds(this.mc.cnt.icon);
            check.x += ib.x + ib.width / 2 - (gb.x + gb.width / 2) + ib.height / 2;
            check.y += ib.y + ib.height / 2 - (gb.y + gb.height / 2);
         }
         if(this.fData.bUpg)
         {
            legend_format = this.mc.cnt.strName.defaultTextFormat;
            legend_format.color = 16566089;
            this.mc.cnt.strName.setTextFormat(legend_format);
         }
         this.mc.cnt.fadedAC.visible = this.fData.bCoins == 1;
         this.mc.cnt.ybtn.buttonMode = true;
         this.mc.cnt.nbtn.buttonMode = true;
         this.mc.cnt.ybtn.addEventListener(MouseEvent.CLICK,this.yClick,false,0,true);
         this.mc.cnt.ybtn.addEventListener(MouseEvent.MOUSE_OVER,this.yMouseOver,false,0,true);
         this.mc.cnt.ybtn.addEventListener(MouseEvent.MOUSE_OUT,this.yMouseOut,false,0,true);
         this.mc.cnt.nbtn.addEventListener(MouseEvent.CLICK,this.nClick,false,0,true);
         this.mc.cnt.nbtn.addEventListener(MouseEvent.MOUSE_OVER,this.nMouseOver,false,0,true);
         this.mc.cnt.nbtn.addEventListener(MouseEvent.MOUSE_OUT,this.nMouseOut,false,0,true);
         if(this.rootClass.litePreference.data.bDraggable)
         {
            this.mc.addEventListener(MouseEvent.MOUSE_DOWN,this.dStartDrag,false,0,true);
            this.mc.addEventListener(MouseEvent.MOUSE_UP,this.dStopDrag,false,0,true);
         }
      }
      
      private function applyLayout() : void
      {
         this.mc.cnt.strName.autoSize = "left";
         this.mc.cnt.strName.text = this.fData.sName;
         if(this.fData.iQty > 1)
         {
            this.mc.cnt.strName.text += " x" + this.fData.iQty;
         }
         this.mc.cnt.bg.width = Math.max(this.mc.cnt.strName.x + int(this.mc.cnt.strName.textWidth) + 15,250);
         this.mc.cnt.ybtn.bg.width = Math.round(this.mc.cnt.bg.width / 2);
         this.mc.cnt.nbtn.bg.width = Math.round(this.mc.cnt.bg.width - this.mc.cnt.ybtn.bg.width);
         this.mc.cnt.nbtn.x = this.mc.cnt.ybtn.width;
         this.mc.cnt.ybtn.ti.x = this.mc.cnt.ybtn.bg.width / 2 - this.mc.cnt.ybtn.ti.textWidth / 2 + 4;
         this.mc.cnt.nbtn.ti.x = this.mc.cnt.nbtn.bg.width / 2 - this.mc.cnt.nbtn.ti.textWidth / 2 - 4;
         if(this.fData.bCoins == 1)
         {
            this.mc.cnt.fadedAC.x = this.mc.cnt.bg.width - 115;
         }
      }
      
      public function addQuantity(param1:int) : void
      {
         if(param1 <= 0 || Boolean(this.isClosing))
         {
            return;
         }
         this.fData.iQty += param1;
         this.applyLayout();
      }
      
      public function isOwned(param1:Boolean, param2:*) : Boolean
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
      
      private function dStartDrag(param1:MouseEvent) : void
      {
         param1.currentTarget.startDrag();
      }
      
      private function dStopDrag(param1:MouseEvent) : void
      {
         param1.currentTarget.stopDrag();
      }
      
      private function yClick(param1:MouseEvent) : *
      {
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:Boolean = true;
         for each(_loc3_ in this.rootClass.world.myAvatar.items)
         {
            if(_loc3_.ItemID == this.fData.ItemID && _loc3_.iQty < _loc3_.iStk)
            {
               _loc2_ = false;
            }
         }
         if(_loc2_ && this.rootClass.world.myAvatar.items.length < this.rootClass.world.myAvatar.objData.iBagSlots)
         {
            _loc2_ = false;
         }
         if(Boolean(this.rootClass.isHouseItem(this.fData)) && this.rootClass.world.myAvatar.houseitems.length >= this.rootClass.world.myAvatar.objData.iHouseSlots)
         {
            this.rootClass.MsgBox.notify("House Inventory Full!");
         }
         else if(!this.rootClass.isHouseItem(this.fData) && _loc2_)
         {
            this.rootClass.MsgBox.notify("Item Inventory Full!");
         }
         else
         {
            _loc4_ = MovieClip(param1.currentTarget);
            _loc5_ = MovieClip(_loc4_.parent.parent);
            this.setCT(_loc4_.bg,3385873);
            _loc5_.cnt.ybtn.mouseEnabled = false;
            _loc5_.cnt.ybtn.mouseChildren = false;
            this.rootClass.sfc.sendXtMessage("zm","getDrop",[this.fData.ItemID],"str",this.rootClass.world.curRoom);
            this.isClosing = true;
         }
      }
      
      private function nClick(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         var _loc3_:* = MovieClip(_loc2_.parent.parent);
         this.setCT(_loc2_.bg,16711680);
         _loc3_.mouseChildren = false;
         this.isClosing = true;
         this.killButtons();
         _loc3_.gotoAndPlay("out");
      }
      
      private function yMouseOver(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         this.setCT(_loc2_.bg,2236962);
      }
      
      private function yMouseOut(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         this.setCT(_loc2_.bg,0);
      }
      
      private function nMouseOver(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         this.setCT(_loc2_.bg,2236962);
      }
      
      private function nMouseOut(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         this.setCT(_loc2_.bg,0);
      }
      
      private function killButtons() : void
      {
         this.mc.cnt.ybtn.removeEventListener(MouseEvent.CLICK,this.yClick);
         this.mc.cnt.ybtn.removeEventListener(MouseEvent.MOUSE_OVER,this.yMouseOver);
         this.mc.cnt.ybtn.removeEventListener(MouseEvent.MOUSE_OUT,this.yMouseOut);
         this.mc.cnt.nbtn.removeEventListener(MouseEvent.CLICK,this.nClick);
         this.mc.cnt.nbtn.removeEventListener(MouseEvent.MOUSE_OVER,this.nMouseOver);
         this.mc.cnt.nbtn.removeEventListener(MouseEvent.MOUSE_OUT,this.nMouseOut);
         if(this.mc.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this.mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.dStartDrag);
            this.mc.removeEventListener(MouseEvent.MOUSE_UP,this.dStopDrag);
         }
      }
      
      public function fClose() : void
      {
         this.killButtons();
         MovieClip(this).parent.removeChild(this);
      }
      
      private function setCT(param1:*, param2:*) : *
      {
         var _loc3_:* = param1.transform.colorTransform;
         _loc3_.color = param2;
         param1.transform.colorTransform = _loc3_;
      }
   }
}

