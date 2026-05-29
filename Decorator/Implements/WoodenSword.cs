using DecoratorDemo.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace DecoratorDemo.Implements
{
    internal class WoodenSword : ISword
    {
        public double AttackDamage => 4;

        public double AttackSpeed => 1.6;

        public double Durability => 59;
        public double PercentDrop => 100;
    }
}
