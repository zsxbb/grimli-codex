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
   
   public dynamic class mcSkillUp_563 extends MovieClip
   {
      public var rootClass:MovieClip;
      
      public var c:int;
      
      public var t:int;
      
      public function mcSkillUp_563()
      {
         super();
      }
      
      public function fClose() : void
      {
         this.gotoAndStop("reset");
      }
      
      public function onSkillUpClick(param1:MouseEvent) : void
      {
         this.rootClass.toggleCharpanel("spend");
         this.fClose();
      }
   }
}

