package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   public dynamic class Bank extends MovieClip
   {
      public var bg1:MovieClip;
      
      public var btnBank:SimpleButton;
      
      public var btnBankAC:SimpleButton;
      
      public var btnFromInventory:SimpleButton;
      
      public var btnToInventory:SimpleButton;
      
      public var mcBankList:ItemList;
      
      public var mcCoin:MovieClip;
      
      public var mcCoinBank:MovieClip;
      
      public var mcItemList:ItemList;
      
      public var mcUpgrade:MovieClip;
      
      public var mcUpgradeBank:MovieClip;
      
      public var strCoins:TextField;
      
      public var strGold:TextField;
      
      public var strInfo:TextField;
      
      public var strNewInfo:TextField;
      
      public var txtBagSlots:TextField;
      
      public var txtBankSlots:TextField;
      
      public function Bank()
      {
         super();
      }
   }
}

