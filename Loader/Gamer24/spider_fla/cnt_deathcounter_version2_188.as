package spider_fla
{
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   
   public dynamic class cnt_deathcounter_version2_188 extends MovieClip
   {
      public var mcContent:MovieClip;
      
      public var mcTomb:MovieClip;
      
      public var rootClass:*;
      
      public var arrTips:Array;
      
      public var arrAds:Array;
      
      public var iAdIndex:int;
      
      public function cnt_deathcounter_version2_188()
      {
         super();
      }
      
      public function clickGo(param1:MouseEvent) : *
      {
         var _loc2_:String = "http://tracking.battleon.com/click.asp?game=AW&campaign=DEATHAQW_" + this.arrAds[this.iAdIndex].sType.toUpperCase();
         sendToURL(new URLRequest(_loc2_));
         navigateToURL(new URLRequest(this.arrAds[this.iAdIndex].sTarget),"_blank");
      }
      
      public function loadAd() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Loader = null;
         this.mcContent.mcButtons.chkAds.checkmark.visible = this.mcContent.mcButtons.chkAds.bitChecked = !this.rootClass.userPreference.data.bDeathAd;
         trace("line 90");
         this.mcContent.mcAd.visible = false;
         trace("line 92");
         if(this.rootClass.userPreference.data.bDeathAd)
         {
            _loc1_ = (this.rootClass.date_server.getTime() - this.rootClass.world.myAvatar.objData.dCreated.getTime()) / 1000;
            _loc2_ = _loc1_ / (60 * 60);
            _loc3_ = 0;
            while(_loc3_ < this.arrAds.length)
            {
               if(this.arrAds[_loc3_].sType == "member" && this.rootClass.world.myAvatar.isUpgraded() || this.arrAds[_loc3_].sType == "aeextra" && int(this.rootClass.world.myAvatar.objData.iAge) < 13 || this.arrAds[_loc3_].sType == "dragonhero" && (_loc2_ >= 72 || this.rootClass.world.myAvatar.isUpgraded()))
               {
                  this.arrAds.splice(_loc3_,1);
                  _loc3_--;
               }
               _loc3_++;
            }
            this.iAdIndex = Math.floor(Math.random() * this.arrAds.length);
            this.mcContent.mcAd.removeChildAt(0);
            _loc4_ = new Loader();
            _loc4_.load(new URLRequest(this.rootClass.sFilePath + this.arrAds[this.iAdIndex].sURL));
            this.mcContent.mcAd.addChild(_loc4_);
            this.mcContent.mcAd.visible = true;
         }
         else
         {
            this.mcContent.mcAd.visible = false;
            this.mcContent.mcButtons.txtRes.visible = false;
            this.mcContent.mcButtons.btnRes.visible = false;
         }
      }
      
      public function onCheckBoxClick(param1:Event) : void
      {
         if(this.rootClass.world.myAvatar.isUpgraded())
         {
            this.rootClass.userPreference.data.bDeathAd = !this.mcContent.mcButtons.chkAds.bitChecked;
            this.rootClass.userPreference.flush();
            this.loadAd();
         }
      }
   }
}

