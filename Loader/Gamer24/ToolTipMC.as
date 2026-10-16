package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class ToolTipMC extends MovieClip
   {
      public var cnt:MovieClip;
      
      internal var world:MovieClip;
      
      internal var isOpen:Boolean = false;
      
      internal var mc:MovieClip;
      
      internal var rootClass:MovieClip;
      
      internal var data:Object;
      
      internal var tWidth:int;
      
      private var neutralCT:ColorTransform;
      
      private var blackCT:ColorTransform;
      
      public var tOpen:Timer;
      
      public var tClose:Timer;
      
      public function ToolTipMC(param1:MovieClip = null)
      {
         this.neutralCT = new ColorTransform();
         this.blackCT = new ColorTransform(0,0,0);
         this.tOpen = new Timer(200,1);
         this.tClose = new Timer(10000,1);
         super();
         this.mc = MovieClip(this);
         this.rootClass = !!param1 ? param1 : MovieClip(stage.getChildAt(0));
         this.world = this.rootClass.world;
         this.mc.cnt.visible = false;
         this.mc.cnt.ti.autoSize = "left";
         this.tWidth = this.mc.cnt.ti.width;
         this.mc.mouseEnabled = false;
         this.mc.mouseChildren = false;
         this.tOpen.addEventListener(TimerEvent.TIMER_COMPLETE,this.open,false,0,true);
         this.tClose.addEventListener(TimerEvent.TIMER_COMPLETE,this.close,false,0,true);
         addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut,false,0,true);
         this.mc.cnt.ti.addEventListener(TextEvent.LINK,this.onTextLink,false,0,true);
      }
      
      public function openWith(param1:*) : *
      {
         this.data = param1;
         this.tOpen.reset();
         this.tOpen.start();
         if("closein" in this.data)
         {
            this.tClose.reset();
            this.tClose.delay = int(this.data.closein);
            this.tClose.start();
         }
      }
      
      public function open(param1:TimerEvent) : *
      {
         this.isOpen = true;
         this.mc.cnt.visible = true;
         this.mc.cnt.ti.width = this.tWidth;
         this.mc.cnt.ti.htmlText = this.data.str;
         this.mc.cnt.ti.width = int(this.mc.cnt.ti.textWidth) + 6;
         this.mc.cnt.bg.width = int(this.mc.cnt.ti.width) + 10;
         this.mc.cnt.bg.height = int(this.mc.cnt.ti.height) + 8;
         if("invert" in this.data && Boolean(this.data.invert))
         {
            this.mc.cnt.bg.transform.colorTransform = this.blackCT;
         }
         else
         {
            this.mc.cnt.bg.transform.colorTransform = this.neutralCT;
         }
         if("lowerright" in this.data)
         {
            this.mc.x = 960 - this.mc.cnt.bg.width - 4;
            this.mc.y = 480 - this.mc.cnt.bg.height - 4;
         }
         else if("fromlocal" in this.data && Boolean(this.data.fromlocal))
         {
            this.mc.x = this.data.fromlocal.x - this.mc.width / 2;
            this.mc.y = this.data.fromlocal.y - this.mc.height - 15;
         }
         else
         {
            this.mc.x = this.rootClass.mouseX - this.mc.width / 2 - this.rootClass.ui.x;
            this.mc.y = this.rootClass.mouseY - this.mc.height - 15;
            if(this.mc.x + this.mc.cnt.bg.width > 960)
            {
               this.mc.x = 960 - this.mc.cnt.bg.width - 10;
            }
            if(this.mc.x < 1)
            {
               this.mc.x = 1;
            }
            if(this.mc.y < 1)
            {
               this.mc.y = this.rootClass.mouseY + 10;
            }
         }
         if(this.data.str.indexOf("href") > -1)
         {
            this.mc.mouseEnabled = false;
            this.mc.mouseChildren = true;
         }
         else
         {
            this.mc.mouseEnabled = false;
            this.mc.mouseChildren = false;
         }
         if("frommap" in this.data && Boolean(this.data.frommap))
         {
            this.mc.x = this.data.x;
            this.mc.y = this.data.y;
         }
         else
         {
            this.mc.x = int(this.mc.x);
            this.mc.y = int(this.mc.y);
         }
         this.mc.gotoAndPlay("in");
      }
      
      private function onTextLink(param1:TextEvent) : void
      {
         var _loc2_:String = String(param1.text.split("::")[0]).toLowerCase();
         if(_loc2_ == "link")
         {
            navigateToURL(new URLRequest(param1.text.split("::")[1]),"_blank");
         }
      }
      
      public function close(param1:Event = null) : *
      {
         this.isOpen = false;
         this.tOpen.reset();
         this.tClose.reset();
         this.mc.gotoAndPlay("out");
      }
      
      public function hide() : *
      {
         this.mc.cnt.visible = false;
         this.mc.x = 1050;
         this.mc.y = 0;
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         if(this.tOpen.running)
         {
            this.tOpen.stop();
         }
         if(this.tClose.running)
         {
            this.tClose.stop();
         }
         this.close();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.tClose.reset();
      }
      
      public function destroy() : void
      {
         this.tOpen.stop();
         this.tOpen.removeEventListener(TimerEvent.TIMER_COMPLETE,this.open);
         this.tClose.stop();
         this.tClose.removeEventListener(TimerEvent.TIMER_COMPLETE,this.close);
         removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.mc.cnt.ti.removeEventListener(TextEvent.LINK,this.onTextLink);
         this.tOpen = null;
         this.tClose = null;
      }
   }
}

