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
   
   public dynamic class game_1_mcNotificationWrapper_2 extends MovieClip
   {
      public var mcNoticeBubble:MovieClip;
      
      public function game_1_mcNotificationWrapper_2()
      {
         super();
      }
      
      public function notify(param1:String) : void
      {
         this.mcNoticeBubble.strNotice.text = param1;
         gotoAndPlay(3);
         visible = true;
      }
   }
}

