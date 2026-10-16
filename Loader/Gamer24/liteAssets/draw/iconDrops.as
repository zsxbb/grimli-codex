package liteAssets.draw
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.filters.*;
   import flash.utils.*;
   
   public class iconDrops extends MovieClip
   {
      public var border:MovieClip;
      
      internal var rootClass:MovieClip;
      
      private var alertTimer:Timer;
      
      private var glowFilter:GlowFilter;
      
      private var alternate:Boolean = false;
      
      public function iconDrops()
      {
         super();
         this.buttonMode = true;
         this.addEventListener(MouseEvent.CLICK,this.onBtDrop,false,0,true);
         this.glowFilter = new GlowFilter(16777215,1,35,35,1,1,true,false);
         this.alertTimer = new Timer(50);
         this.alertTimer.addEventListener(TimerEvent.TIMER,this.onGlow,false,0,true);
      }
      
      public function initRoot(param1:MovieClip) : void
      {
         this.rootClass = param1;
      }
      
      public function onBtDrop(param1:MouseEvent) : void
      {
         if(this.alertTimer.running)
         {
            this.alertTimer.stop();
            this.border.filters = [];
         }
         param1.stopPropagation();
         this.rootClass.cDropsUI.onShow();
      }
      
      public function onAlert() : void
      {
         if(this.alertTimer.running)
         {
            return;
         }
         this.glowFilter.strength = 1;
         this.border.filters = [this.glowFilter];
         this.alternate = false;
         this.alertTimer.start();
      }
      
      public function onGlow(param1:TimerEvent) : void
      {
         if(this.rootClass.cDropsUI.isMenuOpen())
         {
            this.alertTimer.stop();
            this.border.filters = [];
            return;
         }
         this.glowFilter.strength += !!this.alternate ? 0.05 : -0.05;
         this.border.filters = [this.glowFilter];
         if(this.glowFilter.strength <= 0 || this.glowFilter.strength >= 1)
         {
            this.alternate = this.glowFilter.strength <= 0 ? true : false;
         }
      }
      
      public function cleanup() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.onBtDrop);
         if(this.alertTimer != null)
         {
            this.alertTimer.stop();
            this.alertTimer.removeEventListener(TimerEvent.TIMER,this.onGlow);
            this.alertTimer = null;
         }
         this.border.filters = [];
         this.glowFilter = null;
         this.rootClass = null;
      }
   }
}

