package types
{
   import flash.display.MovieClip;
   
   public class ZSortItem
   {
      public var mc:MovieClip;
      
      public var oy:Number;
      
      public function ZSortItem(param1:MovieClip = null, param2:Number = 0)
      {
         super();
         this.mc = param1;
         this.oy = param2;
      }
   }
}

