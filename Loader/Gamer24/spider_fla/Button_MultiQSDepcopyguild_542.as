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
   
   public dynamic class Button_MultiQSDepcopyguild_542 extends MovieClip
   {
      public var btnButton:MovieClip;
      
      public var txtLabel:TextField;
      
      public var rootClass:*;
      
      public var world:*;
      
      public function Button_MultiQSDepcopyguild_542()
      {
         super();
      }
      
      public function onButtonPress(param1:MouseEvent) : void
      {
         if(this.bitMemberOnly)
         {
            this.rootClass.showUpgradeWindow();
         }
         else
         {
            navigateToURL(new URLRequest("https://www.aq.com/order-now/direct/"),"_blank");
         }
      }
   }
}

