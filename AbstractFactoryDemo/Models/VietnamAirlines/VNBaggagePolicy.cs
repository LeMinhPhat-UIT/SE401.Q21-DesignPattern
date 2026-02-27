using AbstractFactoryDemo.Interfaces;

namespace AbstractFactoryDemo.Models.VietnamAirlines
{
    internal class VNBaggagePolicy : IBaggagePolicy
    {
        public int FreeBaggageWeight => 10;
    }
}
