using Grimoire.Tools;
using System;
using System.Threading.Tasks;

namespace Grimoire.Botting.Commands.Misc
{
    public class CmdSetFPS : IBotCommand
    {
        public int FPS
        {
            get;
            set;
        }

        public Task Execute(IBotEngine instance)
        {
            Flash.Call("SetFPS", FPS);
            return Task.CompletedTask;
        }

        public override string ToString()
        {
            return $"Set FPS: {FPS}";
        }
    }
}