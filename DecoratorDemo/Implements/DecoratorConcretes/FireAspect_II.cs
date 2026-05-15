using DecoratorDemo.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace DecoratorDemo.Implements.DecoratorConcretes
{
    internal class FireAspect_II : SwordDecorator
    {
        public FireAspect_II(ISword innerSword) : base(innerSword) { }

        public double FireDamage => 1;
    }
}
