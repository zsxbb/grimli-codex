package spider_fla
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
   import liteAssets.draw.*;
   import org.sepy.ColorPicker.ColorPicker2;
   
   public dynamic class mcCustomizeArmor_439 extends MovieClip
   {
      public var bg:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var btnColor:MovieClip;
      
      public var cpAccessory:ColorPicker2;
      
      public var cpBase:ColorPicker2;
      
      public var cpTrim:ColorPicker2;
      
      public var submit:SimpleButton;
      
      public var rootClass:*;
      
      public var avt:Avatar;
      
      public var backData:*;
      
      public var mcSets:colorSets;
      
      public function mcCustomizeArmor_439()
      {
         super();
         this.__setProp_cpAccessory_mcCustomizeArmor_Layer22_0();
         this.__setProp_cpTrim_mcCustomizeArmor_Layer23_0();
         this.__setProp_cpBase_mcCustomizeArmor_Layer24_0();
      }
      
      public function onColorClick(param1:Event) : *
      {
         if(this.rootClass.stage.getChildByName("mcColorPicker"))
         {
            return;
         }
         var _loc2_:colorPicker = new colorPicker();
         _loc2_.name = "mcColorPicker";
         this.rootClass.stage.addChild(_loc2_);
      }
      
      public function onCloseClick(param1:Event) : *
      {
         if(this.backData.intColorBase != this.avt.objData.intColorBase || this.backData.intColorTrim != this.avt.objData.intColorTrim || this.backData.intColorAccessory != this.avt.objData.intColorAccessory)
         {
            this.avt.objData.intColorBase = this.backData.intColorBase;
            this.avt.objData.intColorTrim = this.backData.intColorTrim;
            this.avt.objData.intColorAccessory = this.backData.intColorAccessory;
            this.avt.pMC.updateColor();
         }
         MovieClip(Game.root).mixer.playSound("Click");
         gotoAndPlay("out");
      }
      
      public function onSaveClick(param1:Event) : *
      {
         if(this.backData.intColorBase != this.avt.objData.intColorBase || this.backData.intColorTrim != this.avt.objData.intColorTrim || this.backData.intColorAccessory != this.avt.objData.intColorAccessory)
         {
            this.rootClass.world.sendChangeArmorColorRequest(this.avt.objData.intColorBase,this.avt.objData.intColorTrim,this.avt.objData.intColorAccessory);
         }
         MovieClip(Game.root).mixer.playSound("Click");
         gotoAndPlay("out");
      }
      
      public function onColorSelect(param1:Event) : void
      {
         switch(param1.target.name)
         {
            case "cpBase":
               this.avt.objData.intColorBase = param1.target.selectedColor;
               break;
            case "cpTrim":
               this.avt.objData.intColorTrim = param1.target.selectedColor;
               break;
            case "cpAccessory":
               this.avt.objData.intColorAccessory = param1.target.selectedColor;
         }
         this.avt.pMC.updateColor();
      }
      
      public function onItemRollOver(param1:Event) : void
      {
         var _loc2_:* = new Object();
         _loc2_.intColorSkin = this.avt.objData.intColorSkin;
         _loc2_.intColorHair = this.avt.objData.intColorHair;
         _loc2_.intColorEye = this.avt.objData.intColorEye;
         _loc2_.intColorBase = this.avt.objData.intColorBase;
         _loc2_.intColorTrim = this.avt.objData.intColorTrim;
         _loc2_.intColorAccessory = this.avt.objData.intColorAccessory;
         switch(param1.target.name)
         {
            case "cpBase":
               _loc2_.intColorBase = param1.target.selectedColor;
               break;
            case "cpTrim":
               _loc2_.intColorTrim = param1.target.selectedColor;
               break;
            case "cpAccessory":
               _loc2_.intColorAccessory = param1.target.selectedColor;
         }
         this.avt.pMC.updateColor(_loc2_);
      }
      
      public function onItemRollOut(param1:Event) : void
      {
         this.avt.pMC.updateColor();
      }
      
      internal function __setProp_cpAccessory_mcCustomizeArmor_Layer22_0() : *
      {
         try
         {
            this.cpAccessory["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.cpAccessory.allowUserColor = true;
         this.cpAccessory.selectedColor = 0;
         this.cpAccessory.columns = 21;
         this.cpAccessory.direction = "DL";
         this.cpAccessory.useAdvancedColorSelector = true;
         this.cpAccessory.useNoColorSelector = false;
         try
         {
            this.cpAccessory["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_cpTrim_mcCustomizeArmor_Layer23_0() : *
      {
         try
         {
            this.cpTrim["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.cpTrim.allowUserColor = true;
         this.cpTrim.selectedColor = 0;
         this.cpTrim.columns = 21;
         this.cpTrim.direction = "DL";
         this.cpTrim.useAdvancedColorSelector = true;
         this.cpTrim.useNoColorSelector = false;
         try
         {
            this.cpTrim["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_cpBase_mcCustomizeArmor_Layer24_0() : *
      {
         try
         {
            this.cpBase["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.cpBase.allowUserColor = true;
         this.cpBase.selectedColor = 0;
         this.cpBase.columns = 21;
         this.cpBase.direction = "DL";
         this.cpBase.useAdvancedColorSelector = true;
         this.cpBase.useNoColorSelector = false;
         try
         {
            this.cpBase["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

