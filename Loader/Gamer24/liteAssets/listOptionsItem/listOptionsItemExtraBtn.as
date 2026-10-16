package liteAssets.listOptionsItem
{
   import fl.controls.*;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.text.*;
   import liteAssets.handlers.*;
   
   public class listOptionsItemExtraBtn extends MovieClip
   {
      public var txtName:TextField;
      
      public var btnActive:SimpleButton;
      
      public var sDesc:String;
      
      public var rootClass:MovieClip;
      
      public function listOptionsItemExtraBtn(param1:MovieClip, param2:String)
      {
         super();
         this.rootClass = param1;
         this.sDesc = param2;
         this.btnActive.addEventListener(MouseEvent.CLICK,this.onActive,false,0,true);
      }
      
      public function onActive(param1:MouseEvent) : void
      {
         optionHandler.cmd(this.rootClass,this.txtName.text);
      }
   }
}

