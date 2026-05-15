using System;
using System.Collections.Generic;
using System.Text;

namespace DecoratorDemo.Interfaces
{
    internal abstract class SwordDecorator : ISword
    {
        public ISword _innerSword;

        public SwordDecorator(ISword innerSword) 
        {
            _innerSword = innerSword;
        }

        public virtual double AttackDamage => _innerSword.AttackDamage;

        public virtual double AttackSpeed => _innerSword.AttackSpeed;

        public virtual double Durability => _innerSword.Durability;
    }
}
