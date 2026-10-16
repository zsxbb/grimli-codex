using Grimoire.Tools;
using Newtonsoft.Json.Linq;

namespace Grimoire.Networking.Handlers
{
    public class HandlerGetDrop : IJsonMessageHandler
    {
        public string[] HandledCommands { get; } = new string[1] { "getDrop" };

        public void Handle(JsonMessage message)
        {
            if (message?.DataObject is JObject data)
            {
                Flash.HandleGetDropData(data);
            }
        }
    }
}
