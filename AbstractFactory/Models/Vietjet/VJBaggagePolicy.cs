using AbstractFactoryDemo.Interfaces;

namespace AbstractFactoryDemo.Models.Vietjet
{
    internal class VJBaggagePolicy : IBaggagePolicy
    {
        public int FreeBaggageWeight => 20;
    }
}
