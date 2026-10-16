package
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class HealIconMC extends MovieClip
   {
      public var hit:MovieClip;
      
      public var shp:MovieClip;
      
      private var world:MovieClip;
      
      private var avt:Avatar;
      
      public function HealIconMC(param1:Avatar, param2:MovieClip)
      {
         super();
         this.world = param2;
         this.avt = param1;
         this.hit.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.hit.buttonMode = true;
         this.hit.alpha = 0;
         this.shp.mouseEnabled = false;
         this.shp.mouseChildren = false;
         y = this.avt.pMC.pname.y - height - 5;
         x -= int(width / 2);
      }
      
      public function onClick(param1:MouseEvent) : void
      {
         this.world.healByIcon(this.avt);
         this.fClose();
      }
      
      public function fClose() : void
      {
         stop();
         this.hit.removeEventListener(MouseEvent.CLICK,this.onClick);
         if(parent != null && parent.contains(this))
         {
            parent.removeChild(this);
         }
         this.world = null;
         this.avt = null;
      }
   }
}

