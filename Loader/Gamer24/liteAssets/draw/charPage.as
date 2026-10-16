package liteAssets.draw
{
   import characterA_fla.movFaction_73;
   import fl.data.*;
   import fl.events.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class charPage extends MovieClip
   {
      public var btCharPage:MovieClip;
      
      public var btClose:SimpleButton;
      
      public var mcCharUI:MovieClip;
      
      public var movFaction:movFaction_73;
      
      public var txtAlignment:TextField;
      
      public var txtArmor:TextField;
      
      public var txtCape:TextField;
      
      public var txtClassName:TextField;
      
      public var txtGuildName:TextField;
      
      public var txtHelm:TextField;
      
      public var txtLvl:TextField;
      
      public var txtMisc:TextField;
      
      public var txtPet:TextField;
      
      public var txtUserName:TextField;
      
      public var txtWeapon:TextField;
      
      internal var charPageLoader:URLLoader;
      
      internal var userName:String;
      
      internal var rootClass:MovieClip;
      
      internal var flashvars:URLVariables;
      
      internal var _tempMC:AvatarMC;
      
      private var petMC:PetMC;
      
      public function charPage(param1:MovieClip, param2:String)
      {
         super();
         this.rootClass = param1;
         this.x = 205;
         this.y = 80;
         this.visible = false;
         this.userName = param2;
         this.charPageLoader = new URLLoader();
         this.charPageLoader.addEventListener(Event.COMPLETE,this.onCharPage,false,0,true);
         this.charPageLoader.load(new URLRequest(this.rootClass.getGamePath() + "api/charpage/fvars?id=" + this.userName));
         this.btCharPage.addEventListener(MouseEvent.CLICK,this.onBtCharPage,false,0,true);
         this.btClose.addEventListener(MouseEvent.CLICK,this.onBtClose,false,0,true);
         this.txtClassName.addEventListener(MouseEvent.CLICK,this.onWiki,false,0,true);
         this.txtWeapon.addEventListener(MouseEvent.CLICK,this.onWiki,false,0,true);
         this.txtArmor.addEventListener(MouseEvent.CLICK,this.onWiki,false,0,true);
         this.txtHelm.addEventListener(MouseEvent.CLICK,this.onWiki,false,0,true);
         this.txtCape.addEventListener(MouseEvent.CLICK,this.onWiki,false,0,true);
         this.txtPet.addEventListener(MouseEvent.CLICK,this.onWiki,false,0,true);
         this.txtMisc.addEventListener(MouseEvent.CLICK,this.onWiki,false,0,true);
      }
      
      public function onWiki(param1:MouseEvent) : void
      {
         if(param1.currentTarget.text == "None")
         {
            return;
         }
         navigateToURL(new URLRequest("http://aqwwiki.wikidot.com/" + param1.currentTarget.text),"_blank");
      }
      
      public function onDrag(param1:MouseEvent) : void
      {
         this.startDrag();
      }
      
      public function onStopDrag(param1:MouseEvent) : void
      {
         this.stopDrag();
      }
      
      public function onCharPage(param1:Event) : void
      {
         var _loc3_:Class = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(param1.target.data == "Hidden" || param1.target.data == "Empty")
         {
            _loc3_ = this.rootClass.world.getClass("ModalMC");
            _loc4_ = new _loc3_();
            _loc5_ = {};
            _loc5_.strBody = "User not found: " + this.userName;
            _loc5_.params = {};
            _loc5_.glow = "red,medium";
            _loc5_.btns = "mono";
            this.rootClass.stage.addChild(_loc4_);
            _loc4_.init(_loc5_);
            return;
         }
         this.flashvars = new URLVariables(param1.target.data.substring(1).replace("+","%2B"));
         this.txtUserName.text = this.flashvars.strName;
         this.txtLvl.text = this.flashvars.intLevel.split(" -")[0];
         if(this.flashvars.intLevel.indexOf(" Guild") > -1)
         {
            this.txtGuildName.text = this.flashvars.intLevel.split("--- ")[1].substring(0,this.flashvars.intLevel.split("--- ")[1].length - 6);
         }
         else
         {
            this.txtGuildName.text = "None";
         }
         this.txtClassName.text = this.flashvars.strClassName;
         if(this.txtClassName.text == "")
         {
            this.txtClassName.text = "None";
         }
         this.txtWeapon.text = this.flashvars.strWeaponName;
         if(this.txtWeapon.text == "")
         {
            this.txtWeapon.text = "None";
         }
         this.txtArmor.text = this.flashvars.strArmorName;
         if(this.txtArmor.text == "")
         {
            this.txtArmor.text = "None";
         }
         this.txtHelm.text = this.flashvars.strHelmName;
         if(this.txtHelm.text == "")
         {
            this.txtHelm.text = "None";
         }
         this.txtCape.text = this.flashvars.strCapeName;
         if(this.txtCape.text == "")
         {
            this.txtCape.text = "None";
         }
         this.txtPet.text = this.flashvars.strPetName;
         if(this.txtPet.text == "")
         {
            this.txtPet.text = "None";
         }
         if(this.flashvars.strMiscName)
         {
            this.txtMisc.text = this.flashvars.strMiscName;
            if(this.txtMisc.text == "")
            {
               this.txtMisc.text = "None";
            }
         }
         else
         {
            this.txtMisc.text = "None";
         }
         var _loc2_:String = this.flashvars.strFaction;
         this.txtAlignment.text = _loc2_;
         if(_loc2_ == "Neutral")
         {
            this.movFaction.gotoAndStop(2);
         }
         if(_loc2_ == "Good")
         {
            this.movFaction.gotoAndStop(3);
         }
         if(_loc2_ == "Evil")
         {
            this.movFaction.gotoAndStop(4);
         }
         if(_loc2_ == "Chaos")
         {
            this.movFaction.gotoAndStop(5);
         }
         this._tempMC = new AvatarMC();
         this._tempMC.world = this.rootClass.world;
         this.copyTo(this._tempMC.mcChar);
         this._tempMC.hideHPBar();
         this._tempMC.name = "DisplayMC";
         this.mcCharUI.mcBG.addChild(this._tempMC);
         this._tempMC.x = 250;
         this._tempMC.y = -30;
         this._tempMC.scaleX *= -3;
         this._tempMC.scaleY *= 3;
         this.visible = true;
      }
      
      public function getAchievement(param1:int) : int
      {
         if(param1 < 0 || param1 > 31)
         {
            return -1;
         }
         var _loc2_:* = this.flashvars.ia1;
         if(_loc2_ == null)
         {
            return -1;
         }
         return (_loc2_ & Math.pow(2,param1)) == 0 ? 0 : 1;
      }
      
      public function copyTo(param1:MovieClip) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:Avatar = new Avatar(this.rootClass);
         _loc3_.isCharPage = true;
         _loc3_.pnm = this.rootClass.world.myAvatar.pnm;
         _loc3_.objData = this.rootClass.copyObj(this.rootClass.world.myAvatar.objData);
         this._tempMC.pAV = _loc3_;
         this._tempMC.pAV.pMC = this._tempMC;
         this._tempMC.pAV.objData.intColorHair = this.flashvars.intColorHair;
         this._tempMC.pAV.objData.intColorSkin = this.flashvars.intColorSkin;
         this._tempMC.pAV.objData.intColorEye = this.flashvars.intColorEye;
         this._tempMC.pAV.objData.intColorBase = this.flashvars.intColorBase;
         this._tempMC.pAV.objData.intColorTrim = this.flashvars.intColorTrim;
         this._tempMC.pAV.objData.intColorAccessory = this.flashvars.intColorAccessory;
         this._tempMC.pAV.objData.strHairFilename = this.flashvars.strHairFile;
         this._tempMC.pAV.objData.strHairName = this.flashvars.strHairName;
         this._tempMC.pAV.objData.eqp = {};
         this._tempMC.pAV.objData.eqp.co = {};
         this._tempMC.pAV.objData.eqp.co["sFile"] = this.flashvars.strClassFile;
         this._tempMC.pAV.objData.eqp.co["sLink"] = this.flashvars.strClassLink;
         this._tempMC.pAV.objData.eqp.Weapon = {};
         this._tempMC.pAV.objData.eqp.Weapon["sFile"] = this.flashvars.strWeaponFile;
         this._tempMC.pAV.objData.eqp.Weapon["sLink"] = this.flashvars.strWeaponLink;
         this._tempMC.pAV.objData.eqp.Weapon["sType"] = this.flashvars.strWeaponType;
         this._tempMC.pAV.objData.eqp.ba = {};
         this._tempMC.pAV.objData.eqp.ba["sFile"] = this.flashvars.strCapeFile;
         this._tempMC.pAV.objData.eqp.ba["sLink"] = this.flashvars.strCapeLink;
         this._tempMC.pAV.objData.eqp.he = {};
         this._tempMC.pAV.objData.eqp.he["sFile"] = this.flashvars.strHelmFile;
         this._tempMC.pAV.objData.eqp.he["sLink"] = this.flashvars.strHelmLink;
         this._tempMC.pAV.objData.eqp.mi = {};
         this._tempMC.pAV.objData.eqp.mi["sFile"] = this.flashvars.strMiscFile;
         this._tempMC.pAV.objData.eqp.mi["sLink"] = this.flashvars.strMiscLink;
         this._tempMC.pAV.objData.strGender = this.flashvars.strGender;
         this._tempMC.strGender = this.flashvars.strGender;
         this._tempMC.pAV.dataLeaf.showHelm = this.flashvars.strHelmFile != "none" && this.getAchievement(1) == 0;
         this._tempMC.pAV.dataLeaf.showCloak = this.flashvars.strCapeFile != "none" && this.getAchievement(0) == 0;
         this._tempMC.pAV.isCharPage = true;
         var _loc4_:* = ["cape","backhair","robe","backrobe"];
         for(_loc2_ in _loc4_)
         {
            if(typeof param1[_loc4_[_loc2_]] != undefined)
            {
               param1[_loc4_[_loc2_]].visible = false;
            }
         }
         if(!this._tempMC.pAV.dataLeaf.showHelm || this._tempMC.pAV.objData.eqp.he.sFile == "none")
         {
            this._tempMC.loadHair();
         }
         for(_loc5_ in this._tempMC.pAV.objData.eqp)
         {
            _loc6_ = this._tempMC.pAV.objData.eqp[_loc5_];
            switch(_loc5_)
            {
               case "Weapon":
                  this._tempMC.loadWeapon(_loc6_.sFile,_loc6_.sLink);
                  break;
               case "he":
                  if(Boolean(this._tempMC.pAV.dataLeaf.showHelm) && this._tempMC.pAV.objData.eqp.he.sFile != "none")
                  {
                     this._tempMC.loadHelm(_loc6_.sFile,_loc6_.sLink);
                  }
                  break;
               case "ba":
                  if(Boolean(this._tempMC.pAV.dataLeaf.showCloak) && this._tempMC.pAV.objData.eqp.ba.sFile != "none")
                  {
                     this._tempMC.loadCape(_loc6_.sFile,_loc6_.sLink);
                  }
                  break;
               case "co":
                  this._tempMC.loadArmor(_loc6_.sFile,_loc6_.sLink);
                  break;
               case "mi":
                  this._tempMC.loadMisc(_loc6_.sFile,_loc6_.sLink);
                  break;
            }
         }
         if(this.flashvars.strPetFile != "none" && this.getAchievement(2) == 0)
         {
            this.petMC = new PetMC();
            this.petMC.mouseEnabled = this.petMC.mouseChildren = false;
            this.petMC.pAV = this._tempMC.pAV;
            this.rootClass.world.queueLoad({
               "strFile":this.rootClass.getFilePath() + this.flashvars.strPetFile,
               "callBackA":this.onLoadPetComplete,
               "avt":this._tempMC.pAV,
               "sES":"Pet"
            });
         }
      }
      
      public function onLoadPetComplete(param1:Event) : void
      {
         var _loc2_:Class = this.rootClass.world.getClass(this.flashvars.strPetLink) as Class;
         this.petMC.removeChildAt(1);
         this.petMC.mcChar = MovieClip(this.petMC.addChildAt(new _loc2_(),1));
         this.mcCharUI.mcBG.addChild(this.petMC);
         this.petMC.scale(2);
         this.petMC.turn("left");
         this.petMC.x = 50;
         this.petMC.y = -150;
         this.petMC.shadow.visible = false;
         this.mcCharUI.mcBG.setChildIndex(this.petMC,this.mcCharUI.mcBG.numChildren - 2);
      }
      
      public function ioErrorHandler(param1:*) : void
      {
         var _loc2_:Class = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         _loc2_ = this.rootClass.world.getClass("ModalMC");
         _loc3_ = new _loc2_();
         _loc4_ = {};
         _loc4_.strBody = "Connection Error";
         _loc4_.params = {};
         _loc4_.glow = "red,medium";
         _loc4_.btns = "mono";
         this.rootClass.stage.addChild(_loc3_);
         _loc3_.init(_loc4_);
      }
      
      public function onBtCharPage(param1:*) : void
      {
         navigateToURL(new URLRequest("https://account.aq.com/CharPage?id=" + this.userName),"_blank");
      }
      
      public function onBtClose(param1:*) : void
      {
         this.cleanup();
         this.parent.removeChild(this);
      }
      
      private function cleanup() : void
      {
         if(this.charPageLoader != null)
         {
            this.charPageLoader.removeEventListener(Event.COMPLETE,this.onCharPage);
            try
            {
               this.charPageLoader.close();
            }
            catch(e:Error)
            {
            }
            this.charPageLoader = null;
         }
         this.btCharPage.removeEventListener(MouseEvent.CLICK,this.onBtCharPage);
         this.btClose.removeEventListener(MouseEvent.CLICK,this.onBtClose);
         this.txtClassName.removeEventListener(MouseEvent.CLICK,this.onWiki);
         this.txtWeapon.removeEventListener(MouseEvent.CLICK,this.onWiki);
         this.txtArmor.removeEventListener(MouseEvent.CLICK,this.onWiki);
         this.txtHelm.removeEventListener(MouseEvent.CLICK,this.onWiki);
         this.txtCape.removeEventListener(MouseEvent.CLICK,this.onWiki);
         this.txtPet.removeEventListener(MouseEvent.CLICK,this.onWiki);
         this.txtMisc.removeEventListener(MouseEvent.CLICK,this.onWiki);
         if(this._tempMC != null)
         {
            this._tempMC.fClose();
            this._tempMC = null;
         }
         if(this.petMC != null)
         {
            this.petMC.fClose();
            this.petMC = null;
         }
         this.rootClass = null;
      }
   }
}

