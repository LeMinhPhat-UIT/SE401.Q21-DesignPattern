namespace AbstractFactoryDemo.Interfaces
{
    internal interface IAirlineFactory
    {
        ITicket CreateTicket(string @class);
        IBaggagePolicy CreatePolicy();
    }
}
