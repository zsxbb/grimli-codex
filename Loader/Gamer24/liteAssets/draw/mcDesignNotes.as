package liteAssets.draw
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   
   public class mcDesignNotes extends MovieClip
   {
      public var btnClose:MovieClip;
      
      public var btnLeft:SimpleButton;
      
      public var btnRight:SimpleButton;
      
      public var scrollBottom:MovieClip;
      
      public var scrollTop:MovieClip;
      
      public var txtContent:TextField;
      
      public var r:MovieClip;
      
      internal var loader:*;
      
      internal var dnLoader:URLLoader;
      
      private var posts:Array;
      
      private var pos:Number = 0;
      
      private var bLoaded:Number = 0;
      
      private var bTotal:Number = 0;
      
      public function mcDesignNotes(param1:MovieClip)
      {
         this.dnLoader = new URLLoader();
         super();
         this.r = param1;
         this.r.world.visible = false;
         this.loader = new (this.r.world.getClass("mcLoader") as Class)();
         this.loader.x = 400;
         this.loader.y = 211;
         this.loader.name = "loader";
         this.addChild(this.loader);
         this.setupTF();
         this.loadDesignNotes();
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onClose,false,0,true);
         this.btnLeft.addEventListener(MouseEvent.CLICK,this.onBtnMove,false,0,true);
         this.btnRight.addEventListener(MouseEvent.CLICK,this.onBtnMove,false,0,true);
      }
      
      public function onClose(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function onBtnMove(param1:MouseEvent) : void
      {
         if(param1.target.name == "btnLeft")
         {
            --this.pos;
         }
         else
         {
            ++this.pos;
         }
         if(this.pos < 0)
         {
            this.pos = this.posts.length - 1;
         }
         if(this.pos >= this.posts.length)
         {
            this.pos = 0;
         }
         this.txtContent.htmlText = this.cleanup(this.posts[this.pos]);
      }
      
      public function destroy() : void
      {
         this.cleanupListeners();
         this.r.world.visible = true;
         parent.removeChild(this);
      }
      
      private function cleanupListeners() : void
      {
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.onClose);
         this.btnLeft.removeEventListener(MouseEvent.CLICK,this.onBtnMove);
         this.btnRight.removeEventListener(MouseEvent.CLICK,this.onBtnMove);
         if(this.dnLoader != null)
         {
            this.dnLoader.removeEventListener(Event.COMPLETE,this.onComplete);
            this.dnLoader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.dnLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
            try
            {
               this.dnLoader.close();
            }
            catch(e:Error)
            {
            }
         }
         this.r = null;
      }
      
      public function loadDesignNotes() : void
      {
         this.dnLoader.addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
         this.dnLoader.addEventListener(ProgressEvent.PROGRESS,this.onProgress,false,0,true);
         this.dnLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onError,false,0,true);
         this.dnLoader.load(new URLRequest("https://www.aq.com/gamedesignnotes/"));
      }
      
      public function setupTF() : void
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.parseCSS("img { display:block; margin-right: auto; margin-left: auto; } p { align:center; } strong { font-weight: bold; } a { color: #990000; font-size:16px; text-decoration:underline; } a:link { color:#f6a70c; } .date { font-weight:bold; font-size:12px; color: #444444; } h2 { font-weight:bold;font-size:24px; color: #222222; } h3 { font-weight:bold; color: #900000; font-size: 18px; }");
         this.txtContent.styleSheet = _loc1_;
         this.txtContent.embedFonts = true;
         this.txtContent.condenseWhite = true;
         this.txtContent.multiline = true;
         this.txtContent.wordWrap = true;
      }
      
      public function onComplete(param1:Event) : void
      {
         var _loc2_:String = param1.target.data;
         this.posts = _loc2_.match(/(?<=<div class='post pull-right'>)((.|\n)*)(?=<\/div><img src='\/img\/gfx\/divider-md.jpg' alt='divider')/igm);
         trace("[UI] design notes posts: " + this.posts.length);
         this.txtContent.htmlText = this.cleanup(this.posts[0]);
      }
      
      public function cleanup(param1:String) : String
      {
         var _loc2_:* = /(?<=<h2>)((.|\n)*)(?=<\/h2>)/im;
         var _loc3_:* = /(?<='>)((.|\n)*)(?=<\/a>)/im;
         var _loc4_:* = /<\/?strong>/igm;
         param1 = param1.replace(_loc2_,param1.match(_loc2_)[0].match(_loc3_)[0]);
         return param1.replace(_loc4_,"");
      }
      
      public function onProgress(param1:ProgressEvent) : void
      {
         if(!this.loader)
         {
            return;
         }
         this.bLoaded = param1.bytesLoaded;
         this.bTotal = param1.bytesTotal;
         var _loc2_:int = this.bLoaded / this.bTotal * 100;
         var _loc3_:Number = this.bLoaded / this.bTotal;
         this.loader.mcPct.text = _loc2_ + "%";
         if(this.bLoaded >= this.bTotal)
         {
            this.loader.parent.removeChild(this.loader);
            this.loader = null;
         }
      }
      
      public function onError(param1:IOErrorEvent) : void
      {
         this.destroy();
      }
   }
}

