using FactoryMethodDemo.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace FactoryMethodDemo.Models
{
    internal class Bicycle : IVehicle
    {
        public string StartEngine() => "Your bicycle has engine? That's cool";
    }
}
