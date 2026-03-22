using DecoratorDemo.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace DecoratorDemo.Implements.DecoratorConcretes
{
    internal class Sharpness_V : SwordDecorator
    {
        public Sharpness_V(ISword innerSword) : base(innerSword) { }

        public override double AttackDamage => base.AttackDamage+3;
    }
}
