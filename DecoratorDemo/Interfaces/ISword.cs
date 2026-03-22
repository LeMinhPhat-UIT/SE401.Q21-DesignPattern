using System;
using System.Collections.Generic;
using System.Text;

namespace DecoratorDemo.Interfaces
{
    internal interface ISword : ITool
    {
        double AttackDamage { get; }
        double AttackSpeed { get; }
    }
}
