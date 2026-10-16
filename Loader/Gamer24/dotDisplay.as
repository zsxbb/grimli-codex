package
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   public dynamic class dotDisplay extends MovieClip
   {
      public var t:MovieClip;
      
      public var hpDisplay:int;
      
      public var randNum:Number;
      
      public function dotDisplay()
      {
         super();
      }
      
      public function init() : void
      {
         if(this.randNum < 0)
         {
            this.randNum = Math.random();
         }
         if(this.randNum <= 0.1)
         {
            gotoAndPlay("dot1");
         }
         else if(this.randNum <= 0.2 && this.randNum > 0.1)
         {
            gotoAndPlay("dot2");
         }
         else if(this.randNum <= 0.3 && this.randNum > 0.2)
         {
            gotoAndPlay("dot3");
         }
         else if(this.randNum <= 0.4 && this.randNum > 0.3)
         {
            gotoAndPlay("dot4");
         }
         else if(this.randNum <= 0.5 && this.randNum > 0.4)
         {
            gotoAndPlay("dot5");
         }
         else if(this.randNum <= 0.6 && this.randNum > 0.5)
         {
            gotoAndPlay("dot6");
         }
         else if(this.randNum <= 0.7 && this.randNum > 0.6)
         {
            gotoAndPlay("dot7");
         }
         else if(this.randNum <= 0.8 && this.randNum > 0.7)
         {
            gotoAndPlay("dot8");
         }
         else if(this.randNum <= 0.9 && this.randNum > 0.8)
         {
            gotoAndPlay("dot9");
         }
         else if(this.randNum <= 1 && this.randNum > 0.9)
         {
            gotoAndPlay("dot10");
         }
         else
         {
            gotoAndPlay("dot1");
         }
      }
      
      public function setText() : void
      {
         if(this.hpDisplay > 0)
         {
            this.t.ti.textColor = 15636736;
         }
         this.t.ti.text = Math.abs(this.hpDisplay);
      }
   }
}

