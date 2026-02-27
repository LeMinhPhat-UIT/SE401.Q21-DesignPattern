using AbstractFactoryDemo.Interfaces;

namespace AbstractFactoryDemo.Models.VietnamAirlines
{
    internal class VNEconomyTicket : ITicket
    {
        public string Class { get; } = nameof(VNEconomyTicket);

        public decimal GetPrice() => 100;
    }
}
