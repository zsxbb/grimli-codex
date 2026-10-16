package
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.filters.GlowFilter;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class Avatar
   {
      private static const NAME_GLOW:GlowFilter = new GlowFilter(0,1,3,3,64,1);
      
      private static const LOADABLE_SLOTS:Array = ["Weapon","he","ba","ar","co","pe","mi"];
      
      public var morphMC:MovieClip;
      
      public var rootClass:*;
      
      public var uid:int;
      
      public var pMC:MovieClip;
      
      public var pnm:String;
      
      public var objData:Object = null;
      
      public var dataLeaf:Object;
      
      public var guild:Object;
      
      public var npcType:String = "player";
      
      public var target:* = null;
      
      public var targets:Object;
      
      public var isMyAvatar:Boolean = false;
      
      public var friends:Array;
      
      public var classes:Array;
      
      public var factions:Array;
      
      public var bank:Array;
      
      public var items:Array;
      
      public var houseitems:Array;
      
      public var tempitems:Array;
      
      public var bitData:Boolean = false;
      
      public var strFrame:String = "";
      
      public var petMC:PetMC;
      
      private var petLoader:Loader = null;
      
      public var sLinkPet:String = "";
      
      public var friendsLoaded:Number;
      
      public var strProj:String = "";
      
      public var invLoaded:Boolean = false;
      
      private var pendingEquipment:Dictionary;
      
      public var firstLoad:Boolean = true;
      
      private var isInitializingEquipment:Boolean = false;
      
      private var specialAnimation:Object;
      
      public var equipOrder:Array;
      
      public var isCharPage:Boolean = false;
      
      public var isCameraTool:Boolean = false;
      
      public var isWorldCamera:Boolean = false;
      
      public var filtered_list:Array;
      
      public var boosts:Object;
      
      public function Avatar(param1:MovieClip)
      {
         this.dataLeaf = {};
         this.guild = {};
         this.targets = {};
         this.friends = [];
         this.factions = [];
         this.tempitems = [];
         this.pendingEquipment = new Dictionary();
         this.specialAnimation = new Object();
         this.equipOrder = [];
         this.boosts = {
            "dmgall":[0,""],
            "undead":[0,""],
            "human":[0,""],
            "chaos":[0,""],
            "dragonkin":[0,""],
            "orc":[0,""],
            "drakath":[0,""],
            "elemental":[0,""],
            "cp":[0,""],
            "gold":[0,""],
            "rep":[0,""],
            "exp":[0,""]
         };
         super();
         this.rootClass = param1;
      }
      
      public function initAvatar(param1:Object) : *
      {
         var world:*;
         var uoLeaf:*;
         var sES2:* = undefined;
         var sES:* = undefined;
         var obj:Object = param1;
         trace("[Avatar] initAvatar: " + this.pnm);
         this.isMyAvatar = this.uid == this.rootClass.sfc.myUserId;
         world = this.rootClass.world;
         uoLeaf = world.uoTree[this.pnm];
         this.objData = obj.data;
         if("intGold" in this.objData)
         {
            this.objData.intGold = Number(this.objData.intGold);
         }
         if("intCoins" in this.objData)
         {
            this.objData.intCoins = Number(this.objData.intCoins);
         }
         if("dUpgExp" in this.objData)
         {
            this.objData.dUpgExp = this.rootClass.stringToDate(this.objData.dUpgExp);
         }
         if("dMutedTill" in this.objData)
         {
            this.objData.dMutedTill = this.rootClass.stringToDate(this.objData.dMutedTill);
         }
         if("dCreated" in this.objData)
         {
            this.objData.dCreated = this.rootClass.stringToDate(this.objData.dCreated);
         }
         this.dataLeaf.intSP = 100;
         this.pMC.strGender = this.objData.strGender;
         try
         {
            this.updateRep();
            this.pMC.updateName();
         }
         catch(e:Error)
         {
            trace("[Avatar] ERR initAvatar rep/name: " + e.message);
         }
         try
         {
            switch(Number(obj.data.intAccessLevel))
            {
               case 100:
               case 50:
                  this.pMC.pname.ti.textColor = 12283391;
                  this.pMC.pname.filters = [NAME_GLOW];
                  break;
               case 60:
               case 61:
               case 62:
                  this.pMC.pname.ti.textColor = 16698168;
                  this.pMC.pname.filters = [NAME_GLOW];
                  break;
               case 40:
                  this.pMC.pname.ti.textColor = 5308200;
                  this.pMC.pname.filters = [NAME_GLOW];
                  break;
               case 30:
                  this.pMC.pname.ti.textColor = 52881;
                  this.pMC.pname.filters = [NAME_GLOW];
                  break;
               default:
                  if(this.isUpgraded())
                  {
                     this.pMC.pname.ti.textColor = 9229823;
                  }
                  this.pMC.pname.filters = [NAME_GLOW];
            }
            if(this.objData.guild != null)
            {
               this.pMC.pname.tg.text = "< " + String(this.objData.guild.Name) + " >";
            }
            this.pMC.ignore.visible = this.rootClass.chatF.isIgnored(obj.data.strUsername);
         }
         catch(e:Error)
         {
            trace("[Avatar] ERR initAvatar cosmetics: " + e.message);
         }
         if(this.firstLoad)
         {
            if(this.isMyAvatar)
            {
               this.isInitializingEquipment = true;
               this.pendingEquipment = new Dictionary();
               if(this.objData.eqp != null)
               {
                  for(sES2 in this.objData.eqp)
                  {
                     if(this.objData.eqp[sES2] != null)
                     {
                        if(!(sES2 == "ar" && this.objData.eqp.co != null))
                        {
                           if(LOADABLE_SLOTS.indexOf(sES2) >= 0)
                           {
                              this.pendingEquipment[sES2] = true;
                           }
                        }
                     }
                  }
               }
               this.pendingEquipment["Hair"] = true;
            }
            if(this.objData.eqp != null)
            {
               for(sES in this.objData.eqp)
               {
                  if(this.objData.eqp[sES] != null)
                  {
                     try
                     {
                        this.loadMovieAtES(sES,this.objData.eqp[sES].sFile,this.objData.eqp[sES].sLink);
                        this.updateItemAnimation(this.objData.eqp[sES].sMeta);
                     }
                     catch(e:Error)
                     {
                        trace("[Avatar] ERR initAvatar equip load: " + sES + " " + e.message);
                        if(isMyAvatar)
                        {
                           markEquipmentLoaded(sES);
                        }
                     }
                  }
               }
            }
            try
            {
               this.pMC.loadHair();
            }
            catch(e:Error)
            {
               trace("[Avatar] ERR initAvatar hair load: " + e.message);
               if(isMyAvatar)
               {
                  markEquipmentLoaded("Hair");
               }
            }
            if(this.isMyAvatar)
            {
               this.isInitializingEquipment = false;
               this.checkLoadComplete();
            }
         }
         this.bitData = true;
         if(world.strAreaName.toLowerCase().indexOf("magicmeadow") == 0 || world.strAreaName.toLowerCase().indexOf("magicmeaderp") == 0)
         {
            this.swapMorphs(true);
         }
      }
      
      public function swapMorphs(param1:Boolean) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Class = null;
         if(param1)
         {
            if(this.morphMC != null && this.morphMC.parent != null)
            {
               MovieClip(this.morphMC.parent).removeChild(this.morphMC);
               this.morphMC = null;
            }
            _loc2_ = this.rootClass.getInterface("pony_engine");
            _loc2_ = _loc2_.getChildAt(0);
            switch(this.pMC.strGender)
            {
               case "F":
                  _loc3_ = _loc2_.FemalePonyMC() as Class;
                  break;
               default:
                  _loc3_ = _loc2_.MalePonyMC() as Class;
            }
            this.morphMC = new _loc3_();
            this.pMC.addChild(this.morphMC);
            this.morphMC.name = "morphMC";
            this.morphMC.x = 0;
            this.morphMC.y = 0;
            this.morphMC.scaleX *= this.pMC.mcChar.scaleX < 0 ? -1 : 1;
            this.morphMC.visible = true;
            this.pMC.mcChar.visible = false;
         }
         else
         {
            this.morphMC.visible = false;
            this.pMC.mcChar.visible = true;
         }
      }
      
      public function loadMovieAtES(param1:*, param2:*, param3:*) : void
      {
         if(Boolean(this.pMC.isRasterized) && param1 != "pe")
         {
            if(this.isMyAvatar && this.firstLoad && this.pendingEquipment[param1] != null)
            {
               this.markEquipmentLoaded(param1);
            }
            return;
         }
         if(this.isMyAvatar && !this.invLoaded && param1 != null && param1 != "pe" && LOADABLE_SLOTS.indexOf(param1) >= 0)
         {
            if(param1 == "ar" && this.objData != null && this.objData.eqp != null && this.objData.eqp.co != null)
            {
               trace("[Avatar] loadMovieAtES: skip ar registration, co exists");
            }
            else if(this.pendingEquipment[param1] == null)
            {
               this.pendingEquipment[param1] = true;
               trace("[Avatar] loadMovieAtES: registered pending " + param1 + " total " + this.getPendingEquipmentCount());
            }
         }
         if(param1 != null)
         {
            switch(param1)
            {
               case "Weapon":
                  this.pMC.loadWeapon(param2,param3);
                  break;
               case "he":
                  this.pMC.loadHelm(param2,param3);
                  break;
               case "ba":
                  this.pMC.loadCape(param2,param3);
                  break;
               case "ar":
                  if(this.objData != null && this.objData.eqp != null && this.objData.eqp.co != null)
                  {
                     trace("[Avatar] loadMovieAtES: skip ar load, co exists");
                     return;
                  }
                  this.pMC.loadClass(param2,param3);
                  break;
               case "co":
                  this.pMC.loadArmor(param2,param3);
                  break;
               case "pe":
                  this.loadPet();
                  break;
               case "mi":
                  this.pMC.loadMisc(param2,param3);
            }
         }
      }
      
      public function unloadMovieAtES(param1:*) : void
      {
         if(Boolean(this.pMC.isRasterized) && param1 != "pe")
         {
            return;
         }
         if(param1 != null)
         {
            switch(param1)
            {
               case "he":
                  this.pMC.mcChar.head.helm.visible = false;
                  if(Boolean(this.pMC.helmBackHair) && Boolean(this.pMC.bBackHair))
                  {
                     this.pMC.helmBackHair = false;
                     this.pMC.loadHair();
                  }
                  else
                  {
                     this.pMC.mcChar.head.hair.visible = true;
                     this.pMC.mcChar.backhair.visible = this.pMC.bBackHair;
                     if(this == this.rootClass.world.myAvatar)
                     {
                        this.rootClass.showPortrait(this);
                     }
                     if(this == this.rootClass.world.myAvatar.target)
                     {
                        this.rootClass.showPortraitTarget(this);
                     }
                  }
                  break;
               case "ba":
                  this.pMC.mcChar.cape.visible = false;
                  break;
               case "pe":
                  this.unloadPet();
                  break;
               case "co":
                  this.pMC.loadClass(this.objData.eqp["ar"].sFile,this.objData.eqp["ar"].sLink);
                  break;
               case "mi":
                  this.pMC.cShadow.visible = false;
                  this.pMC.shadow.alpha = 1;
            }
         }
      }
      
      public function loadPet() : void
      {
         if(this.rootClass.world.doLoadPet(this) && this.objData != null && this.objData.eqp != null && this.objData.eqp["pe"] != null && Boolean(this.rootClass.world.CHARS.contains(this.pMC)))
         {
            if(this.petMC == null || !this.petMC)
            {
               this.petMC = new PetMC();
               this.petMC.mouseEnabled = this.petMC.mouseChildren = false;
               this.petMC.WORLD = this.rootClass.world;
               this.petMC.pAV = this;
            }
            if(this.petLoader != null)
            {
               try
               {
                  this.petLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadPetComplete);
                  this.petLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadPetError);
                  this.petLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadPetError);
                  this.petLoader.close();
                  this.petLoader.unloadAndStop(true);
               }
               catch(e:Error)
               {
               }
               this.petLoader = null;
            }
            this.petLoader = new Loader();
            this.petLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadPetComplete,false,0,true);
            this.petLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadPetError,false,0,true);
            this.petLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadPetError,false,0,true);
            try
            {
               this.petLoader.load(new URLRequest(this.rootClass.vswf(this.rootClass.getFilePath() + this.objData.eqp["pe"].sFile)),this.rootClass.world.loaderC);
            }
            catch(e:Error)
            {
               onLoadPetError(null);
               return;
            }
         }
         else if(this.isMyAvatar && this.firstLoad)
         {
            this.markEquipmentLoaded("pe");
         }
      }
      
      private function onLoadPetError(param1:Event) : void
      {
         trace("[Avatar] ERR onLoadPetError: pet load failed");
         this.unloadPet();
         if(this.isMyAvatar && this.firstLoad)
         {
            this.markEquipmentLoaded("pe");
         }
      }
      
      public function onLoadPetComplete(param1:Event) : void
      {
         var AssetClass:Class = null;
         var e:Event = param1;
         try
         {
            AssetClass = this.rootClass.world.loaderD.getDefinition(this.objData.eqp["pe"].sLink) as Class;
            this.petMC.removeChildAt(1);
            this.petMC.mcChar = MovieClip(this.petMC.addChildAt(new AssetClass(),1));
            this.petMC.mcChar.name = "mc";
         }
         catch(e:Error)
         {
            trace("[Avatar] ERR onLoadPetComplete: " + e.message);
         }
         if(this.isMyAvatar && this.firstLoad)
         {
            this.markEquipmentLoaded("pe");
         }
         if(!this.isMyAvatar && Boolean(this.rootClass.world.hideOtherPets))
         {
            return;
         }
         if(!this.isMyAvatar && (this.pMC == null || !this.pMC.visible || !this.rootClass.world.CHARS.contains(this.pMC)))
         {
            return;
         }
         if(this.dataLeaf != null && this.dataLeaf.strFrame == this.rootClass.world.strFrame)
         {
            if(this.petMC.stage == null && this.petMC.getChildByName("defaultmc") == null)
            {
               MovieClip(this.rootClass.world.CHARS.addChild(this.petMC)).name = "pet_" + this.uid;
            }
            this.petMC.scale(this.pMC.mcChar.scaleY);
            this.petPos();
         }
      }
      
      public function petPos() : void
      {
         this.petMC.x = this.pMC.x - 20;
         this.petMC.y = this.pMC.y + 5;
      }
      
      public function unloadPet() : void
      {
         if(this.petMC != null)
         {
            if(this.petMC.stage != null)
            {
               this.rootClass.world.CHARS.removeChild(this.petMC);
            }
            if(this.petMC.fClose != null)
            {
               this.petMC.fClose();
            }
            this.petMC = null;
         }
         if(this.petLoader != null)
         {
            try
            {
               this.petLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadPetComplete);
               this.petLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadPetError);
               this.petLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadPetError);
               this.petLoader.close();
               this.petLoader.unloadAndStop(true);
            }
            catch(e:Error)
            {
            }
            this.petLoader = null;
         }
      }
      
      public function cleanup() : void
      {
         this.unloadPet();
         this.target = null;
         this.targets = null;
         this.objData = null;
         this.dataLeaf = null;
         this.guild = null;
         this.friends = null;
         this.classes = null;
         this.factions = null;
         this.bank = null;
         this.items = null;
         this.houseitems = null;
         this.tempitems = null;
         this.equipOrder = null;
         this.pendingEquipment = null;
         this.pMC = null;
         this.morphMC = null;
         this.rootClass = null;
      }
      
      public function showMC() : void
      {
         if(this.pMC != null)
         {
            if(!this.isMyAvatar && this.dataLeaf != null && this.dataLeaf.strFrame != this.rootClass.world.strFrame)
            {
               return;
            }
            if(this.rootClass.world.TRASH.contains(this.pMC))
            {
               this.rootClass.world.CHARS.addChild(this.rootClass.world.TRASH.removeChild(this.pMC));
            }
            else if(!this.rootClass.world.CHARS.contains(this.pMC))
            {
               this.rootClass.world.CHARS.addChild(this.pMC);
            }
            this.pMC.visible = true;
            if(Boolean(this.rootClass.world.bPvP) && Boolean(this.pMC.mcChar.onMove))
            {
               this.pMC.calculateNewPxPy();
               if(this.pMC.px != 0 && this.pMC.py != 0)
               {
                  this.pMC.mcChar.gotoAndPlay("Walk");
                  this.pMC.walkTo(this.pMC.tx,this.pMC.ty,this.pMC.sp);
               }
            }
            this.showPetMC();
         }
      }
      
      public function hideMC() : void
      {
         if(this.pMC != null)
         {
            this.pMC.visible = false;
            this.hidePetMC();
         }
      }
      
      public function showPetMC() : void
      {
         if(!this.isMyAvatar && this.dataLeaf != null && this.dataLeaf.strFrame != this.rootClass.world.strFrame)
         {
            return;
         }
         if(!this.isMyAvatar && (this.pMC == null || !this.pMC.visible || !this.rootClass.world.CHARS.contains(this.pMC)))
         {
            return;
         }
         if(this.petMC == null)
         {
            this.loadPet();
         }
         else if(this.petMC.stage == null && this.petMC.getChildByName("defaultmc") == null)
         {
            this.rootClass.world.CHARS.addChild(this.petMC);
            this.petMC.scale(this.pMC.mcChar.scaleY);
            this.petPos();
         }
         else if(this.petMC.stage != null)
         {
            this.petMC.scale(this.pMC.mcChar.scaleY);
            this.petPos();
            this.petMC.visible = true;
         }
      }
      
      public function hidePetMC() : void
      {
         if(this.petMC != null && this.petMC.stage != null)
         {
            this.petMC.visible = false;
         }
      }
      
      public function initFactions(param1:Array) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            this.factions = [];
         }
         else
         {
            this.factions = param1;
            _loc2_ = 0;
            while(_loc2_ < this.factions.length)
            {
               this.initFaction(this.factions[_loc2_]);
               _loc2_++;
            }
         }
      }
      
      public function addFaction(param1:Object) : void
      {
         if(param1 != null && this.factions != null)
         {
            this.factions.push(param1);
            this.initFaction(param1);
         }
      }
      
      public function addRep(param1:int, param2:int, param3:int = 0) : void
      {
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc4_:* = this.getFaction(param1);
         if(_loc4_ != null)
         {
            _loc5_ = int(_loc4_.iRank);
            _loc4_.iRep += param2;
            this.initFaction(_loc4_);
            if(_loc4_.iRank > _loc5_)
            {
               this.rankUp(_loc4_.sName,_loc4_.iRank);
               this.rootClass.FB_showFeedDialog("Rank Up!","reached Rank " + _loc4_.iRank + " for " + _loc4_.sName + " Reputation in AQWorlds!","aqw-rankup.jpg");
            }
            _loc6_ = "";
            if(param3 > 0)
            {
               _loc6_ = " + " + param3 + "(Bonus)";
            }
            this.rootClass.chatF.pushMsg("server","Reputation for " + _loc4_.sName + " increased by " + (param2 - param3) + _loc6_ + ".","SERVER","",0);
         }
      }
      
      public function initFaction(param1:*) : void
      {
         param1.iRep = int(param1.iRep);
         param1.iRank = this.rootClass.getRankFromPoints(param1.iRep);
         param1.iRepToRank = 0;
         if(param1.iRank < this.rootClass.iRankMax)
         {
            param1.iRepToRank = this.rootClass.arrRanks[param1.iRank] - this.rootClass.arrRanks[param1.iRank - 1];
         }
         param1.iSpillRep = param1.iRep - this.rootClass.arrRanks[param1.iRank - 1];
      }
      
      public function getRep(param1:Object) : int
      {
         var _loc2_:* = this.getFaction(param1);
         return _loc2_ == null ? 0 : int(_loc2_.iRep);
      }
      
      public function getFaction(param1:Object) : Object
      {
         return isNaN(Number(param1)) ? this.getFactionByName(String(param1)) : this.getFactionByID(int(param1));
      }
      
      private function getFactionByID(param1:int) : Object
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.factions.length)
         {
            if(this.factions[_loc2_].FactionID == param1)
            {
               return this.factions[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function getFactionByName(param1:String) : Object
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.factions.length)
         {
            if(this.factions[_loc2_].sName == param1)
            {
               return this.factions[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function initFriendsList(param1:Array) : void
      {
         if(param1 != null)
         {
            this.friends = param1;
         }
      }
      
      public function addFriend(param1:Object) : void
      {
         if(param1 != null)
         {
            this.friends.push(param1);
            if(this.rootClass.ui.mcOFrame.currentLabel == "Idle")
            {
               this.rootClass.ui.mcOFrame.update();
            }
         }
      }
      
      public function updateFriend(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(param1 != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.friends.length)
            {
               if(this.friends[_loc2_].ID == param1.ID)
               {
                  this.friends[_loc2_] = param1;
                  break;
               }
               _loc2_++;
            }
            if(this.rootClass.ui.mcOFrame.currentLabel == "Idle")
            {
               this.rootClass.ui.mcOFrame.update();
            }
         }
      }
      
      public function deleteFriend(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.friends.length)
         {
            if(this.friends[_loc2_].ID == param1)
            {
               this.friends.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         if(this.rootClass.ui.mcOFrame.currentLabel == "Idle")
         {
            this.rootClass.ui.mcOFrame.update();
         }
      }
      
      public function isFriend(param1:int) : Boolean
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.friends.length)
         {
            if(this.friends[_loc2_].ID == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function isFriendName(param1:String) : Boolean
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.friends.length)
         {
            if(this.friends[_loc2_].sName.toLowerCase() == param1.toLowerCase())
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      internal function initGuild(param1:Object) : void
      {
         this.guild = param1;
         if(param1 != null)
         {
            this.pMC.pname.tg.text = "< " + String(param1.Name) + " >";
            if(this.isMyAvatar)
            {
               this.rootClass.chatF.chn.guild.act = 1;
            }
            this.objData.guild = param1;
            this.syncSelfGuildRank(param1);
         }
      }
      
      public function updateGuild(param1:Object) : void
      {
         this.objData.guild = param1;
         if(this.objData.guild != null)
         {
            this.pMC.pname.tg.text = "< " + String(this.objData.guild.Name) + " >";
         }
         else
         {
            this.pMC.pname.tg.text = "";
         }
         this.syncSelfGuildRank(param1);
         if(param1 != null && this.isMyAvatar)
         {
            this.updateGuildInfo();
         }
      }
      
      internal function syncSelfGuildRank(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(!this.isMyAvatar || this.objData == null)
         {
            return;
         }
         if(param1 == null)
         {
            this.objData.guildRank = 0;
            return;
         }
         try
         {
            for each(_loc2_ in param1.ul)
            {
               if(_loc2_ != null && String(_loc2_.userName).toLowerCase() == String(this.objData.strUsername).toLowerCase())
               {
                  this.objData.guildRank = int(_loc2_.Rank);
                  return;
               }
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function updateGuildInfo() : void
      {
         if(this.rootClass.ui.mcPopup.currentLabel == "GuildPanelNew")
         {
            if(this.rootClass.getChildByName("guildPanel"))
            {
               ((this.rootClass.getChildByName("guildPanel") as MovieClip).getChildAt(0) as MovieClip).updateData();
            }
         }
      }
      
      public function initInventory(param1:Array) : void
      {
         var i:* = undefined;
         var costumeSlots:Array = null;
         var cs:String = null;
         var wearES:Object = null;
         var arrItems:Array = param1;
         trace("[Avatar] initInventory: " + this.pnm);
         if(arrItems == null)
         {
            this.items = [];
         }
         else
         {
            this.items = arrItems;
            i = 0;
            while(i < this.items.length)
            {
               if(this.items[i] == null)
               {
                  this.items.splice(i,1);
                  i--;
               }
               else
               {
                  this.items[i].iQty = int(this.items[i].iQty);
                  this.rootClass.world.invTree[this.items[i].ItemID] = this.items[i];
               }
               i++;
            }
            if(this.objData != null && this.objData.eqp != null)
            {
               costumeSlots = ["Weapon","he","ba","co"];
               for each(cs in costumeSlots)
               {
                  try
                  {
                     if(this.objData.eqp[cs] == null)
                     {
                        wearES = this.getWearAtES(cs);
                        if(wearES != null)
                        {
                           this.objData.eqp[cs] = {};
                           this.objData.eqp[cs].sFile = wearES.sFile;
                           this.objData.eqp[cs].sLink = wearES.sLink;
                           this.objData.eqp[cs].sType = wearES.sType;
                           this.loadMovieAtES(cs,wearES.sFile,wearES.sLink);
                        }
                     }
                  }
                  catch(e:Error)
                  {
                     trace("[Avatar] ERR initInventory costume load: " + cs + " " + e.message);
                     if(isMyAvatar)
                     {
                        markEquipmentLoaded(cs);
                     }
                  }
               }
            }
         }
      }
      
      public function cleanInventory() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this.items.length)
         {
            _loc2_ = this.items[_loc1_];
            if(_loc2_.iQty == null)
            {
               _loc2_.iQty = 1;
            }
            _loc1_++;
         }
      }
      
      public function initBank(param1:Array) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            this.bank = [];
         }
         else
         {
            this.bank = param1;
            _loc2_ = 0;
            while(_loc2_ < this.bank.length)
            {
               if(this.bank[_loc2_].bCoins == 0)
               {
                  ++this.iBankCount;
               }
               this.bank[_loc2_].iQty = int(this.bank[_loc2_].iQty);
               _loc2_++;
            }
         }
      }
      
      public function bankFromInv(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.items.length)
         {
            if(this.items[_loc2_].ItemID == param1)
            {
               if(this.items[_loc2_].bCoins == 0)
               {
                  ++this.iBankCount;
               }
               this.rootClass.world.addItemsToBank(this.rootClass.copyObj(this.items.splice(_loc2_,1)));
               this.rootClass.world.invTree[param1].iQty = 0;
               this.removeFromFiltered(param1);
               this.rootClass.world.bankinfo.bankFromInv(param1);
               return;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.houseitems.length)
         {
            if(this.houseitems[_loc2_].ItemID == param1)
            {
               if(this.houseitems[_loc2_].bCoins == 0)
               {
                  ++this.iBankCount;
               }
               this.rootClass.world.addItemsToBank(this.rootClass.copyObj(this.houseitems.splice(_loc2_,1)));
               this.rootClass.world.invTree[param1].iQty = 0;
               this.removeFromFiltered(param1);
               this.rootClass.world.bankinfo.bankFromInv(param1);
               return;
            }
            _loc2_++;
         }
      }
      
      public function bankToInv(param1:int) : void
      {
         var _loc2_:Object = this.rootClass.world.bankinfo.bankToInv(param1);
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:Boolean = _loc2_.bHouse != null ? int(_loc2_.bHouse) == 1 : false;
         (_loc3_ || _loc2_.sType == "House" || _loc2_.sType == "Floor Item" || _loc2_.sType == "Wall Item" ? this.houseitems : this.items).push(_loc2_);
         this.rootClass.world.invTree[param1] = _loc2_;
      }
      
      public function bankSwapInv(param1:int, param2:int) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc6_:Boolean = false;
         var _loc5_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < this.items.length)
         {
            if(this.items[_loc5_].ItemID == param1)
            {
               _loc4_ = this.items.splice(_loc5_,1)[0];
               break;
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.houseitems.length)
         {
            if(this.houseitems[_loc5_].ItemID == param1)
            {
               _loc4_ = this.houseitems.splice(_loc5_,1)[0];
               break;
            }
            _loc5_++;
         }
         _loc3_ = this.rootClass.world.bankinfo.bankToInv(param2);
         if(_loc3_ != null && _loc4_ != null)
         {
            this.rootClass.world.bankinfo.addItem(this.rootClass.copyObj(_loc4_));
            if(_loc4_.bCoins == 0)
            {
               ++this.iBankCount;
            }
            this.rootClass.world.invTree[param1].iQty = 0;
            _loc6_ = _loc3_.bHouse != null ? int(_loc3_.bHouse) == 1 : false;
            ((_loc6_) || _loc3_.sType == "House" || _loc3_.sType == "Floor Item" || _loc3_.sType == "Wall Item" ? this.houseitems : this.items).push(_loc3_);
            if(_loc3_.bCoins == 0)
            {
               --this.iBankCount;
            }
            this.rootClass.world.invTree[param2] = _loc3_;
            this.rootClass.world.bankinfo.bankFromInv(param1);
         }
      }
      
      public function removeItem(param1:Object) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(Boolean(param1.hasOwnProperty("bBank")) && Boolean(param1.bBank))
         {
            _loc4_ = this.getItemByCharID(param1.CharItemID);
            if(_loc4_ != null)
            {
               if(this.isItemInInventory(_loc4_.ItemID))
               {
                  this.bankFromInv(_loc4_.ItemID);
               }
               this.removeFromBank(param1);
            }
            return;
         }
         if(!param1.hasOwnProperty("iQty"))
         {
            param1.iQty = 1;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.items.length)
         {
            if(this.items[_loc2_].CharItemID == param1.CharItemID)
            {
               _loc5_ = !!param1.hasOwnProperty("iQtyNow") ? int(param1.iQtyNow) : int(this.items[_loc2_].iQty - param1.iQty);
               if(this.items[_loc2_].sES == "ar" || _loc5_ < 1)
               {
                  this.items[_loc2_].iQty = 0;
                  this.rootClass.resetInvTreeByItemID(this.items[_loc2_].ItemID);
                  this.removeFromFiltered(this.items[_loc2_].ItemID);
                  this.items.splice(_loc2_,1);
               }
               else
               {
                  this.items[_loc2_].iQty = _loc5_;
               }
               return;
            }
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.houseitems.length)
         {
            _loc6_ = !!param1.hasOwnProperty("iQtyNow") ? int(param1.iQtyNow) : int(this.houseitems[_loc3_].iQty - param1.iQty);
            if(this.houseitems[_loc3_].CharItemID == param1.CharItemID)
            {
               if(_loc6_ > 0)
               {
                  this.houseitems[_loc3_].iQty = _loc6_;
               }
               else
               {
                  this.houseitems[_loc3_].iQty = 0;
                  this.removeFromFiltered(this.houseitems[_loc3_].ItemID);
                  this.houseitems.splice(_loc3_,1);
               }
               return;
            }
            _loc3_++;
         }
      }
      
      public function removeItemByID(param1:int, param2:int = 1) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.items.length)
         {
            if(this.items[_loc3_].ItemID == param1)
            {
               if(this.items[_loc3_].sES == "ar" || this.items[_loc3_].iQty <= param2)
               {
                  this.items[_loc3_].iQty = 0;
                  this.items.splice(_loc3_,1);
               }
               else
               {
                  this.items[_loc3_].iQty -= param2;
               }
               return;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.houseitems.length)
         {
            if(this.houseitems[_loc3_].ItemID == param1)
            {
               if(this.houseitems[_loc3_].iQty <= param2)
               {
                  this.houseitems[_loc3_].iQty = 0;
                  this.houseitems.splice(_loc3_,1);
               }
               else
               {
                  this.houseitems[_loc3_].iQty -= param2;
               }
               return;
            }
            _loc3_++;
         }
      }
      
      public function removeFromFiltered(param1:int) : void
      {
         if(!this.filtered_list)
         {
            return;
         }
         if(Boolean(this.filtered_list) && this.filtered_list.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.filtered_list.length)
         {
            if(this.filtered_list[_loc2_].ItemID == param1)
            {
               this.filtered_list.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function get filtered_inventory() : Array
      {
         return Boolean(this.filtered_list) && this.filtered_list.length > 0 ? this.filtered_list : (this.rootClass.ui.mcPopup.currentLabel == "HouseInventory" || this.rootClass.ui.mcPopup.currentLabel == "HouseBank" ? this.houseitems : this.items);
      }
      
      public function addItem(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc5_:* = undefined;
         if(Boolean(param1.bBank))
         {
            _loc5_ = this.getItemByCharID(param1.CharItemID);
            if(_loc5_ != null)
            {
               if(this.isItemInInventory(_loc5_.ItemID))
               {
                  this.bankFromInv(_loc5_.ItemID);
               }
               this.addToBank(param1);
            }
            return;
         }
         var _loc3_:Boolean = param1.bHouse != null ? int(param1.bHouse) == 1 : false;
         _loc2_ = _loc3_ || param1.sType == "House" || param1.sType == "Floor Item" || param1.sType == "Wall Item" ? this.houseitems : this.items;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_].ItemID == param1.ItemID)
            {
               if(param1.hasOwnProperty("iQtyNow"))
               {
                  _loc2_[_loc4_].iQty = int(param1.iQtyNow);
               }
               else
               {
                  _loc2_[_loc4_].iQty += int(param1.iQty);
               }
               return;
            }
            _loc4_++;
         }
         param1.iQty = int(param1.iQty);
         this.rootClass.world.invTree[param1.ItemID] = param1;
         _loc2_.push(param1);
      }
      
      public function addToBank(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = this.rootClass.world.bankinfo.bankItems;
         if(_loc2_ == null || _loc2_.length == 0)
         {
            return;
         }
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.ItemID == param1.ItemID)
            {
               if(param1.hasOwnProperty("iQtyNow"))
               {
                  _loc3_.iQty = int(param1.iQtyNow);
               }
               else
               {
                  _loc3_.iQty += int(param1.iQty);
               }
               this.rootClass.world.bankinfo.bankModified = true;
               return;
            }
         }
      }
      
      public function removeFromBank(param1:*) : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = this.rootClass.world.bankinfo.bankItems;
         if(_loc2_ == null || _loc2_.length == 0)
         {
            return;
         }
         if(!param1.hasOwnProperty("iQty"))
         {
            param1.iQty = 1;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].CharItemID == param1.CharItemID)
            {
               _loc4_ = !!param1.hasOwnProperty("iQtyNow") ? int(param1.iQtyNow) : int(_loc2_[_loc3_].iQty - param1.iQty);
               if(_loc2_[_loc3_].sES == "ar" || _loc4_ < 1)
               {
                  _loc2_[_loc3_].iQty = 0;
                  this.rootClass.resetInvTreeByItemID(_loc2_[_loc3_].ItemID);
                  this.removeFromFiltered(_loc2_[_loc3_].ItemID);
                  this.rootClass.world.bankinfo.bankItems.splice(_loc3_,1);
               }
               else
               {
                  _loc2_[_loc3_].iQty = _loc4_;
               }
               this.rootClass.world.bankinfo.bankModified = true;
               return;
            }
            _loc3_++;
         }
      }
      
      public function varVal(param1:String) : *
      {
         var _loc2_:* = MovieClip(this.pMC.mcChar.stage.getChildAt(0));
         var _loc3_:* = _loc2_.world;
         return _loc2_.sfc.getRoom(_loc3_.curRoom).getUser(this.uid).getVariable(param1);
      }
      
      public function getItemByCharID(param1:Number) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.items != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.items.length)
            {
               if(this.items[_loc2_].CharItemID == param1)
               {
                  return this.items[_loc2_];
               }
               _loc2_++;
            }
         }
         if(this.houseitems != null)
         {
            _loc3_ = 0;
            while(_loc3_ < this.houseitems.length)
            {
               if(this.houseitems[_loc3_].CharItemID == param1)
               {
                  return this.houseitems[_loc3_];
               }
               _loc3_++;
            }
         }
         if(this.bank != null)
         {
            _loc4_ = 0;
            while(_loc4_ < this.bank.length)
            {
               if(this.bank[_loc4_].CharItemID == param1)
               {
                  return this.bank[_loc4_];
               }
               _loc4_++;
            }
         }
         return null;
      }
      
      public function getItemByID(param1:int) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.items != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.items.length)
            {
               if(this.items[_loc2_].ItemID == param1)
               {
                  return this.items[_loc2_];
               }
               _loc2_++;
            }
         }
         if(this.houseitems != null)
         {
            _loc3_ = 0;
            while(_loc3_ < this.houseitems.length)
            {
               if(this.houseitems[_loc3_].ItemID == param1)
               {
                  return this.houseitems[_loc3_];
               }
               _loc3_++;
            }
         }
         if(this.tempitems != null)
         {
            _loc4_ = 0;
            while(_loc4_ < this.tempitems.length)
            {
               if(this.tempitems[_loc4_].ItemID == param1)
               {
                  return this.tempitems[_loc4_];
               }
               _loc4_++;
            }
         }
         if(this.rootClass.world.bankinfo != null)
         {
            if(this.rootClass.world.bankinfo.isItemInBank(param1))
            {
               return this.rootClass.world.bankinfo.getBankItem(param1);
            }
         }
         return null;
      }
      
      public function getItemIDByName(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.items != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.items.length)
            {
               if(this.items[_loc2_].sName == param1)
               {
                  return this.items[_loc2_].ItemID;
               }
               _loc2_++;
            }
         }
         if(this.houseitems != null)
         {
            _loc3_ = 0;
            while(_loc3_ < this.houseitems.length)
            {
               if(this.houseitems[_loc3_].sName == param1)
               {
                  return this.houseitems[_loc3_].ItemID;
               }
               _loc3_++;
            }
         }
         if(this.tempitems != null)
         {
            _loc4_ = 0;
            while(_loc4_ < this.tempitems.length)
            {
               if(this.tempitems[_loc4_].sName == param1)
               {
                  return this.tempitems[_loc4_].ItemID;
               }
               _loc4_++;
            }
         }
         return -1;
      }
      
      public function isItemInBank(param1:Number) : Boolean
      {
         var _loc2_:int = 0;
         if(this.bank != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.bank.length)
            {
               if(this.bank[_loc2_].ItemID == param1)
               {
                  return true;
               }
               _loc2_++;
            }
         }
         return false;
      }
      
      public function isItemInInventory(param1:Object) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:int = isNaN(Number(param1)) ? this.getItemIDByName(String(param1)) : int(param1);
         if(_loc2_ > 0)
         {
            if(this.items != null)
            {
               _loc3_ = 0;
               while(_loc3_ < this.items.length)
               {
                  if(this.items[_loc3_].ItemID == _loc2_)
                  {
                     return true;
                  }
                  _loc3_++;
               }
            }
            if(this.houseitems != null)
            {
               _loc4_ = 0;
               while(_loc4_ < this.houseitems.length)
               {
                  if(this.houseitems[_loc4_].ItemID == _loc2_)
                  {
                     return true;
                  }
                  _loc4_++;
               }
            }
         }
         return false;
      }
      
      public function isItemStackMaxed(param1:Number) : Boolean
      {
         var _loc2_:int = 0;
         if(this.bank != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.bank.length)
            {
               if(this.bank[_loc2_].ItemID == param1 && this.bank[_loc2_].iQty >= this.bank[_loc2_].iStk)
               {
                  return true;
               }
               _loc2_++;
            }
         }
         if(this.items != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.items.length)
            {
               if(this.items[_loc2_].ItemID == param1 && this.items[_loc2_].iQty >= this.items[_loc2_].iStk)
               {
                  return true;
               }
               _loc2_++;
            }
         }
         if(this.houseitems != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.houseitems.length)
            {
               if(this.houseitems[_loc2_].ItemID == param1 && this.houseitems[_loc2_].iQty >= this.houseitems[_loc2_].iStk)
               {
                  return true;
               }
               _loc2_++;
            }
         }
         return false;
      }
      
      public function addTempItem(param1:Object) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.tempitems.length)
         {
            if(this.tempitems[_loc2_].ItemID == param1.ItemID)
            {
               this.tempitems[_loc2_].iQty += int(param1.iQty);
               return;
            }
            _loc2_++;
         }
         this.tempitems.push(param1);
         this.rootClass.world.invTree[param1.ItemID] = param1;
      }
      
      public function removeTempItem(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.tempitems.length)
         {
            if(this.tempitems[_loc3_].ItemID == param1)
            {
               if(this.tempitems[_loc3_].iQty > param2)
               {
                  this.tempitems[_loc3_].iQty -= param2;
               }
               else
               {
                  this.tempitems[_loc3_].iQty = 0;
                  this.tempitems.splice(_loc3_,1);
               }
               return;
            }
            _loc3_++;
         }
      }
      
      public function checkTempItem(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.tempitems.length)
         {
            if(this.tempitems[_loc3_].ItemID == param1 && this.tempitems[_loc3_].iQty >= param2)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function getTempItemQty(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.tempitems.length)
         {
            if(this.tempitems[_loc2_].ItemID == param1)
            {
               return this.tempitems[_loc2_].iQty;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function unequipItemAtES(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this.items != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.items.length)
            {
               if(this.items[_loc2_].sES == param1)
               {
                  this.items[_loc2_].bEquip = 0;
                  this.removeItemAnimation(this.items[_loc2_].sMeta);
               }
               _loc2_++;
            }
         }
         if(this.tempitems != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.tempitems.length)
            {
               if(this.tempitems[_loc2_].sES == param1)
               {
                  this.tempitems[_loc2_].bEquip = 0;
               }
               _loc2_++;
            }
         }
      }
      
      public function unequipItemAtType(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this.items != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.items.length)
            {
               if(this.items[_loc2_].sType == param1)
               {
                  this.items[_loc2_].bEquip = 0;
                  this.removeItemAnimation(this.items[_loc2_].sMeta);
               }
               _loc2_++;
            }
         }
         if(this.tempitems != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.tempitems.length)
            {
               if(this.tempitems[_loc2_].sType == param1)
               {
                  this.tempitems[_loc2_].bEquip = 0;
               }
               _loc2_++;
            }
         }
      }
      
      public function getWearAtES(param1:String) : Object
      {
         var _loc2_:int = 0;
         if(this.items != null && this.items.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.items.length)
            {
               if(this.items[_loc2_].bWear == 1 && this.items[_loc2_].sES == param1)
               {
                  return this.items[_loc2_];
               }
               _loc2_++;
            }
         }
         return null;
      }
      
      public function unwearItemAtES(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this.items == null)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < this.items.length)
         {
            if(this.items[_loc2_].sES == param1)
            {
               this.items[_loc2_].bWear = 0;
            }
            _loc2_++;
         }
      }
      
      public function wearItem(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.items != null && this.items.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.items.length)
            {
               if(this.items[_loc2_].ItemID == param1)
               {
                  this.unwearItemAtES(this.items[_loc2_].sES);
                  this.items[_loc2_].bWear = 1;
                  return;
               }
               _loc2_++;
            }
         }
      }
      
      public function unwearItem(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.items != null && this.items.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.items.length)
            {
               if(this.items[_loc2_].ItemID == param1)
               {
                  this.items[_loc2_].bWear = 0;
                  return;
               }
               _loc2_++;
            }
         }
      }
      
      public function equipItem(param1:int) : void
      {
         var _loc2_:int = 0;
         this.rootClass.world.afkPostpone();
         if(this.items != null && this.items.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.items.length)
            {
               if(this.items[_loc2_].ItemID == param1)
               {
                  if(this.items[_loc2_].sType == "Item")
                  {
                     this.unequipItemAtType(this.items[_loc2_].sType);
                  }
                  else
                  {
                     this.unequipItemAtES(this.items[_loc2_].sES);
                  }
                  this.items[_loc2_].bEquip = 1;
                  this.updateItemAnimation(this.items[_loc2_].sMeta);
                  return;
               }
               _loc2_++;
            }
         }
         if(this.tempitems != null && this.tempitems.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.tempitems.length)
            {
               if(this.tempitems[_loc2_].ItemID == param1)
               {
                  if(this.tempitems[_loc2_].sType == "Item")
                  {
                     this.unequipItemAtType(this.tempitems[_loc2_].sType);
                  }
                  else
                  {
                     this.unequipItemAtES(this.tempitems[_loc2_].sES);
                  }
                  this.tempitems[_loc2_].bEquip = 1;
                  return;
               }
               _loc2_++;
            }
         }
      }
      
      public function unequipItem(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.items != null && this.items.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.items.length)
            {
               if(this.items[_loc2_].ItemID == param1)
               {
                  this.items[_loc2_].bEquip = 0;
                  this.removeItemAnimation(this.items[_loc2_].sMeta);
                  return;
               }
               _loc2_++;
            }
         }
         if(this.tempitems != null && this.tempitems.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.tempitems.length)
            {
               if(this.tempitems[_loc2_].ItemID == param1)
               {
                  this.tempitems[_loc2_].bEquip = 0;
                  return;
               }
               _loc2_++;
            }
         }
      }
      
      public function calculateIntoBoosts() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         this.boosts = {
            "dmgall":[0,""],
            "undead":[0,""],
            "human":[0,""],
            "chaos":[0,""],
            "dragonkin":[0,""],
            "orc":[0,""],
            "drakath":[0,""],
            "elemental":[0,""],
            "cp":[0,""],
            "gold":[0,""],
            "rep":[0,""],
            "exp":[0,""]
         };
         for(_loc1_ in this.objData.eqp)
         {
            if(_loc1_ != "ar")
            {
               if(this.objData.eqp[_loc1_].sMeta != null)
               {
                  _loc2_ = this.objData.eqp[_loc1_].sMeta.split(",");
                  if(_loc2_.length >= 1)
                  {
                     _loc3_ = 0;
                     while(_loc3_ < _loc2_.length)
                     {
                        _loc4_ = _loc2_[_loc3_].split(":")[0].toLowerCase();
                        _loc5_ = _loc2_[_loc3_].split(":")[1];
                        if(this.boosts.hasOwnProperty(_loc4_))
                        {
                           if(_loc5_ > this.boosts[_loc4_][0])
                           {
                              this.boosts[_loc4_] = [_loc5_,_loc1_];
                           }
                        }
                        _loc3_++;
                     }
                  }
               }
            }
         }
         if(this.rootClass.ui.getChildByName("mcStatsPanel"))
         {
            this.rootClass.ui.getChildByName("mcStatsPanel").updateBoosts();
            return;
         }
      }
      
      public function checkItemAnimation() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.items.length)
         {
            if(this.items[_loc1_].bEquip == 1)
            {
               this.updateItemAnimation(this.items[_loc1_].sMeta);
            }
            _loc1_++;
         }
      }
      
      private function updateItemAnimation(param1:String) : void
      {
         var _loc5_:Array = null;
         if(param1 == null)
         {
            return;
         }
         if(param1.indexOf("anim") < 0 && param1.indexOf("proj") < 0)
         {
            return;
         }
         var _loc2_:String = "";
         var _loc3_:Number = -1;
         var _loc4_:Array = param1.split(",");
         var _loc6_:uint = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc6_].split(":");
            if(_loc5_[0] == "anim")
            {
               _loc2_ = _loc5_[1];
            }
            else
            {
               if(_loc5_[0] == "chance")
               {
                  _loc3_ = Number(_loc5_[1]);
               }
               if(_loc5_[0] == "proj")
               {
                  this.strProj = _loc5_[1];
               }
            }
            _loc6_++;
         }
         if(_loc2_ != "" && _loc3_ > 0)
         {
            this.specialAnimation[_loc2_] = _loc3_;
         }
      }
      
      private function removeItemAnimation(param1:String) : *
      {
         var _loc2_:String = null;
         if(param1 == null)
         {
            return;
         }
         if(param1.indexOf("proj") > -1)
         {
            this.strProj = "";
         }
         for(_loc2_ in this.specialAnimation)
         {
            if(param1.indexOf(_loc2_) > -1)
            {
               delete this.specialAnimation[_loc2_];
               return;
            }
         }
      }
      
      public function isItemEquipped(param1:int) : Boolean
      {
         var _loc2_:* = this.getItemByID(param1);
         if(_loc2_ == null || _loc2_.bEquip == null || _loc2_.bEquip == 0)
         {
            return false;
         }
         return true;
      }
      
      public function getClassArmor(param1:String) : Object
      {
         if(this.items == null)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.items.length)
         {
            if(this.items[_loc2_].bEquip == 1 && this.items[_loc2_].sName == param1 && this.items[_loc2_].sES == "ar")
            {
               return this.items[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getEquippedItemBySlot(param1:String) : Object
      {
         if(this.items == null)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.items.length)
         {
            if(this.items[_loc2_].bEquip == 1 && this.items[_loc2_].sES == param1)
            {
               return this.items[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getItemByEquipSlot(param1:String) : Object
      {
         if(this.objData != null && this.objData.eqp != null && this.objData.eqp[param1] != null)
         {
            return this.objData.eqp[param1];
         }
         return null;
      }
      
      public function updateArmorRep() : void
      {
         var _loc1_:* = this.getEquippedItemBySlot("ar");
         if(_loc1_ != null)
         {
            _loc1_.iQty = Number(this.objData.iCP);
         }
      }
      
      public function getArmorRep(param1:String = "") : int
      {
         if(param1 == "")
         {
            param1 = this.objData.strClassName;
         }
         var _loc2_:* = this.getEquippedItemBySlot("ar");
         if(_loc2_ != null)
         {
            return _loc2_.iQty;
         }
         return 0;
      }
      
      public function getCPByID(param1:int) : int
      {
         var _loc2_:* = this.getItemByID(param1);
         if(_loc2_ != null)
         {
            return _loc2_.iQty;
         }
         return -1;
      }
      
      public function updateRep() : void
      {
         var _loc1_:* = this.objData.iRank;
         var _loc2_:* = this.objData.iCP;
         var _loc3_:int = int(this.rootClass.getRankFromPoints(_loc2_));
         var _loc4_:int = 0;
         var _loc5_:* = this.rootClass.world;
         if(_loc3_ < this.rootClass.iRankMax)
         {
            _loc4_ = this.rootClass.arrRanks[_loc3_] - this.rootClass.arrRanks[_loc3_ - 1];
         }
         this.objData.iCurCP = _loc2_ - this.rootClass.arrRanks[_loc3_ - 1];
         this.objData.iRank = _loc3_;
         this.objData.iCPToRank = _loc4_;
         if(this.isMyAvatar && _loc1_ != _loc3_)
         {
            _loc5_.updatePortrait(this);
         }
         if(this.isMyAvatar)
         {
            this.rootClass.updateRepBar();
         }
      }
      
      public function levelUp() : void
      {
         this.healAnimation();
         var _loc1_:* = this.pMC.addChild(new LevelUpDisplay());
         _loc1_.t.ti.text = this.objData.intLevel;
         _loc1_.x = this.pMC.mcChar.x;
         _loc1_.y = this.pMC.pname.y + 10;
         this.rootClass.FB_showFeedDialog("Level Up!","reached Level " + this.objData.intLevel + " in AQWorlds!","aqw-levelup.jpg");
      }
      
      public function rankUp(param1:String, param2:int) : void
      {
         this.healAnimation();
         var _loc3_:* = this.pMC.addChild(new RankUpDisplay());
         _loc3_.t.ti.text = param1 + ", Rank " + param2;
         _loc3_.x = this.pMC.mcChar.x;
         _loc3_.y = this.pMC.pname.y + 10;
      }
      
      public function healAnimation() : void
      {
         this.rootClass.mixer.playSound("Heal");
         var _loc1_:* = this.pMC.parent.addChild(new sp_eh1());
         _loc1_.x = this.pMC.x;
         _loc1_.y = this.pMC.y;
      }
      
      public function isUpgraded() : Boolean
      {
         return int(this.objData.iUpgDays) >= 0;
      }
      
      public function hasUpgraded() : Boolean
      {
         return int(this.objData.iUpg) > 0;
      }
      
      public function isVerified() : Boolean
      {
         return this.objData.intAQ > 0 || this.objData.intDF > 0 || this.objData.intMQ > 0;
      }
      
      public function isStaff() : Boolean
      {
         return this.objData.intAccessLevel >= 40;
      }
      
      public function isEmailVerified() : Boolean
      {
         return this.objData.intActivationFlag == 5;
      }
      
      public function updatePending(param1:int) : void
      {
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         if(this.objData.pending == null)
         {
            _loc5_ = "";
            _loc6_ = 0;
            while(_loc6_ < 500)
            {
               _loc5_ += String.fromCharCode(0);
               _loc6_++;
            }
            this.objData.pending = _loc5_;
         }
         var _loc2_:int = Math.floor(param1 >> 3);
         var _loc3_:int = param1 % 8;
         var _loc4_:* = int(this.objData.pending.charCodeAt(_loc2_));
         _loc4_ = _loc4_ | 1 << _loc3_;
         this.objData.pending = this.objData.pending.substr(0,_loc2_) + String.fromCharCode(_loc4_) + this.objData.pending.substr(_loc2_ + 1);
      }
      
      public function updateScrolls(param1:int) : void
      {
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         if(this.objData.scrolls == null)
         {
            _loc5_ = "";
            _loc6_ = 0;
            while(_loc6_ < 500)
            {
               _loc5_ += String.fromCharCode(0);
               _loc6_++;
            }
            this.objData.scrolls = _loc5_;
         }
         var _loc2_:int = Math.floor(param1 >> 3);
         var _loc3_:int = param1 % 8;
         var _loc4_:* = int(this.objData.scrolls.charCodeAt(_loc2_));
         _loc4_ = _loc4_ | 1 << _loc3_;
         this.objData.scrolls = this.objData.scrolls.substr(0,_loc2_) + String.fromCharCode(_loc4_) + this.objData.scrolls.substr(_loc2_ + 1);
      }
      
      public function handleItemAnimation() : void
      {
         var _loc2_:String = null;
         var _loc3_:Class = null;
         var _loc4_:MovieClip = null;
         var _loc1_:Number = Math.random() * 100;
         for(_loc2_ in this.specialAnimation)
         {
            if(_loc1_ < this.specialAnimation[_loc2_])
            {
               _loc3_ = this.rootClass.world.getClass(_loc2_) as Class;
               if(_loc3_ != null)
               {
                  _loc4_ = new _loc3_() as MovieClip;
                  _loc4_.x = this.pMC.x;
                  _loc4_.y = this.pMC.y;
                  if(this.pMC.mcChar.scaleX < 0)
                  {
                     _loc4_.scaleX *= -1;
                  }
                  try
                  {
                     _loc4_.fxDeadline = getTimer() + 20000;
                  }
                  catch(eDl:Error)
                  {
                  }
                  this.rootClass.world.CHARS.addChild(_loc4_);
               }
               return;
            }
         }
      }
      
      public function get FirstLoad() : Boolean
      {
         return this.firstLoad;
      }
      
      public function get LoadCount() : int
      {
         return this.getPendingEquipmentCount();
      }
      
      public function registerPendingEquipment(param1:String) : void
      {
         if(this.pendingEquipment[param1] == null)
         {
            this.pendingEquipment[param1] = true;
            trace("[Avatar] registerPendingEquipment: " + param1 + " total " + this.getPendingEquipmentCount());
         }
      }
      
      public function markAnyEquipmentLoaded() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:* = this.pendingEquipment;
         for(_loc1_ in _loc3_)
         {
            delete this.pendingEquipment[_loc1_];
            trace("[Avatar] ERR markAnyEquipmentLoaded: recovered slot " + _loc1_ + " remaining " + this.getPendingEquipmentCount());
         }
         if(this.isMyAvatar && this.firstLoad)
         {
            this.checkLoadComplete();
         }
      }
      
      public function markEquipmentLoaded(param1:String) : void
      {
         if(this.pendingEquipment[param1] != null)
         {
            delete this.pendingEquipment[param1];
            trace("[Avatar] markEquipmentLoaded: " + param1 + " remaining " + this.getPendingEquipmentCount());
         }
         if(this.isMyAvatar && this.firstLoad)
         {
            this.checkLoadComplete();
         }
      }
      
      private function getPendingEquipmentCount() : int
      {
         var _loc2_:String = null;
         var _loc1_:int = 0;
         for(_loc2_ in this.pendingEquipment)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      private function isEquipmentLoadComplete() : Boolean
      {
         return this.getPendingEquipmentCount() == 0;
      }
      
      public function checkLoadComplete() : void
      {
         trace("[Avatar] checkLoadComplete: init " + this.isInitializingEquipment + " pending " + this.getPendingEquipmentCount() + " invLoaded " + this.invLoaded + " firstLoad " + this.firstLoad + " pMC " + (this.pMC != null));
         if(this.isInitializingEquipment)
         {
            return;
         }
         if(this.isEquipmentLoadComplete() && this.invLoaded && this.firstLoad && this.pMC != null)
         {
            trace("[Avatar] checkLoadComplete: character load complete");
            this.pMC.gotoAndPlay("in1");
            this.pMC.isLoaded = true;
            this.pMC.handleAfterAvatarLoad();
            this.firstDone();
            this.rootClass.world.rootClass.showTracking("7");
            this.rootClass.world.rootClass.chatF.pushMsg("server","Character load complete.","SERVER","",0);
            this.rootClass.updateXPBar();
            this.rootClass.updateRepBar();
            if(this.objData != null && this.objData.intGold != null)
            {
               this.rootClass.setGoldDisplay(this.objData.intGold);
            }
         }
      }
      
      public function firstDone() : void
      {
         this.firstLoad = false;
      }
      
      public function get iBankCount() : int
      {
         return this.rootClass.world.bankinfo.Count;
      }
      
      public function set iBankCount(param1:int) : void
      {
         this.rootClass.world.bankinfo.Count = param1;
      }
   }
}

