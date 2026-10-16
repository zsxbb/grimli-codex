package spider_fla
{
   import fl.controls.NumericStepper;
   import fl.controls.Slider;
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
   
   public dynamic class CameraToolWD_A_662 extends MovieClip
   {
      public var background:MovieClip;
      
      public var btnAddLayer:SimpleButton;
      
      public var btnDelLayer:SimpleButton;
      
      public var btnInCombat:SimpleButton;
      
      public var btnMirror:SimpleButton;
      
      public var btnSetFocus:SimpleButton;
      
      public var numWepScale:NumericStepper;
      
      public var sldrRotation:Slider;
      
      public var txtFocus:TextField;
      
      public function CameraToolWD_A_662()
      {
         super();
         this.__setProp_sldrRotation_CameraToolWD_A_Layer1_0();
         this.__setProp_numWepScale_CameraToolWD_A_Layer1_0();
      }
      
      internal function __setProp_sldrRotation_CameraToolWD_A_Layer1_0() : *
      {
         try
         {
            this.sldrRotation["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.sldrRotation.direction = "horizontal";
         this.sldrRotation.enabled = true;
         this.sldrRotation.liveDragging = true;
         this.sldrRotation.maximum = 360;
         this.sldrRotation.minimum = 0;
         this.sldrRotation.snapInterval = 0;
         this.sldrRotation.tickInterval = 0;
         this.sldrRotation.value = 0;
         this.sldrRotation.visible = true;
         try
         {
            this.sldrRotation["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_numWepScale_CameraToolWD_A_Layer1_0() : *
      {
         try
         {
            this.numWepScale["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.numWepScale.enabled = true;
         this.numWepScale.maximum = 10;
         this.numWepScale.minimum = 0;
         this.numWepScale.stepSize = 0.001;
         this.numWepScale.value = 0.222;
         this.numWepScale.visible = true;
         try
         {
            this.numWepScale["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

