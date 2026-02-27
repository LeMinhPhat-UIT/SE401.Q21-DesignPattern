using FactoryMethodDemo.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace FactoryMethodDemo.Models
{
    internal class Boat : IVehicle
    {
        public string StartEngine() => "Boat has been started";
    }
}
