package
{
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class Killvis extends EventDispatcher
   {
      internal var vobj:*;
      
      internal var vTimer:Timer;
      
      public function Killvis()
      {
         this.vTimer = new Timer(1000,1);
         super();
         this.vTimer.addEventListener(TimerEvent.TIMER,this.noVis,false,0,true);
      }
      
      public function kill(param1:Object, param2:int) : *
      {
         this.vobj = param1;
         this.vTimer.delay = param2;
         this.vTimer.reset();
         this.vTimer.start();
      }
      
      public function stopkill() : *
      {
         if(this.vTimer != null && Boolean(this.vTimer.running))
         {
            this.vTimer.stop();
         }
      }
      
      public function resetkill() : *
      {
         if(this.vTimer != null && Boolean(this.vTimer.running))
         {
            this.vTimer.reset();
            this.vTimer.start();
         }
      }
      
      public function noVis(param1:TimerEvent) : *
      {
         this.vobj.visible = false;
         MovieClip(MovieClip(this.vobj).parent).kv = null;
      }
      
      public function dispose() : void
      {
         if(this.vTimer != null)
         {
            this.vTimer.stop();
            this.vTimer.removeEventListener(TimerEvent.TIMER,this.noVis);
            this.vTimer = null;
         }
         this.vobj = null;
      }
   }
}

