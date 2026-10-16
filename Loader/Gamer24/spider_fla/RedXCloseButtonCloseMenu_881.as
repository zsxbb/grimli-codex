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
   
   public dynamic class RedXCloseButtonCloseMenu_881 extends MovieClip
   {
      public var btnClose:SimpleButton;
      
      public function RedXCloseButtonCloseMenu_881()
      {
         super();
      }
      
      public function onButtonPress(param1:MouseEvent) : void
      {
         MovieClip(parent).gotoAndPlay("Close");
      }
   }
}

