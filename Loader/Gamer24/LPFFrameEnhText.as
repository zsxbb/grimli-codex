package
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   
   public class LPFFrameEnhText extends LPFFrame
   {
      public var mcStats:MovieClip;
      
      public var tDesc:TextField;
      
      private var iSel:Object;
      
      private var eSel:Object;
      
      private var iEnh:Object;
      
      private var eEnh:Object;
      
      private var rootClass:MovieClip;
      
      private var curItem:Object;
      
      internal var mcContainer:MovieClip;
      
      internal var boostsObj:Object;
      
      public function LPFFrameEnhText()
      {
         super();
         this.mcStats.sproto.visible = false;
      }
      
      override public function fOpen(param1:Object) : void
      {
         this.rootClass = MovieClip(stage.getChildAt(0));
         positionBy(param1.r);
         this.iEnh = null;
         this.eEnh = null;
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         this.fDraw();
         getLayout().registerForEvents(this,eventTypes);
      }
      
      override public function fClose() : void
      {
         var _loc1_:DisplayObject = null;
         while(this.mcStats.numChildren > 1)
         {
            _loc1_ = this.mcStats.getChildAt(1);
            this.mcStats.removeChildAt(1);
         }
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      protected function fDraw() : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:* = false;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Object = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc1_:* = "";
         var _loc2_:String = "#00CCFF";
         if(this.iSel != null)
         {
            _loc1_ = "<font size=\'10\' color=\'#FFFFFF\'>Enhancement: </font>";
            if(["Weapon","he","ar","ba"].indexOf(this.iSel.sES) > -1)
            {
               this.rootClass.world.initPatternTree();
               this.iEnh = null;
               this.eEnh = null;
               if(this.iSel.PatternID != null)
               {
                  this.iEnh = this.rootClass.world.enhPatternTree[this.iSel.PatternID];
               }
               if(this.iSel.EnhPatternID != null)
               {
                  this.iEnh = this.rootClass.world.enhPatternTree[this.iSel.EnhPatternID];
               }
               if(this.eSel != null)
               {
                  if(this.eSel.sES == this.iSel.sES)
                  {
                     if(this.eSel.PatternID != null)
                     {
                        this.eEnh = this.rootClass.world.enhPatternTree[this.eSel.PatternID];
                     }
                     if(this.eSel.EnhPatternID != null)
                     {
                        this.eEnh = this.rootClass.world.enhPatternTree[this.eSel.EnhPatternID];
                     }
                     _loc1_ += "<font size=\'11\' color=\'" + _loc2_ + "\'>" + this.rootClass.getDisplayEnhName(this.eEnh);
                     if(this.eSel.iRty > 1)
                     {
                        _loc1_ += " +" + (this.eSel.iRty - 1);
                     }
                     if(this.eEnh && this.eEnh.hasOwnProperty("DIS") && Boolean(this.eEnh["DIS"]))
                     {
                        _loc1_ += ", " + this.rootClass.getDisplayEnhTraitName(this.eEnh);
                     }
                     _loc1_ += "</font>";
                     _loc1_ += "<font size=\'11\' color=\'#FFFFFF\'> vs. </font>";
                     _loc2_ = "#999999";
                     if(this.iEnh != null)
                     {
                        if(this.iEnh.hasOwnProperty("DIS"))
                        {
                           _loc1_ += "<font size=\'11\' color=\'" + _loc2_ + "\'>Forge";
                        }
                        else
                        {
                           _loc1_ += "<font size=\'11\' color=\'" + _loc2_ + "\'>" + this.iEnh.sName;
                        }
                        if(this.iSel.EnhRty > 1)
                        {
                           _loc1_ += " +" + (this.iSel.EnhRty - 1);
                        }
                        if(Boolean(this.iEnh.hasOwnProperty("DIS")) && Boolean(this.iEnh["DIS"]))
                        {
                           _loc1_ += ", " + this.rootClass.getDisplayEnhTraitName(this.iEnh);
                        }
                        _loc1_ += "</font>";
                     }
                     else
                     {
                        _loc1_ += "<font size=\'10\' color=\'#00CCFF\'>No enhancement</font>";
                     }
                  }
                  else
                  {
                     _loc1_ += "<font size=\'11\' color=\'#00CCFF\'>Enhancement type must match item slot!</font>";
                  }
               }
               else if(this.iEnh != null)
               {
                  _loc1_ += "<font size=\'10\' color=\'" + _loc2_ + "\'>" + this.rootClass.getDisplayEnhName(this.iEnh);
                  if("EnhRty" in this.iSel && this.iSel.EnhRty > 1)
                  {
                     _loc1_ += " +" + (this.iSel.EnhRty - 1);
                  }
                  else if("iRty" in this.iSel && this.iSel.iRty < 10 && this.iSel.iRty > 1)
                  {
                     _loc1_ += " +" + (this.iSel.iRty - 1);
                  }
                  if(Boolean(this.iSel.ProcID) && !this.iEnh.hasOwnProperty("DIS"))
                  {
                     switch(this.iSel.ProcID)
                     {
                        case 2:
                           _loc4_ = "Spiral Carve";
                           break;
                        case 3:
                           _loc4_ = "Awe Blast";
                           break;
                        case 4:
                           _loc4_ = "Health Vamp";
                           break;
                        case 5:
                           _loc4_ = "Mana Vamp";
                           break;
                        case 6:
                           _loc4_ = "Powerword DIE";
                           break;
                        case 7:
                           _loc4_ = "Lacerate";
                           break;
                        case 8:
                           _loc4_ = "Smite";
                           break;
                        case 9:
                           _loc4_ = "Valiance";
                           break;
                        case 10:
                           _loc4_ = "Arcana\'s Concerto";
                           break;
                        case 11:
                           _loc4_ = "Acheron";
                           break;
                        case 12:
                           _loc4_ = "Elysium";
                           break;
                        case 13:
                           _loc4_ = "Praxis";
                           break;
                        case 14:
                           _loc4_ = "Dauntless";
                           break;
                        case 15:
                           _loc4_ = "Ravenous";
                           break;
                        default:
                           _loc4_ = "Unknown";
                     }
                     _loc1_ += ", " + _loc4_;
                  }
                  else if(Boolean(this.iEnh.hasOwnProperty("DIS")) && Boolean(this.iEnh["DIS"]))
                  {
                     _loc1_ += ", " + this.rootClass.getDisplayEnhTraitName(this.iEnh);
                  }
                  _loc1_ += "</font>";
               }
               else
               {
                  _loc1_ += "<font size=\'11\' color=\'#00CCFF\'>No enhancement</font>";
               }
               if(this.iSel.sType.toLowerCase() == "enhancement")
               {
                  _loc1_ += " <font size=\'11\' color=\'#FFFFFF\'>imbues an item with: </font>";
               }
               _loc3_ = this.rootClass.copyObj(this.iSel);
               if(this.eSel != null)
               {
                  _loc3_ = this.rootClass.copyObj(this.eSel);
                  if(this.iSel != null)
                  {
                     _loc3_.sType = this.iSel.sType;
                     if("EnhRty" in this.iSel)
                     {
                        _loc3_.EnhRty = this.iSel.EnhRty;
                     }
                     if("iRng" in this.iSel)
                     {
                        _loc3_.iRng = this.iSel.iRng;
                     }
                     else
                     {
                        _loc3_.iRng = 10;
                     }
                  }
               }
               if(_loc3_.sES.toLowerCase() == "weapon")
               {
                  _loc5_ = _loc3_.sType.toLowerCase() == "enhancement";
                  if(_loc5_)
                  {
                     _loc6_ = Number(_loc3_.iDPS);
                  }
                  else if("EnhDPS" in _loc3_)
                  {
                     _loc6_ = Number(_loc3_.EnhDPS);
                  }
                  else if(this.eSel != null && "iDPS" in this.eSel)
                  {
                     _loc6_ = Number(this.eSel.iDPS);
                  }
                  else
                  {
                     _loc6_ = -1;
                  }
                  if(_loc6_ == 0)
                  {
                     _loc6_ = 100;
                  }
                  if(_loc6_ == -1)
                  {
                     _loc6_ = 100;
                  }
                  _loc6_ /= 100;
                  _loc7_ = "iRng" in _loc3_ ? Number(_loc3_.iRng) : 0;
                  _loc7_ = _loc7_ / 100;
                  _loc8_ = 0;
                  if("iRty" in _loc3_)
                  {
                     _loc8_ = _loc3_.iRty - 1;
                  }
                  if("EnhRty" in _loc3_)
                  {
                     _loc8_ = _loc3_.EnhRty - 1;
                  }
                  if(_loc5_)
                  {
                     _loc9_ = int(_loc3_.iLvl);
                  }
                  else if("EnhLvl" in _loc3_)
                  {
                     _loc9_ = int(_loc3_.EnhLvl);
                  }
                  else if(this.eSel != null && "iLvl" in this.eSel)
                  {
                     _loc9_ = int(this.eSel.iLvl);
                  }
                  else
                  {
                     _loc9_ = int(this.iSel.iLvl);
                  }
                  _loc10_ = int(this.rootClass.getBaseHPByLevel(_loc9_ + _loc8_));
                  _loc11_ = 20;
                  _loc12_ = 2;
                  _loc13_ = Math.round(_loc10_ / _loc11_ * _loc6_ * this.rootClass.PCDPSMod);
                  _loc14_ = Math.round(_loc13_ * _loc12_);
                  _loc15_ = this.rootClass.world.getAutoAttack();
                  _loc14_ *= _loc15_.damage;
                  _loc16_ = Math.floor(_loc14_ - _loc14_ * _loc7_);
                  _loc17_ = Math.ceil(_loc14_ + _loc14_ * _loc7_);
                  if(_loc3_.sType.toLowerCase() == "enhancement" || ("EnhLvl" in _loc3_ || this.eSel != null))
                  {
                     _loc1_ += "<br><font color=\'#FFFFFF\'>" + _loc13_ + " DPS";
                  }
                  if(_loc3_.sType.toLowerCase() != "enhancement" && ("EnhLvl" in _loc3_ || this.eSel != null))
                  {
                     _loc1_ += " ( <font color=\'#999999\'>" + _loc16_ + "-" + _loc17_ + ", " + this.rootClass.numToStr(_loc15_.cd / 1000,1) + " speed</font> )</font>";
                  }
               }
            }
            else
            {
               _loc1_ += "<font size=\'10\' color=\'#00CCFF\'>This item cannot be enhanced.</font>";
               if(this.iSel.sES == "pe" || this.iSel.sES == "co" || this.iSel.sES == "am" || this.iSel.sType.toLowerCase() == "item" && this.iSel.sLink != null && this.iSel.sLink != "")
               {
               }
            }
            this.tDesc.htmlText = _loc1_;
            this.showStats();
         }
         else
         {
            if(MovieClip(getLayout()).iSel != null && !this.rootClass.doIHaveEnhancements())
            {
               this.tDesc.htmlText = "<font color=\'#FF0000\'>You need an Enhancement!</font><br>";
               this.tDesc.htmlText += "<font color=\'#FFFFFF\'>No enhancments for this type of item were found in your backpack. Enhancements are used to power up your item. You can buy at shops or find them on monsters.</font>";
            }
            else
            {
               this.tDesc.htmlText = "No item selected.";
            }
            this.showStats();
         }
         this.tDesc.x = 2;
         this.tDesc.y = 7;
         this.mcStats.x = 13;
         this.mcStats.y = this.tDesc.y - 1;
      }
      
      override public function notify(param1:Object) : void
      {
         if(param1.eventType != "showItemListB")
         {
            if(param1.eventType == "refreshItems")
            {
               if(this.iSel != param1.fData.iSel && this.iSel != param1.fData.eSel)
               {
                  this.iSel = null;
                  this.eSel = null;
               }
            }
            else if(param1.eventType == "clearState")
            {
               this.iSel = null;
               this.eSel = null;
            }
            else
            {
               this.iSel = param1.fData.iSel;
               this.eSel = param1.fData.eSel;
               if(this.iSel == null && this.eSel != null)
               {
                  this.iSel = this.eSel;
                  this.eSel = null;
               }
            }
         }
         this.fDraw();
      }
      
      private function showStats() : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc10_:MovieClip = null;
         var _loc11_:Object = null;
         var _loc12_:Boolean = false;
         var _loc13_:Array = null;
         var _loc14_:MovieClip = null;
         var _loc15_:String = null;
         var _loc16_:* = undefined;
         var _loc17_:int = 0;
         var _loc18_:* = undefined;
         var _loc19_:String = null;
         var _loc20_:MovieClip = null;
         var _loc21_:MovieClip = null;
         var _loc22_:MovieClip = null;
         var _loc23_:MovieClip = null;
         var _loc24_:MovieClip = null;
         var _loc25_:MovieClip = null;
         while(this.mcStats.numChildren > 1)
         {
            this.mcStats.removeChildAt(1);
         }
         this.mcStats.sproto.x = 0;
         this.mcStats.sproto.y = this.tDesc.textHeight + 8;
         var _loc1_:* = this.eSel != null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = "";
         var _loc9_:Class = this.mcStats.sproto.constructor as Class;
         if(this.iSel != null && ((this.iEnh != null || this.eEnh != null) && (this.eSel == null || this.eSel.sES == this.iSel.sES) || _loc1_ && this.eSel.sES == this.iSel.sES))
         {
            if(_loc1_ && this.iEnh != null)
            {
               _loc2_ = this.rootClass.getStatsA(this.eSel,this.iSel.sES);
               _loc3_ = this.rootClass.getStatsA(this.iSel,this.iSel.sES);
            }
            else
            {
               _loc11_ = this.rootClass.copyObj(this.iSel);
               if(_loc1_)
               {
                  _loc11_.EnhPatternID = this.eSel.PatternID;
                  _loc11_.EnhLvl = this.eSel.iLvl;
                  _loc11_.EnhRty = this.eSel.iRty;
                  _loc1_ = false;
               }
               _loc2_ = this.rootClass.getStatsA(_loc11_,this.iSel.sES);
            }
            _loc4_ = 0;
            while(_loc4_ < this.rootClass.orderedStats.length)
            {
               _loc8_ = this.rootClass.orderedStats[_loc4_];
               _loc7_ = 0;
               if(_loc1_ && _loc3_["$" + _loc8_] != null && _loc2_["$" + _loc8_] == null)
               {
                  _loc2_["$" + _loc8_] = 0;
               }
               if(_loc2_["$" + _loc8_] != null)
               {
                  _loc10_ = new _loc9_();
                  _loc6_ = int(_loc2_["$" + _loc8_]);
                  _loc10_.tSta.text = this.rootClass.getFullStatName(_loc8_).toUpperCase();
                  _loc10_.tOldval.visible = false;
                  if(_loc1_)
                  {
                     if(_loc3_["$" + _loc8_] != null)
                     {
                        _loc7_ = int(_loc3_["$" + _loc8_]);
                     }
                     _loc10_.tOldval.text = "(" + _loc7_ + ")";
                     _loc10_.tOldval.visible = true;
                     _loc10_.tVal.text = _loc6_;
                  }
                  else
                  {
                     _loc10_.tVal.text = _loc6_;
                  }
                  _loc10_.tOldval.x = _loc10_.tVal.x + _loc10_.tVal.textWidth + 3;
                  _loc10_.x = this.mcStats.sproto.x + _loc5_ % 3 * 100;
                  _loc10_.y = this.mcStats.sproto.y + Math.floor(_loc5_ / 3) * 16;
                  _loc10_.hit.alpha = 0;
                  _loc10_.name = "t" + _loc8_;
                  this.mcStats.addChild(_loc10_);
                  _loc5_++;
               }
               _loc4_++;
            }
            this.mcStats.visible = true;
         }
         else
         {
            this.mcStats.visible = false;
         }
         if(Boolean(this.mcContainer) && Boolean(getChildByName("mcContainer")))
         {
            removeChild(getChildByName("mcContainer"));
         }
         if(Boolean(this.mcContainer) && Boolean(this.mcStats.getChildByName("mcContainer")))
         {
            this.mcStats.removeChild(this.mcStats.getChildByName("mcContainer"));
         }
         if(this.iSel != null && this.iSel.sMeta != null && !(this.iSel.sMeta is Number) && this.iSel.sMeta.indexOf(":") > -1)
         {
            _loc12_ = false;
            switch(this.iSel.sES)
            {
               case "he":
               case "ba":
               case "Weapon":
               case "pe":
               case "co":
               case "mi":
                  _loc12_ = true;
            }
            if(!_loc12_)
            {
               return;
            }
            this.boostsObj = {};
            this.mcContainer = new boostsContainer();
            this.iEnh = null;
            if(this.iSel.PatternID != null)
            {
               this.iEnh = this.rootClass.world.enhPatternTree[this.iSel.PatternID];
            }
            if(this.iSel.EnhPatternID != null)
            {
               this.iEnh = this.rootClass.world.enhPatternTree[this.iSel.EnhPatternID];
            }
            if(this.iEnh)
            {
               this.mcStats.addChild(this.mcContainer);
               this.mcContainer.name = "mcContainer";
               this.mcContainer.x = -13;
               this.mcContainer.y = this.mcStats.height - 8;
            }
            else
            {
               addChild(this.mcContainer);
               this.mcContainer.name = "mcContainer";
               this.mcContainer.x = -2;
               this.mcContainer.y = 20;
            }
            while(this.mcContainer.numChildren > 0)
            {
               this.mcContainer.removeChildAt(0);
            }
            _loc13_ = this.iSel.sMeta.split(",");
            _loc14_ = new damageBoost();
            if(!this.boostsObj["dmgBoost"])
            {
               this.boostsObj["dmgBoost"] = "";
            }
            for each(_loc16_ in _loc13_)
            {
               _loc19_ = _loc16_.split(":")[1];
               _loc15_ = Math.round((Number(_loc19_) - 1) * 100).toString();
               switch(_loc16_.split(":")[0].toLowerCase())
               {
                  case "dmgall":
                     this.boostsObj["dmgBoost"] += "All +" + _loc15_ + "%\n";
                     break;
                  case "undead":
                     this.boostsObj["dmgBoost"] += "Undead +" + _loc15_ + "%\n";
                     break;
                  case "human":
                     this.boostsObj["dmgBoost"] += "Human +" + _loc15_ + "%\n";
                     break;
                  case "chaos":
                     this.boostsObj["dmgBoost"] += "Chaos +" + _loc15_ + "%\n";
                     break;
                  case "dragonkin":
                     this.boostsObj["dmgBoost"] += "Dragonkin +" + _loc15_ + "%\n";
                     break;
                  case "orc":
                     this.boostsObj["dmgBoost"] += "Orc +" + _loc15_ + "%\n";
                     break;
                  case "drakath":
                     this.boostsObj["dmgBoost"] += "Drakath +" + _loc15_ + "%\n";
                     break;
                  case "elemental":
                     this.boostsObj["dmgBoost"] += "Elemental +" + _loc15_ + "%\n";
                     break;
                  case "cp":
                     this.boostsObj["classBoost"] = "Class Points +" + _loc15_ + "%";
                     break;
                  case "gold":
                     this.boostsObj["goldBoost"] = "Gold +" + _loc15_ + "%";
                     break;
                  case "rep":
                     this.boostsObj["repBoost"] = "Reputation +" + _loc15_ + "%";
                     break;
                  case "exp":
                     this.boostsObj["xpBoost"] = "Experience +" + _loc15_ + "%";
                     break;
               }
            }
            _loc17_ = 30;
            for(_loc18_ in this.boostsObj)
            {
               switch(_loc18_)
               {
                  case "dmgBoost":
                     if(this.boostsObj[_loc18_] != "")
                     {
                        this.mcContainer.addChild(_loc14_);
                        _loc14_.width = _loc17_;
                        _loc14_.height = _loc17_;
                        _loc14_.name = "dmgBoost";
                        _loc14_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                        _loc14_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                     }
                     break;
                  case "classBoost":
                     _loc20_ = new classBoost();
                     this.mcContainer.addChild(_loc20_);
                     _loc20_.width = _loc17_;
                     _loc20_.height = _loc17_;
                     _loc20_.name = "classBoost";
                     _loc20_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                     _loc20_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                     break;
                  case "goldBoost":
                     _loc21_ = new goldBoost();
                     this.mcContainer.addChild(_loc21_);
                     _loc21_.width = _loc17_;
                     _loc21_.height = _loc17_;
                     _loc21_.name = "goldBoost";
                     _loc21_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                     _loc21_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                     break;
                  case "repBoost":
                     _loc22_ = new repBoost();
                     this.mcContainer.addChild(_loc22_);
                     _loc22_.width = _loc17_;
                     _loc22_.height = _loc17_;
                     _loc22_.name = "repBoost";
                     _loc22_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                     _loc22_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                     break;
                  case "xpBoost":
                     _loc23_ = new xpBoost();
                     this.mcContainer.addChild(_loc23_);
                     _loc23_.width = _loc17_;
                     _loc23_.height = _loc17_;
                     _loc23_.name = "xpBoost";
                     _loc23_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                     _loc23_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                     break;
               }
            }
            _loc4_ = 0;
            while(_loc4_ < this.mcContainer.numChildren)
            {
               _loc24_ = this.mcContainer.getChildAt(_loc4_) as MovieClip;
               _loc24_.x = _loc4_ * _loc24_.width + 2;
               _loc4_++;
            }
            if(this.mcContainer.numChildren > 0)
            {
               _loc25_ = new btnMoreInfo();
               _loc25_.addEventListener(MouseEvent.CLICK,this.onBoostsInfo,false,0,true);
               this.mcContainer.addChild(_loc25_);
               _loc25_.x = this.mcContainer.getChildAt(this.mcContainer.numChildren - 2).x + this.mcContainer.getChildAt(this.mcContainer.numChildren - 2).width + 3;
               _loc25_.y = _loc25_.height / 4 + 2;
            }
         }
      }
      
      private function onBoostsInfo(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://www.aq.com/lore/Guides/AQWBoosts"),"_blank");
      }
      
      private function onBoostGet(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         this.rootClass.ui.ToolTip.openWith({"str":this.boostsObj[_loc2_]});
      }
      
      private function onBoostOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }
      
      private function onTTFieldMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         var _loc3_:String = "";
         switch(_loc2_)
         {
            case "tAP":
               _loc3_ = "Attack Power increases the effectiveness of your physical damage attacks.";
               break;
            case "tSP":
               _loc3_ = "Magic Power increases the effectiveness of your magical damage attacks.";
               break;
            case "tDmg":
               _loc3_ = "This is the damage you would expect to see on a normal melee hit, before any other modifiers.";
               break;
            case "tHP":
               _loc3_ = "Your total Hit Points.  When these reach zero, you will need to wait a short time before being able to continue playing.";
               break;
            case "tHitTF":
               _loc3_ = "Hit chance determines how likely you are to hit a target, before any other modifiers.";
               break;
            case "tHasteTF":
               _loc3_ = "Haste reduces the cooldown on all of your attacks and spells, including Auto Attack, by a certain percentage (hard capped at 50%).";
               break;
            case "tCritTF":
               _loc3_ = "Critical Strike chance increases the likelihood of dealing additional damage on a any attack.";
               break;
            case "tDodgeTF":
               _loc3_ = "Evasion chance allows you to completely avoid incoming damage.";
               break;
            case "tSTR":
            case "sl1":
               _loc3_ = "Strength increases Attack Power, which boosts physical damage. It also improves Critical Strike chance for melee classes.";
               break;
            case "tINT":
            case "sl2":
               _loc3_ = "Intellect increases Magic Power, which boosts magical damage. It also improve Critical Strike chance for caster classes.";
               break;
            case "tEND":
            case "sl3":
               _loc3_ = "Endurance directly contributes to your total Hit Points.  While very useful for all classes, some abilities work best with very high or very low total HP.";
               break;
            case "tDEX":
            case "sl4":
               _loc3_ = "Dexterity is valuable to melee classes. It increases Haste, Hit chance, and Evasion chance. It increases only Evasion chance for caster classes.";
               break;
            case "tWIS":
            case "sl5":
               _loc3_ = "Wisdom is valuable to caster classes. It increases Hit chance, Crit chance, and Evasion chance. It improves only Evasion chance for melee classes.";
               break;
            case "tLCK":
            case "sl6":
               _loc3_ = "Luck increases your Critical Strike modifier value directly, and may have effects outside of combat.";
         }
         this.rootClass.ui.ToolTip.openWith({"str":_loc3_});
      }
      
      private function onTTFieldMouseOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }
   }
}

