using AbstractFactoryDemo.Exceptions;
using AbstractFactoryDemo.Interfaces;
using AbstractFactoryDemo.Models.VietnamAirlines;

namespace AbstractFactoryDemo.Factories
{
    internal class VietnamAirlinesFactory : IAirlineFactory
    {
        public IBaggagePolicy CreatePolicy() => new VNBaggagePolicy();

        public ITicket CreateTicket(string @class)
        {
            return @class switch
            {
                nameof(VNEconomyTicket) => new VNEconomyTicket(),
                nameof(VNBusinessTicket) => new VNBusinessTicket(),
                _ => throw new NotFoundTicketClassException()
            };
        }
    }
}
