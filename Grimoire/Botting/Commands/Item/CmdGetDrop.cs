using Grimoire.Game;
using System;
using System.Threading.Tasks;

namespace Grimoire.Botting.Commands.Item
{
    public class CmdGetDrop : IBotCommand
    {
        public string ItemName
        {
            get;
            set;
        }

        public async Task Execute(IBotEngine instance)
        {
            BotData.BotState = BotData.State.Others;
            string target = (instance.IsVar(this.ItemName) ? Configuration.Tempvariable[instance.GetVar(this.ItemName)] : this.ItemName);
            if (string.IsNullOrWhiteSpace(target))
                return;

            target = target.Trim();

            // If an explicit numeric ID was supplied (e.g. "46053")
            if (int.TryParse(target, out int itemId) && itemId > 0)
            {
                await World.DropStack.GetDrop(itemId);
                await Task.Delay(400);
                return;
            }

            // If drop not yet registered in DropStack, give it up to 1000ms to arrive from server
            if (!World.DropStack.Contains(target))
            {
                for (int i = 0; i < 10; i++)
                {
                    await Task.Delay(100);
                    if (World.DropStack.Contains(target))
                        break;
                }
            }

            await World.DropStack.GetDrop(target);
            await Task.Delay(400);
        }

        public override string ToString()
        {
            return "Get drop: " + ItemName;
        }
    }
}