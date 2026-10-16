package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   
   public class Projectile extends MovieClip
   {
      private var rootClass:MovieClip;
      
      private var interPoint:Point;
      
      private var pointStart:Point;
      
      private var mc:MovieClip;
      
      private var startTime:Number = 0;
      
      private var curTime:Number;
      
      private var timeTotal:Number;
      
      private var mcParent:MovieClip;
      
      private const velocity:Number = 1500;
      
      private var xPos:Number;
      
      private var yPos:Number;
      
      private var tempPoint:Point;
      
      public function Projectile(param1:Point, param2:Point, param3:MovieClip, param4:MovieClip)
      {
         this.interPoint = new Point();
         super();
         this.rootClass = param4;
         trace("start x: " + param1.x + " y: " + param1.y);
         trace("end x: " + param2.x + " y: " + param2.y);
         this.pointStart = param1;
         this.interPoint.x = param2.x - param1.x;
         trace("inter.x: " + this.interPoint.x);
         this.interPoint.y = param2.y - param1.y;
         this.mc = param3;
         this.mc.scaleX = this.interPoint.x < 0 ? this.mc.scaleX * -1 : Number(this.mc.scaleX);
         this.mcParent = MovieClip(this.mc.parent);
         var _loc5_:Number = param2.x - param1.x;
         var _loc6_:Number = param2.y - param1.y;
         var _loc7_:Number = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_);
         this.timeTotal = 1000 * (_loc7_ / this.velocity);
         trace("total time: " + this.timeTotal);
         this.startTime = getTimer();
         trace("projectile set up");
         this.addEventListener(Event.ENTER_FRAME,this.onEnter,false,0,true);
      }
      
      private function onEnter(param1:Event) : void
      {
         this.curTime = getTimer() - this.startTime;
         this.curTime = this.curTime >= this.timeTotal ? Number(this.timeTotal) : Number(this.curTime);
         this.xPos = this.pointStart.x + this.interPoint.x * (this.curTime / this.timeTotal);
         this.yPos = this.pointStart.y + this.interPoint.y * (this.curTime / this.timeTotal);
         trace("global x: " + this.xPos + " y: " + this.yPos);
         this.mc.x = this.pointStart.x + this.interPoint.x * (this.curTime / this.timeTotal);
         this.mc.y = this.pointStart.y + this.interPoint.y * (this.curTime / this.timeTotal);
         if(this.curTime >= this.timeTotal)
         {
            this.mc.visible = false;
            trace("removing projectile");
            this.mcParent.removeChild(this.mc);
            this.removeEventListener(Event.ENTER_FRAME,this.onEnter);
            return;
         }
      }
   }
}

