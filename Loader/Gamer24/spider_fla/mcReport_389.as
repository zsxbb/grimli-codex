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
   
   public dynamic class mcReport_389 extends MovieClip
   {
      public var bg:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var i0:MovieClip;
      
      public var i1:MovieClip;
      
      public var i2:MovieClip;
      
      public var i3:MovieClip;
      
      public var submit:MovieClip;
      
      public var tDesc:TextField;
      
      public var ti:TextField;
      
      public var iSel:*;
      
      public var mc:*;
      
      public var defaultDesc:String;
      
      public var tDetailTemplate:*;
      
      public var rootClass:MovieClip;
      
      public function mcReport_389()
      {
         super();
      }
      
      public function itemClick(param1:MouseEvent) : *
      {
         this.iSel = int(MovieClip(param1.currentTarget).name.substr(1));
         var _loc2_:* = 0;
         while(_loc2_ < 4)
         {
            if(this.mc["i" + _loc2_] != null)
            {
               this.mc["i" + _loc2_].d.f1.visible = _loc2_ == this.iSel;
            }
            _loc2_++;
         }
         this.mc.submit.visible = true;
         if(this.tDetailTemplate.indexOf(this.tDesc.text) > -1 || this.tDesc.text == this.defaultDesc || this.tDesc.text == " " || this.tDesc.text == "")
         {
            this.tDesc.text = this.tDetailTemplate[this.iSel];
         }
      }
      
      public function submitClick(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(stage.getChildAt(0));
         var _loc3_:* = MovieClip(parent);
         var _loc4_:String = " ";
         if(this.tDesc.text.length > 3 && this.tDesc.text != this.defaultDesc)
         {
            _loc4_ = this.tDesc.text;
         }
         _loc2_.world.sendReport(["reportlang",_loc3_.fData.unm,this.iSel,_loc4_]);
         _loc3_.onClose(null);
      }
      
      public function onClose(param1:Event = null) : void
      {
         if(MovieClip(parent).currentLabel != "Init")
         {
            this.rootClass.mixer.playSound("Click");
            MovieClip(parent).gotoAndPlay("Init");
         }
      }
   }
}

