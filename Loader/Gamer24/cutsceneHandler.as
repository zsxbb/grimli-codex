package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class cutsceneHandler
   {
      private var rootClass:MovieClip;
      
      private var strMap:String;
      
      private var strFrame:String = "";
      
      private var strPad:String;
      
      private var changeMap:Boolean = false;
      
      private var strFile:String;
      
      private var cutFrame:String;
      
      private var cutPad:String;
      
      private var bDelayed:Boolean = false;
      
      private var cutTimer:Timer;
      
      private var polling:Boolean = false;
      
      private var waitTicks:int = 0;
      
      private var loadedTick:int = 0;
      
      private var baseChildren:int = 0;
      
      public function cutsceneHandler(param1:MovieClip)
      {
         super();
         this.rootClass = param1;
         this.startPoll();
      }
      
      private function startPoll() : void
      {
         if(!this.polling)
         {
            this.polling = true;
            this.waitTicks = 0;
            this.loadedTick = 0;
            this.rootClass.addEventListener(Event.ENTER_FRAME,this.onReadyPoll,false,0,true);
         }
      }
      
      public function isPending() : Boolean
      {
         return this.polling && this.strFile != null || this.cutTimer != null;
      }
      
      public function setCutsceneTarget(param1:String, param2:String, param3:String = "") : void
      {
         this.strFrame = param1;
         this.strPad = param2;
         this.strMap = param3;
         this.changeMap = param3 != "";
      }
      
      public function transfer() : void
      {
         trace("transfer");
         this.cancel();
         try
         {
            if(this.changeMap)
            {
               this.rootClass.world.gotoTown(this.strMap,this.strFrame,this.strPad);
            }
            else if(this.strFrame != "")
            {
               trace("strFrame: " + this.strFrame + " strPad: " + this.strPad);
               this.rootClass.world.moveToCell(this.strFrame,this.strPad);
            }
         }
         catch(e:Error)
         {
            trace("transfer move failed: " + e.message);
         }
         this.rootClass.clearExternamSWF();
      }
      
      public function showCutscene(param1:String, param2:Boolean = false, param3:String = "Cut1", param4:String = "Left") : void
      {
         trace("showCutscene deferred: " + param1 + " frame: " + param3);
         this.strFile = param1;
         this.cutFrame = param3;
         this.cutPad = param4;
         this.bDelayed = param2;
         this.startPoll();
      }
      
      private function onReadyPoll(param1:Event) : void
      {
         ++this.waitTicks;
         var _loc2_:* = this.rootClass.world;
         var _loc3_:Boolean = _loc2_ != null && _loc2_.map != null && !_loc2_.mapLoadInProgress;
         if(_loc3_ && this.loadedTick == 0)
         {
            this.loadedTick = this.waitTicks;
         }
         var _loc4_:Boolean = _loc3_ && (Boolean(_loc2_.mapEntered) || this.waitTicks - this.loadedTick >= 90);
         if((_loc4_) && this.strFile == null)
         {
            _loc4_ = false;
         }
         if(!_loc4_ && this.waitTicks < 450)
         {
            return;
         }
         this.polling = false;
         this.rootClass.removeEventListener(Event.ENTER_FRAME,this.onReadyPoll);
         if(this.strFile == null)
         {
            trace("cutscene poll expired with no showCutscene call");
            return;
         }
         trace("cutscene ready after " + this.waitTicks + " ticks, mapEntered: " + (_loc2_ != null ? _loc2_.mapEntered : "no world"));
         if(this.bDelayed)
         {
            this.cutTimer = new Timer(3000,1);
            this.cutTimer.addEventListener(TimerEvent.TIMER,this.onCutTimer,false,0,true);
            this.cutTimer.start();
         }
         else
         {
            this.fireCutscene();
         }
      }
      
      private function fireCutscene() : void
      {
         trace("fireCutscene: " + this.strFile);
         var _loc1_:MovieClip = this.rootClass.mcExtSWF as MovieClip;
         this.baseChildren = _loc1_ != null ? _loc1_.numChildren : 0;
         this.rootClass.loadExternalSWF(this.strFile);
         this.waitTicks = 0;
         this.polling = true;
         this.rootClass.addEventListener(Event.ENTER_FRAME,this.onOverlayPoll,false,0,true);
      }
      
      private function onOverlayPoll(param1:Event) : void
      {
         ++this.waitTicks;
         var _loc2_:MovieClip = this.rootClass.mcExtSWF as MovieClip;
         var _loc3_:Boolean = _loc2_ != null && _loc2_.numChildren > this.baseChildren;
         if(!_loc3_ && this.waitTicks < 450)
         {
            return;
         }
         this.polling = false;
         this.rootClass.removeEventListener(Event.ENTER_FRAME,this.onOverlayPoll);
         trace("cutscene overlay " + (_loc3_ ? "shown" : "TIMED OUT") + ", moving to " + this.cutFrame);
         if(!_loc3_)
         {
            this.rootClass.clearExternamSWF();
            return;
         }
         this.rootClass.world.moveToCell(this.cutFrame,this.cutPad);
      }
      
      private function onCutTimer(param1:TimerEvent) : void
      {
         this.cutTimer.stop();
         this.cutTimer.removeEventListener(TimerEvent.TIMER,this.onCutTimer);
         this.cutTimer = null;
         this.fireCutscene();
      }
      
      public function cancel() : void
      {
         this.polling = false;
         this.rootClass.removeEventListener(Event.ENTER_FRAME,this.onReadyPoll);
         this.rootClass.removeEventListener(Event.ENTER_FRAME,this.onOverlayPoll);
         if(this.cutTimer != null)
         {
            this.cutTimer.stop();
            this.cutTimer.removeEventListener(TimerEvent.TIMER,this.onCutTimer);
            this.cutTimer = null;
         }
      }
   }
}

