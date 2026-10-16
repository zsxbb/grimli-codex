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
   
   public dynamic class chkBox_40 extends MovieClip
   {
      public var checkmark:MovieClip;
      
      public var bitChecked:Boolean;
      
      public function chkBox_40()
      {
         super();
      }
      
      public function onClick(param1:MouseEvent) : *
      {
         this.bitChecked = !this.bitChecked;
         this.checkmark.visible = this.bitChecked;
      }
   }
}

