namespace AbstractFactoryDemo.Interfaces
{
    internal interface ITicket
    {
        string Class { get; }
        decimal GetPrice();
    }
}
