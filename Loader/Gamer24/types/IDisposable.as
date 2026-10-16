package types
{
   public interface IDisposable
   {
      function dispose() : void;
      
      function get disposed() : Boolean;
   }
}

