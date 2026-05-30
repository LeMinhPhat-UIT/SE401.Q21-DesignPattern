using System;

public class InventoryService
{
    public bool CheckStock(string productId, int quantity)
    {
        Console.WriteLine($"Checking stock for product {productId}, quantity {quantity}...");
        return true;
    }
}

public class PaymentService
{
    public bool Pay(decimal amount)
    {
        Console.WriteLine($"Processing payment: {amount}...");
        return true;
    }
}

public class OrderService
{
    public string CreateOrder(string productId, int quantity)
    {
        Console.WriteLine($"Creating order for product {productId}, quantity {quantity}...");
        return "ORDER-001";
    }
}

public class EmailService
{
    public void SendConfirmation(string orderId)
    {
        Console.WriteLine($"Sending confirmation email for order {orderId}...");
    }
}

public class CheckoutFacade
{
    private readonly InventoryService _inventoryService;
    private readonly PaymentService _paymentService;
    private readonly OrderService _orderService;
    private readonly EmailService _emailService;

    public CheckoutFacade()
    {
        _inventoryService = new InventoryService();
        _paymentService = new PaymentService();
        _orderService = new OrderService();
        _emailService = new EmailService();
    }

    public void Checkout(string productId, int quantity, decimal amount)
    {
        bool hasStock = _inventoryService.CheckStock(productId, quantity);

        if (!hasStock)
        {
            Console.WriteLine("Checkout failed: product is out of stock.");
            return;
        }

        bool paymentSuccess = _paymentService.Pay(amount);

        if (!paymentSuccess)
        {
            Console.WriteLine("Checkout failed: payment error.");
            return;
        }

        string orderId = _orderService.CreateOrder(productId, quantity);
        _emailService.SendConfirmation(orderId);

        Console.WriteLine("Checkout completed successfully.");
    }
}

public class Client
{
    public void DoCheckout()
    {
        CheckoutFacade checkoutFacade = new CheckoutFacade();
        checkoutFacade.Checkout("P001", 2, 250000);
    }
}

public class Program
{
    public static void Main()
    {
        Client client = new Client();
        client.DoCheckout();
    }
}