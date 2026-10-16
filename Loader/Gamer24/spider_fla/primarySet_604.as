package spider_fla
{
   import fl.controls.ColorPicker;
   import fl.controls.ComboBox;
   import fl.controls.NumericStepper;
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
   
   public dynamic class primarySet_604 extends MovieClip
   {
      public var btnClass1:SimpleButton;
      
      public var btnClass2:SimpleButton;
      
      public var btnClass3:SimpleButton;
      
      public var btnClass4:SimpleButton;
      
      public var btnClass5:SimpleButton;
      
      public var btnDeattach:SimpleButton;
      
      public var btnEmote:SimpleButton;
      
      public var btnFreezePlayer:SimpleButton;
      
      public var btnGlowMain:SimpleButton;
      
      public var btnGlowOff:SimpleButton;
      
      public var btnGlowPlayer:SimpleButton;
      
      public var btnHitPlayer:SimpleButton;
      
      public var btnResetPlayer:SimpleButton;
      
      public var btnShowDeattach:SimpleButton;
      
      public var btnStonePlayer:SimpleButton;
      
      public var btnToggleDummy:SimpleButton;
      
      public var btnVisibility:SimpleButton;
      
      public var cbEmotes:ComboBox;
      
      public var cbVisibility:ComboBox;
      
      public var colBG:ColorPicker;
      
      public var colGlow:ColorPicker;
      
      public var colGlowMain:ColorPicker;
      
      public var colGlowOff:ColorPicker;
      
      public var numScaling:NumericStepper;
      
      public var txtClassName:TextField;
      
      public var txtDeattached:TextField;
      
      public function primarySet_604()
      {
         super();
         this.__setProp_numScaling_primarySet_Layer1_0();
      }
      
      internal function __setProp_numScaling_primarySet_Layer1_0() : *
      {
         try
         {
            this.numScaling["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.numScaling.enabled = true;
         this.numScaling.maximum = 10;
         this.numScaling.minimum = 0;
         this.numScaling.stepSize = 0.1;
         this.numScaling.value = 3;
         this.numScaling.visible = true;
         try
         {
            this.numScaling["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

