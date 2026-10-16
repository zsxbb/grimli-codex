package
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class mcSkel extends MovieClip
   {
      public var arrow:MovieClip;
      
      public var backfoot:MovieClip;
      
      public var backhair:MovieClip;
      
      public var backhand:MovieClip;
      
      public var backrobe:MovieClip;
      
      public var backshin:MovieClip;
      
      public var backshoulder:MovieClip;
      
      public var backthigh:MovieClip;
      
      public var cape:MovieClip;
      
      public var chest:MovieClip;
      
      public var emoteFX:MovieClip;
      
      public var frontfoot:MovieClip;
      
      public var fronthand:MovieClip;
      
      public var frontshin:MovieClip;
      
      public var frontshoulder:MovieClip;
      
      public var frontthigh:MovieClip;
      
      public var head:MovieClip;
      
      public var hip:MovieClip;
      
      public var hitbox:MovieClip;
      
      public var idlefoot:MovieClip;
      
      public var pvpFlag:MovieClip;
      
      public var robe:MovieClip;
      
      public var shield:MovieClip;
      
      public var weapon:MovieClip;
      
      public var weaponFist:MovieClip;
      
      public var weaponFistOff:MovieClip;
      
      public var weaponOff:MovieClip;
      
      public var weaponTemp:MovieClip;
      
      public var animLoop:int;
      
      public var avtMC:MovieClip;
      
      public var projClass:Class;
      
      public var projMC:MovieClip;
      
      public var sp:Point;
      
      public var ep:Point;
      
      public var onMove:Boolean = false;
      
      public function mcSkel()
      {
         super();
      }
      
      public function emoteLoopFrame() : int
      {
         var _loc1_:int = 0;
         while(_loc1_ < currentLabels.length)
         {
            if(currentLabels[_loc1_].name == currentLabel)
            {
               return currentLabels[_loc1_].frame;
            }
            _loc1_++;
         }
         return 8;
      }
      
      public function emoteLoop(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:int = this.emoteLoopFrame();
         if(_loc3_ > 8)
         {
            if(++this.animLoop < param1)
            {
               this.gotoAndPlay(_loc3_ + 1);
               return;
            }
         }
         if(param2)
         {
            this.gotoAndPlay("Idle");
         }
      }
      
      public function showIdleFoot() : *
      {
         this.frontfoot.visible = false;
         this.idlefoot.visible = true;
      }
      
      public function showFrontFoot() : *
      {
         this.idlefoot.visible = false;
         this.frontfoot.visible = true;
      }
      
      override public function gotoAndPlay(param1:Object, param2:String = null) : void
      {
         var _loc3_:Array = null;
         if(MovieClip(parent).pAV != null && MovieClip(parent).pAV.morphMC != null && Boolean(MovieClip(parent).pAV.morphMC.visible))
         {
            _loc3_ = ["Idle","Walk"];
            if(_loc3_.indexOf(param1) > -1)
            {
               if(MovieClip(parent).pAV.morphMC.currentLabel != param1)
               {
                  MovieClip(parent).pAV.morphMC.onMove = true;
                  MovieClip(parent).pAV.morphMC.gotoAndPlay(param1);
               }
            }
         }
         if(!this.handleAnimEvent(String(param1)))
         {
            super.gotoAndPlay(param1);
         }
      }
      
      private function handleAnimEvent(param1:String) : Boolean
      {
         var f:Function = null;
         var o:Boolean = false;
         var strAnim:String = param1;
         var animEvents:Object = MovieClip(parent).AnimEvent;
         if(animEvents[strAnim] == null)
         {
            return false;
         }
         f = animEvents[strAnim][0];
         o = Boolean(animEvents[strAnim][1]);
         try
         {
            f();
         }
         catch(e:*)
         {
            trace("[Avatar] ERR handleAnimEvent: armor missing anim listener " + strAnim);
         }
         if(!o || strAnim == "Idle")
         {
            return false;
         }
         return true;
      }
   }
}

