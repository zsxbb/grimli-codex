package
{
   public class RandomNumber
   {
      internal const MAX_RATIO:Number = 4.656612875245797e-10;
      
      private var r:int;
      
      private var randNum:Number;
      
      public function RandomNumber()
      {
         this.NEGA_MAX_RATIO = -this.MAX_RATIO;
         this.r = Math.random() * int.MAX_VALUE;
         super();
      }
      
      public function rand(param1:Number = 0, param2:Number = 1) : Number
      {
         this.randNum = this.XORandom() * (param2 - param1) + param1;
         return this.randNum < param2 ? Number(this.randNum) : param2;
      }
      
      private function XORandom() : Number
      {
         this.r ^= this.r << 21;
         this.r ^= this.r >>> 35;
         this.r ^= this.r << 4;
         if(this.r > 0)
         {
            return this.r * this.MAX_RATIO;
         }
         return this.r * this.NEGA_MAX_RATIO;
      }
      
      public function newSeed() : void
      {
         this.r = Math.random() * int.MAX_VALUE;
      }
   }
}

