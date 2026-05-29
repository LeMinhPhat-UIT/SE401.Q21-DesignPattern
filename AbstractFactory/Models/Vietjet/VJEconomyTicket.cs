using AbstractFactoryDemo.Interfaces;

namespace AbstractFactoryDemo.Models.Vietjet
{
    internal class VJEconomyTicket : ITicket
    {
        public string Class => nameof(VJEconomyTicket);

        public decimal GetPrice() => 200;
    }
}
