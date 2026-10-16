using System.Threading.Tasks;

namespace Grimoire.Botting.Commands.Misc
{
    public class CmdRestart : IBotCommand
    {
        public Task Execute(IBotEngine instance)
        {
            instance.Index = -1;
            return Task.CompletedTask;
        }

        public override string ToString()
        {
            return "Restart bot";
        }
    }
}