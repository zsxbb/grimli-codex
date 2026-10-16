package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class invSearch extends MovieClip
   {
      public var txtSearch:TextField;
      
      internal var rootClass:MovieClip;
      
      private var _searchLower:String = "";
      
      public function invSearch(param1:MovieClip)
      {
         super();
         this.rootClass = param1;
         this.txtSearch.addEventListener(KeyboardEvent.KEY_DOWN,this.onInvSearch,false,0,true);
      }
      
      public function onFilter(param1:*, param2:int, param3:Array) : Boolean
      {
         return param1.sName.toLowerCase().indexOf(this._searchLower) > -1;
      }
      
      public function apply() : void
      {
         this._searchLower = this.txtSearch.text.toLowerCase();
         if(this.rootClass.ui.mcPopup.currentLabel == "Inventory")
         {
            this.rootClass.world.myAvatar.filtered_list = this.txtSearch.text != "" ? this.rootClass.world.myAvatar.items.filter(this.onFilter) : null;
            MovieClip(this.rootClass.ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshInv"});
         }
         else if(this.rootClass.ui.mcPopup.currentLabel == "HouseInventory")
         {
            this.rootClass.world.myAvatar.filtered_list = this.txtSearch.text != "" ? this.rootClass.world.myAvatar.houseitems.filter(this.onFilter) : null;
            MovieClip(this.rootClass.ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshInv"});
         }
         else if(this.rootClass.ui.mcPopup.currentLabel == "Bank")
         {
            this.rootClass.world.myAvatar.filtered_list = this.txtSearch.text != "" ? this.rootClass.world.myAvatar.items.filter(this.onFilter) : null;
            MovieClip(this.rootClass.ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshInv"});
         }
         else if(this.rootClass.ui.mcPopup.currentLabel == "HouseBank")
         {
            this.rootClass.world.myAvatar.filtered_list = this.txtSearch.text != "" ? this.rootClass.world.myAvatar.houseitems.filter(this.onFilter) : null;
            MovieClip(this.rootClass.ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshInv"});
         }
      }
      
      internal function onInvSearch(param1:KeyboardEvent) : void
      {
         if(param1.charCode == 13)
         {
            this.apply();
         }
      }
      
      public function reset() : void
      {
         this.rootClass.world.myAvatar.filtered_list = null;
      }
      
      public function dispose() : void
      {
         this.txtSearch.removeEventListener(KeyboardEvent.KEY_DOWN,this.onInvSearch);
         this.rootClass = null;
      }
   }
}

