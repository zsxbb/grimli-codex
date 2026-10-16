package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.Rectangle;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class monsterDrops extends Sprite
   {
      private static const PANEL_W:int = 340;
      
      private static const PANEL_H:int = 420;
      
      private static const TITLE_H:int = 28;
      
      private static const SCROLLBAR_W:int = 8;
      
      private static const VIEW_X:int = 10;
      
      private static const VIEW_Y:int = 36;
      
      private static const VIEW_W:int = 310;
      
      private static const VIEW_H:int = 374;
      
      private static const BASE_ROW_H:int = 30;
      
      private static const ICON_SIZE:int = 20;
      
      private static const WHEEL_STEP:int = 30;
      
      private static const MIN_THUMB:int = 24;
      
      private static const RATE_W:int = 104;
      
      private static const CHECK_X_NUDGE:int = 10;
      
      private static const PREVIEW_W:int = 210;
      
      private static const EXPANDED_W:int = PANEL_W + PREVIEW_W;
      
      private static const PV_X:int = PANEL_W + 12;
      
      private static const PV_Y:int = TITLE_H + 12;
      
      private static const PV_W:int = PREVIEW_W - 24;
      
      private static const PV_H:int = 300;
      
      private static const BTN_Y:int = PANEL_H - 44;
      
      private static const BTN_H:int = 26;
      
      private static const WHITE_GLOW:GlowFilter = new GlowFilter(16777215,1,8,8,2,1,false,false);
      
      private var rootClass:MovieClip;
      
      private var MonMapID:*;
      
      private var monName:String;
      
      private var titleTF:TextField;
      
      private var statusTF:TextField;
      
      private var closeBtn:Sprite;
      
      private var closeTF:TextField;
      
      private var contentHost:Sprite;
      
      private var content:Sprite;
      
      private var contentMask:Shape;
      
      private var scrollBar:Sprite;
      
      private var track:Sprite;
      
      private var thumb:Sprite;
      
      private var itemCount:int = 0;
      
      private var contentHeight:Number = 0;
      
      private var maxScroll:Number = 0;
      
      private var dragging:Boolean = false;
      
      private var dragStartMouseY:Number = 0;
      
      private var dragStartThumbY:Number = 0;
      
      private var expanded:Boolean = false;
      
      private var selectedRow:DropRow;
      
      private var previewItem:Object;
      
      private var assetLoader:*;
      
      private var previewHeaderTF:TextField;
      
      private var previewHost:MovieClip;
      
      private var previewMask:Shape;
      
      private var prevCloseBtn:Sprite;
      
      private var prevCloseTF:TextField;
      
      private var tryBtn:Sprite;
      
      private var tryTF:TextField;
      
      private var wikiBtn:Sprite;
      
      private var wikiTF:TextField;
      
      private var tryW:Number = 0;
      
      private var wikiW:Number = 0;
      
      private var sLinkArmor:String = "";
      
      private var sLinkCape:String = "";
      
      private var sLinkHelm:String = "";
      
      private var sLinkPet:String = "";
      
      private var sLinkWeapon:String = "";
      
      private var sLinkMisc:String = "";
      
      public function monsterDrops(param1:MovieClip, param2:*, param3:String)
      {
         super();
         this.rootClass = param1;
         this.MonMapID = param2;
         this.monName = param3 != null ? param3 : "Monster";
         this.name = "monsterDropsPanel";
         var _loc4_:* = this.rootClass.ui.getChildByName("monsterDropsPanel");
         if(_loc4_ != null && _loc4_ != this && _loc4_ is monsterDrops)
         {
            (_loc4_ as monsterDrops).fClose();
         }
         this.buildChrome();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,false,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage,false,0,true);
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
         this.closeBtn.addEventListener(MouseEvent.ROLL_OVER,this.onCloseOver,false,0,true);
         this.closeBtn.addEventListener(MouseEvent.ROLL_OUT,this.onCloseOut,false,0,true);
         this.thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.onThumbDown,false,0,true);
         this.track.addEventListener(MouseEvent.MOUSE_DOWN,this.onTrackDown,false,0,true);
         this.x = (960 - PANEL_W) / 2;
         this.y = (550 - PANEL_H) / 2;
         this.rootClass.sfc.sendXtMessage("zm","getMonsterDrops",[this.MonMapID],"str",this.rootClass.world.curRoom);
      }
      
      private function makeTF(param1:int, param2:uint, param3:Boolean, param4:String) : TextFormat
      {
         var _loc5_:TextFormat = new TextFormat();
         _loc5_.font = "Arial";
         _loc5_.size = param1;
         _loc5_.color = param2;
         _loc5_.bold = param3;
         _loc5_.align = param4;
         return _loc5_;
      }
      
      private function drawFrame(param1:int) : void
      {
         graphics.clear();
         graphics.lineStyle(1,3355443,1);
         graphics.beginFill(0,0.88);
         graphics.drawRect(0,0,param1,PANEL_H);
         graphics.endFill();
         graphics.lineStyle(0,0,0);
         graphics.beginFill(1710618,1);
         graphics.drawRect(1,1,param1 - 2,TITLE_H);
         graphics.endFill();
         if(param1 > PANEL_W)
         {
            graphics.beginFill(3355443,1);
            graphics.drawRect(PANEL_W,1,1,PANEL_H - 2);
            graphics.endFill();
         }
      }
      
      private function buildChrome() : void
      {
         this.drawFrame(PANEL_W);
         this.titleTF = new TextField();
         this.titleTF.defaultTextFormat = this.makeTF(14,16777215,true,"left");
         this.titleTF.selectable = false;
         this.titleTF.mouseEnabled = false;
         this.titleTF.x = 10;
         this.titleTF.y = 5;
         this.titleTF.width = PANEL_W - 44;
         this.titleTF.height = 20;
         this.titleTF.text = this.monName + " - Drops";
         addChild(this.titleTF);
         this.closeBtn = new Sprite();
         this.closeBtn.graphics.beginFill(0,0.5);
         this.closeBtn.graphics.drawRect(0,0,18,18);
         this.closeBtn.graphics.endFill();
         this.closeTF = new TextField();
         this.closeTF.defaultTextFormat = this.makeTF(14,16777215,true,"center");
         this.closeTF.selectable = false;
         this.closeTF.mouseEnabled = false;
         this.closeTF.width = 18;
         this.closeTF.height = 20;
         this.closeTF.y = -1;
         this.closeTF.text = "X";
         this.closeBtn.addChild(this.closeTF);
         this.closeBtn.x = PANEL_W - 24;
         this.closeBtn.y = 5;
         this.closeBtn.buttonMode = true;
         this.closeBtn.mouseChildren = false;
         addChild(this.closeBtn);
         this.contentHost = new Sprite();
         this.contentHost.x = VIEW_X;
         this.contentHost.y = VIEW_Y;
         addChild(this.contentHost);
         this.content = new Sprite();
         this.contentHost.addChild(this.content);
         this.contentMask = new Shape();
         this.contentMask.graphics.beginFill(16777215,1);
         this.contentMask.graphics.drawRect(0,0,VIEW_W,VIEW_H);
         this.contentMask.graphics.endFill();
         this.contentHost.addChild(this.contentMask);
         this.content.mask = this.contentMask;
         this.scrollBar = new Sprite();
         this.scrollBar.x = VIEW_X + VIEW_W + 2;
         this.scrollBar.y = VIEW_Y;
         this.track = new Sprite();
         this.track.graphics.beginFill(16777215,0.08);
         this.track.graphics.drawRect(0,0,SCROLLBAR_W,VIEW_H);
         this.track.graphics.endFill();
         this.scrollBar.addChild(this.track);
         this.thumb = new Sprite();
         this.thumb.graphics.beginFill(16777215,0.3);
         this.thumb.graphics.drawRect(0,0,SCROLLBAR_W,MIN_THUMB);
         this.thumb.graphics.endFill();
         this.thumb.buttonMode = true;
         this.scrollBar.addChild(this.thumb);
         this.scrollBar.visible = false;
         addChild(this.scrollBar);
         this.statusTF = new TextField();
         this.statusTF.defaultTextFormat = this.makeTF(12,14540253,false,"center");
         this.statusTF.selectable = false;
         this.statusTF.mouseEnabled = false;
         this.statusTF.width = VIEW_W;
         this.statusTF.height = 40;
         this.statusTF.x = VIEW_X;
         this.statusTF.y = VIEW_Y + 24;
         this.statusTF.text = "Loading drops...";
         addChild(this.statusTF);
      }
      
      public function populate(param1:Object) : void
      {
         var _loc3_:* = undefined;
         var _loc6_:DropRow = null;
         if(param1 == null)
         {
            return;
         }
         if(param1.MonMapID != this.MonMapID)
         {
            return;
         }
         while(this.content.numChildren > 0)
         {
            this.content.removeChildAt(0);
         }
         if(this.statusTF.parent != null)
         {
            removeChild(this.statusTF);
         }
         this.selectedRow = null;
         var _loc2_:Array = [];
         for(_loc3_ in param1.items)
         {
            _loc2_.push(param1.items[_loc3_]);
         }
         this.itemCount = _loc2_.length;
         this.titleTF.text = this.monName + " - Drops (" + this.itemCount + ")";
         if(this.itemCount == 0)
         {
            this.statusTF.text = "This monster has no drops.";
            addChild(this.statusTF);
            this.scrollBar.visible = false;
            return;
         }
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc6_ = this.buildRow(_loc2_[_loc5_],_loc5_);
            _loc6_.y = _loc4_;
            this.content.addChild(_loc6_);
            _loc4_ += _loc6_.rowH;
            _loc5_++;
         }
         this.contentHeight = _loc4_;
         this.setupScroll();
      }
      
      private function resolveIcon(param1:Object) : String
      {
         var _loc2_:String = "";
         var _loc3_:String = param1.sType != null ? String(param1.sType).toLowerCase() : "";
         if(_loc3_ == "enhancement")
         {
            _loc2_ = this.rootClass.getIconBySlot(param1.sES);
         }
         else if(_loc3_ == "serveruse" || _loc3_ == "clientuse")
         {
            if("sFile" in param1 && param1.sFile != null && String(param1.sFile).length > 0 && this.rootClass.world.getClass(param1.sFile) != null)
            {
               _loc2_ = param1.sFile;
            }
            else
            {
               _loc2_ = param1.sIcon;
            }
         }
         else if(param1.sIcon == null || param1.sIcon == "" || param1.sIcon == "none")
         {
            if(param1.sLink != null && String(param1.sLink).toLowerCase() != "none")
            {
               _loc2_ = "iidesign";
            }
            else
            {
               _loc2_ = "iibag";
            }
         }
         else
         {
            _loc2_ = param1.sIcon;
         }
         return _loc2_;
      }
      
      private function buildRow(param1:Object, param2:int) : DropRow
      {
         var sIcon:String;
         var mcIcon:DisplayObject;
         var nameX:int;
         var colW:int;
         var nameTF:TextField;
         var showRate:Boolean;
         var rarityTF:TextField;
         var rowH:Number;
         var questHtml:String;
         var hi:Shape;
         var iconHolder:Sprite = null;
         var iconClass:Class = null;
         var acClass:Class = null;
         var ac:DisplayObject = null;
         var ab:Rectangle = null;
         var arb:Rectangle = null;
         var b:Rectangle = null;
         var s:Number = NaN;
         var nb:Rectangle = null;
         var check:detailedCheck = null;
         var lb:Rectangle = null;
         var fb:Rectangle = null;
         var gb:Rectangle = null;
         var rateTF:TextField = null;
         var rDiv:Number = NaN;
         var eaSfx:String = null;
         var qtyTF:TextField = null;
         var questTF:TextField = null;
         var item:Object = param1;
         var index:int = param2;
         var row:DropRow = new DropRow();
         row.itemData = item;
         row.mouseChildren = false;
         row.buttonMode = true;
         if(item.bCoins == 1)
         {
            try
            {
               acClass = getDefinitionByName("mcFadedAC") as Class;
               ac = new acClass();
               ac.alpha = 0.25;
               ab = ac.getBounds(ac);
               if(ab.height > 0)
               {
                  ac.scaleX = ac.scaleY = (BASE_ROW_H - 4) / ab.height;
               }
               arb = ac.getBounds(row);
               ac.x += VIEW_W - 52 - (arb.x + arb.width / 2);
               ac.y += BASE_ROW_H / 2 - (arb.y + arb.height / 2);
               row.addChild(ac);
            }
            catch(eAC:Error)
            {
            }
         }
         iconHolder = new Sprite();
         iconHolder.x = 4;
         iconHolder.y = (BASE_ROW_H - ICON_SIZE) / 2;
         row.addChild(iconHolder);
         sIcon = this.resolveIcon(item);
         mcIcon = null;
         try
         {
            iconClass = this.rootClass.world.getClass(sIcon) as Class;
            mcIcon = iconHolder.addChild(new iconClass() as DisplayObject);
         }
         catch(e:Error)
         {
            try
            {
               iconClass = rootClass.world.getClass("iibag") as Class;
               mcIcon = iconHolder.addChild(new iconClass() as DisplayObject);
            }
            catch(e2:Error)
            {
               mcIcon = null;
            }
         }
         if(mcIcon != null)
         {
            b = mcIcon.getBounds(iconHolder);
            if(b.width > 0 && b.height > 0)
            {
               s = ICON_SIZE / Math.max(b.width,b.height);
               mcIcon.scaleX = mcIcon.scaleY = s;
               nb = mcIcon.getBounds(iconHolder);
               mcIcon.x -= nb.x + (nb.width - ICON_SIZE) / 2;
               mcIcon.y -= nb.y + (nb.height - ICON_SIZE) / 2;
            }
            if(this.isOwned(item.bHouse,item.ItemID))
            {
               check = new detailedCheck();
               iconHolder.addChild(check);
               lb = check.getBounds(check);
               if(lb.height > 0)
               {
                  check.scaleX = check.scaleY = ICON_SIZE / lb.height;
               }
               fb = mcIcon.getBounds(iconHolder);
               gb = check.getBounds(iconHolder);
               check.x += fb.x + fb.width / 2 - (gb.x + gb.width / 2) + CHECK_X_NUDGE;
               check.y += fb.y + fb.height / 2 - (gb.y + gb.height / 2);
            }
         }
         nameX = 30;
         colW = VIEW_W - nameX - RATE_W - 4;
         nameTF = new TextField();
         nameTF.defaultTextFormat = this.makeTF(12,item.bUpg == 1 ? 16566089 : 16777215,false,"left");
         nameTF.selectable = false;
         nameTF.mouseEnabled = false;
         nameTF.x = nameX;
         nameTF.y = 3;
         nameTF.width = colW;
         nameTF.height = 16;
         nameTF.text = item.sName != null ? item.sName : "?";
         row.addChild(nameTF);
         showRate = item.iRate != null;
         if(showRate)
         {
            rateTF = new TextField();
            rateTF.defaultTextFormat = this.makeTF(12,16763904,true,"right");
            rateTF.selectable = false;
            rateTF.mouseEnabled = false;
            rateTF.x = VIEW_W - RATE_W;
            rateTF.y = 4;
            rateTF.width = RATE_W;
            rateTF.height = 16;
            rDiv = item.bVaryQty == true ? int(item.iQty) : 1;
            eaSfx = rDiv > 1 ? " ea" : "";
            if(item.iRateBoosted != null)
            {
               rateTF.htmlText = "<font color=\'#FFCC00\'>(" + this.formatRate(item.iRate,rDiv) + " </font><font color=\'#66FF00\'>+" + this.formatRate(item.iRateBoosted,rDiv) + ")</font>" + eaSfx;
            }
            else
            {
               rateTF.htmlText = "<font color=\'#FFCC00\'>" + this.formatRate(item.iRate,rDiv) + "</font>" + eaSfx;
            }
            row.addChild(rateTF);
         }
         rarityTF = new TextField();
         rarityTF.defaultTextFormat = this.makeTF(10,10465992,false,"left");
         rarityTF.selectable = false;
         rarityTF.mouseEnabled = false;
         rarityTF.x = nameX;
         rarityTF.y = 16;
         rarityTF.width = colW;
         rarityTF.height = 14;
         rarityTF.text = this.rootClass.getRarityString(int(item.iRty));
         row.addChild(rarityTF);
         if(int(item.iStk) > 1)
         {
            qtyTF = new TextField();
            qtyTF.defaultTextFormat = this.makeTF(showRate ? 10 : 12,14729312,false,"right");
            qtyTF.selectable = false;
            qtyTF.mouseEnabled = false;
            qtyTF.x = VIEW_W - RATE_W;
            qtyTF.y = showRate ? 16 : 4;
            qtyTF.width = RATE_W;
            qtyTF.height = showRate ? 14 : 16;
            qtyTF.text = this.formatQty(item);
            row.addChild(qtyTF);
         }
         rowH = Number(BASE_ROW_H);
         questHtml = this.buildInfoHtml(item);
         if(questHtml != null)
         {
            questTF = new TextField();
            questTF.defaultTextFormat = this.makeTF(10,16777215,false,"left");
            questTF.selectable = false;
            questTF.mouseEnabled = false;
            questTF.multiline = true;
            questTF.wordWrap = true;
            questTF.width = VIEW_W - 16;
            questTF.x = 8;
            questTF.y = BASE_ROW_H;
            questTF.autoSize = TextFieldAutoSize.LEFT;
            questTF.htmlText = questHtml;
            row.addChild(questTF);
            rowH = BASE_ROW_H + questTF.height + 4;
         }
         row.rowH = rowH;
         hi = new Shape();
         row.baseAlpha = index % 2 == 0 ? 0 : 0.04;
         hi.graphics.beginFill(16777215,row.baseAlpha);
         hi.graphics.drawRect(0,0,VIEW_W,rowH);
         hi.graphics.endFill();
         row.addChildAt(hi,0);
         row.hi = hi;
         row.addEventListener(MouseEvent.ROLL_OVER,this.onRowOver,false,0,true);
         row.addEventListener(MouseEvent.ROLL_OUT,this.onRowOut,false,0,true);
         row.addEventListener(MouseEvent.CLICK,this.onRowClick,false,0,true);
         return row;
      }
      
      private function buildInfoHtml(param1:Object) : String
      {
         var _loc2_:Array = [];
         if(param1.bEventDrop == true)
         {
            _loc2_.push("<font color=\'#66FF00\'>Event drop</font>");
         }
         var _loc3_:Array = param1.questGated is Array ? param1.questGated : null;
         if(_loc3_ != null && _loc3_.length > 0)
         {
            _loc2_.push("<font color=\'#FFCC00\'>Requires quest: " + _loc3_.join(", ") + "</font>");
         }
         else if(param1.bQuestGated == true)
         {
            _loc2_.push("<font color=\'#FFCC00\'>Requires a quest to obtain</font>");
         }
         var _loc4_:Array = param1.questObjective is Array ? param1.questObjective : null;
         if(_loc4_ != null && _loc4_.length > 0)
         {
            _loc2_.push("<font color=\'#66CCFF\'>Quest objective: " + _loc4_.join(", ") + "</font>");
         }
         if(_loc2_.length == 0)
         {
            return null;
         }
         return _loc2_.join("<br>");
      }
      
      private function formatRate(param1:*, param2:Number = 1) : String
      {
         var _loc3_:Number = Number(param1);
         if(isNaN(_loc3_))
         {
            return "-";
         }
         _loc3_ /= param2;
         if(_loc3_ > 100)
         {
            _loc3_ = 100;
         }
         if(_loc3_ == int(_loc3_))
         {
            return int(_loc3_) + "%";
         }
         return _loc3_.toFixed(2) + "%";
      }
      
      private function formatQty(param1:Object) : String
      {
         var _loc2_:int = int(param1.iQty);
         if(_loc2_ <= 1)
         {
            return "x 1";
         }
         if(param1.bVaryQty == true)
         {
            return "x 1-" + _loc2_;
         }
         return "x " + _loc2_;
      }
      
      private function setupScroll() : void
      {
         this.content.y = 0;
         this.maxScroll = this.contentHeight - VIEW_H;
         if(this.maxScroll <= 0)
         {
            this.maxScroll = 0;
            this.scrollBar.visible = false;
            return;
         }
         this.scrollBar.visible = true;
         var _loc1_:Number = Math.max(MIN_THUMB,VIEW_H * (VIEW_H / this.contentHeight));
         if(_loc1_ > VIEW_H)
         {
            _loc1_ = Number(VIEW_H);
         }
         this.thumb.height = _loc1_;
         this.thumb.y = 0;
      }
      
      private function updateThumbFromContent() : void
      {
         if(this.maxScroll <= 0)
         {
            return;
         }
         var _loc1_:Number = VIEW_H - this.thumb.height;
         if(_loc1_ <= 0)
         {
            return;
         }
         var _loc2_:Number = -this.content.y / this.maxScroll * _loc1_;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > _loc1_)
         {
            _loc2_ = _loc1_;
         }
         this.thumb.y = _loc2_;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,false,0,true);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
         }
      }
      
      private function onWheel(param1:MouseEvent) : void
      {
         if(this.maxScroll <= 0)
         {
            return;
         }
         if(!this.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            return;
         }
         this.content.y += param1.delta * WHEEL_STEP / 3;
         if(this.content.y > 0)
         {
            this.content.y = 0;
         }
         if(this.content.y < -this.maxScroll)
         {
            this.content.y = -this.maxScroll;
         }
         this.updateThumbFromContent();
      }
      
      private function onThumbDown(param1:MouseEvent) : void
      {
         if(this.maxScroll <= 0)
         {
            return;
         }
         this.dragging = true;
         this.dragStartMouseY = stage.mouseY;
         this.dragStartThumbY = this.thumb.y;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onStageMove,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageUp,false,0,true);
      }
      
      private function onTrackDown(param1:MouseEvent) : void
      {
         if(this.maxScroll <= 0)
         {
            return;
         }
         var _loc2_:Number = VIEW_H - this.thumb.height;
         if(_loc2_ <= 0)
         {
            return;
         }
         var _loc3_:Number = this.track.mouseY - this.thumb.height / 2;
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         if(_loc3_ > _loc2_)
         {
            _loc3_ = _loc2_;
         }
         this.thumb.y = _loc3_;
         this.content.y = -(_loc3_ / _loc2_) * this.maxScroll;
         this.dragging = true;
         this.dragStartMouseY = stage.mouseY;
         this.dragStartThumbY = this.thumb.y;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onStageMove,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageUp,false,0,true);
      }
      
      private function onStageMove(param1:MouseEvent) : void
      {
         if(!this.dragging)
         {
            return;
         }
         var _loc2_:Number = VIEW_H - this.thumb.height;
         if(_loc2_ <= 0)
         {
            return;
         }
         var _loc3_:Number = this.dragStartThumbY + (stage.mouseY - this.dragStartMouseY);
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         if(_loc3_ > _loc2_)
         {
            _loc3_ = _loc2_;
         }
         this.thumb.y = _loc3_;
         this.content.y = -(_loc3_ / _loc2_) * this.maxScroll;
         param1.updateAfterEvent();
      }
      
      private function onStageUp(param1:MouseEvent) : void
      {
         this.dragging = false;
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStageMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageUp);
         }
      }
      
      private function paintRow(param1:DropRow, param2:Number) : void
      {
         param1.hi.graphics.clear();
         param1.hi.graphics.beginFill(16777215,param2);
         param1.hi.graphics.drawRect(0,0,VIEW_W,param1.rowH);
         param1.hi.graphics.endFill();
      }
      
      private function onRowOver(param1:MouseEvent) : void
      {
         var _loc2_:DropRow = param1.currentTarget as DropRow;
         if(_loc2_ == null)
         {
            return;
         }
         this.paintRow(_loc2_,0.14);
         var _loc3_:* = this.rootClass.world.invTree[_loc2_.itemData.ItemID];
         if(_loc3_ == null)
         {
            _loc3_ = _loc2_.itemData;
         }
         var _loc4_:String = this.rootClass.getItemInfoStringB(_loc3_);
         _loc4_ = _loc4_.replace("<font size=\'12\'><b>","<font size=\'12\' color=\'#FFFFFF\'><b>");
         this.rootClass.ui.ToolTip.openWith({
            "str":_loc4_,
            "invert":true
         });
      }
      
      private function onRowOut(param1:MouseEvent) : void
      {
         var _loc2_:DropRow = param1.currentTarget as DropRow;
         if(_loc2_ == null)
         {
            return;
         }
         this.paintRow(_loc2_,_loc2_ == this.selectedRow ? 0.2 : _loc2_.baseAlpha);
         this.rootClass.ui.ToolTip.close();
      }
      
      private function onRowClick(param1:MouseEvent) : void
      {
         var _loc2_:DropRow = param1.currentTarget as DropRow;
         if(_loc2_ == null)
         {
            return;
         }
         this.rootClass.mixer.playSound("Click");
         if(this.selectedRow != null && this.selectedRow != _loc2_)
         {
            this.paintRow(this.selectedRow,this.selectedRow.baseAlpha);
         }
         this.selectedRow = _loc2_;
         this.paintRow(_loc2_,0.2);
         this.openPreview(_loc2_.itemData);
      }
      
      private function isOwned(param1:*, param2:*) : Boolean
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in !!param1 ? this.rootClass.world.myAvatar.houseitems : this.rootClass.world.myAvatar.items)
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
      
      private function openPreview(param1:Object) : void
      {
         this.previewItem = param1;
         if(!this.expanded)
         {
            this.expanded = true;
            this.x -= PREVIEW_W / 2;
            this.drawFrame(EXPANDED_W);
            this.buildPreviewPane();
         }
         var _loc2_:* = false;
         if(String(param1.sType).toLowerCase() != "enhancement")
         {
            switch(param1.sES)
            {
               case "Weapon":
               case "he":
               case "ba":
               case "pe":
               case "ar":
               case "co":
               case "mi":
                  _loc2_ = !(param1.bUpg == 1 && !this.rootClass.world.myAvatar.isUpgraded());
                  break;
               default:
                  _loc2_ = false;
            }
         }
         this.layoutPreviewButtons(_loc2_);
         this.previewHeaderTF.text = param1.sName != null ? param1.sName : "?";
         this.loadPreview(param1);
      }
      
      private function buildPreviewPane() : void
      {
         this.previewHeaderTF = new TextField();
         this.previewHeaderTF.defaultTextFormat = this.makeTF(13,16777215,true,"left");
         this.previewHeaderTF.selectable = false;
         this.previewHeaderTF.mouseEnabled = false;
         this.previewHeaderTF.x = PANEL_W + 12;
         this.previewHeaderTF.y = 6;
         this.previewHeaderTF.width = PREVIEW_W - 40;
         this.previewHeaderTF.height = 18;
         addChild(this.previewHeaderTF);
         this.prevCloseBtn = new Sprite();
         this.prevCloseBtn.graphics.beginFill(0,0.5);
         this.prevCloseBtn.graphics.drawRect(0,0,18,18);
         this.prevCloseBtn.graphics.endFill();
         this.prevCloseTF = new TextField();
         this.prevCloseTF.defaultTextFormat = this.makeTF(14,16777215,true,"center");
         this.prevCloseTF.selectable = false;
         this.prevCloseTF.mouseEnabled = false;
         this.prevCloseTF.width = 18;
         this.prevCloseTF.height = 20;
         this.prevCloseTF.y = -1;
         this.prevCloseTF.text = "X";
         this.prevCloseBtn.addChild(this.prevCloseTF);
         this.prevCloseBtn.x = EXPANDED_W - 24;
         this.prevCloseBtn.y = 5;
         this.prevCloseBtn.buttonMode = true;
         this.prevCloseBtn.mouseChildren = false;
         addChild(this.prevCloseBtn);
         this.prevCloseBtn.addEventListener(MouseEvent.CLICK,this.onPrevCloseClick,false,0,true);
         this.prevCloseBtn.addEventListener(MouseEvent.ROLL_OVER,this.onPrevCloseOver,false,0,true);
         this.prevCloseBtn.addEventListener(MouseEvent.ROLL_OUT,this.onPrevCloseOut,false,0,true);
         this.previewHost = new MovieClip();
         this.previewHost.x = PV_X;
         this.previewHost.y = PV_Y;
         addChild(this.previewHost);
         this.previewMask = new Shape();
         this.previewMask.graphics.beginFill(16777215,1);
         this.previewMask.graphics.drawRect(0,0,PV_W,PV_H);
         this.previewMask.graphics.endFill();
         this.previewMask.x = PV_X;
         this.previewMask.y = PV_Y;
         addChild(this.previewMask);
         this.previewHost.mask = this.previewMask;
         this.tryBtn = new Sprite();
         this.tryBtn.buttonMode = true;
         this.tryBtn.mouseChildren = false;
         this.tryTF = new TextField();
         this.tryTF.defaultTextFormat = this.makeTF(12,16777215,true,"center");
         this.tryTF.selectable = false;
         this.tryTF.mouseEnabled = false;
         this.tryTF.y = 4;
         this.tryTF.height = 18;
         this.tryTF.text = "Try Me";
         this.tryBtn.addChild(this.tryTF);
         addChild(this.tryBtn);
         this.tryBtn.addEventListener(MouseEvent.CLICK,this.onTryClick,false,0,true);
         this.tryBtn.addEventListener(MouseEvent.ROLL_OVER,this.onTryOver,false,0,true);
         this.tryBtn.addEventListener(MouseEvent.ROLL_OUT,this.onTryOut,false,0,true);
         this.wikiBtn = new Sprite();
         this.wikiBtn.buttonMode = true;
         this.wikiBtn.mouseChildren = false;
         this.wikiTF = new TextField();
         this.wikiTF.defaultTextFormat = this.makeTF(12,16777215,true,"center");
         this.wikiTF.selectable = false;
         this.wikiTF.mouseEnabled = false;
         this.wikiTF.y = 4;
         this.wikiTF.height = 18;
         this.wikiTF.text = "Wiki";
         this.wikiBtn.addChild(this.wikiTF);
         addChild(this.wikiBtn);
         this.wikiBtn.addEventListener(MouseEvent.CLICK,this.onWikiClick,false,0,true);
         this.wikiBtn.addEventListener(MouseEvent.ROLL_OVER,this.onWikiOver,false,0,true);
         this.wikiBtn.addEventListener(MouseEvent.ROLL_OUT,this.onWikiOut,false,0,true);
         this.assetLoader = new PreviewAssetLoader(this.previewHost,this.rootClass,false);
      }
      
      private function drawBtnBg(param1:Sprite, param2:Number, param3:Boolean) : void
      {
         param1.graphics.clear();
         param1.graphics.lineStyle(1,5592405,1);
         param1.graphics.beginFill(param3 ? 3026478 : 1710618,1);
         param1.graphics.drawRect(0,0,param2,BTN_H);
         param1.graphics.endFill();
      }
      
      private function layoutPreviewButtons(param1:Boolean) : void
      {
         this.tryBtn.visible = param1;
         if(param1)
         {
            this.tryW = (PV_W - 8) / 2;
            this.wikiW = this.tryW;
            this.drawBtnBg(this.tryBtn,this.tryW,false);
            this.tryBtn.x = PV_X;
            this.tryBtn.y = BTN_Y;
            this.tryTF.width = this.tryW;
            this.drawBtnBg(this.wikiBtn,this.wikiW,false);
            this.wikiBtn.x = PV_X + this.tryW + 8;
            this.wikiBtn.y = BTN_Y;
            this.wikiTF.width = this.wikiW;
         }
         else
         {
            this.wikiW = PV_W;
            this.drawBtnBg(this.wikiBtn,this.wikiW,false);
            this.wikiBtn.x = PV_X;
            this.wikiBtn.y = BTN_Y;
            this.wikiTF.width = this.wikiW;
         }
      }
      
      private function clearPreview() : void
      {
         if(this.assetLoader != null)
         {
            this.assetLoader.clearPreview();
         }
      }
      
      private function loadPreview(param1:Object) : void
      {
         if(this.assetLoader == null)
         {
            return;
         }
         if(String(param1.sType).toLowerCase() != "enhancement")
         {
            switch(param1.sES)
            {
               case "Weapon":
                  this.loadWeapon(param1.sFile,param1.sLink);
                  break;
               case "he":
                  this.loadHelm(param1.sFile,param1.sLink);
                  break;
               case "ba":
                  this.loadCape(param1.sFile,param1.sLink);
                  break;
               case "pe":
                  this.loadPet(param1.sFile,param1.sLink);
                  break;
               case "ar":
               case "co":
                  this.loadArmor(param1.sFile,param1.sLink);
                  break;
               case "ho":
                  this.loadHouse(param1.sFile);
                  break;
               case "hi":
                  this.loadHouseItem(param1.sFile,param1.sLink);
                  break;
               case "mi":
                  this.loadMisc(param1.sFile,param1.sLink);
                  break;
               default:
                  if(String(param1.sType).toLowerCase() == "item" && String(param1.sLink).toLowerCase() != "none")
                  {
                     this.loadBag(param1);
                  }
                  else if(param1.sES == "am")
                  {
                     this.loadBag(param1,true);
                  }
                  else if(String(param1.sType).toLowerCase() == "serveruse" || String(param1.sType).toLowerCase() == "clientuse")
                  {
                     this.loadBag(param1);
                  }
                  else
                  {
                     this.loadBag(param1,true);
                  }
            }
         }
         else
         {
            this.loadEnhancement(param1);
         }
      }
      
      private function loadEnhancement(param1:Object) : void
      {
         var _loc2_:Class = null;
         var _loc3_:MovieClip = null;
         this.clearPreview();
         try
         {
            _loc2_ = this.rootClass.world.getClass("iidesign") as Class;
            _loc3_ = new _loc2_();
            _loc3_.scaleX = _loc3_.scaleY = 3;
            this.previewHost.addChild(_loc3_);
            this.addGlow(_loc3_);
         }
         catch(err:Error)
         {
         }
      }
      
      private function loadBag(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:MovieClip = null;
         this.clearPreview();
         var _loc4_:Class = this.rootClass.world.getClass("iibag") as Class;
         if(param2 || (param1 == null || !("sFile" in param1) || String(param1.sFile).length < 1 || this.rootClass.world.getClass(param1.sFile) == null))
         {
            _loc4_ = this.rootClass.world.getClass(param1.sIcon) as Class;
         }
         else if(param1 != null && "sFile" in param1 && String(param1.sFile).length > 0 && this.rootClass.world.getClass(param1.sFile) != null)
         {
            _loc4_ = this.rootClass.world.getClass(param1.sFile) as Class;
         }
         try
         {
            _loc3_ = new _loc4_();
            _loc3_.scaleX = _loc3_.scaleY = 3;
            this.previewHost.addChild(_loc3_);
            this.addGlow(_loc3_);
         }
         catch(e:Error)
         {
         }
      }
      
      private function loadWeapon(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkWeapon = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"weapon",this.onLoadWeaponComplete,this.onLoadError);
      }
      
      private function loadCape(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkCape = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"cape",this.onLoadCapeComplete,this.onLoadError);
      }
      
      private function loadHelm(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkHelm = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"helm",this.onLoadHelmComplete,this.onLoadError);
      }
      
      private function loadPet(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkPet = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"pet",this.onLoadPetComplete,this.onLoadError);
      }
      
      private function loadMisc(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkMisc = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"misc",this.onLoadMiscComplete,this.onLoadError);
      }
      
      private function loadArmor(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkArmor = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + "classes/" + this.rootClass.world.myAvatar.objData.strGender + "/" + param1,param2,"armor",this.onLoadArmorComplete,this.onLoadError);
      }
      
      private function onLoadArmorComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc4_:* = this.previewHost.addChild(new AvatarMC());
         _loc4_.visible = false;
         _loc4_.strGender = this.rootClass.world.myAvatar.objData.strGender;
         var _loc5_:* = new Avatar(this.rootClass);
         _loc5_.isCharPage = true;
         _loc5_.objData = this.rootClass.copyObj(this.rootClass.world.myAvatar.objData);
         _loc4_.pAV = _loc5_;
         _loc4_.pAV.pMC = _loc4_;
         _loc4_.world = MovieClip(Game.root).world;
         _loc4_.hideHPBar();
         _loc4_.name = "previewMC";
         _loc4_.x = PV_W / 2;
         _loc4_.y = PV_H - 28;
         _loc4_.scaleX = _loc4_.scaleY = 1.65;
         this.addGlow(_loc4_.mcChar,false);
         _loc4_.loadArmorPiecesFromDomain(this.sLinkArmor,this.assetLoader.applicationDomain);
         _loc4_.visible = true;
      }
      
      private function loadHouse(param1:String) : void
      {
         this.clearPreview();
         var _loc2_:String = param1.substring(0,param1.length - 4);
         this.assetLoader.loadAsset(Game.serverFilePath + "maps/" + _loc2_ + "_preview.swf",param1,"house",this.onLoadHouseComplete,this.onLoadError);
      }
      
      private function loadHouseItem(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"houseitem",this.onLoadHouseItemComplete,this.onLoadError);
      }
      
      private function onLoadWeaponComplete(param1:Event, param2:String, param3:String) : void
      {
         var mc:MovieClip = null;
         var AssetClass:Class = null;
         var e:Event = param1;
         var linkage:String = param2;
         var type:String = param3;
         try
         {
            AssetClass = this.assetLoader.getDefinition(this.sLinkWeapon);
            mc = new AssetClass();
         }
         catch(err:Error)
         {
            mc = e.target.content;
         }
         if(mc == null)
         {
            return;
         }
         mc.scaleX = mc.scaleY = 0.3;
         this.previewHost.addChild(mc);
         this.addGlow(mc);
      }
      
      private function onLoadCapeComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc4_:Class = null;
         var _loc5_:MovieClip = null;
         try
         {
            _loc4_ = this.assetLoader.getDefinition(this.sLinkCape);
            _loc5_ = new _loc4_();
            _loc5_.scaleX = _loc5_.scaleY = 0.5;
            this.previewHost.addChild(_loc5_);
            this.addGlow(_loc5_);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onLoadHelmComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc4_:Class = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Class = null;
         var _loc7_:MovieClip = null;
         try
         {
            _loc4_ = this.assetLoader.getDefinition(this.sLinkHelm);
            _loc5_ = new _loc4_();
            _loc5_.scaleX = _loc5_.scaleY = 0.8;
            this.previewHost.addChild(_loc5_);
            try
            {
               _loc6_ = this.assetLoader.getDefinition(this.sLinkHelm + "_backhair");
               if(_loc6_ != null)
               {
                  _loc7_ = new _loc6_();
                  _loc7_.x = _loc5_.getChildAt(0).x + 1;
                  _loc7_.y = _loc5_.getChildAt(0).y - 28;
                  _loc7_.scaleX = _loc7_.scaleY = 3.2;
                  _loc5_.addChild(_loc7_);
                  _loc5_.setChildIndex(_loc7_,0);
               }
            }
            catch(e0:Error)
            {
            }
            this.addGlow(_loc5_);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onLoadPetComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc5_:MovieClip = null;
         var _loc4_:Class = this.assetLoader.getDefinition(this.sLinkPet);
         if(_loc4_ != null)
         {
            _loc5_ = new _loc4_();
            _loc5_.scaleX = _loc5_.scaleY = 2;
            this.previewHost.addChild(_loc5_);
            this.addGlow(_loc5_);
         }
      }
      
      private function onLoadMiscComplete(param1:Event, param2:String, param3:String) : void
      {
         var mc:MovieClip = null;
         var AssetClass:Class = null;
         var e:Event = param1;
         var linkage:String = param2;
         var type:String = param3;
         try
         {
            AssetClass = this.assetLoader.getDefinition(this.sLinkMisc);
            mc = new AssetClass();
         }
         catch(err:Error)
         {
            mc = e.target.content;
         }
         if(mc == null)
         {
            return;
         }
         this.previewHost.addChild(mc);
         this.addGlow(mc);
      }
      
      private function onLoadHouseComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc9_:MovieClip = null;
         var _loc4_:String = param2;
         var _loc5_:String = _loc4_.substring(0,_loc4_.length - 4);
         var _loc6_:int = _loc4_.lastIndexOf("/") + 1;
         var _loc7_:* = _loc5_.substr(_loc6_).split("-").join("_") + "_preview";
         var _loc8_:Class = this.assetLoader.getDefinition(_loc7_);
         if(_loc8_ != null)
         {
            _loc9_ = new _loc8_();
            this.previewHost.addChild(_loc9_);
            this.addGlow(_loc9_);
         }
      }
      
      private function onLoadHouseItemComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc5_:MovieClip = null;
         var _loc4_:Class = this.assetLoader.getDefinition(param2);
         if(_loc4_ != null)
         {
            _loc5_ = new _loc4_();
            this.previewHost.addChild(_loc5_);
            this.addGlow(_loc5_);
         }
      }
      
      private function onLoadError(param1:String) : void
      {
      }
      
      private function addGlow(param1:MovieClip, param2:Boolean = true) : void
      {
         param1.filters = [WHITE_GLOW];
         param1.mouseEnabled = param1.mouseChildren = false;
         if(param2)
         {
            this.repositionPreview(param1);
         }
      }
      
      private function repositionPreview(param1:MovieClip) : void
      {
         var _loc2_:Rectangle = param1.getBounds(this.previewHost);
         var _loc3_:Number = 1;
         if(_loc2_.height > PV_H)
         {
            _loc3_ = Math.min(_loc3_,PV_H / _loc2_.height);
         }
         if(_loc2_.width > PV_W)
         {
            _loc3_ = Math.min(_loc3_,PV_W / _loc2_.width);
         }
         if(_loc3_ < 1)
         {
            param1.scaleX *= _loc3_;
            param1.scaleY *= _loc3_;
            _loc2_ = param1.getBounds(this.previewHost);
         }
         param1.x -= _loc2_.x + _loc2_.width / 2 - PV_W / 2;
         param1.y -= _loc2_.y + _loc2_.height / 2 - PV_H / 2;
      }
      
      private function onTryClick(param1:MouseEvent) : void
      {
         if(this.previewItem == null)
         {
            return;
         }
         this.rootClass.mixer.playSound("Click");
         this.rootClass.xTryMe(this.previewItem);
      }
      
      private function onWikiClick(param1:MouseEvent) : void
      {
         if(this.previewItem == null)
         {
            return;
         }
         navigateToURL(new URLRequest("http://aqwwiki.wikidot.com/" + this.previewItem.sName),"_blank");
      }
      
      private function onTryOver(param1:MouseEvent) : void
      {
         this.drawBtnBg(this.tryBtn,this.tryW,true);
         this.rootClass.ui.ToolTip.openWith({"str":"Try Me!"});
      }
      
      private function onTryOut(param1:MouseEvent) : void
      {
         this.drawBtnBg(this.tryBtn,this.tryW,false);
         this.rootClass.ui.ToolTip.close();
      }
      
      private function onWikiOver(param1:MouseEvent) : void
      {
         this.drawBtnBg(this.wikiBtn,this.wikiW,true);
         this.rootClass.ui.ToolTip.openWith({"str":"Search on Wiki"});
      }
      
      private function onWikiOut(param1:MouseEvent) : void
      {
         this.drawBtnBg(this.wikiBtn,this.wikiW,false);
         this.rootClass.ui.ToolTip.close();
      }
      
      private function onPrevCloseClick(param1:MouseEvent) : void
      {
         this.collapsePreview();
      }
      
      private function onPrevCloseOver(param1:MouseEvent) : void
      {
         this.prevCloseTF.textColor = 16733525;
      }
      
      private function onPrevCloseOut(param1:MouseEvent) : void
      {
         this.prevCloseTF.textColor = 16777215;
      }
      
      private function teardownPreview() : void
      {
         if(this.assetLoader != null)
         {
            this.assetLoader.dispose();
            this.assetLoader = null;
         }
         if(this.prevCloseBtn != null)
         {
            this.prevCloseBtn.removeEventListener(MouseEvent.CLICK,this.onPrevCloseClick);
            this.prevCloseBtn.removeEventListener(MouseEvent.ROLL_OVER,this.onPrevCloseOver);
            this.prevCloseBtn.removeEventListener(MouseEvent.ROLL_OUT,this.onPrevCloseOut);
         }
         if(this.tryBtn != null)
         {
            this.tryBtn.removeEventListener(MouseEvent.CLICK,this.onTryClick);
            this.tryBtn.removeEventListener(MouseEvent.ROLL_OVER,this.onTryOver);
            this.tryBtn.removeEventListener(MouseEvent.ROLL_OUT,this.onTryOut);
         }
         if(this.wikiBtn != null)
         {
            this.wikiBtn.removeEventListener(MouseEvent.CLICK,this.onWikiClick);
            this.wikiBtn.removeEventListener(MouseEvent.ROLL_OVER,this.onWikiOver);
            this.wikiBtn.removeEventListener(MouseEvent.ROLL_OUT,this.onWikiOut);
         }
         this.removeIf(this.previewHeaderTF);
         this.removeIf(this.prevCloseBtn);
         this.removeIf(this.previewHost);
         this.removeIf(this.previewMask);
         this.removeIf(this.tryBtn);
         this.removeIf(this.wikiBtn);
         this.previewHeaderTF = null;
         this.prevCloseBtn = null;
         this.previewHost = null;
         this.previewMask = null;
         this.tryBtn = null;
         this.wikiBtn = null;
         this.previewItem = null;
      }
      
      private function removeIf(param1:DisplayObject) : void
      {
         if(param1 != null && param1.parent == this)
         {
            removeChild(param1);
         }
      }
      
      private function collapsePreview() : void
      {
         if(!this.expanded)
         {
            return;
         }
         this.teardownPreview();
         this.expanded = false;
         this.x += PREVIEW_W / 2;
         this.drawFrame(PANEL_W);
         if(this.selectedRow != null)
         {
            this.paintRow(this.selectedRow,this.selectedRow.baseAlpha);
            this.selectedRow = null;
         }
      }
      
      private function onCloseClick(param1:MouseEvent) : void
      {
         this.fClose();
      }
      
      private function onCloseOver(param1:MouseEvent) : void
      {
         this.closeTF.textColor = 16733525;
      }
      
      private function onCloseOut(param1:MouseEvent) : void
      {
         this.closeTF.textColor = 16777215;
      }
      
      public function fClose() : void
      {
         if(this.expanded)
         {
            this.teardownPreview();
         }
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
         }
         if(this.thumb != null)
         {
            this.thumb.removeEventListener(MouseEvent.MOUSE_DOWN,this.onThumbDown);
         }
         if(this.track != null)
         {
            this.track.removeEventListener(MouseEvent.MOUSE_DOWN,this.onTrackDown);
         }
         if(this.closeBtn != null)
         {
            this.closeBtn.removeEventListener(MouseEvent.CLICK,this.onCloseClick);
            this.closeBtn.removeEventListener(MouseEvent.ROLL_OVER,this.onCloseOver);
            this.closeBtn.removeEventListener(MouseEvent.ROLL_OUT,this.onCloseOut);
         }
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStageMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageUp);
         }
         if(this.rootClass != null && this.rootClass.ui != null && this.rootClass.ui.ToolTip != null)
         {
            this.rootClass.ui.ToolTip.close();
         }
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

import flash.display.Shape;
import flash.display.Sprite;

class DropRow extends Sprite
{
   public var itemData:Object;
   
   public var hi:Shape;
   
   public var baseAlpha:Number = 0;
   
   public var rowH:Number = 30;
   
   public function DropRow()
   {
      super();
   }
}
