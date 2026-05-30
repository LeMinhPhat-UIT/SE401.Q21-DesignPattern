using System;

public sealed class AppLogger
{
    private static readonly Lazy<AppLogger> _instance =
        new Lazy<AppLogger>(() => new AppLogger());

    private AppLogger()
    {
    }

    public static AppLogger Instance => _instance.Value;

    public void Log(string message)
    {
        Console.WriteLine($"[LOG] {DateTime.Now}: {message}");
    }
}

public class OrderService
{
    public void CreateOrder()
    {
        AppLogger.Instance.Log("Creating order...");
        Console.WriteLine("Order created.");
    }
}

public class PaymentService
{
    public void Pay()
    {
        AppLogger.Instance.Log("Processing payment...");
        Console.WriteLine("Payment completed.");
    }
}

public class Program
{
    public static void Main()
    {
        var orderService = new OrderService();
        orderService.CreateOrder();

        var paymentService = new PaymentService();
        paymentService.Pay();
    }
}