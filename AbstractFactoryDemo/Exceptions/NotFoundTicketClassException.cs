namespace AbstractFactoryDemo.Exceptions
{
    internal class NotFoundTicketClassException : Exception
    {
        public NotFoundTicketClassException() : base(nameof(NotFoundTicketClassException)) { }
    }
}
