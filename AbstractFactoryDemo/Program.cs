using AbstractFactoryDemo.Factories;
using AbstractFactoryDemo.Interfaces;
using AbstractFactoryDemo.Models.VietnamAirlines;

string airline = nameof(VietnamAirlinesFactory);
IAirlineFactory airlineFactory;

airlineFactory = airline switch
{
    nameof(VietnamAirlinesFactory) => new VietnamAirlinesFactory(),
    nameof(VietjetFactory) => new VietjetFactory(),
    _ => throw new Exception()
};

if (airlineFactory is not null)
{
    var vnEconomyTicket = airlineFactory.CreateTicket(nameof(VNEconomyTicket));
    var vnBaggagePolicy = airlineFactory.CreatePolicy();

    Console.WriteLine
    (
        $"""
            Ticket Price For {vnEconomyTicket.Class} Class = {vnEconomyTicket.GetPrice()},
            Free Baggage Weight = {vnBaggagePolicy.FreeBaggageWeight}
        """
    );
}