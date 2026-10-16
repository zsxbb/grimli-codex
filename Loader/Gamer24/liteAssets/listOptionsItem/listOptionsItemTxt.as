package liteAssets.listOptionsItem
{
   import fl.controls.*;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.text.*;
   import liteAssets.draw.*;
   
   public class listOptionsItemTxt extends MovieClip
   {
      public var txtName:TextField;
      
      public var txtSearch:TextField;
      
      public var btnActive:SimpleButton;
      
      public var sDesc:String;
      
      public var rootClass:MovieClip;
      
      public function listOptionsItemTxt(param1:MovieClip, param2:String)
      {
         super();
         this.rootClass = param1;
         this.sDesc = param2;
         this.btnActive.addEventListener(MouseEvent.CLICK,this.onActive,false,0,true);
         this.txtSearch.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPress,false,0,true);
      }
      
      public function onActive(param1:MouseEvent) : void
      {
         if(this.txtSearch.text.length < 1)
         {
            return;
         }
         var _loc2_:charPage = new charPage(this.rootClass,this.txtSearch.text);
         this.rootClass.ui.addChild(_loc2_);
      }
      
      public function onKeyPress(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            this.btnActive.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
   }
}

