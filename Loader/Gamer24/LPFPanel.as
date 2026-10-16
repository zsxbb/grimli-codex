package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import liteAssets.draw.*;
   
   public class LPFPanel extends MovieClip
   {
      public var frames:Array;
      
      public var w:int;
      
      public var h:int;
      
      public var xo:int;
      
      public var yo:int;
      
      public var xBuffer:int;
      
      public var yBuffer:int;
      
      public var frameID:int = 0;
      
      public var fParent:LPFLayout;
      
      public var bg:MovieClip;
      
      public var isOpen:Boolean = false;
      
      protected var fData:Object;
      
      protected var sMode:String;
      
      protected var closeType:String;
      
      protected var hideDir:String = "";
      
      protected var hidePad:int = 0;
      
      public var mcSearch:*;
      
      public function LPFPanel()
      {
         super();
      }
      
      public function notify(param1:Object) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.frames.length)
         {
            this.frames[_loc2_].mc.notify(param1);
            _loc2_++;
         }
      }
      
      public function addFrame(param1:Object) : void
      {
         var _loc2_:LPFFrame = addChild(param1.frame) as LPFFrame;
         _loc2_.subscribeTo(this);
         this.frames.push({
            "mc":_loc2_,
            "id":this.frameID++
         });
         _loc2_.fOpen(param1);
      }
      
      public function delFrame(param1:LPFFrame) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.frames.length)
         {
            if(this.frames[_loc2_].mc == param1)
            {
               this.frames[_loc2_].fClose();
               this.frames.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function subscribeTo(param1:LPFLayout) : void
      {
         this.fParent = param1;
      }
      
      public function fOpen(param1:Object) : void
      {
         var _loc3_:int = 0;
         this.fData = param1.fData;
         var _loc2_:Object = param1.r;
         x = _loc2_.x;
         if(_loc2_.y > -1)
         {
            y = _loc2_.y;
         }
         else
         {
            _loc3_ = this.fParent.numChildren;
            if(_loc3_ > 1)
            {
               y = this.fParent.getChildAt(_loc3_ - 2).y + this.fParent.getChildAt(_loc3_ - 2).height + 10;
            }
            else
            {
               y = 10;
            }
         }
         this.w = _loc2_.w;
         this.h = _loc2_.h;
         this.xo = x;
         this.yo = y;
      }
      
      public function fClose() : void
      {
         if(this.bg != null && this.bg.btnClose != null)
         {
            this.bg.btnClose.removeEventListener(MouseEvent.CLICK,this.onCloseClick);
         }
         while(this.frames.length > 0)
         {
            this.frames[0].mc.fClose();
            this.frames.shift();
         }
         if(this.mcSearch)
         {
            this.mcSearch.reset();
         }
         this.mcSearch = null;
         MovieClip(this.fParent).delPanel(this);
      }
      
      public function fHide() : void
      {
         this.isOpen = false;
         visible = false;
         switch(this.hideDir.toLowerCase())
         {
            case "left":
               x = this.xo - this.w - this.hidePad;
               break;
            case "right":
               x = this.xo + this.w + this.hidePad;
               break;
            case "top":
               y = this.yo - this.h - this.hidePad;
               break;
            case "bottom":
               y = this.yo + this.h + this.hidePad;
               break;
            case "":
         }
      }
      
      public function fShow(param1:int = -1) : void
      {
         this.isOpen = true;
         visible = true;
         if(param1 > -1)
         {
            x = param1;
         }
         else
         {
            x = this.xo;
         }
      }
      
      protected function drawBG(param1:* = null) : void
      {
         var _loc2_:* = undefined;
         if(param1 == null)
         {
            this.bg = addChildAt(new LPFPanelBg(),0) as MovieClip;
            this.bg.frame.width = this.w;
            this.bg.frame.height = this.h;
            this.bg.bg.width = this.w - 6 * 2;
            this.bg.bg.height = this.h - 5 * 2;
            this.bg.btnClose.x = this.w - 31;
            this.bg.dragonRight.x = this.bg.frame.width + 21;
            this.bg.tTitle.x = int(this.w / 2 - this.bg.tTitle.width / 2);
         }
         else
         {
            this.bg = addChildAt(new param1(),0) as MovieClip;
         }
         if("sName" in this.fData)
         {
            this.bg.tTitle.text = this.fData.sName;
            this.bg.tTitle.textColor = 16777215;
            _loc2_ = MovieClip(stage.getChildAt(0)).world.shopinfo;
            if(_loc2_)
            {
               this.bg.tTitle.textColor = Number(_loc2_.bUpgrd) == 1 ? 16566089 : 16777215;
               if(Number(_loc2_.bStaff) == 1)
               {
                  this.bg.tTitle.textColor = 16776960;
               }
            }
         }
         if(MovieClip(stage.getChildAt(0)).ui.mcPopup.currentLabel.indexOf("Bank") > -1 || this.fData.sName.toLowerCase() == "inventory" || this.fData.sName.toLowerCase() == "house inventory")
         {
            if(!this.bg.getChildByName("mcInvSearch"))
            {
               this.mcSearch = this.bg.addChild(new invSearch(MovieClip(stage.getChildAt(0))));
               this.mcSearch.name = "mcInvSearch";
               if(MovieClip(stage.getChildAt(0)).ui.mcPopup.currentLabel.indexOf("Bank") == -1)
               {
                  this.mcSearch.x = 156;
                  this.mcSearch.y = 26;
               }
               else
               {
                  this.mcSearch.x = 737;
                  this.mcSearch.y = 24;
               }
               this.bg.tTitle.visible = false;
            }
         }
      }
      
      protected function onCloseClick(param1:MouseEvent = null) : void
      {
         switch(this.closeType)
         {
            case "hide":
               this.fHide();
               break;
            case "close":
            default:
               this.mcSearch = null;
               this.bg.btnClose.removeEventListener(MouseEvent.CLICK,this.onCloseClick);
               this.fParent.fClose();
         }
      }
   }
}

