using DecoratorDemo.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace DecoratorDemo.Implements.DecoratorConcretes
{
    internal class Unbreaking_III : SwordDecorator
    {
        public Unbreaking_III(ISword innerSword) : base(innerSword) { }

        public override double Durability => base.Durability*(1+3d/7);
    }
}
