package
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.Rectangle;
   import flash.net.*;
   import flash.text.*;
   import liteAssets.draw.*;
   
   public class QFrameMC extends MovieClip
   {
      private static const RARITY_GLOWS:Array = [new GlowFilter(6710886,1,8,8,2,1,false,false),new GlowFilter(16777215,1,8,8,2,1,false,false),new GlowFilter(6749952,1,8,8,2,1,false,false),new GlowFilter(2663679,1,8,8,2,1,false,false),new GlowFilter(16711935,1,8,8,2,1,false,false),new GlowFilter(16763904,1,8,8,2,1,false,false),new GlowFilter(16711680,1,8,8,2,1,false,false)];
      
      private static const CHOICE_GLOW:GlowFilter = new GlowFilter(16763955,1,5,5,2,1,true,false);
      
      public var cnt:MovieClip;
      
      public var world:MovieClip;
      
      public var rootClass:MovieClip;
      
      public var qData:Object = null;
      
      internal var qMode:String = null;
      
      internal var choiceID:int = -1;
      
      internal var isOpen:Boolean = false;
      
      internal var mc:MovieClip;
      
      internal var mDown:Boolean = false;
      
      internal var hRun:int = 0;
      
      internal var dRun:int = 0;
      
      internal var mbY:int = 0;
      
      internal var mhY:int = 0;
      
      internal var mbD:int = 0;
      
      internal var qly:int = 70;
      
      internal var qdy:int = 58;
      
      internal var qla:Array;
      
      internal var qlb:Array;
      
      public var qIDs:Array;
      
      public var sIDs:Array;
      
      public var tIDs:Array;
      
      internal var rewardCount:int = -1;
      
      public function QFrameMC()
      {
         this.qla = [];
         this.qlb = [];
         this.qIDs = [];
         this.sIDs = [];
         this.tIDs = [];
         super();
         this.mc = MovieClip(this);
         this.mc.x = 0;
         this.mc.y = 65;
         this.mc.cnt.bg.btnClose.addEventListener(MouseEvent.CLICK,this.xClick);
         this.mc.cnt.bg.btnTry.visible = false;
         this.mc.cnt.bg.btnPin.visible = false;
         this.mc.cnt.bg.btnWiki.visible = false;
      }
      
      public function onPin(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         this.rootClass.pinnedQuests = "";
         if(!param1.shiftKey)
         {
            for each(_loc2_ in this.qIDs)
            {
               this.rootClass.pinnedQuests += _loc2_ + ",";
            }
         }
      }
      
      public function open() : *
      {
         this.rootClass = MovieClip(this.stage.getChildAt(0));
         this.mc.cnt.bg.btnPin.addEventListener(MouseEvent.CLICK,this.onPin,false,0,true);
         this.mc.cnt.bg.btnWiki.addEventListener(MouseEvent.CLICK,this.onWiki,false,0,true);
         this.world = this.rootClass.world;
         this.mc = MovieClip(this);
         this.mc.cnt.bg.fx.visible = false;
         if(this.rootClass.isDialoqueUp())
         {
            this.mc.cnt.bg.fx.visible = true;
         }
         if(!this.isOpen)
         {
            this.isOpen = true;
            this.mc.cnt.gotoAndPlay("intro");
         }
         else
         {
            this.isOpen = false;
            this.fClose();
         }
      }
      
      public function onWiki(param1:MouseEvent) : void
      {
         if(!this.qData)
         {
            return;
         }
         navigateToURL(new URLRequest("http://aqwwiki.wikidot.com/search:site/a/p/q/" + this.qData.sName),"_blank");
      }
      
      public function showQuestList() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.mc.cnt.bg.btnPin.visible = this.rootClass.litePreference.data.bQuestPin;
         this.mc.cnt.bg.btnWiki.visible = false;
         if(this.qMode == "l" && this.world.getActiveQuests() != "" || this.qMode == "q")
         {
            if(this.qMode == "l")
            {
               this.qIDs = this.world.getActiveQuests().split(",");
            }
            else
            {
               this.qIDs = [];
               _loc1_ = 0;
               while(_loc1_ < this.sIDs.length)
               {
                  this.qIDs.push(this.sIDs[_loc1_]);
                  _loc1_++;
               }
               _loc2_ = 0;
               while(_loc2_ < this.tIDs.length)
               {
                  if(Boolean(this.world.isQuestInProgress(this.tIDs[_loc2_])) && this.qIDs.indexOf(this.tIDs[_loc2_]) == -1)
                  {
                     this.qIDs.push(this.tIDs[_loc2_]);
                  }
                  _loc2_++;
               }
            }
            this.world.checkAllQuestStatus();
            this.buildQuestList();
         }
         else
         {
            this.showEmptyList();
         }
         if(this.mc.cnt.bg.btnPin.visible)
         {
            this.mc.cnt.strTitle.x = 53;
            this.mc.cnt.strTitle.width = 256;
         }
         else
         {
            this.mc.cnt.strTitle.x = 42;
            this.mc.cnt.strTitle.width = 270;
         }
         if(this.qMode == "l")
         {
            this.mc.cnt.strTitle.htmlText = "Current Quests<font color=\"#FF0000\">:</font>";
         }
         if(this.qMode == "q")
         {
            this.mc.cnt.strTitle.htmlText = "Available Quests<font color=\"#FF0000\">:</font>";
         }
         this.mc.cnt.qList.visible = true;
         this.mc.cnt.qList.mHi.visible = false;
         this.mc.cnt.mouseChildren = true;
      }
      
      private function isQuestAvailable(param1:Object) : Boolean
      {
         if(param1 != null)
         {
            if(param1.bGuild != null && param1.bGuild == 1)
            {
               if(this.rootClass.world.myAvatar.objData.guild == null)
               {
                  return false;
               }
               if(param1.iReqRep > 0 && this.rootClass.world.myAvatar.objData.guild.guildRep < param1.iReqRep)
               {
                  return false;
               }
            }
            if(param1.sField != null && this.world.getAchievement(param1.sField,param1.iIndex) != 0 || param1.iLvl > this.world.myAvatar.objData.intLevel || param1.bUpg == 1 && !this.world.myAvatar.isUpgraded() || param1.iSlot >= 0 && this.world.getQuestValue(param1.iSlot) < Math.abs(param1.iValue) - 1 || param1.iClass > 0 && this.world.myAvatar.getCPByID(param1.iClass) < param1.iReqCP || param1.FactionID > 1 && this.world.myAvatar.getRep(param1.FactionID) < param1.iReqRep)
            {
               return false;
            }
            if(param1.QuestID == 3190 && !this.world.myAvatar.isUpgraded())
            {
               if(this.world.getQuestValue(43) < 3)
               {
                  return false;
               }
               if(this.world.getQuestValue(21) < 26)
               {
                  return false;
               }
               if(this.world.getQuestValue(22) < 35)
               {
                  return false;
               }
               if(this.world.getQuestValue(25) < 22)
               {
                  return false;
               }
               if(this.world.getQuestValue(26) < 23)
               {
                  return false;
               }
               if(this.world.getQuestValue(27) < 14)
               {
                  return false;
               }
               if(this.world.getQuestValue(32) < 35)
               {
                  return false;
               }
               if(this.world.getQuestValue(36) < 28)
               {
                  return false;
               }
               if(this.world.getQuestValue(51) < 34 && this.world.getQuestValue(52) < 34)
               {
                  return false;
               }
               if(this.world.getQuestValue(100) < 15)
               {
                  return false;
               }
               if(this.world.getQuestValue(117) < 17)
               {
                  return false;
               }
               if(this.world.getQuestValue(131) < 27)
               {
                  return false;
               }
               if(this.world.getQuestValue(122) < 35)
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
      
      private function getQuestListA() : void
      {
         var _loc2_:* = undefined;
         this.qla = [];
         var _loc1_:int = 0;
         while(_loc1_ < this.qIDs.length)
         {
            _loc2_ = this.world.questTree[this.qIDs[_loc1_]];
            this.qla.push(this.isQuestAvailable(_loc2_));
            _loc1_++;
         }
      }
      
      private function getQuestListB() : void
      {
         var _loc2_:* = undefined;
         this.qlb = [];
         var _loc1_:int = 0;
         while(_loc1_ < this.qIDs.length)
         {
            _loc2_ = this.world.questTree[this.qIDs[_loc1_]];
            this.qlb.push(this.isQuestAvailable(_loc2_));
            _loc1_++;
         }
      }
      
      private function nextQuestAvailable() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.qIDs.length)
         {
            if(this.qla[_loc2_] == false && this.qlb[_loc2_] == true)
            {
               _loc1_ = this.world.questTree[this.qIDs[_loc2_]];
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function hasRequiredItemsForQuest(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         if(param1.reqd != null && param1.reqd.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.reqd.length)
            {
               _loc3_ = param1.reqd[_loc2_].ItemID;
               _loc4_ = int(param1.reqd[_loc2_].iQty);
               if(this.rootClass.world.invTree[_loc3_] == null || int(this.rootClass.world.invTree[_loc3_].iQty) < _loc4_)
               {
                  return false;
               }
               _loc2_++;
            }
         }
         return true;
      }
      
      private function getQuestValidationString(param1:Object) : String
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:* = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:* = undefined;
         if(param1.sField != null && this.world.getAchievement(param1.sField,param1.iIndex) != 0)
         {
            if(param1.sField == "im0")
            {
               return "Monthly Quests are only available once per month.";
            }
            if(param1.sField == "iw0")
            {
               return "Weekly Quests reset every Friday morning.";
            }
            return "Daily Quests are only available once per day.";
         }
         if(param1.bUpg == 1 && !this.world.myAvatar.isUpgraded())
         {
            return "Upgrade is required for this quest!";
         }
         if(param1.iSlot >= 0 && this.world.getQuestValue(param1.iSlot) < param1.iValue - 1)
         {
            return "Quest has not been unlocked!";
         }
         if(param1.iLvl > this.world.myAvatar.objData.intLevel)
         {
            return "Unlocks at Level " + param1.iLvl + ".";
         }
         if(param1.iClass > 0 && this.world.myAvatar.getCPByID(param1.iClass) < param1.iReqCP)
         {
            _loc2_ = int(this.rootClass.getRankFromPoints(param1.iReqCP));
            _loc3_ = param1.iReqCP - this.rootClass.arrRanks[_loc2_ - 1];
            if(_loc3_ > 0)
            {
               return "Requires " + _loc3_ + " Class Points on " + param1.sClass + ", Rank " + _loc2_ + ".";
            }
            return "Requires " + (!!this.rootClass.litePreference.data.bDebugger ? "(" + param1.iClass + ") " : "") + param1.sClass + ", Rank " + _loc2_ + ".";
         }
         if(param1.FactionID > 1 && this.world.myAvatar.getRep(param1.FactionID) < param1.iReqRep)
         {
            _loc4_ = int(this.rootClass.getRankFromPoints(param1.iReqRep));
            _loc5_ = param1.iReqRep - this.rootClass.arrRanks[_loc4_ - 1];
            if(_loc5_ > 0)
            {
               return "Requires " + _loc5_ + " Reputation for " + param1.sFaction + ", Rank " + _loc4_ + ".";
            }
            return "Requires " + param1.sFaction + ", Rank " + _loc4_ + ".";
         }
         if(param1.reqd != null && !this.hasRequiredItemsForQuest(param1))
         {
            _loc6_ = "Required Item(s): ";
            _loc7_ = 0;
            while(_loc7_ < param1.reqd.length)
            {
               _loc8_ = this.world.invTree[param1.reqd[_loc7_].ItemID];
               _loc9_ = int(param1.reqd[_loc7_].iQty);
               if(_loc8_.sES == "ar")
               {
                  _loc10_ = int(this.rootClass.getRankFromPoints(_loc9_));
                  _loc11_ = _loc9_ - this.rootClass.arrRanks[_loc10_ - 1];
                  if(_loc11_ > 0)
                  {
                     _loc6_ += _loc11_ + " Class Points on ";
                  }
                  if(this.rootClass.litePreference.data.bDebugger)
                  {
                     _loc6_ += "(" + param1.reqd[_loc7_].ItemID + ")";
                  }
                  _loc6_ += _loc8_.sName + ", Rank " + _loc10_;
               }
               else
               {
                  if(this.rootClass.litePreference.data.bDebugger)
                  {
                     _loc6_ += "(" + param1.reqd[_loc7_].ItemID + ")";
                  }
                  _loc6_ += _loc8_.sName;
                  if(_loc9_ > 1)
                  {
                     _loc6_ += "x" + _loc9_;
                  }
               }
               _loc6_ += ", ";
               _loc7_++;
            }
            return _loc6_.substr(0,_loc6_.length - 2) + ".";
         }
         return "";
      }
      
      private function isOneTimeQuestDone(param1:*) : Boolean
      {
         return param1.bOnce == 1 && (param1.iSlot < 0 || this.world.getQuestValue(param1.iSlot) >= param1.iValue);
      }
      
      private function buildQuestList() : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:String = null;
         var _loc1_:* = 0;
         while(_loc1_ < this.qIDs.length)
         {
            _loc5_ = this.world.questTree[this.qIDs[_loc1_]];
            if(_loc5_ != null && !this.isOneTimeQuestDone(_loc5_))
            {
               _loc6_ = this.mc.cnt.qList.addChild(new qProto());
               _loc7_ = !!this.rootClass.litePreference.data.bDebugger ? "(" + _loc5_.QuestID + ")" : "";
               if(this.isQuestAvailable(_loc5_))
               {
                  _loc6_.ti.htmlText = "<font color=\'#009900\'><b>" + _loc7_ + _loc5_.sName + "</b></font>";
               }
               else
               {
                  _loc6_.ti.htmlText = "<font color=\'#990000\'><b>" + _loc7_ + _loc5_.sName + "</b></font>";
               }
               _loc6_.addEventListener(MouseEvent.CLICK,this.qListClick);
               _loc6_.QuestID = _loc5_.QuestID;
               if(_loc5_.sTyp != null)
               {
                  _loc6_.ti.htmlText += " <font color=\"#888888\">" + _loc5_.sTyp + "</font>";
               }
               if(_loc5_.status != null)
               {
                  switch(_loc5_.status)
                  {
                     case "p":
                        _loc6_.ti.htmlText += "<font color=\'#888888\'> - In progress</font>";
                        break;
                     case "c":
                        _loc6_.ti.htmlText += "<font color=\'#99FF00\'> - <b>Complete!</b></font>";
                  }
               }
               _loc6_.addEventListener(MouseEvent.MOUSE_OVER,this.iMouseOver,false,0,true);
               _loc6_.addEventListener(MouseEvent.MOUSE_OUT,this.iMouseOut,false,0,true);
               _loc6_.buttonMode = true;
               _loc6_.hit.alpha = 0;
               _loc6_.y = _loc1_ * 20;
               _loc6_.x = 10;
            }
            _loc1_++;
         }
         var _loc2_:* = this.mc.cnt.scr;
         var _loc3_:* = this.mc.cnt.bMask;
         var _loc4_:* = this.mc.cnt.qList;
         _loc2_.h.height = int(_loc2_.b.height / _loc4_.height * _loc2_.b.height);
         this.hRun = _loc2_.b.height - _loc2_.h.height;
         this.dRun = _loc4_.height - _loc2_.b.height + 20;
         _loc2_.h.y = 0;
         _loc4_.oy = _loc4_.y = this.qly;
         _loc2_.visible = false;
         _loc2_.hit.alpha = 0;
         this.mDown = false;
         if(_loc4_.height > _loc2_.b.height)
         {
            _loc2_.visible = true;
            _loc2_.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.scrDown,false,0,true);
            _loc2_.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
            _loc4_.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
         }
         this.mc.cnt.qList.iproto.visible = false;
      }
      
      private function qListClick(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         this.qData = this.world.questTree[_loc2_.QuestID];
         _loc2_.removeEventListener(MouseEvent.CLICK,this.qListClick);
         _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.iMouseOver);
         _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.iMouseOut);
         this.mc.cnt.gotoAndPlay("out");
         if(this.mc.cnt.qList.hasEventListener(Event.ENTER_FRAME))
         {
            this.mc.cnt.qList.removeEventListener(Event.ENTER_FRAME,this.dEF);
         }
         this.mc.cnt.qList.mouseEnabled = false;
         this.mc.cnt.qList.mouseChildren = false;
      }
      
      private function showEmptyList() : *
      {
         var _loc1_:* = this.mc.cnt.qList.addChild(new qProto());
         _loc1_.ti.htmlText = "<font color=\"#DDDDDD\">You aren\'t on any quests!</font>";
         _loc1_.hit.alpha = 0;
         _loc1_.x = 10;
         this.mc.cnt.qList.iproto.visible = false;
         this.mc.cnt.scr.visible = false;
      }
      
      private function isOwned(param1:Boolean, param2:*) : Boolean
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in param1 ? this.rootClass.world.myAvatar.houseitems : this.rootClass.world.myAvatar.items)
         {
            if(_loc3_.ItemID == param2)
            {
               return true;
            }
         }
         if(this.rootClass.world.bankinfo.isItemInBank(param2))
         {
            return true;
         }
         return false;
      }
      
      public function getCount(param1:String) : int
      {
         var _loc2_:* = undefined;
         if(this.rewardCount != -1)
         {
            return this.rewardCount;
         }
         this.rewardCount = 0;
         for(_loc2_ in this.qData.oRewards[param1])
         {
            ++this.rewardCount;
         }
         return this.rewardCount;
      }
      
      public function showQuestDetail() : *
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = null;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:Class = null;
         var _loc18_:MovieClip = null;
         var _loc19_:GlowFilter = null;
         var _loc20_:Array = null;
         var _loc21_:String = null;
         var _loc22_:Object = null;
         var _loc23_:MovieClip = null;
         var _loc24_:Object = null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:String = null;
         var _loc28_:String = null;
         var _loc29_:int = 0;
         var _loc30_:String = null;
         var _loc31_:Object = null;
         var _loc32_:Object = null;
         var _loc33_:* = undefined;
         var _loc34_:Class = null;
         var _loc35_:DisplayObject = null;
         var _loc36_:Rectangle = null;
         var _loc37_:int = 0;
         var _loc38_:Number = NaN;
         var _loc39_:detailedCheck = null;
         var _loc40_:Rectangle = null;
         var _loc41_:Rectangle = null;
         var _loc42_:Rectangle = null;
         var _loc43_:TextFormat = null;
         var _loc44_:* = undefined;
         this.mc.cnt.bg.btnPin.visible = false;
         this.mc.cnt.bg.btnWiki.visible = true;
         if(this.mc.cnt.bg.btnWiki.visible)
         {
            this.mc.cnt.strTitle.x = 53;
            this.mc.cnt.strTitle.width = 256;
         }
         else
         {
            this.mc.cnt.strTitle.x = 42;
            this.mc.cnt.strTitle.width = 270;
         }
         var _loc1_:int = 0;
         this.choiceID = -1;
         this.world.checkAllQuestStatus();
         this.mc.cnt.mouseChildren = true;
         this.mc.cnt.strTitle.text = this.qData.sName;
         var _loc5_:* = this.mc.cnt.core;
         _loc5_.strNote.autoSize = "left";
         _loc5_.strNote.text = this.getQuestValidationString(this.qData);
         _loc5_.strDesc.mouseWheelEnabled = false;
         _loc5_.strReq.mouseWheelEnabled = false;
         _loc5_.rewards.strRew.mouseWheelEnabled = false;
         _loc5_.strDesc.autoSize = "left";
         _loc5_.strReq.autoSize = "left";
         _loc5_.rewards.strRew.autoSize = "left";
         if(this.qData.status == "c" && this.tIDs.indexOf(String(this.qData.QuestID)) >= 0 && this.qData.sEndText != "")
         {
            _loc5_.strDesc.text = this.qData.sEndText;
         }
         else
         {
            _loc5_.strDesc.text = this.qData.sDesc;
         }
         _loc5_.strReq.htmlText = "";
         if(this.qData.turnin != null && this.qData.turnin.length > 0)
         {
            _loc13_ = "";
            _loc1_ = 0;
            while(_loc1_ < this.qData.turnin.length)
            {
               _loc14_ = this.world.invTree[this.qData.turnin[_loc1_].ItemID];
               _loc15_ = this.qData.oItems[this.qData.turnin[_loc1_].ItemID].sName;
               if(this.rootClass.litePreference.data.bDebugger)
               {
                  _loc15_ = "(" + this.qData.turnin[_loc1_].ItemID + ") " + _loc15_;
               }
               _loc16_ = int(this.qData.turnin[_loc1_].iQty);
               if(_loc1_ > 0)
               {
                  _loc13_ += ",<br>";
               }
               if(_loc14_.iQty < _loc16_)
               {
                  _loc13_ += _loc15_ + " <font color=\"#888888\">" + _loc14_.iQty + "/</font>" + _loc16_;
               }
               else
               {
                  _loc13_ += "<font color=\"#888888\">" + _loc15_ + " " + _loc14_.iQty + "/" + _loc16_ + "</font>";
               }
               _loc1_++;
            }
            _loc5_.strReq.htmlText = _loc13_;
         }
         var _loc6_:* = this.qData.iGold + "<font color=\"#FFCC00\"> gold</font><br>";
         _loc6_ = _loc6_ + (this.qData.iExp + "<font color=\"#FF00FF\"> xp</font>");
         if(Boolean(this.qData.hasOwnProperty("metaValues")) && Boolean(this.qData.metaValues.hasOwnProperty("freeac")))
         {
            _loc6_ += "<br>" + this.qData.metaValues.freeac + "<font color=\"#FFCC00\"> ac</font>";
         }
         if(this.qData.FactionID > 1 && this.qData.iRep > 0)
         {
            _loc6_ += "<br>" + this.qData.iRep + " <font color=\'#00FF66\'>rep : " + this.qData.sFaction + "</font>";
         }
         _loc5_.rewards.strRew.htmlText = _loc6_;
         if(_loc5_.strNote.text == "")
         {
            _loc5_.descTitle.y = 0;
         }
         else
         {
            _loc5_.descTitle.y = _loc5_.strNote.y + _loc5_.strNote.textHeight + 10;
         }
         _loc5_.strDesc.y = _loc5_.descTitle.y + 15;
         _loc5_.reqTitle.y = Math.round(_loc5_.strDesc.y + _loc5_.strDesc.textHeight + 10);
         _loc5_.strReq.y = _loc5_.reqTitle.y + 15;
         _loc5_.rewards.y = Math.round(_loc5_.strReq.y + _loc5_.strReq.textHeight + 10);
         var _loc7_:Number = _loc5_.rewards.y + _loc5_.rewards.height + 15;
         if(this.qData.oRewards != null)
         {
            _loc17_ = this.world.getClass("DFrameMCcnt");
            _loc20_ = ["itemsS","itemsC","itemsR","itemsrand"];
            _loc1_ = 0;
            while(_loc1_ < _loc20_.length)
            {
               _loc21_ = _loc20_[_loc1_];
               switch(_loc21_)
               {
                  case "itemsS":
                  default:
                     _loc23_ = _loc5_.rewardsStatic;
                     break;
                  case "itemsC":
                     _loc23_ = _loc5_.rewardsChoice;
                     break;
                  case "itemsR":
                     _loc23_ = _loc5_.rewardsRoll;
                     break;
                  case "itemsrand":
                     _loc23_ = _loc5_.rewardsRandom;
               }
               if(this.qData.oRewards[_loc21_] == null)
               {
                  _loc23_.visible = false;
               }
               else
               {
                  _loc22_ = this.qData.oRewards[_loc21_];
                  _loc26_ = 16;
                  for(_loc2_ in _loc22_)
                  {
                     _loc24_ = _loc22_[_loc2_];
                     _loc25_ = int(_loc24_.iQty);
                     _loc18_ = _loc23_.addChild(new _loc17_()) as MovieClip;
                     _loc18_.ItemID = _loc24_.ItemID;
                     _loc18_.strName.autoSize = "left";
                     _loc27_ = !!this.rootClass.litePreference.data.bDebugger ? "(" + _loc24_.ItemID + ")" : "";
                     _loc18_.strName.text = _loc27_ + _loc24_.sName;
                     _loc18_.strName.width = _loc18_.strName.textWidth + 6;
                     _loc28_ = "100";
                     if(_loc21_ != "itemsrand")
                     {
                        for each(_loc33_ in this.qData.reward)
                        {
                           if(_loc33_.ItemID == _loc18_.ItemID && _loc33_.iQty == _loc25_)
                           {
                              _loc28_ = _loc33_.iRate;
                           }
                        }
                     }
                     if(_loc21_ == "itemsrand")
                     {
                        _loc28_ = Number(Number(_loc28_) / this.getCount(_loc21_)).toFixed(2).toString();
                     }
                     _loc18_.strType.text = !!_loc28_ ? _loc24_.sType + " (" + _loc28_ + "%)" : _loc24_.sType;
                     _loc18_.strType.width = 100;
                     _loc18_.strRate.visible = false;
                     _loc18_.bg.width = int(_loc18_.strName.textWidth) + 75;
                     if(_loc18_.bg.width < 175)
                     {
                        _loc18_.bg.width = 175;
                     }
                     _loc18_.fx1.width = _loc18_.bg.width;
                     if(_loc25_ > 1)
                     {
                        _loc18_.strQ.text = "x" + _loc25_;
                        _loc18_.strQ.x = _loc18_.bg.width - _loc18_.strQ.width - 7;
                        _loc18_.strQ.visible = true;
                     }
                     else
                     {
                        _loc18_.strQ.x = 0;
                        _loc18_.strQ.visible = false;
                     }
                     _loc29_ = _loc24_.iRty >= 0 && _loc24_.iRty < RARITY_GLOWS.length ? int(_loc24_.iRty) : 0;
                     _loc18_.bg.filters = [RARITY_GLOWS[_loc29_]];
                     _loc18_.icon.removeAllChildren();
                     _loc30_ = "";
                     if(_loc24_.sType.toLowerCase() == "enhancement")
                     {
                        _loc30_ = this.rootClass.getIconBySlot(_loc24_.sES);
                     }
                     else if(_loc24_.sIcon == null || _loc24_.sIcon == "" || _loc24_.sIcon == "none")
                     {
                        if(_loc24_.sLink.toLowerCase() != "none")
                        {
                           _loc30_ = "iidesign";
                        }
                        else
                        {
                           _loc30_ = "iibag";
                        }
                     }
                     else
                     {
                        _loc30_ = _loc24_.sIcon;
                     }
                     try
                     {
                        _loc34_ = this.world.getClass(_loc30_) as Class;
                        _loc35_ = _loc18_.icon.addChild(new _loc34_());
                        _loc35_.scaleX = _loc35_.scaleY = String(_loc24_.sType).toLowerCase() == "misc" ? 0.25 : 0.5;
                        _loc36_ = _loc35_.getBounds(_loc18_.icon);
                        if(_loc36_.width > 30 || _loc36_.height > 30)
                        {
                           _loc38_ = 30 / Math.max(_loc36_.width,_loc36_.height);
                           _loc35_.scaleX *= _loc38_;
                           _loc35_.scaleY *= _loc38_;
                        }
                        _loc37_ = _loc24_.iRty >= 0 && _loc24_.iRty < RARITY_GLOWS.length ? int(_loc24_.iRty) : 0;
                        _loc18_.icon.filters = [RARITY_GLOWS[_loc37_]];
                        if(this.isOwned(_loc24_.bHouse,_loc24_.ItemID))
                        {
                           _loc39_ = new detailedCheck();
                           _loc18_.icon.addChild(_loc39_);
                           _loc40_ = _loc39_.getBounds(_loc39_);
                           _loc41_ = _loc35_.getBounds(_loc18_.icon);
                           if(_loc40_.height > 0)
                           {
                              _loc39_.scaleX = _loc39_.scaleY = _loc41_.height / _loc40_.height;
                           }
                           _loc42_ = _loc39_.getBounds(_loc18_.icon);
                           _loc39_.x += _loc41_.x + _loc41_.width / 2 - (_loc42_.x + _loc42_.width / 2) + _loc41_.height / 2;
                           _loc39_.y += _loc41_.y + _loc41_.height / 2 - (_loc42_.y + _loc42_.height / 2);
                        }
                     }
                     catch(e:Error)
                     {
                     }
                     _loc18_.y = _loc26_;
                     _loc26_ += Math.round(_loc18_.height + 8);
                     if(_loc21_ == "itemsC" && this.qMode != "l" && this.qData.status != null && this.qData.status == "c" && this.tIDs.indexOf(String(this.qData.QuestID)) >= 0)
                     {
                        _loc18_.mouseEnabled = true;
                        _loc18_.mouseChildren = false;
                        _loc18_.buttonMode = true;
                        _loc18_.addEventListener(MouseEvent.CLICK,this.btnRewardClick,false,0,true);
                     }
                     if(_loc24_.bCoins != 1)
                     {
                        _loc18_.fadedAC.visible = false;
                     }
                     else
                     {
                        _loc18_.fadedAC.x = _loc18_.bg.width - 72;
                     }
                     if(_loc24_.bUpg)
                     {
                        _loc43_ = _loc18_.strName.defaultTextFormat;
                        _loc43_.color = 16566089;
                        _loc18_.strName.setTextFormat(_loc43_);
                        _loc43_ = _loc18_.strQ.defaultTextFormat;
                        _loc43_.color = 16566089;
                        _loc18_.strQ.setTextFormat(_loc43_);
                     }
                     for each(_loc32_ in this.qData.oRewards)
                     {
                        for each(_loc33_ in _loc32_)
                        {
                           if(_loc33_.ItemID == _loc18_.ItemID)
                           {
                              _loc31_ = _loc33_;
                           }
                        }
                     }
                     if(!_loc18_.hasEventListener(MouseEvent.CLICK))
                     {
                        _loc18_.addEventListener(MouseEvent.CLICK,this.onRewardPreview,false,0,true);
                     }
                  }
               }
               if(_loc23_.visible)
               {
                  _loc23_.y = _loc7_;
                  _loc7_ = _loc23_.y + _loc23_.height + 15;
               }
               _loc1_++;
            }
         }
         this.rewardCount = -1;
         var _loc8_:* = null;
         var _loc9_:* = {};
         if(this.qMode != "l")
         {
            if(this.qData.status == null)
            {
               _loc8_ = this.mc.cnt.btns.dual;
               this.mc.cnt.btns.tri.visible = false;
               _loc9_ = {
                  "b1":{
                     "txt":"Accept",
                     "fn":this.btnAccept
                  },
                  "b2":{
                     "txt":"Decline",
                     "fn":this.btnBack
                  }
               };
            }
            else if(this.qData.status == "c" && this.tIDs.indexOf(String(this.qData.QuestID)) >= 0)
            {
               _loc8_ = this.mc.cnt.btns.tri;
               this.mc.cnt.btns.dual.visible = false;
               _loc9_ = {
                  "b1":{
                     "txt":"Back",
                     "fn":this.btnBack
                  },
                  "b2":{
                     "txt":"Turn in!",
                     "fn":this.btnComplete
                  },
                  "b3":{
                     "txt":"Abandon",
                     "fn":this.btnAbandon
                  }
               };
            }
            else
            {
               _loc8_ = this.mc.cnt.btns.dual;
               this.mc.cnt.btns.tri.visible = false;
               _loc9_ = {
                  "b1":{
                     "txt":"Back",
                     "fn":this.btnBack
                  },
                  "b2":{
                     "txt":"Abandon",
                     "fn":this.btnAbandon
                  }
               };
            }
         }
         else
         {
            _loc8_ = this.mc.cnt.btns.dual;
            this.mc.cnt.btns.tri.visible = false;
            _loc9_ = {
               "b1":{
                  "txt":"Back",
                  "fn":this.btnBack
               },
               "b2":{
                  "txt":"Abandon",
                  "fn":this.btnAbandon
               }
            };
         }
         for(_loc10_ in _loc9_)
         {
            _loc44_ = _loc8_[_loc10_];
            _loc44_.buttonMode = true;
            _loc44_.fx.visible = false;
            _loc44_.ti.mouseEnabled = false;
            _loc44_.addEventListener(MouseEvent.MOUSE_OVER,this.bMouseOver,false,0,true);
            _loc44_.addEventListener(MouseEvent.MOUSE_OUT,this.bMouseOut,false,0,true);
            _loc44_.ti.text = _loc9_[_loc10_].txt;
            _loc44_.addEventListener(MouseEvent.CLICK,_loc9_[_loc10_].fn,false,0,true);
         }
         _loc11_ = this.mc.cnt.scr;
         _loc12_ = this.mc.cnt.bMask;
         _loc11_.h.height = int(_loc11_.b.height / _loc5_.height * _loc11_.b.height);
         this.hRun = _loc11_.b.height - _loc11_.h.height;
         this.dRun = _loc5_.height - _loc11_.b.height + 20;
         _loc11_.h.y = 0;
         _loc5_.oy = _loc5_.y = this.qdy;
         _loc11_.visible = false;
         _loc11_.hit.alpha = 0;
         this.mDown = false;
         if(_loc5_.height > _loc11_.b.height)
         {
            _loc11_.visible = true;
            _loc11_.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.scrDown,false,0,true);
            _loc11_.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
            _loc5_.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
         }
         this.mc.cnt.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,false,0,true);
      }
      
      private function onRewardPreview(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc5_:Object = null;
         for each(_loc3_ in this.qData.oRewards)
         {
            for each(_loc5_ in _loc3_)
            {
               if(_loc5_.ItemID == param1.currentTarget.ItemID)
               {
                  _loc2_ = _loc5_;
               }
            }
         }
         if(this.rootClass.ui.getChildByName("qRewardPrev"))
         {
            this.rootClass.ui.getChildByName("qRewardPrev").fClose();
         }
         var _loc4_:* = this.rootClass.ui.addChild(new qRewardPrev(_loc2_));
         _loc4_.world = this.rootClass.world;
         _loc4_.rootClass = this.rootClass;
         _loc4_.open();
      }
      
      private function onWheel(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = this.mc.cnt.scr;
         if(!_loc2_ || !_loc2_.visible)
         {
            return;
         }
         _loc2_.h.y += param1.delta * -1 * 3;
         if(_loc2_.h.y < 0)
         {
            _loc2_.h.y = 0;
         }
         if(_loc2_.h.y + _loc2_.h.height > _loc2_.b.height)
         {
            _loc2_.h.y = int(_loc2_.b.height - _loc2_.h.height);
         }
      }
      
      private function scrDown(param1:MouseEvent) : *
      {
         this.mbY = int(mouseY);
         this.mhY = int(MovieClip(param1.currentTarget.parent).h.y);
         this.mDown = true;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.scrUp,false,0,true);
      }
      
      private function scrUp(param1:MouseEvent) : *
      {
         this.mDown = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.scrUp);
      }
      
      private function hEF(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(this.mDown)
         {
            _loc2_ = MovieClip(param1.currentTarget.parent);
            this.mbD = int(mouseY) - this.mbY;
            _loc2_.h.y = this.mhY + this.mbD;
            if(_loc2_.h.y + _loc2_.h.height > _loc2_.b.height)
            {
               _loc2_.h.y = int(_loc2_.b.height - _loc2_.h.height);
            }
            if(_loc2_.h.y < 0)
            {
               _loc2_.h.y = 0;
            }
         }
      }
      
      private function dEF(param1:Event) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget.parent).scr;
         var _loc3_:* = MovieClip(param1.currentTarget);
         var _loc4_:* = -_loc2_.h.y / this.hRun;
         var _loc5_:* = int(_loc4_ * this.dRun) + _loc3_.oy;
         if(Math.abs(_loc5_ - _loc3_.y) > 0.2)
         {
            _loc3_.y += (_loc5_ - _loc3_.y) / 4;
         }
         else
         {
            _loc3_.y = _loc5_;
         }
      }
      
      public function killDetailUI() : *
      {
         if(this.mc.cnt.core.hasEventListener(Event.ENTER_FRAME))
         {
            this.mc.cnt.core.removeEventListener(Event.ENTER_FRAME,this.dEF);
         }
      }
      
      public function turninResult(param1:String) : *
      {
         this.getQuestListB();
         this.qData = null;
         if(this.mc.cnt.currentLabel == "hold")
         {
            if(param1 == "pass")
            {
               this.qData = this.nextQuestAvailable();
            }
            this.mc.cnt.gotoAndPlay("back");
         }
      }
      
      private function xClick(param1:MouseEvent) : *
      {
         this.fClose();
         if(this.rootClass.ui.getChildByName("qRewardPrev"))
         {
            this.rootClass.ui.getChildByName("qRewardPrev").fClose();
         }
      }
      
      public function fClose() : void
      {
         this.mc.cnt.bg.btnClose.removeEventListener(MouseEvent.CLICK,this.xClick);
         stage.focus = stage;
         this.mc.parent.removeChild(this.mc);
      }
      
      private function btnAccept(param1:MouseEvent) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = this.getQuestValidationString(this.qData);
         if(Boolean(this.qData.hasOwnProperty("sMeta")) && this.qData.sMeta.indexOf("EmailConfirm") != -1 && this.world.myAvatar.objData.intActivationFlag < 5)
         {
            this.rootClass.MsgBox.notify("Confirmed Contact Email Address Required");
         }
         else if(_loc2_ != "")
         {
            MovieClip(Game.root).MsgBox.notify(_loc2_);
         }
         else if(this.world.coolDown("acceptQuest"))
         {
            _loc3_ = MovieClip(param1.currentTarget);
            this.setCT(_loc3_.bg,43775);
            _loc3_.removeEventListener(MouseEvent.CLICK,this.btnAccept);
            _loc3_.removeEventListener(MouseEvent.MOUSE_OVER,this.bMouseOver);
            _loc3_.removeEventListener(MouseEvent.MOUSE_OUT,this.bMouseOut);
            this.world.acceptQuest(this.qData.QuestID);
            this.qData = null;
         }
      }
      
      private function btnAbandon(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         this.world.abandonQuest(this.qData.QuestID);
         this.setCT(_loc2_.bg,16711680);
         _loc2_.removeEventListener(MouseEvent.CLICK,this.btnAbandon);
         _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.bMouseOver);
         _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.bMouseOut);
         this.qData = null;
         this.mc.cnt.gotoAndPlay("back");
      }
      
      private function btnComplete(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(Boolean(this.world.coolDown("tryQuestComplete")) && Boolean(this.world.canTurnInQuest(this.qData.QuestID)))
         {
            if(this.qData.oRewards.itemsC != null && this.choiceID == -1)
            {
               this.rootClass.addUpdate("Please choose a reward before turning the quest in!");
               this.rootClass.chatF.pushMsg("warning","Please choose a reward before turning the quest in!","SERVER","",0);
               return;
            }
            _loc2_ = MovieClip(param1.currentTarget);
            this.setCT(_loc2_.bg,65280);
            _loc2_.removeEventListener(MouseEvent.CLICK,this.btnAbandon);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.bMouseOver);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.bMouseOut);
            this.mc.cnt.gotoAndPlay("hold");
            this.getQuestListA();
            if(this.qData.sField == null && this.world.maximumQuestTurnIns(this.qData.QuestID) > 1 && this.qData.bOnce == 0)
            {
               _loc3_ = new ModalMC();
               _loc4_ = {};
               _loc4_.params = {};
               _loc4_.strBody = "Turn-in the quest how many times?";
               _loc4_.callback = this.onQtyComplete;
               _loc4_.qtySel = {
                  "min":1,
                  "max":this.world.maximumQuestTurnIns(this.qData.QuestID),
                  "base":1
               };
               _loc4_.glow = "white,medium";
               _loc4_.greedy = false;
               this.rootClass.ui.ModalStack.addChild(_loc3_);
               _loc3_.init(_loc4_);
            }
            else
            {
               this.world.tryQuestComplete(this.qData.QuestID,this.choiceID);
            }
         }
      }
      
      private function onQtyComplete(param1:Object) : void
      {
         if(param1.accept)
         {
            this.world.tryQuestComplete(this.qData.QuestID,this.choiceID,false,Number(param1.iQty));
         }
      }
      
      private function btnBack(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         this.setCT(_loc2_.bg,11184810);
         _loc2_.removeEventListener(MouseEvent.CLICK,this.btnBack);
         _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.bMouseOver);
         _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.bMouseOut);
         this.mc.cnt.mouseChildren = false;
         this.qData = null;
         this.mc.cnt.gotoAndPlay("back");
      }
      
      private function btnRewardClick(param1:MouseEvent) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:Array = null;
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc3_:MovieClip = _loc2_.parent as MovieClip;
         this.choiceID = _loc2_.ItemID;
         var _loc6_:int = 1;
         while(_loc6_ < _loc3_.numChildren)
         {
            _loc4_ = _loc3_.getChildAt(_loc6_) as MovieClip;
            _loc5_ = _loc4_.bg.filters;
            if(this.choiceID == _loc4_.ItemID && _loc5_.length == 1)
            {
               _loc5_.push(CHOICE_GLOW);
               _loc4_.bg.filters = _loc5_;
            }
            if(this.choiceID != _loc4_.ItemID && _loc5_.length > 1)
            {
               _loc5_.pop();
               _loc4_.bg.filters = _loc5_;
            }
            _loc6_++;
         }
      }
      
      private function bMouseOver(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         _loc2_.fx.visible = true;
      }
      
      private function bMouseOut(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         _loc2_.fx.visible = false;
      }
      
      private function setCT(param1:*, param2:*) : *
      {
         var _loc3_:* = param1.transform.colorTransform;
         _loc3_.color = param2;
         param1.transform.colorTransform = _loc3_;
      }
      
      private function iMouseOver(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         _loc2_.parent.mHi.visible = true;
         _loc2_.parent.mHi.y = _loc2_.y;
      }
      
      private function iMouseOut(param1:MouseEvent) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget);
         _loc2_.parent.mHi.visible = false;
      }
   }
}

