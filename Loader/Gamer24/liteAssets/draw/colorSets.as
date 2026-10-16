package liteAssets.draw
{
   import fl.controls.ComboBox;
   import fl.controls.TextInput;
   import fl.data.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class colorSets extends MovieClip
   {
      public var bg:MovieClip;
      
      public var btnAdd:SimpleButton;
      
      public var btnApply:SimpleButton;
      
      public var btnCopy:SimpleButton;
      
      public var btnDel:SimpleButton;
      
      public var cPreview1:MovieClip;
      
      public var cPreview2:MovieClip;
      
      public var cPreview3:MovieClip;
      
      public var cbSets:ComboBox;
      
      public var txtColor1:TextField;
      
      public var txtColor2:TextField;
      
      public var txtColor3:TextField;
      
      public var txtName:TextInput;
      
      public var mode:String;
      
      internal var rootClass:MovieClip;
      
      public function colorSets(param1:MovieClip)
      {
         super();
         this.rootClass = param1;
         this.txtColor1.text = "#ffffff";
         this.txtColor2.text = "#ffffff";
         this.txtColor3.text = "#ffffff";
         this.txtName.text = "My Color Set 1";
         this.cbSets.addEventListener(MouseEvent.CLICK,this.onCbSets,false,0,true);
         this.cbSets.addEventListener(Event.CHANGE,this.onCbSets,false,0,true);
         this.txtColor1.addEventListener(Event.CHANGE,this.onTxtColor1,false,0,true);
         this.txtColor2.addEventListener(Event.CHANGE,this.onTxtColor2,false,0,true);
         this.txtColor3.addEventListener(Event.CHANGE,this.onTxtColor3,false,0,true);
         this.btnApply.addEventListener(MouseEvent.CLICK,this.onBtApply,false,0,true);
         this.btnAdd.addEventListener(MouseEvent.CLICK,this.onBtAdd,false,0,true);
         this.btnDel.addEventListener(MouseEvent.CLICK,this.onBtDel,false,0,true);
         this.btnCopy.addEventListener(MouseEvent.CLICK,this.onBtCopy,false,0,true);
         this.__setProp_txtName_mcColorSets_Layer1_0();
      }
      
      public function onUpdate() : void
      {
         if(this.rootClass.litePreference.data.colorSets)
         {
            this.cbSets.dataProvider = new DataProvider(this.rootClass.litePreference.data.colorSets);
         }
      }
      
      private function onBtCopy(param1:MouseEvent) : void
      {
         if(this.mode == "mcCustomize")
         {
            this.txtColor1.text = "#" + this.rootClass.ui.mcPopup.mcCustomize.cpHair.selectedColor.toString(16);
            this.txtColor2.text = "#" + this.rootClass.ui.mcPopup.mcCustomize.cpSkin.selectedColor.toString(16);
            this.txtColor3.text = "#" + this.rootClass.ui.mcPopup.mcCustomize.cpEye.selectedColor.toString(16);
         }
         else
         {
            this.txtColor1.text = "#" + this.rootClass.ui.mcPopup.mcCustomizeArmor.cpBase.selectedColor.toString(16);
            this.txtColor2.text = "#" + this.rootClass.ui.mcPopup.mcCustomizeArmor.cpTrim.selectedColor.toString(16);
            this.txtColor3.text = "#" + this.rootClass.ui.mcPopup.mcCustomizeArmor.cpAccessory.selectedColor.toString(16);
         }
         this.txtColor1.dispatchEvent(new Event(Event.CHANGE));
         this.txtColor2.dispatchEvent(new Event(Event.CHANGE));
         this.txtColor3.dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function onBtApply(param1:MouseEvent) : void
      {
         if(this.mode == "mcCustomize")
         {
            this.rootClass.ui.mcPopup.mcCustomize.cpHair.selectedColor = int("0x" + this.txtColor1.text.replace("#",""));
            this.rootClass.ui.mcPopup.mcCustomize.cpSkin.selectedColor = int("0x" + this.txtColor2.text.replace("#",""));
            this.rootClass.ui.mcPopup.mcCustomize.cpEye.selectedColor = int("0x" + this.txtColor3.text.replace("#",""));
            if(!this.rootClass.ui.mcPopup.mcCustomize.backData.intColorHair)
            {
               this.rootClass.ui.mcPopup.mcCustomize.backData.intColorHair = this.rootClass.world.myAvatar.objData.intColorHair;
            }
            if(!this.rootClass.ui.mcPopup.mcCustomize.backData.intColorSkin)
            {
               this.rootClass.ui.mcPopup.mcCustomize.backData.intColorSkin = this.rootClass.world.myAvatar.objData.intColorSkin;
            }
            if(!this.rootClass.ui.mcPopup.mcCustomize.backData.intColorEye)
            {
               this.rootClass.ui.mcPopup.mcCustomize.backData.intColorEye = this.rootClass.world.myAvatar.objData.intColorEye;
            }
            this.rootClass.world.myAvatar.objData.intColorHair = int("0x" + this.txtColor1.text.replace("#",""));
            this.rootClass.world.myAvatar.objData.intColorSkin = int("0x" + this.txtColor2.text.replace("#",""));
            this.rootClass.world.myAvatar.objData.intColorEye = int("0x" + this.txtColor3.text.replace("#",""));
         }
         else
         {
            this.rootClass.ui.mcPopup.mcCustomizeArmor.cpBase.selectedColor = int("0x" + this.txtColor1.text.replace("#",""));
            this.rootClass.ui.mcPopup.mcCustomizeArmor.cpTrim.selectedColor = int("0x" + this.txtColor2.text.replace("#",""));
            this.rootClass.ui.mcPopup.mcCustomizeArmor.cpAccessory.selectedColor = int("0x" + this.txtColor3.text.replace("#",""));
            if(!this.rootClass.ui.mcPopup.mcCustomizeArmor.backData.intColorBase)
            {
               this.rootClass.ui.mcPopup.mcCustomizeArmor.backData.intColorBase = this.rootClass.world.myAvatar.objData.intColorBase;
            }
            if(!this.rootClass.ui.mcPopup.mcCustomizeArmor.backData.intColorTrim)
            {
               this.rootClass.ui.mcPopup.mcCustomizeArmor.backData.intColorTrim = this.rootClass.world.myAvatar.objData.intColorTrim;
            }
            if(!this.rootClass.ui.mcPopup.mcCustomizeArmor.backData.intColorAccessory)
            {
               this.rootClass.ui.mcPopup.mcCustomizeArmor.backData.intColorAccessory = this.rootClass.world.myAvatar.objData.intColorAccessory;
            }
            this.rootClass.world.myAvatar.objData.intColorBase = int("0x" + this.txtColor1.text.replace("#",""));
            this.rootClass.world.myAvatar.objData.intColorTrim = int("0x" + this.txtColor2.text.replace("#",""));
            this.rootClass.world.myAvatar.objData.intColorAccessory = int("0x" + this.txtColor3.text.replace("#",""));
         }
         this.rootClass.world.myAvatar.pMC.updateColor();
      }
      
      private function onCbSets(param1:Event) : void
      {
         if(this.cbSets.selectedIndex < 0)
         {
            return;
         }
         this.txtName.text = this.cbSets.selectedItem.label;
         this.txtColor1.text = this.cbSets.selectedItem.color1;
         this.txtColor2.text = this.cbSets.selectedItem.color2;
         this.txtColor3.text = this.cbSets.selectedItem.color3;
         this.txtColor1.dispatchEvent(new Event(Event.CHANGE));
         this.txtColor2.dispatchEvent(new Event(Event.CHANGE));
         this.txtColor3.dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function onTxtColor1(param1:Event) : void
      {
         var _loc2_:* = undefined;
         try
         {
            _loc2_ = new ColorTransform();
            _loc2_.color = int("0x" + this.txtColor1.text.replace("#",""));
            this.cPreview1.transform.colorTransform = _loc2_;
         }
         catch(exception:*)
         {
         }
      }
      
      private function onTxtColor2(param1:Event) : void
      {
         var _loc2_:* = undefined;
         try
         {
            _loc2_ = new ColorTransform();
            _loc2_.color = int("0x" + this.txtColor2.text.replace("#",""));
            this.cPreview2.transform.colorTransform = _loc2_;
         }
         catch(exception:*)
         {
         }
      }
      
      private function onTxtColor3(param1:Event) : void
      {
         var _loc2_:* = undefined;
         try
         {
            _loc2_ = new ColorTransform();
            _loc2_.color = int("0x" + this.txtColor3.text.replace("#",""));
            this.cPreview3.transform.colorTransform = _loc2_;
         }
         catch(exception:*)
         {
         }
      }
      
      private function onBtAdd(param1:MouseEvent) : void
      {
         this.cbSets.addItem({
            "label":this.txtName.text,
            "color1":this.txtColor1.text,
            "color2":this.txtColor2.text,
            "color3":this.txtColor3.text
         });
         this.rootClass.litePreference.data.colorSets = this.cbSets.dataProvider.toArray();
         this.rootClass.litePreference.flush();
      }
      
      private function onBtDel(param1:MouseEvent) : void
      {
         if(this.cbSets.selectedIndex != -1)
         {
            this.cbSets.removeItemAt(this.cbSets.selectedIndex);
         }
         this.cbSets.selectedIndex = -1;
         this.rootClass.litePreference.data.colorSets = this.cbSets.dataProvider.toArray();
         this.rootClass.litePreference.flush();
      }
      
      internal function __setProp_txtName_mcColorSets_Layer1_0() : *
      {
         try
         {
            this.txtName["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.txtName.displayAsPassword = false;
         this.txtName.editable = true;
         this.txtName.enabled = true;
         this.txtName.maxChars = 25;
         this.txtName.restrict = "";
         this.txtName.text = "";
         this.txtName.visible = true;
         try
         {
            this.txtName["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

