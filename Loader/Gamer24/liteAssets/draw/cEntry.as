package liteAssets.draw
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.text.*;
   
   public class cEntry extends MovieClip
   {
      public var entryBar:MovieClip;
      
      public var overEntryBar:MovieClip;
      
      public var txtEntry:TextField;
      
      private var cellName:String;
      
      private var sCellName:String;
      
      internal var rootClass:MovieClip;
      
      public function cEntry(param1:MovieClip, param2:String, param3:String)
      {
         super();
         this.rootClass = param1;
         this.cellName = param2;
         this.sCellName = param3;
         this.gotoAndStop("idle");
         this.txtEntry.text = param2;
         if(param2 == this.rootClass.world.strFrame)
         {
            this.txtEntry.textColor = 12283391;
         }
         this.addEventListener(MouseEvent.ROLL_OVER,this.onHighlight,false,0,true);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onDeHighlight,false,0,true);
         this.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,false,0,true);
      }
      
      internal function onWheel(param1:MouseEvent) : void
      {
         this.rootClass.cMenuUI.onScroll(param1);
      }
      
      internal function onClick(param1:MouseEvent) : void
      {
         if(this.sCellName != "")
         {
            this.rootClass.world.moveToCell(this.sCellName,this.cellName);
         }
         this.rootClass.cMenuUI.reDraw(this.sCellName != "" ? "" : this.cellName);
         this.rootClass.stage.focus = null;
      }
      
      internal function onHighlight(param1:MouseEvent) : void
      {
         this.gotoAndStop("hover");
      }
      
      internal function onDeHighlight(param1:MouseEvent) : void
      {
         this.gotoAndStop("idle");
      }
   }
}

