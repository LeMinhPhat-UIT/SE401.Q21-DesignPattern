using FactoryMethodDemo.Implements;
using FactoryMethodDemo.Interfaces;

string creator = nameof(BoatCreator);
VehicleCreator vehicleCreator;

vehicleCreator = creator switch
{
    nameof(BoatCreator) => new BoatCreator(),
    nameof(BicycleCreator) => new BicycleCreator(),
    _ => throw new Exception()
};

if (vehicleCreator is not null)
{
    var vehicle = vehicleCreator.CreateVehicle();

    Console.WriteLine(vehicle.StartEngine());
}