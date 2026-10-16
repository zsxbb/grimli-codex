using System.Threading.Tasks;

namespace Grimoire.Botting.Commands.Misc
{
    public class CmdBankList : IBotCommand
    {
        public Task Execute(IBotEngine instance) => Task.CompletedTask;

        public override string ToString()
        {
            return "Bank Item list";
        }
    }
}