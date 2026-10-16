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
   
   public class cellMenu extends MovieClip
   {
      public var inner_menu:MovieClip;
      
      internal var rootClass:MovieClip;
      
      private var inactive:ColorMatrixFilter;
      
      private var isOpen:Boolean = false;
      
      private var possiblePads:Array;
      
      public function cellMenu(param1:MovieClip)
      {
         this.possiblePads = ["Spawn","Center","Left","Right","Top","Bottom","Up","Down"];
         super();
         this.rootClass = param1;
         var _loc2_:AdjustColor = new AdjustColor();
         _loc2_.saturation = -100;
         _loc2_.brightness = -100;
         _loc2_.contrast = 0;
         _loc2_.hue = 0;
         this.inactive = new ColorMatrixFilter(_loc2_.CalculateFinalFlatArray());
         this.name = "cellMenu";
         this.visible = true;
         this.onSetup();
      }
      
      public function onSetup() : void
      {
         this.rootClass.ui.mcInterface.addChild(this);
         this.rootClass.ui.mcInterface.setChildIndex(this.rootClass.ui.mcInterface.getChildByName("cellMenu"),0);
         this.x = 808;
         this.y = -530;
         this.inner_menu.visible = true;
         this.inner_menu.height = 42.8;
         this.inner_menu.addEventListener(MouseEvent.ROLL_OVER,this.onRollOverAttached,false,0,true);
         this.inner_menu.addEventListener(MouseEvent.ROLL_OUT,this.onRollOutAttached,false,0,true);
         this.inner_menu.addEventListener(MouseEvent.CLICK,this.onToggleAttached,false,0,true);
         this.inner_menu.filters = [this.inactive];
      }
      
      public function cleanup() : void
      {
         this.inner_menu.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOverAttached);
         this.inner_menu.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOutAttached);
         this.inner_menu.removeEventListener(MouseEvent.CLICK,this.onToggleAttached);
         parent.removeChild(this);
      }
      
      public function isMenuOpen() : Boolean
      {
         return this.isOpen;
      }
      
      public function onRollOverAttached(param1:MouseEvent) : void
      {
         if(this.isOpen)
         {
            return;
         }
         this.y = -521;
      }
      
      public function onRollOutAttached(param1:MouseEvent) : void
      {
         if(this.isOpen)
         {
            return;
         }
         this.y = -530;
      }
      
      public function toggle() : void
      {
         this.inner_menu.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
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
            this.inner_menu.height = 42.8;
            this.inner_menu.y = 0;
            this.y = -530;
         }
         else
         {
            this.inner_menu.filters = [];
            this.reDraw();
         }
      }
      
      public function onScroll(param1:MouseEvent) : void
      {
         param1.delta *= 3;
         this.y += param1.delta;
         if(this.y < -521 + -1 * this.height + 50)
         {
            this.y = -521 + -1 * this.height + 50;
         }
         if(this.y >= -521)
         {
            this.y = -521;
         }
      }
      
      public function reDraw(param1:String = "") : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         while(this.numChildren > 1)
         {
            this.removeChildAt(1);
         }
         var _loc2_:int = 0;
         for each(_loc3_ in param1 != "" ? this.possiblePads : this.rootClass.world.map.currentScene.labels)
         {
            if(!(param1 == "" && (_loc3_.name == "Wait" || _loc3_.name == "Blank")))
            {
               _loc4_ = new cEntry(this.rootClass,param1 != "" ? _loc3_ : _loc3_.name,param1);
               _loc4_.x = 1.5;
               _loc4_.y = 24 + 21.5 * _loc2_ - 0.5;
               this.addChild(_loc4_);
               _loc2_++;
            }
         }
         this.inner_menu.y = 0;
         this.inner_menu.height = _loc2_ == 0 ? 47.5 : 47.5 + 21.5 * (_loc2_ - 1);
         this.y = -521;
      }
   }
}

