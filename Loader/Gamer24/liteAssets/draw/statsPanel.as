package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class statsPanel extends MovieClip
   {
      public var bContainer:MovieClip;
      
      public var bg:MovieClip;
      
      public var btnExit:MovieClip;
      
      public var btnHelp:MovieClip;
      
      public var btnHelp2:MovieClip;
      
      public var btnHelp3:MovieClip;
      
      public var tCat:TextField;
      
      public var tCombat1:TextField;
      
      public var tCombat2:TextField;
      
      public var tCore:TextField;
      
      public var tMod:TextField;
      
      public var tName:TextField;
      
      public var tStats:TextField;
      
      private var r:MovieClip;
      
      private var world:MovieClip;
      
      internal var tt:MovieClip;
      
      private var allocated:Object;
      
      private var nextMode:String;
      
      private var uoLeaf:Object;
      
      private var uoData:Object;
      
      private var stp:Object;
      
      private var stg:Object;
      
      internal var tStatVals:Array;
      
      internal var tStatFormats:Array;
      
      internal var tFormats:Array;
      
      internal var tValues:Array;
      
      internal var tCombatFormats1:Array;
      
      internal var tCombatFormats2:Array;
      
      internal var tCombat1Vals:Array;
      
      internal var tCombat2Vals:Array;
      
      internal var boostsObj:Object;
      
      public function statsPanel(param1:MovieClip)
      {
         this.tStatVals = ["STR","INT","DEX","END","WIS","LCK"];
         this.tStatFormats = [];
         this.tFormats = [];
         this.tValues = ["$cai","$cao","$cpi","$cpo","$cmi","$cmo","$chi","$cho","$cdi","$cdo","$cmc"];
         this.tCombatFormats1 = [];
         this.tCombatFormats2 = [];
         this.tCombat1Vals = ["$ap","$sp","$thi","$tha"];
         this.tCombat2Vals = ["$tcr","$scm","$tdo"];
         this.boostsObj = {};
         super();
         this.r = param1;
         this.world = this.r.world;
         this.uoLeaf = this.world.myLeaf();
         this.uoData = this.world.myAvatar.objData;
         this.stp = new Object();
         this.stg = new Object();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onStage,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onDrag,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_UP,this.onStop,false,0,true);
         this.btnHelp.addEventListener(MouseEvent.CLICK,this.onHelp,false,0,true);
         this.btnHelp2.addEventListener(MouseEvent.CLICK,this.onHelp,false,0,true);
         this.btnHelp3.addEventListener(MouseEvent.CLICK,this.onHelp,false,0,true);
         this.btnExit.addEventListener(MouseEvent.CLICK,this.onExit,false,0,true);
         this.tName.mouseEnabled = false;
         this.tCat.mouseEnabled = false;
         this.updateBoosts();
      }
      
      public function onHelp(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://www.aq.com/lore/guides/stats"),"_blank");
      }
      
      public function cleanup() : void
      {
         var _loc1_:MovieClip = null;
         if(parent != null)
         {
            _loc1_ = MovieClip(parent);
            _loc1_.removeChild(this);
            this.r.stage.focus = null;
         }
      }
      
      public function onExit(param1:MouseEvent) : void
      {
         this.cleanup();
      }
      
      public function onStage(param1:Event) : void
      {
         this.updateBase();
         this.update();
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onStage);
         this.tt = new ToolTipMC(this.r);
         addChild(this.tt);
      }
      
      private function getCatDefinition() : String
      {
         switch(this.uoData.sClassCat)
         {
            case "M1":
               return "Tank Melee";
            case "M2":
               return "Dodge Melee";
            case "M3":
               return "Full Hybrid";
            case "M4":
               return "Power Melee";
            case "C1":
               return "Offensive Caster";
            case "C2":
               return "Defensive Caster";
            case "C3":
               return "Power Caster";
            case "S1":
               return "Luck Hybrid";
            default:
               return "Adventurer";
         }
      }
      
      private function buildStu() : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc1_:Object = this.r.getCategoryStats(this.uoData.sClassCat,this.uoLeaf.intLevel);
         var _loc2_:String = "";
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.r.stats.length)
         {
            _loc2_ = this.r.stats[_loc3_];
            this.stg["^" + _loc2_] = 0;
            this.stp["_" + _loc2_] = Math.floor(_loc1_[_loc2_]);
            _loc3_++;
         }
         var _loc4_:* = this.world.uoTree[this.r.sfc.myUserName.toLowerCase()];
         for(_loc5_ in _loc4_.tempSta)
         {
            if(_loc5_ != "innate")
            {
               for(_loc6_ in _loc4_.tempSta[_loc5_])
               {
                  if(this.stg["^" + _loc6_] == null)
                  {
                     this.stg["^" + _loc6_] = 0;
                  }
                  this.stg["^" + _loc6_] += int(_loc4_.tempSta[_loc5_][_loc6_]);
               }
            }
         }
      }
      
      private function fixValues(param1:String, param2:Number) : Array
      {
         var _loc3_:Array = [param1 == "$chi" || param1 == "$cmc" || param1 == "$tha" ? this.r.coeffToPct(param2) : this.r.coeffToPct(param2 - 1)];
         switch(param1)
         {
            case "$cai":
               _loc3_[0] *= -1;
               return param2 <= 0.2 ? [this.r.coeffToPct(1 - 0.2),"*"] : _loc3_;
            case "$cao":
               return param2 <= 0.1 ? [this.r.coeffToPct(0.1 - 1),"*"] : _loc3_;
            case "$tha":
               return param2 >= 0.5 ? [this.r.coeffToPct(1 - 0.5),"*"] : _loc3_;
            case "$cpi":
               _loc3_[0] *= -1;
               return param2 <= 0.2 ? [this.r.coeffToPct(1 - 0.2),"*"] : _loc3_;
            case "$cmi":
               _loc3_[0] *= -1;
               return param2 <= 0.2 ? [this.r.coeffToPct(1 - 0.2),"*"] : _loc3_;
            case "$cmo":
               return param2 <= 0.2 ? [this.r.coeffToPct(1 - 0.1),"*"] : _loc3_;
            case "$cdi":
               _loc3_[0] *= -1;
               return _loc3_;
            default:
               return _loc3_;
         }
      }
      
      private function determineColor(param1:String, param2:Number) : *
      {
         if(!this.allocated[param1])
         {
            this.allocated[param1] = param2;
            return 13421772;
         }
         var _loc3_:Number = this.fixValues(param1,param2)[0] - 1;
         var _loc4_:Number = this.fixValues(param1,this.allocated[param1])[0] - 1;
         if(param1 == "$cmc")
         {
            _loc3_ *= -1;
            _loc4_ *= -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 6710886;
         }
         if(_loc3_ > _loc4_)
         {
            return 13408512;
         }
         return 13421772;
      }
      
      private function determineStatColor(param1:String, param2:Number) : *
      {
         var _loc3_:Number = this.stp["_" + param1] + this.stg["^" + param1];
         var _loc4_:Number = param2;
         if(_loc3_ > _loc4_)
         {
            return 6710886;
         }
         if(_loc3_ < _loc4_)
         {
            return 13408512;
         }
         return 13421772;
      }
      
      private function allocateBaseValues() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(!this.allocated)
         {
            this.allocated = new Object();
         }
         if(this.r.baseClassStats)
         {
            for(_loc3_ in this.r.baseClassStats)
            {
               this.allocated[_loc3_] = this.r.baseClassStats[_loc3_];
            }
            this.allocated["intHPMax"] = this.uoLeaf.intHPMax;
            this.r.baseClassStats = null;
            return;
         }
         var _loc1_:* = this.world.uoTree[this.r.sfc.myUserName.toLowerCase()].sta;
         for each(_loc2_ in this.tValues)
         {
            this.allocated[_loc2_] = _loc1_[_loc2_];
         }
         for each(_loc2_ in this.tCombat1Vals)
         {
            this.allocated[_loc2_] = _loc1_[_loc2_];
         }
         for each(_loc2_ in this.tCombat2Vals)
         {
            this.allocated[_loc2_] = _loc1_[_loc2_];
         }
         this.allocated["intHPMax"] = this.uoLeaf.intHPMax;
      }
      
      public function updateBase() : void
      {
         this.tName.text = this.uoData.strClassName;
         this.tCat.text = this.getCatDefinition();
         this.allocateBaseValues();
      }
      
      public function update() : void
      {
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:Array = null;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:TextFormat = null;
         this.buildStu();
         var _loc1_:* = this.world.uoTree[this.r.sfc.myUserName.toLowerCase()].sta;
         var _loc2_:int = Math.floor(100 - this.world.myAvatar.getEquippedItemBySlot("Weapon").iRng);
         var _loc3_:int = 100 + this.world.myAvatar.getEquippedItemBySlot("Weapon").iRng;
         var _loc4_:Object = this.getEnhances();
         this.tCore.text = _loc2_ + "% - " + _loc3_ + "%\n" + _loc4_["Weapon"][0] + _loc4_["Weapon"][1] + (_loc4_["Weapon"][2] != "" ? ", " + _loc4_["Weapon"][2] : "") + "\n" + _loc4_["ar"][0] + _loc4_["ar"][1] + "\n" + _loc4_["ba"][0] + _loc4_["ba"][1] + (_loc4_["ba"][2] != "" ? ", " + _loc4_["ba"][2] : "") + "\n" + _loc4_["he"][0] + _loc4_["he"][1] + (_loc4_["he"][2] != "" ? ", " + _loc4_["he"][2] : "") + "\n";
         var _loc7_:int = 0;
         this.tStats.text = "";
         for each(_loc8_ in this.tStatVals)
         {
            this.tStats.appendText(this.stp["_" + _loc8_] + this.stg["^" + _loc8_] + " (" + (!_loc1_["$" + _loc8_] ? 0 : _loc1_["$" + _loc8_]) + ")\n");
            this.tStatFormats[_loc7_] = [this.tStats.text.lastIndexOf("(") + 1,this.tStats.text.lastIndexOf(")"),this.determineStatColor(_loc8_,_loc1_["$" + _loc8_])];
            _loc7_++;
         }
         this.tCombat1.text = "";
         _loc7_ = 0;
         for each(_loc9_ in this.tCombat1Vals)
         {
            if(_loc9_ == "$ap" || _loc9_ == "$sp")
            {
               _loc5_ = String(_loc1_[_loc9_]);
            }
            if(_loc9_ == "$thi")
            {
               _loc5_ = this.r.coeffToPct(Number(1 - this.r.baseMiss + _loc1_["$thi"])) + "%";
            }
            if(_loc9_ == "$tha")
            {
               _loc13_ = this.fixValues("$tha",_loc1_["$tha"]);
               _loc5_ = (_loc13_.length == 2 ? _loc13_[1] : "") + _loc13_[0] + "%";
            }
            _loc6_ = this.tCombat1.length;
            this.tCombat1.appendText(_loc5_ + "\n");
            this.tCombatFormats1[_loc7_] = [_loc6_,this.tCombat1.length,this.determineColor(_loc9_,_loc1_[_loc9_])];
            _loc7_++;
         }
         this.tCombat2.text = "";
         _loc7_ = 0;
         for each(_loc10_ in this.tCombat2Vals)
         {
            _loc6_ = this.tCombat2.length;
            this.tCombat2.appendText(this.r.coeffToPct(_loc1_[_loc10_]) + "%\n");
            this.tCombatFormats2[_loc7_] = [_loc6_,this.tCombat2.length,this.determineColor(_loc10_,_loc1_[_loc10_])];
            _loc7_++;
         }
         _loc6_ = this.tCombat2.length;
         this.tCombat2.appendText(String(this.uoLeaf.intHPMax));
         this.tCombatFormats2[_loc7_] = [_loc6_,this.tCombat2.length,this.determineColor("intHPMax",this.uoLeaf.intHPMax)];
         this.tMod.text = "";
         _loc7_ = 0;
         for each(_loc11_ in this.tValues)
         {
            _loc14_ = this.stg["^" + _loc11_] != null ? _loc1_[_loc11_] + this.stg["^" + _loc11_] : _loc1_[_loc11_];
            _loc15_ = this.fixValues(_loc11_,_loc14_);
            _loc6_ = this.tMod.length;
            this.tMod.appendText((_loc15_.length == 2 ? _loc15_[1] + _loc15_[0] : _loc15_[0]) + "%\n");
            this.tFormats[_loc7_] = [_loc6_,this.tMod.length,this.determineColor(_loc11_,_loc14_)];
            _loc7_++;
         }
         for each(_loc12_ in this.tStatFormats)
         {
            _loc16_ = this.tStats.getTextFormat(_loc12_[0],_loc12_[1]);
            _loc16_.color = _loc12_[2];
            _loc16_.leading = 4;
            this.tStats.setTextFormat(_loc16_,_loc12_[0],_loc12_[1]);
         }
         for each(_loc12_ in this.tFormats)
         {
            _loc16_ = this.tMod.getTextFormat(_loc12_[0],_loc12_[1]);
            _loc16_.color = _loc12_[2];
            _loc16_.leading = 2.6;
            this.tMod.setTextFormat(_loc16_,_loc12_[0],_loc12_[1]);
         }
         for each(_loc12_ in this.tCombatFormats1)
         {
            _loc16_ = this.tCombat1.getTextFormat(_loc12_[0],_loc12_[1]);
            _loc16_.color = _loc12_[2];
            _loc16_.leading = 2;
            this.tCombat1.setTextFormat(_loc16_,_loc12_[0],_loc12_[1]);
         }
         for each(_loc12_ in this.tCombatFormats2)
         {
            _loc16_ = this.tCombat2.getTextFormat(_loc12_[0],_loc12_[1]);
            _loc16_.color = _loc12_[2];
            _loc16_.leading = 2;
            this.tCombat2.setTextFormat(_loc16_,_loc12_[0],_loc12_[1]);
         }
         this.tCore.height = this.tCore.textHeight + 4;
         this.tStats.height = this.tStats.textHeight + 4;
         this.tCombat1.height = this.tCombat1.textHeight + 4;
         this.tCombat2.height = this.tCombat2.textHeight + 4;
         this.tMod.height = this.tMod.textHeight + 4;
      }
      
      private function getProc(param1:Object) : String
      {
         var _loc2_:String = "";
         if(Boolean(param1) && Boolean(param1.hasOwnProperty("ProcID")))
         {
            switch(param1.ProcID)
            {
               case 2:
                  _loc2_ = "Spiral Carve";
                  break;
               case 3:
                  _loc2_ = "Awe Blast";
                  break;
               case 4:
                  _loc2_ = "Health Vamp";
                  break;
               case 5:
                  _loc2_ = "Mana Vamp";
                  break;
               case 6:
                  _loc2_ = "Powerword DIE";
                  break;
               case 7:
                  _loc2_ = "Lacerate";
                  break;
               case 8:
                  _loc2_ = "Smite";
                  break;
               case 9:
                  _loc2_ = "Valiance";
                  break;
               case 10:
                  _loc2_ = "Arcana\'s Concerto";
                  break;
               case 11:
                  _loc2_ = "Acheron";
                  break;
               case 12:
                  _loc2_ = "Elysium";
                  break;
               case 13:
                  _loc2_ = "Praxis";
                  break;
               case 14:
                  _loc2_ = "Dauntless";
                  break;
               case 15:
                  _loc2_ = "Ravenous";
                  break;
               default:
                  _loc2_ = "None";
            }
         }
         return _loc2_;
      }
      
      private function getEnh(param1:String) : Array
      {
         var _loc4_:* = undefined;
         var _loc2_:Array = ["None","",""];
         var _loc3_:Object = this.world.myAvatar.getEquippedItemBySlot(param1);
         _loc2_[2] = this.getProc(_loc3_);
         if(!_loc3_)
         {
            return _loc2_;
         }
         if(_loc3_.PatternID != null)
         {
            _loc4_ = this.r.world.enhPatternTree[_loc3_.PatternID];
         }
         if(_loc3_.EnhPatternID != null)
         {
            _loc4_ = this.r.world.enhPatternTree[_loc3_.EnhPatternID];
         }
         if(!_loc4_)
         {
            return _loc2_;
         }
         _loc2_[0] = _loc4_.sName;
         _loc2_[1] = _loc3_.EnhRty > 1 ? " +" + String(_loc3_.EnhRty - 1) : "";
         if(_loc4_.hasOwnProperty("DIS"))
         {
            _loc2_[0] = this.r.getDisplayEnhName(_loc4_);
            _loc2_[2] = this.r.getDisplayEnhTraitName(_loc4_);
         }
         return _loc2_;
      }
      
      private function getEnhances() : Object
      {
         var _loc2_:* = undefined;
         var _loc1_:Object = {
            "Weapon":[],
            "ar":[],
            "ba":[],
            "he":[]
         };
         this.r.world.initPatternTree();
         for(_loc2_ in _loc1_)
         {
            _loc1_[_loc2_] = this.getEnh(_loc2_);
         }
         return _loc1_;
      }
      
      private function handleMissing(param1:String) : String
      {
         return param1 == "NaN" ? "100" : param1;
      }
      
      private function onDrag(param1:MouseEvent) : void
      {
         this.startDrag();
      }
      
      private function onStop(param1:MouseEvent) : void
      {
         this.stopDrag();
      }
      
      public function updateBoosts() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:MovieClip = null;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:MovieClip = null;
         var _loc10_:MovieClip = null;
         var _loc11_:MovieClip = null;
         var _loc12_:MovieClip = null;
         var _loc13_:* = undefined;
         while(this.bContainer.numChildren > 1)
         {
            this.bContainer.removeChildAt(1);
         }
         var _loc1_:Object = this.r.world.myAvatar.boosts;
         var _loc2_:Boolean = false;
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_[0] > 0)
            {
               _loc2_ = true;
               break;
            }
         }
         this.bContainer.visible = _loc2_;
         if(!_loc2_)
         {
            return;
         }
         this.boostsObj = {};
         this.boostsObj["dmgBoost"] = "";
         for(_loc3_ in _loc1_)
         {
            _loc7_ = _loc1_[_loc3_][0];
            if(Number(_loc7_) == 0)
            {
               continue;
            }
            _loc8_ = Math.round((Number(_loc7_) - 1) * 100).toString();
            switch(_loc3_)
            {
               case "dmgall":
                  this.boostsObj["dmgBoost"] += "All +" + _loc8_ + "%\n";
                  break;
               case "undead":
                  this.boostsObj["dmgBoost"] += "Undead +" + _loc8_ + "%\n";
                  break;
               case "human":
                  this.boostsObj["dmgBoost"] += "Human +" + _loc8_ + "%\n";
                  break;
               case "chaos":
                  this.boostsObj["dmgBoost"] += "Chaos +" + _loc8_ + "%\n";
                  break;
               case "dragonkin":
                  this.boostsObj["dmgBoost"] += "Dragonkin +" + _loc8_ + "%\n";
                  break;
               case "orc":
                  this.boostsObj["dmgBoost"] += "Orc +" + _loc8_ + "%\n";
                  break;
               case "drakath":
                  this.boostsObj["dmgBoost"] += "Drakath +" + _loc8_ + "%\n";
                  break;
               case "elemental":
                  this.boostsObj["dmgBoost"] += "Elemental +" + _loc8_ + "%\n";
                  break;
               case "cp":
                  this.boostsObj["classBoost"] = "Class Points +" + _loc8_ + "%";
                  break;
               case "gold":
                  this.boostsObj["goldBoost"] = "Gold +" + _loc8_ + "%";
                  break;
               case "rep":
                  this.boostsObj["repBoost"] = "Reputation +" + _loc8_ + "%";
                  break;
               case "exp":
                  this.boostsObj["xpBoost"] = "Experience +" + _loc8_ + "%";
                  break;
            }
         }
         _loc4_ = new damageBoost();
         for(_loc5_ in this.boostsObj)
         {
            switch(_loc5_)
            {
               case "dmgBoost":
                  if(this.boostsObj[_loc5_] != "")
                  {
                     this.bContainer.addChild(_loc4_);
                     _loc4_.scaleX = 0.043;
                     _loc4_.scaleY = 0.04;
                     _loc4_.name = "dmgBoost";
                     _loc4_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                     _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                  }
                  break;
               case "classBoost":
                  _loc9_ = new classBoost();
                  this.bContainer.addChild(_loc9_);
                  _loc9_.scaleX = 0.043;
                  _loc9_.scaleY = 0.04;
                  _loc9_.name = "classBoost";
                  _loc9_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                  _loc9_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                  break;
               case "goldBoost":
                  _loc10_ = new goldBoost();
                  this.bContainer.addChild(_loc10_);
                  _loc10_.scaleX = 0.043;
                  _loc10_.scaleY = 0.04;
                  _loc10_.name = "goldBoost";
                  _loc10_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                  _loc10_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                  break;
               case "repBoost":
                  _loc11_ = new repBoost();
                  this.bContainer.addChild(_loc11_);
                  _loc11_.scaleX = 0.043;
                  _loc11_.scaleY = 0.04;
                  _loc11_.name = "repBoost";
                  _loc11_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                  _loc11_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                  break;
               case "xpBoost":
                  _loc12_ = new xpBoost();
                  this.bContainer.addChild(_loc12_);
                  _loc12_.scaleX = 0.043;
                  _loc12_.scaleY = 0.04;
                  _loc12_.name = "xpBoost";
                  _loc12_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                  _loc12_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                  break;
            }
         }
         _loc6_ = 1;
         while(_loc6_ < this.bContainer.numChildren)
         {
            _loc13_ = this.bContainer.getChildAt(_loc6_);
            if(_loc13_ is MovieClip)
            {
               _loc13_.y = 3;
               _loc13_.x = (_loc6_ - 1) * _loc13_.width + 2;
            }
            _loc6_++;
         }
      }
      
      private function onBoostGet(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         this.tt.openWith({
            "str":this.boostsObj[_loc2_],
            "fromlocal":{
               "x":this.bContainer.x + this.bContainer.width / 2,
               "y":this.bContainer.y + this.bContainer.height
            }
         });
      }
      
      private function onBoostOut(param1:MouseEvent) : void
      {
         this.tt.close();
      }
   }
}

