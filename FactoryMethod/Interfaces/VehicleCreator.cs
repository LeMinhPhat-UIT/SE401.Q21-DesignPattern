using System;
using System.Collections.Generic;
using System.Text;

namespace FactoryMethodDemo.Interfaces
{
    abstract class VehicleCreator
    {
        public abstract IVehicle CreateVehicle();
    }
}
