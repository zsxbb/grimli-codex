package
{
   import flash.events.Event;
   
   public class FacebookConnectEvent extends Event
   {
      public static const DEFAULT_NAME:String = "FacebookConnectEvent";
      
      public static const ONCONNECT:String = "onConnect";
      
      public var params:Object;
      
      public function FacebookConnectEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.params = param2;
      }
      
      override public function clone() : Event
      {
         return new FacebookConnectEvent(type,this.params,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("FacebookConnectEvent","params","type","bubbles","cancelable");
      }
   }
}

