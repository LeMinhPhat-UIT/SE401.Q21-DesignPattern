using AbstractFactoryDemo.Exceptions;
using AbstractFactoryDemo.Interfaces;
using AbstractFactoryDemo.Models.Vietjet;

namespace AbstractFactoryDemo.Factories
{
    internal class VietjetFactory : IAirlineFactory
    {
        public IBaggagePolicy CreatePolicy() => new VJBaggagePolicy();

        public ITicket CreateTicket(string @class)
        {
            return @class switch
            {
                nameof(VJEconomyTicket) => new VJEconomyTicket(),
                nameof(VJBusinessTicket) => new VJBusinessTicket(),
                _ => throw new NotFoundTicketClassException()
            };
        }
    }
}
