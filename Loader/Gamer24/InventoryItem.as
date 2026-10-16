package
{
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   
   public dynamic class InventoryItem extends MovieClip
   {
      public var bg:MovieClip;
      
      public var btnSelect:SimpleButton;
      
      public var icon:MovieClip;
      
      public var strIndex:TextField;
      
      public var strLevel:TextField;
      
      public var strName:TextField;
      
      public var isEq:Boolean;
      
      public var isSel:Boolean;
      
      public function InventoryItem()
      {
         super();
      }
      
      public function onItemSelect(param1:Event) : void
      {
         MovieClip(parent).selectItem(param1.target.parent.intIndex);
      }
      
      public function select() : void
      {
         this.bg.b.visible = true;
         this.isSel = true;
      }
      
      public function equip() : void
      {
         this.isEq = true;
         this.bg.transform.colorTransform = new ColorTransform(1,1,1,1,0,30,50,0);
         this.bg.b.visible = false;
         this.bg.c.visible = true;
      }
      
      public function unequip() : void
      {
         this.isEq = false;
         this.bg.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         this.bg.c.visible = false;
         if(!this.isSel)
         {
            this.bg.b.visible = false;
         }
      }
      
      public function reset() : void
      {
         if(!this.isEq)
         {
            this.bg.b.visible = false;
         }
         this.isSel = false;
      }
      
      public function clearText() : void
      {
         this.strName.text = "";
         this.strLevel.text = "";
         this.icon.visible = false;
      }
   }
}

