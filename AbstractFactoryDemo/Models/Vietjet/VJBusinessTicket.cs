using AbstractFactoryDemo.Interfaces;

namespace AbstractFactoryDemo.Models.Vietjet
{
    internal class VJBusinessTicket : ITicket
    {
        public string Class => nameof(VJBusinessTicket);

        public decimal GetPrice() => 2000;
    }
}
