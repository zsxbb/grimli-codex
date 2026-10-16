package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   import flash.utils.*;
   
   public class battleAnalyzer extends MovieClip
   {
      public var bgStart:MovieClip;
      
      public var btnClose:MovieClip;
      
      public var txtStart:TextField;
      
      public var txtValues:TextField;
      
      internal var startTime:Number;
      
      internal var seconds:Number = 0;
      
      private var _running:Boolean = false;
      
      internal var dmg:Number = 0;
      
      internal var heal:Number = 0;
      
      internal var dmgRecv:Number = 0;
      
      internal var gold:Number = 0;
      
      internal var xp:Number = 0;
      
      internal var kills:Number = 0;
      
      public function battleAnalyzer()
      {
         super();
         this.bgStart.addEventListener(MouseEvent.CLICK,this.onStart,false,0,true);
         this.bgStart.buttonMode = true;
         this.txtStart.mouseEnabled = false;
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onDrag,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_UP,this.onStopDrag,false,0,true);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onBtnClose,false,0,true);
      }
      
      public function onBattleTimer(param1:Event) : void
      {
         this.seconds = Math.round(Math.abs(this.startTime - new Date().getTime()) / 1000);
         this.updateDisplay();
      }
      
      public function updateDisplay() : void
      {
         this.txtValues.text = this.formatSeconds() + "\n" + this.addCommas(this.dmg) + (" (" + this.addCommas(Math.round(this.dmg / this.seconds)) + "/sec)") + "\n" + this.addCommas(this.heal) + (" (" + this.addCommas(Math.round(this.heal / this.seconds)) + "/sec)") + "\n" + this.addCommas(this.dmgRecv) + (" (" + this.addCommas(Math.round(this.dmgRecv / this.seconds)) + "/sec)") + "\n" + this.addCommas(this.gold) + (" (" + this.addCommas(Math.round(this.gold / this.seconds)) + "/sec)") + "\n" + this.addCommas(this.xp) + (" (" + this.addCommas(Math.round(this.xp / this.seconds)) + "/sec)") + "\n" + this.addCommas(this.kills) + (" (" + (this.seconds == 0 ? "0" : Number(this.kills / (this.seconds / 60)).toFixed(2)) + "/min)");
      }
      
      public function addCommas(param1:uint) : String
      {
         var _loc4_:uint = 0;
         if(param1 == 0)
         {
            return "0";
         }
         var _loc2_:String = "";
         var _loc3_:uint = param1;
         while(_loc3_ > 0)
         {
            _loc4_ = _loc3_ % 1000;
            _loc2_ = (_loc3_ > 999 ? "," + (_loc4_ < 100 ? (_loc4_ < 10 ? "00" : "0") : "") : "") + _loc4_ + _loc2_;
            _loc3_ /= 1000;
         }
         return _loc2_;
      }
      
      public function isRunning() : Boolean
      {
         return this._running;
      }
      
      public function formatSeconds() : String
      {
         var _loc1_:* = Math.floor(this.seconds / 3600);
         var _loc2_:* = Math.floor(this.seconds % 3600 / 60);
         var _loc3_:* = this.seconds % 60;
         if(_loc1_ < 10)
         {
            _loc1_ = "0" + _loc1_;
         }
         if(_loc2_ < 10)
         {
            _loc2_ = "0" + _loc2_;
         }
         if(_loc3_ < 10)
         {
            _loc3_ = "0" + _loc3_;
         }
         return _loc1_ + ":" + _loc2_ + ":" + _loc3_;
      }
      
      public function addDamage(param1:Number) : void
      {
         this.dmg += param1;
      }
      
      public function addHeal(param1:Number) : void
      {
         this.heal += param1;
      }
      
      public function addReceived(param1:Number) : void
      {
         this.dmgRecv += param1;
      }
      
      public function addGold(param1:Number) : void
      {
         this.gold += param1;
      }
      
      public function addExp(param1:Number) : void
      {
         this.xp += param1;
      }
      
      public function addKill() : void
      {
         this.kills += 1;
      }
      
      public function reset() : void
      {
         this.startTime = new Date().getTime();
         this.seconds = 0;
         this.dmg = 0;
         this.heal = 0;
         this.dmgRecv = 0;
         this.gold = 0;
         this.xp = 0;
         this.kills = 0;
         this.updateDisplay();
      }
      
      public function toggle() : void
      {
         this.bgStart.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      public function onStart(param1:MouseEvent) : void
      {
         if(this._running)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onBattleTimer);
         }
         else
         {
            this.reset();
            this.addEventListener(Event.ENTER_FRAME,this.onBattleTimer,false,0,true);
         }
         this._running = !this._running;
         this.txtStart.text = !!this._running ? "Stop" : "Start";
      }
      
      public function onBtnClose(param1:MouseEvent) : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.onBattleTimer);
         MovieClip(getChildAt(0)).bAnalyzer = null;
         parent.removeChild(this);
      }
      
      public function onDrag(param1:MouseEvent) : void
      {
         this.startDrag();
      }
      
      public function onStopDrag(param1:MouseEvent) : void
      {
         this.stopDrag();
      }
   }
}

