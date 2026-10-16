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
   
   public dynamic class mcCustomize_413 extends MovieClip
   {
      public var bg:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var btnColor:MovieClip;
      
      public var btnLeft:SimpleButton;
      
      public var btnRight:SimpleButton;
      
      public var cpEye:ColorPicker2;
      
      public var cpHair:ColorPicker2;
      
      public var cpSkin:ColorPicker2;
      
      public var submit:SimpleButton;
      
      public var txtHair:TextField;
      
      public var rootClass:*;
      
      public var avt:Avatar;
      
      public var backData:*;
      
      public var HairStyle:Array;
      
      public var intHairStyleIndex:int;
      
      public var arrColors:*;
      
      public var arrEyeColors:*;
      
      public var mcSets:colorSets;
      
      public function mcCustomize_413()
      {
         super();
         this.__setProp_cpEye_mcCustomize_cptabs_0();
         this.__setProp_cpSkin_mcCustomize_Layer22_0();
         this.__setProp_cpHair_mcCustomize_Layer23_0();
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
         if(this.avt.objData.HairID != this.backData.HairID)
         {
            this.avt.objData.HairID = this.backData.HairID;
            this.avt.objData.strHairName = this.backData.strHairName;
            this.avt.objData.strHairFilename = this.backData.strHairFilename;
            this.avt.pMC.loadHair();
         }
         this.avt.objData.intColorSkin = this.backData.intColorSkin;
         this.avt.objData.intColorHair = this.backData.intColorHair;
         this.avt.objData.intColorEye = this.backData.intColorEye;
         this.avt.pMC.updateColor();
         MovieClip(Game.root).mixer.playSound("Click");
         gotoAndPlay("out");
      }
      
      public function onSaveClick(param1:Event) : *
      {
         if(this.backData.HairID != this.avt.objData.HairID || this.backData.intColorSkin != this.avt.objData.intColorSkin || this.backData.intColorHair != this.avt.objData.intColorHair || this.backData.intColorEye != this.avt.objData.intColorEye)
         {
            this.rootClass.world.sendChangeColorRequest(this.avt.objData.intColorSkin,this.avt.objData.intColorHair,this.avt.objData.intColorEye,this.avt.objData.HairID);
         }
         MovieClip(Game.root).mixer.playSound("Click");
         gotoAndPlay("out");
      }
      
      public function nextHairStyle(param1:Event) : *
      {
         if(param1.currentTarget.name == "btnRight")
         {
            this.intHairStyleIndex = (this.intHairStyleIndex + 1) % this.HairStyle.length;
         }
         else if(param1.currentTarget.name == "btnLeft")
         {
            this.intHairStyleIndex = (this.intHairStyleIndex + this.HairStyle.length - 1) % this.HairStyle.length;
         }
         this.avt.objData.HairID = this.HairStyle[this.intHairStyleIndex].HairID;
         this.avt.objData.strHairName = this.HairStyle[this.intHairStyleIndex].sName;
         this.avt.objData.strHairFilename = this.HairStyle[this.intHairStyleIndex].sFile;
         this.txtHair.text = this.avt.objData.strHairName;
         this.avt.pMC.loadHair();
      }
      
      public function onColorSelect(param1:Event) : void
      {
         switch(param1.target.name)
         {
            case "cpSkin":
               this.avt.objData.intColorSkin = param1.target.selectedColor;
               break;
            case "cpEye":
               this.avt.objData.intColorEye = param1.target.selectedColor;
               break;
            case "cpHair":
               this.avt.objData.intColorHair = param1.target.selectedColor;
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
            case "cpSkin":
               _loc2_.intColorSkin = param1.target.selectedColor;
               break;
            case "cpEye":
               _loc2_.intColorEye = param1.target.selectedColor;
               break;
            case "cpHair":
               _loc2_.intColorHair = param1.target.selectedColor;
         }
         this.avt.pMC.updateColor(_loc2_);
      }
      
      public function onItemRollOut(param1:Event) : void
      {
         this.avt.pMC.updateColor();
      }
      
      internal function __setProp_cpEye_mcCustomize_cptabs_0() : *
      {
         try
         {
            this.cpEye["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.cpEye.allowUserColor = true;
         this.cpEye.selectedColor = 0;
         this.cpEye.columns = 21;
         this.cpEye.direction = "DL";
         this.cpEye.useAdvancedColorSelector = true;
         this.cpEye.useNoColorSelector = false;
         try
         {
            this.cpEye["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_cpSkin_mcCustomize_Layer22_0() : *
      {
         try
         {
            this.cpSkin["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.cpSkin.allowUserColor = true;
         this.cpSkin.selectedColor = 0;
         this.cpSkin.columns = 21;
         this.cpSkin.direction = "DL";
         this.cpSkin.useAdvancedColorSelector = true;
         this.cpSkin.useNoColorSelector = false;
         try
         {
            this.cpSkin["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_cpHair_mcCustomize_Layer23_0() : *
      {
         try
         {
            this.cpHair["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.cpHair.allowUserColor = true;
         this.cpHair.selectedColor = 0;
         this.cpHair.columns = 21;
         this.cpHair.direction = "DL";
         this.cpHair.useAdvancedColorSelector = true;
         this.cpHair.useNoColorSelector = false;
         try
         {
            this.cpHair["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

