using AbstractFactoryDemo.Interfaces;

namespace AbstractFactoryDemo.Models.VietnamAirlines
{
    internal class VNBusinessTicket : ITicket
    {
        public string Class => nameof(VNBusinessTicket);

        public decimal GetPrice() => 1000;
    }
}
