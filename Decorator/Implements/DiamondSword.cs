using DecoratorDemo.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace DecoratorDemo.Implements
{
    internal class DiamondSword : ISword
    {
        public double AttackDamage => 7;
        public double AttackSpeed => 1.6;
        public double Durability => 1561;
        public double PercentDrop => 100;
    }
}
