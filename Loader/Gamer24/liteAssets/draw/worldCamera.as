package liteAssets.draw
{
   import fl.data.*;
   import fl.events.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class worldCamera extends MovieClip
   {
      public var btnDown:MovieClip;
      
      public var btnExit:SimpleButton;
      
      public var btnLeft:MovieClip;
      
      public var btnReset:SimpleButton;
      
      public var btnRight:MovieClip;
      
      public var btnUp:MovieClip;
      
      public var btnZoomIn:SimpleButton;
      
      public var btnZoomOut:SimpleButton;
      
      public var txtInfo:TextField;
      
      internal var rootClass:MovieClip;
      
      internal var mcMask:DisplayObject;
      
      public function worldCamera(param1:MovieClip)
      {
         super();
         this.rootClass = param1;
         this.rootClass.world.myAvatar.isWorldCamera = true;
         this.rootClass.world.bitWalk = false;
         this.btnExit.addEventListener(MouseEvent.CLICK,this.onExit,false,0,true);
         this.btnZoomIn.addEventListener(MouseEvent.CLICK,this.onZoomIn,false,0,true);
         this.btnZoomOut.addEventListener(MouseEvent.CLICK,this.onZoomOut,false,0,true);
         this.btnUp.addEventListener(MouseEvent.CLICK,this.onUp,false,0,true);
         this.btnDown.addEventListener(MouseEvent.CLICK,this.onDown,false,0,true);
         this.btnLeft.addEventListener(MouseEvent.CLICK,this.onLeft,false,0,true);
         this.btnRight.addEventListener(MouseEvent.CLICK,this.onRight,false,0,true);
         this.btnReset.addEventListener(MouseEvent.CLICK,this.onReset,false,0,true);
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(0);
         _loc2_.graphics.drawRect(0,0,this.rootClass.world.width,this.rootClass.world.height);
         _loc2_.graphics.endFill();
         this.mcMask = this.rootClass.world.addChild(_loc2_);
         this.mcMask.name = "worldMask";
         this.mcMask.x = this.rootClass.world.x;
         this.mcMask.y = this.rootClass.world.y;
         this.rootClass.world.mask = this.mcMask;
         this.rootClass.ui.visible = false;
         this.rootClass.world.mouseEnabled = this.rootClass.world.mouseChildren = false;
         this.rootClass.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onDrag,false,0,true);
         this.rootClass.stage.addEventListener(MouseEvent.MOUSE_UP,this.onReleaseDrag,false,0,true);
         this.rootClass.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKey,false,0,true);
         var _loc3_:* = this.rootClass.litePreference.data.keys["World Camera\'s Hide"] == null ? "" : this.rootClass.keyDict[this.rootClass.litePreference.data.keys["World Camera\'s Hide"]];
         this.txtInfo.text = "\"" + _loc3_ + "\" to show/hide camera controls!";
      }
      
      public function onKey(param1:KeyboardEvent) : void
      {
         var _loc2_:Number = NaN;
         if(param1.keyCode == this.rootClass.litePreference.data.keys["World Camera\'s Hide"])
         {
            _loc2_ = 0;
            while(_loc2_ < this.numChildren)
            {
               this.getChildAt(_loc2_).visible = !this.getChildAt(_loc2_).visible;
               _loc2_++;
            }
         }
      }
      
      public function onDrag(param1:MouseEvent) : void
      {
         this.rootClass.startDrag();
      }
      
      public function onReleaseDrag(param1:MouseEvent) : void
      {
         this.rootClass.stopDrag();
      }
      
      public function dispatchExit() : void
      {
         this.btnExit.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      public function onExit(param1:MouseEvent) : void
      {
         this.rootClass.removeEventListener(KeyboardEvent.KEY_UP,this.onKey);
         this.rootClass.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDrag);
         this.rootClass.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onReleaseDrag);
         this.rootClass.x = this.rootClass.y = 0;
         this.rootClass.scaleX = this.rootClass.scaleY = 1;
         this.rootClass.ui.visible = true;
         this.rootClass.world.mouseEnabled = this.rootClass.world.mouseChildren = true;
         this.rootClass.world.myAvatar.isWorldCamera = false;
         this.rootClass.world.bitWalk = true;
         this.rootClass.world.mask = null;
         this.mcMask.parent.removeChild(this.mcMask);
         this.parent.removeChild(this);
         this.rootClass.stage.focus = null;
      }
      
      public function onZoomIn(param1:MouseEvent) : void
      {
         this.rootClass.scaleX = this.rootClass.scaleY = this.rootClass.scaleX = this.rootClass.scaleX + 0.5;
         this.rootClass.x -= 220;
         this.rootClass.y -= 150;
      }
      
      public function onZoomOut(param1:MouseEvent) : void
      {
         this.rootClass.scaleX = this.rootClass.scaleY = this.rootClass.scaleX = this.rootClass.scaleX - 0.5;
         this.rootClass.x += 220;
         this.rootClass.y += 150;
      }
      
      public function onReset(param1:MouseEvent) : void
      {
         this.rootClass.x = this.rootClass.y = 0;
         this.rootClass.scaleX = this.rootClass.scaleY = 1;
      }
      
      public function onUp(param1:MouseEvent) : void
      {
         this.rootClass.y += 10;
      }
      
      public function onLeft(param1:MouseEvent) : void
      {
         this.rootClass.x += 10;
      }
      
      public function onRight(param1:MouseEvent) : void
      {
         this.rootClass.x -= 10;
      }
      
      public function onDown(param1:MouseEvent) : void
      {
         this.rootClass.y -= 10;
      }
   }
}

