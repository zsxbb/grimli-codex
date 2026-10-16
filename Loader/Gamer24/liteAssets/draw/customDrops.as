package liteAssets.draw
{
   import fl.motion.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   
   public class customDrops extends MovieClip
   {
      public var inner_menu:MovieClip;
      
      internal var rootClass:MovieClip;
      
      public var mcDraggable:draggableDrops;
      
      private var inactive:ColorMatrixFilter;
      
      private var isOpen:Boolean = false;
      
      internal var itemCount:Object;
      
      internal var invTree:Array;
      
      public function customDrops(param1:MovieClip)
      {
         super();
         this.rootClass = param1;
         this.itemCount = {};
         this.invTree = [];
         var _loc2_:AdjustColor = new AdjustColor();
         _loc2_.saturation = -100;
         _loc2_.brightness = -100;
         _loc2_.contrast = 0;
         _loc2_.hue = 0;
         this.inactive = new ColorMatrixFilter(_loc2_.CalculateFinalFlatArray());
         this.name = "customDrops";
         this.rootClass.ui.mcPortrait.iconDrops.visible = true;
         this.visible = true;
         this.onChange(this.rootClass.litePreference.data.dOptions["dragMode"]);
      }
      
      public function onChange(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.numChildren > 1)
            {
               while(this.numChildren > 1)
               {
                  this.removeChildAt(1);
               }
            }
            this.inner_menu.visible = false;
            if(this.inner_menu.hasEventListener(MouseEvent.CLICK))
            {
               this.inner_menu.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOverAttached);
               this.inner_menu.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOutAttached);
               this.inner_menu.removeEventListener(MouseEvent.CLICK,this.onToggleAttached);
            }
            if(this.rootClass.ui.mcInterface.getChildByName("customDrops"))
            {
               this.rootClass.ui.mcInterface.removeChild(this);
            }
            this.rootClass.ui.addChild(this);
            this.rootClass.ui.setChildIndex(this.rootClass.ui.getChildByName("customDrops"),this.rootClass.ui.numChildren - 1);
            this.x = 0;
            this.y = 0;
            this.mcDraggable = new draggableDrops();
            this.addChild(this.mcDraggable);
            if(this.rootClass.litePreference.data.dmtPos)
            {
               this.mcDraggable.x = this.rootClass.litePreference.data.dmtPos.x;
               this.mcDraggable.y = this.rootClass.litePreference.data.dmtPos.y;
            }
            this.mcDraggable.visible = true;
            this.mcDraggable.txtQty.mouseEnabled = false;
            this.mcDraggable.menuBar.addEventListener(MouseEvent.CLICK,this.onToggleMenu,false,0,true);
            this.mcDraggable.menuBar.addEventListener(MouseEvent.MOUSE_DOWN,this.onHold,false,0,true);
            this.mcDraggable.menuBar.addEventListener(MouseEvent.MOUSE_UP,this.onMouseRelease,false,0,true);
            this.mcDraggable.menu.visible = this.rootClass.litePreference.data.dOptions["openMenu"];
            this.lockMode();
            this.reDraw();
         }
         else
         {
            if(this.mcDraggable)
            {
               while(this.mcDraggable.menu.numChildren > 1)
               {
                  this.mcDraggable.menu.removeChildAt(1);
               }
               this.mcDraggable.menuBar.removeEventListener(MouseEvent.CLICK,this.onToggleMenu);
               this.mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHold);
               this.mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseRelease);
               this.removeChild(this.mcDraggable);
               this.mcDraggable = null;
               this.rootClass.ui.removeChild(this);
            }
            this.rootClass.ui.mcInterface.addChild(this);
            this.rootClass.ui.mcInterface.setChildIndex(this.rootClass.ui.mcInterface.getChildByName("customDrops"),0);
            this.x = 352;
            this.y = !!this.rootClass.litePreference.data.dOptions["invertMenu"] ? -530 : -19;
            this.inner_menu.visible = true;
            this.inner_menu.height = !!this.rootClass.litePreference.data.dOptions["invertMenu"] ? 42.8 : 157.7;
            this.inner_menu.addEventListener(MouseEvent.ROLL_OVER,this.onRollOverAttached,false,0,true);
            this.inner_menu.addEventListener(MouseEvent.ROLL_OUT,this.onRollOutAttached,false,0,true);
            this.inner_menu.addEventListener(MouseEvent.CLICK,this.onToggleAttached,false,0,true);
            if(this.rootClass.litePreference.data.dOptions["openMenu"])
            {
               this.isOpen = true;
               this.reDraw();
            }
            else
            {
               this.inner_menu.filters = [this.inactive];
            }
         }
      }
      
      public function lockMode() : void
      {
         if(!this.mcDraggable)
         {
            return;
         }
         if(!this.rootClass.litePreference.data.dOptions["lockMode"])
         {
            this.mcDraggable.menuBar.addEventListener(MouseEvent.MOUSE_DOWN,this.onHold,false,0,true);
            this.mcDraggable.menuBar.addEventListener(MouseEvent.MOUSE_UP,this.onMouseRelease,false,0,true);
         }
         else
         {
            this.mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHold);
            this.mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseRelease);
         }
      }
      
      public function resetPos() : void
      {
         if(this.mcDraggable)
         {
            this.mcDraggable.x = 0;
            this.mcDraggable.y = 0;
         }
         this.rootClass.litePreference.data.dmtPos.x = 0;
         this.rootClass.litePreference.data.dmtPos.y = 0;
      }
      
      public function onToggleMenu(param1:MouseEvent) : void
      {
         this.mcDraggable.menu.visible = !this.mcDraggable.menu.visible;
         if(this.mcDraggable.menu.visible)
         {
            this.reDraw();
         }
      }
      
      private function onHold(param1:MouseEvent) : void
      {
         this.mcDraggable.startDrag();
      }
      
      private function onMouseRelease(param1:MouseEvent) : void
      {
         this.mcDraggable.stopDrag();
         this.rootClass.litePreference.data.dmtPos = {
            "x":this.mcDraggable.x,
            "y":this.mcDraggable.y
         };
         this.rootClass.litePreference.flush();
      }
      
      public function cleanup() : void
      {
         if(this.mcDraggable)
         {
            this.mcDraggable.menuBar.removeEventListener(MouseEvent.CLICK,this.onToggleMenu);
            this.mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHold);
            this.mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseRelease);
         }
         else
         {
            this.inner_menu.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOverAttached);
            this.inner_menu.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOutAttached);
            this.inner_menu.removeEventListener(MouseEvent.CLICK,this.onToggleAttached);
         }
         this.rootClass.cDropsUI = null;
         this.rootClass.ui.mcPortrait.iconDrops.visible = false;
         parent.removeChild(this);
      }
      
      public function isMenuOpen() : Boolean
      {
         return !!this.mcDraggable ? this.mcDraggable.visible : Boolean(this.isOpen);
      }
      
      public function onRollOverAttached(param1:MouseEvent) : void
      {
         if(this.isOpen)
         {
            return;
         }
         this.y = !!this.rootClass.litePreference.data.dOptions["invertMenu"] ? -521 : -28;
      }
      
      public function onRollOutAttached(param1:MouseEvent) : void
      {
         if(this.isOpen)
         {
            return;
         }
         this.y = !!this.rootClass.litePreference.data.dOptions["invertMenu"] ? -530 : -19;
      }
      
      public function onToggleAttached(param1:MouseEvent) : void
      {
         this.isOpen = !this.isOpen;
         if(!this.isOpen)
         {
            this.inner_menu.filters = [this.inactive];
            while(this.numChildren > 1)
            {
               this.removeChildAt(1);
            }
            this.inner_menu.height = !!this.rootClass.litePreference.data.dOptions["invertMenu"] ? 42.8 : 157.7;
            this.inner_menu.y = 0;
            this.y = !!this.rootClass.litePreference.data.dOptions["invertMenu"] ? -530 : -19;
         }
         else
         {
            this.inner_menu.filters = [];
            this.reDraw();
         }
      }
      
      public function onShow() : void
      {
         if(this.mcDraggable)
         {
            this.mcDraggable.visible = !this.mcDraggable.visible;
         }
         else
         {
            this.inner_menu.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      public function onUpdate() : *
      {
         this.itemCount = {};
         this.invTree.length = 0;
         if(Boolean(this.isOpen) || Boolean(this.mcDraggable))
         {
            this.reDraw();
         }
      }
      
      public function onBtNo(param1:*) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.invTree)
         {
            if(this.invTree[_loc2_].ItemID == param1.ItemID)
            {
               this.itemCount[this.invTree[_loc2_].dID] = null;
               this.invTree.splice(_loc2_,1);
            }
         }
         if(Boolean(this.isOpen) || Boolean(this.mcDraggable))
         {
            this.reDraw();
         }
      }
      
      public function isBlacklisted(param1:String) : Boolean
      {
         return false;
      }
      
      public function cleanDSUI() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc1_:* = this.rootClass.ui.getChildByName("dsUI").numChildren;
         _loc1_ -= 2;
         while(_loc1_ > -1)
         {
            _loc2_ = this.rootClass.ui.getChildByName("dsUI").getChildAt(_loc1_) as MovieClip;
            _loc3_ = this.rootClass.ui.getChildByName("dsUI").getChildAt(_loc1_ + 1) as MovieClip;
            _loc2_.fY = _loc2_.y = _loc3_.fY - (_loc3_.fHeight + 8);
            _loc1_--;
         }
      }
      
      public function showItem(param1:Object) : void
      {
         if(this.isBlacklisted(param1.sName.toUpperCase()))
         {
            return;
         }
         if(this.itemCount[param1.dID] == null)
         {
            this.itemCount[param1.dID] = int(param1.dQty);
            this.invTree.push(param1);
         }
         else
         {
            this.itemCount[param1.dID] += int(param1.dQty);
         }
         if(this.mcDraggable)
         {
            this.reDraw();
            if(!this.mcDraggable.visible)
            {
               this.rootClass.ui.mcPortrait.iconDrops.onAlert();
            }
            return;
         }
         if(this.isOpen)
         {
            this.reDraw();
         }
         else
         {
            this.rootClass.ui.mcPortrait.iconDrops.onAlert();
         }
      }
      
      public function acceptDrop(param1:Object) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.invTree)
         {
            if(this.invTree[_loc2_].ItemID == param1.ItemID)
            {
               this.itemCount[this.invTree[_loc2_].dID] = null;
               this.invTree.splice(_loc2_,1);
            }
         }
         if(Boolean(this.isOpen) || Boolean(this.mcDraggable))
         {
            this.reDraw();
         }
      }
      
      public function reDraw() : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc1_:int = 0;
         while((!!this.mcDraggable ? this.mcDraggable.menu : this).numChildren > 1)
         {
            (!!this.mcDraggable ? this.mcDraggable.menu : this).removeChildAt(1);
         }
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         for each(_loc4_ in this.invTree)
         {
            if(this.itemCount[_loc4_.dID] % 100 == 0)
            {
               if(_loc4_.ItemID == 6521 && this.itemCount[_loc4_.dID] % 1000 == 0)
               {
                  _loc2_ = true;
               }
               else if(_loc4_.ItemID != 6521)
               {
                  _loc2_ = true;
               }
            }
            _loc5_ = new dEntry(this.rootClass,_loc4_,this.itemCount[_loc4_.dID]);
            if(this.rootClass.litePreference.data.dOptions["invertMenu"])
            {
               _loc5_.x = 1.5;
               _loc5_.y = !this.mcDraggable ? 24 + 21.5 * _loc3_ - 0.5 : 161 + 21.5 * _loc3_;
            }
            else
            {
               _loc5_.x = 1.5;
               _loc5_.y = !this.mcDraggable ? -16 - 21.5 * _loc3_ + 0.5 : 108 - 21.5 * _loc3_;
            }
            _loc5_.name = _loc4_.sName;
            (!!this.mcDraggable ? this.mcDraggable.menu : this).addChild(_loc5_);
            _loc1_ += this.itemCount[_loc4_.dID];
            _loc3_++;
         }
         if(_loc2_ && Boolean(this.rootClass.litePreference.data.dOptions["termsAgree"]))
         {
            _loc6_ = new ModalMC();
            _loc7_ = {};
            _loc7_.strBody = "You have an item that\'s over the 100x quantity threshold! Please pick up your drops before you bug out!";
            _loc7_.callback = null;
            _loc7_.btns = "mono";
            _loc7_.glow = "red,medium";
            this.rootClass.ui.ModalStack.addChild(_loc6_);
            _loc6_.init(_loc7_);
         }
         if(this.mcDraggable)
         {
            this.mcDraggable.txtQty.text = " x " + _loc1_;
            if(this.rootClass.litePreference.data.dOptions["invertMenu"])
            {
               this.mcDraggable.menu.menuBG.y = 158;
               this.mcDraggable.menu.menuBG.height = 21.5 * _loc3_ + 6;
            }
            else
            {
               this.mcDraggable.menu.menuBG.y = 108 - 21.5 * (_loc3_ - 1) - 3;
               this.mcDraggable.menu.menuBG.height = 21.5 * _loc3_ + 6;
            }
         }
         else if(this.rootClass.litePreference.data.dOptions["invertMenu"])
         {
            this.inner_menu.y = 0;
            this.inner_menu.height = _loc3_ == 0 ? 47.5 : 47.5 + 21.5 * (_loc3_ - 1);
            this.y = -521;
         }
         else
         {
            this.inner_menu.y = 4 - 21.5 * _loc3_;
            this.inner_menu.height = _loc3_ == 0 ? 157.7 : 157.7 + 21.5 * (_loc3_ - 1);
            this.y = -28;
         }
      }
   }
}

