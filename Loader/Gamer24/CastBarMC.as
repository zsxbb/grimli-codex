package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class CastBarMC extends MovieClip
   {
      public var cnt:MovieClip;
      
      public var o:Object = null;
      
      public var isOpen:Boolean = false;
      
      public var callback:Object = null;
      
      public var state:int = -1;
      
      public var dur:int = 1000;
      
      private var world:MovieClip;
      
      private var rootClass:MovieClip;
      
      private var mc:MovieClip;
      
      private var run:int;
      
      private var ts:Number;
      
      private var date:Date;
      
      public function CastBarMC()
      {
         super();
      }
      
      public function init() : void
      {
         this.mc = MovieClip(this);
         this.rootClass = MovieClip(stage.getChildAt(0));
      }
      
      public function fOpenWith(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.o = param1;
         this.isOpen = true;
         switch(this.o.typ)
         {
            case "sia":
               this.state = this.o.args.ID;
            case "generic":
               this.mc.cnt.t1.text = this.o.txt;
               _loc2_ = this.mc.cnt.fill;
               _loc3_ = this.mc.cnt.fillMask;
               _loc3_.x = int(_loc2_.x - _loc3_.width);
               this.run = int(_loc2_.x - _loc3_.x);
               this.date = new Date();
               this.ts = Number(this.date.getTime());
               this.dur = int(1000 * this.o.dur);
               _loc3_.removeEventListener(Event.ENTER_FRAME,this.slide);
               _loc3_.addEventListener(Event.ENTER_FRAME,this.slide);
               this.mc.cnt.tip.removeEventListener(Event.ENTER_FRAME,this.tipFollow);
               this.mc.cnt.tip.addEventListener(Event.ENTER_FRAME,this.tipFollow);
               this.mc.gotoAndPlay("in");
         }
      }
      
      public function fClose() : void
      {
         var _loc1_:* = undefined;
         if(this.isOpen)
         {
            this.o = null;
            this.state = -1;
            this.isOpen = false;
            _loc1_ = this.mc.cnt.fillMask;
            _loc1_.removeEventListener(Event.ENTER_FRAME,this.slide);
            this.mc.cnt.tip.removeEventListener(Event.ENTER_FRAME,this.tipFollow);
            this.mc.gotoAndPlay("out");
            this.rootClass.world.myAvatar.pMC.endAction();
         }
      }
      
      private function slide(param1:Event) : void
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         this.date = new Date();
         var _loc3_:* = this.date.getTime() - this.ts;
         var _loc4_:* = _loc3_ / this.dur;
         if(_loc4_ >= 1)
         {
            this.mc.gotoAndPlay("out");
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.slide);
            this.mc.cnt.tip.removeEventListener(Event.ENTER_FRAME,this.tipFollow);
            this.fCallback();
            this.fClose();
         }
         else
         {
            _loc2_.x = this.mc.cnt.fill.x - this.mc.cnt.fillMask.width + this.run * _loc4_;
         }
      }
      
      private function tipFollow(param1:Event) : void
      {
         var _loc2_:* = this.mc.cnt.tip;
         var _loc3_:* = this.mc.cnt.fillMask;
         _loc2_.x = _loc3_.x + _loc3_.width - _loc2_.width;
      }
      
      private function fCallback() : void
      {
         if(this.o.msg != null)
         {
            this.rootClass.chatF.pushMsg("event",this.o.msg,"SERVER","",0);
         }
         if(this.o.callback != null)
         {
            if(this.o.args != null)
            {
               this.o.callback(this.o.args);
            }
            else
            {
               this.o.callback();
            }
         }
         if(this.o.xtObj != null)
         {
            this.rootClass.sfc.sendXtMessage("zm",this.o.xtObj.cmd,this.o.xtObj.args,"str",this.rootClass.world.curRoom);
         }
      }
   }
}

