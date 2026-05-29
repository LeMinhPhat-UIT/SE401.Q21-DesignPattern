using FactoryMethodDemo.Interfaces;
using FactoryMethodDemo.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace FactoryMethodDemo.Implements
{
    internal class BicycleCreator : VehicleCreator
    {
        public override IVehicle CreateVehicle() => new Bicycle();
    }
}
