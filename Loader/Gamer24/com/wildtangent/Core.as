package com.wildtangent
{
   import flash.display.Sprite;
   
   public class Core extends Sprite
   {
      public var vexReady:Boolean = false;
      
      public var myVex:* = null;
      
      private var callbacks:Object;
      
      private var _dpName:String;
      
      private var _gameName:String;
      
      private var _partnerName:String;
      
      private var _siteName:String;
      
      private var _userId:String;
      
      private var _cipherKey:String;
      
      private var _vexUrl:String = "http://vex.wildtangent.com";
      
      private var _sandbox:Boolean = false;
      
      private var _javascriptReady:Boolean = false;
      
      protected var _adComplete:Function;
      
      protected var _closed:Function;
      
      protected var _error:Function;
      
      protected var _handlePromo:Function;
      
      protected var _redeemCode:Function;
      
      protected var _requireLogin:Function;
      
      protected var methodStorage:Array;
      
      public function Core()
      {
         methodStorage = [];
         super();
      }
      
      protected function storeMethod(param1:Function, param2:Object = null) : void
      {
         methodStorage.push({
            "tempMethod":param1,
            "obj":param2
         });
      }
      
      public function launchMethods() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in methodStorage)
         {
            if(methodStorage[_loc1_].obj != null)
            {
               methodStorage[_loc1_].tempMethod.call(null,methodStorage[_loc1_].obj);
            }
            else
            {
               methodStorage[_loc1_].tempMethod.call(null);
            }
         }
      }
      
      protected function checkTop() : void
      {
         var _loc1_:* = root;
         var _loc2_:* = parent;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.numChildren)
         {
            if(_loc1_.getChildAt(_loc3_) is WildTangentAPI)
            {
               _loc2_ = _loc1_.getChildAt(_loc3_);
            }
            _loc3_++;
         }
         _loc1_.setChildIndex(_loc1_.getChildByName(_loc2_.name),_loc1_.numChildren - 1);
      }
   }
}

