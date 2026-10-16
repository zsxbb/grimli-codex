using System;
using System.Threading.Tasks;

namespace Grimoire.Botting.Commands.Misc
{
    public class CmdClearTemp : IBotCommand
    {
        public Task Execute(IBotEngine instance)
        {
            Configuration.Tempvalues.Clear();
            Configuration.Tempvariable.Clear();
            return Task.CompletedTask;
        }

        public override string ToString()
        {
            return "Clear TempVar";
        }
    }
}