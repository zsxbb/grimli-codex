package
{
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   
   public class LPFFrameHousePreview extends LPFFrameItemPreview
   {
      public function LPFFrameHousePreview()
      {
         super();
         mcCoin.visible = false;
         mcUpgrade.visible = false;
         btnTry.visible = false;
         btnFGender.visible = false;
         btnMGender.visible = false;
         btnWiki.visible = false;
         btnWiki.addEventListener(MouseEvent.CLICK,super.onBtnWiki,false,0,true);
         btnWiki.addEventListener(MouseEvent.MOUSE_OVER,super.onWikiTTOver,false,0,true);
         btnWiki.addEventListener(MouseEvent.MOUSE_OUT,super.onWikiTTOut,false,0,true);
         btnDelete.addEventListener(MouseEvent.CLICK,super.onBtnDeleteClick,false,0,true);
         btnDelete.addEventListener(MouseEvent.MOUSE_OVER,super.onDeleteTTOver,false,0,true);
         btnDelete.addEventListener(MouseEvent.MOUSE_OUT,super.onDeleteTTOut,false,0,true);
         mcCoin.addEventListener(MouseEvent.MOUSE_OVER,super.onCoinTTOver,false,0,true);
         mcCoin.addEventListener(MouseEvent.MOUSE_OUT,super.onCoinTTOut,false,0,true);
         mcUpgrade.addEventListener(MouseEvent.MOUSE_OVER,super.onUpgradeTTOver,false,0,true);
         mcUpgrade.addEventListener(MouseEvent.MOUSE_OUT,super.onUpgradeTTOut,false,0,true);
         addEventListener(Event.ENTER_FRAME,super.onEF,false,0,true);
      }
      
      override public function fClose() : void
      {
         removeEventListener(Event.ENTER_FRAME,super.onEF);
         btnWiki.removeEventListener(MouseEvent.CLICK,super.onBtnWiki);
         btnWiki.removeEventListener(MouseEvent.MOUSE_OVER,super.onWikiTTOver);
         btnWiki.removeEventListener(MouseEvent.MOUSE_OUT,super.onWikiTTOut);
         btnDelete.removeEventListener(MouseEvent.CLICK,super.onBtnDeleteClick);
         btnDelete.removeEventListener(MouseEvent.MOUSE_OVER,super.onDeleteTTOver);
         btnDelete.removeEventListener(MouseEvent.MOUSE_OUT,super.onDeleteTTOut);
         mcCoin.removeEventListener(MouseEvent.MOUSE_OVER,super.onCoinTTOver);
         mcCoin.removeEventListener(MouseEvent.MOUSE_OUT,super.onCoinTTOut);
         mcUpgrade.removeEventListener(MouseEvent.MOUSE_OVER,super.onUpgradeTTOver);
         mcUpgrade.removeEventListener(MouseEvent.MOUSE_OUT,super.onUpgradeTTOut);
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      override protected function fDraw() : void
      {
         var _loc1_:Object = null;
         tInfo.visible = false;
         btnDelete.visible = false;
         _loc1_ = iSel;
         if(_loc1_ != null)
         {
            btnDelete.visible = true;
            mcUpgrade.visible = false;
            mcCoin.visible = false;
            if(_loc1_.bUpg == 1)
            {
               mcUpgrade.visible = true;
            }
            if(_loc1_.bCoins == 1)
            {
               mcUpgrade.visible = false;
               mcCoin.visible = true;
            }
            this.loadPreview(_loc1_);
         }
         else
         {
            tInfo.htmlText = "Please select an item to preview.";
            while(mcPreview.numChildren > 0)
            {
               mcPreview.removeChildAt(0);
            }
            super.clearPreview();
         }
         btnDelete.visible = true;
         if(getLayout().sMode.toLowerCase().indexOf("shop") > -1)
         {
            btnDelete.visible = false;
         }
         if(_loc1_ != null)
         {
            btnWiki.y = btnMGender.y;
            if(!btnDelete.visible)
            {
               btnWiki.y = btnTry.y;
            }
            btnWiki.visible = true;
         }
      }
      
      override protected function loadPreview(param1:Object) : void
      {
         if(curItem != param1)
         {
            curItem = param1;
            switch(param1.sType)
            {
               case "House":
                  super.loadHouse(param1.sFile);
                  break;
               case "Wall Item":
               case "Floor Item":
                  super.loadHouseItem(param1.sFile,param1.sLink);
                  break;
               default:
                  super.clearPreview();
            }
         }
      }
   }
}

