package
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class AvatarMCCopier
   {
      private var world:*;
      
      private var rootClass:*;
      
      private var mcChar:MovieClip;
      
      private var objLinks:Object;
      
      private var pAV:Avatar;
      
      private var strGender:String;
      
      private var completed:Boolean = false;
      
      private var weaponQueued:Boolean = false;
      
      private var helmEquipped:Boolean = false;
      
      public function AvatarMCCopier(param1:MovieClip)
      {
         this.objLinks = {};
         super();
         this.world = param1;
      }
      
      public function copyTo(param1:MovieClip) : void
      {
         var killList:*;
         var i:* = undefined;
         var sES:* = undefined;
         var _mcChar:MovieClip = param1;
         this.mcChar = _mcChar;
         MovieClip(this.mcChar.parent).pAV = this.world.myAvatar;
         this.pAV = this.world.myAvatar;
         this.strGender = this.pAV.objData.strGender;
         killList = ["cape","backhair","robe","backrobe"];
         for(i in killList)
         {
            if(typeof this.mcChar[killList[i]] != undefined)
            {
               this.mcChar[killList[i]].visible = false;
            }
         }
         try
         {
            if(!this.pAV.dataLeaf.showHelm || !("he" in this.pAV.objData.eqp) && this.pAV.objData.eqp.he == null)
            {
               this.onHairLoadComplete(null);
            }
         }
         catch(err:Error)
         {
         }
         for(sES in this.world.myAvatar.objData.eqp)
         {
            try
            {
               switch(sES)
               {
                  case "Weapon":
                     this.world.queueLoad({
                        "strFile":this.world.rootClass.getFilePath() + this.pAV.objData.eqp[sES].sFile,
                        "callBackA":this.onLoadWeaponComplete,
                        "callBackB":this.onLoadWeaponError
                     });
                     this.weaponQueued = true;
                     break;
                  case "he":
                     if(this.pAV.dataLeaf.showHelm)
                     {
                        this.onLoadHelmComplete(null);
                     }
                     break;
                  case "ba":
                     if(this.pAV.dataLeaf.showCloak)
                     {
                        this.onLoadCapeComplete(null);
                     }
                     break;
                  case "ar":
                     if(this.world.myAvatar.objData.eqp.co == null)
                     {
                        this.objLinks.ar = this.pAV.objData.eqp.ar.sLink;
                        this.onLoadArmorComplete(null);
                     }
                     break;
                  case "co":
                     this.objLinks.ar = this.pAV.objData.eqp.co.sLink;
                     this.onLoadArmorComplete(null);
               }
            }
            catch(err:Error)
            {
               trace("[Avatar] ERR copier copyTo: " + sES + " " + err.message);
            }
         }
         if(!this.weaponQueued)
         {
            this.signalComplete();
         }
      }
      
      private function signalComplete() : void
      {
         if(this.completed)
         {
            return;
         }
         this.completed = true;
         this.world.mapEventTrigger({"cmd":"copyAvatarMCCompleted"});
      }
      
      public function forceComplete() : void
      {
         this.signalComplete();
      }
      
      private function onLoadWeaponError(param1:*) : void
      {
         try
         {
            this.mcChar.weapon.visible = false;
         }
         catch(err:Error)
         {
         }
         this.signalComplete();
      }
      
      public function loadArmorPieces(param1:String) : void
      {
         var AssetClass:Class = null;
         var child:DisplayObject = null;
         var strSkinLinkage:String = param1;
         try
         {
            AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Head") as Class;
            this.mcChar.head.addChildAt(new AssetClass(),0);
            this.mcChar.head.removeChildAt(1);
         }
         catch(err:Error)
         {
            AssetClass = world.getClass("mcHead" + strGender) as Class;
            mcChar.head.addChildAt(new AssetClass(),0);
            mcChar.head.removeChildAt(1);
         }
         try
         {
            AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Chest") as Class;
            this.mcChar.chest.removeChildAt(0);
            this.mcChar.chest.addChild(new AssetClass());
         }
         catch(err:Error)
         {
         }
         try
         {
            AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Hip") as Class;
            this.mcChar.hip.removeChildAt(0);
            this.mcChar.hip.addChild(new AssetClass());
         }
         catch(err:Error)
         {
         }
         try
         {
            AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "FootIdle") as Class;
            this.mcChar.idlefoot.removeChildAt(0);
            this.mcChar.idlefoot.addChild(new AssetClass());
         }
         catch(err:Error)
         {
         }
         try
         {
            AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Foot") as Class;
            this.mcChar.frontfoot.removeChildAt(0);
            this.mcChar.frontfoot.addChild(new AssetClass());
            this.mcChar.frontfoot.visible = false;
            this.mcChar.backfoot.removeChildAt(0);
            this.mcChar.backfoot.addChild(new AssetClass());
         }
         catch(err:Error)
         {
         }
         try
         {
            AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Shoulder") as Class;
            this.mcChar.frontshoulder.removeChildAt(0);
            this.mcChar.frontshoulder.addChild(new AssetClass());
            this.mcChar.backshoulder.removeChildAt(0);
            this.mcChar.backshoulder.addChild(new AssetClass());
         }
         catch(err:Error)
         {
         }
         try
         {
            AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Hand") as Class;
            this.mcChar.fronthand.removeChildAt(0);
            this.mcChar.fronthand.addChild(new AssetClass());
            this.mcChar.backhand.removeChildAt(0);
            this.mcChar.backhand.addChild(new AssetClass());
         }
         catch(err:Error)
         {
         }
         try
         {
            AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Thigh") as Class;
            this.mcChar.frontthigh.removeChildAt(0);
            this.mcChar.frontthigh.addChild(new AssetClass());
            this.mcChar.backthigh.removeChildAt(0);
            this.mcChar.backthigh.addChild(new AssetClass());
         }
         catch(err:Error)
         {
         }
         try
         {
            AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Shin") as Class;
            this.mcChar.frontshin.removeChildAt(0);
            this.mcChar.frontshin.addChild(new AssetClass());
            this.mcChar.backshin.removeChildAt(0);
            this.mcChar.backshin.addChild(new AssetClass());
         }
         catch(err:Error)
         {
         }
         AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Robe") as Class;
         if(AssetClass != null)
         {
            this.mcChar.robe.removeChildAt(0);
            this.mcChar.robe.addChild(new AssetClass());
            this.mcChar.robe.visible = true;
         }
         else
         {
            this.mcChar.robe.visible = false;
         }
         AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "RobeBack") as Class;
         if(AssetClass != null)
         {
            this.mcChar.backrobe.removeChildAt(0);
            this.mcChar.backrobe.addChild(new AssetClass());
            this.mcChar.backrobe.visible = true;
         }
         else
         {
            this.mcChar.backrobe.visible = false;
         }
      }
      
      public function onLoadArmorComplete(param1:Event) : void
      {
         this.loadArmorPieces(this.objLinks.ar);
      }
      
      public function onHairLoadComplete(param1:Event) : void
      {
         var _loc2_:Class = null;
         if(this.helmEquipped)
         {
            return;
         }
         _loc2_ = this.world.getClass(this.pAV.objData.strHairName + this.pAV.objData.strGender + "Hair") as Class;
         if(_loc2_ != null)
         {
            if(this.mcChar.head.hair.numChildren > 0)
            {
               this.mcChar.head.hair.removeChildAt(0);
            }
            this.mcChar.head.hair.addChild(new _loc2_());
            this.mcChar.head.hair.visible = true;
         }
         else
         {
            this.mcChar.head.hair.visible = false;
         }
         _loc2_ = this.world.getClass(this.pAV.objData.strHairName + this.pAV.objData.strGender + "HairBack") as Class;
         if(_loc2_ != null)
         {
            if(this.mcChar.backhair.numChildren > 0)
            {
               this.mcChar.backhair.removeChildAt(0);
            }
            this.mcChar.backhair.addChild(new _loc2_());
            this.mcChar.backhair.visible = true;
         }
         else
         {
            this.mcChar.backhair.visible = false;
         }
      }
      
      public function loadWeapon(param1:*, param2:*) : void
      {
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + param1,
            "callBackA":this.onLoadWeaponComplete,
            "callBackB":this.onLoadWeaponError,
            "avt":this.pAV,
            "sES":"weapon"
         });
      }
      
      public function onLoadWeaponComplete(param1:Event) : void
      {
         var AssetClass:Class = null;
         var e:Event = param1;
         try
         {
            this.mcChar.weapon.removeChildAt(0);
            try
            {
               AssetClass = this.world.getClass(this.pAV.objData.eqp.Weapon.sLink) as Class;
               if(this.pAV.objData.eqp.Weapon.sType == "Gauntlet")
               {
                  this.mcChar.fronthand.addChildAt(new AssetClass(),1);
                  this.mcChar.fronthand.getChildAt(1).scaleX = 0.8;
                  this.mcChar.fronthand.getChildAt(1).scaleY = 0.8;
                  this.mcChar.fronthand.getChildAt(1).scaleX = this.mcChar.fronthand.getChildAt(1).scaleX * -1;
                  this.mcChar.weapon.mcWeapon = new MovieClip();
               }
               else
               {
                  this.mcChar.weapon.addChild(new AssetClass());
               }
            }
            catch(err:Error)
            {
               mcChar.weapon.addChild(e.target.content);
            }
            this.mcChar.weapon.visible = true;
         }
         catch(errOuter:Error)
         {
            trace("[Avatar] ERR copier onLoadWeaponComplete: " + errOuter.message);
         }
         this.signalComplete();
      }
      
      public function onLoadCapeComplete(param1:Event) : void
      {
         var _loc2_:Class = this.world.getClass(this.pAV.objData.eqp.ba.sLink) as Class;
         if(_loc2_ != null)
         {
            this.mcChar.cape.removeChildAt(0);
            this.mcChar.cape.cape = new _loc2_();
            this.mcChar.cape.addChild(this.mcChar.cape.cape);
            this.mcChar.cape.visible = true;
         }
         else
         {
            this.mcChar.cape.visible = false;
         }
      }
      
      public function onLoadHelmComplete(param1:Event) : void
      {
         var _loc2_:Class = this.world.getClass(this.pAV.objData.eqp.he.sLink) as Class;
         var _loc3_:Class = this.world.getClass(this.pAV.objData.eqp.he.sLink + "_backhair") as Class;
         if(_loc2_ != null)
         {
            if(this.mcChar.head.helm.numChildren > 0)
            {
               this.mcChar.head.helm.removeChildAt(0);
            }
            this.mcChar.head.helm.visible = this.pAV.dataLeaf.showHelm;
            this.mcChar.head.hair.visible = !this.mcChar.head.helm.visible;
            if(_loc3_ != null)
            {
               if(this.pAV.dataLeaf.showHelm)
               {
                  this.mcChar.backhair.visible = true;
                  this.mcChar.backhair.addChild(new _loc3_());
               }
               else
               {
                  this.mcChar.backhair.visible = this.mcChar.head.hair.visible && this.pAV.pMC.bBackHair;
               }
            }
            else
            {
               this.mcChar.backhair.visible = this.mcChar.head.hair.visible && this.pAV.pMC.bBackHair;
            }
            this.mcChar.head.helm.addChild(new _loc2_());
            this.helmEquipped = true;
         }
         else
         {
            this.world.rootClass.chatF.pushMsg("warning","Could not resolve Helm definition.","SERVER","",0);
         }
      }
   }
}

