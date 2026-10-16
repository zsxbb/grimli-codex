package
{
   import flash.net.*;
   import flash.text.*;
   
   public class LPFFrameHouseDesc extends LPFFrameItemPreview
   {
      public function LPFFrameHouseDesc()
      {
         super();
         mcPreview.visible = false;
         mcCoin.visible = false;
         mcUpgrade.visible = false;
         btnTry.visible = false;
         btnFGender.visible = false;
         btnMGender.visible = false;
         btnWiki.visible = false;
         btnDelete.visible = false;
      }
      
      override public function fClose() : void
      {
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      override protected function fDraw() : void
      {
         var _loc1_:String = "";
         var _loc2_:String = "";
         var _loc3_:Object = iSel;
         if(_loc3_ != null)
         {
            tInfo.htmlText = rootClass.getItemInfoStringB(_loc3_);
            tInfo.y = 0;
            tInfo.height = 121;
         }
         else
         {
            tInfo.htmlText = "Please select an item to preview.";
         }
      }
   }
}

