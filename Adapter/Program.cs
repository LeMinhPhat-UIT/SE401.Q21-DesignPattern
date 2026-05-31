namespace Adapter;

public interface IPaymentGateway
{
    PaymentResult Pay(decimal amount, string currency);
}

public class PaymentResult
{
    public bool Success { get; }
    public string TransactionId { get; }
    public string Message { get; }

    public PaymentResult(bool success, string transactionId, string message)
    {
        Success = success;
        TransactionId = transactionId;
        Message = message;
    }
}

public class StripeService
{
    public StripeResponse Charge(long amountInCents, string currencyCode)
    {
        Console.WriteLine($"Charging {amountInCents} cents via Stripe...");

        return new StripeResponse(
            isSuccess: true,
            transactionId: Guid.NewGuid().ToString(),
            message: "Stripe payment completed"
        );
    }
}

public class StripeResponse
{
    public bool IsSuccess { get; }
    public string TransactionId { get; }
    public string Message { get; }

    public StripeResponse(bool isSuccess, string transactionId, string message)
    {
        IsSuccess = isSuccess;
        TransactionId = transactionId;
        Message = message;
    }
}

public class StripePaymentAdapter : IPaymentGateway
{
    private readonly StripeService _stripeService;

    public StripePaymentAdapter(StripeService stripeService)
    {
        _stripeService = stripeService;
    }

    public PaymentResult Pay(decimal amount, string currency)
    {
        long amountInCents = ConvertToCents(amount);
        StripeResponse stripeResponse = _stripeService.Charge(amountInCents, currency);

        return new PaymentResult(
            success: stripeResponse.IsSuccess,
            transactionId: stripeResponse.TransactionId,
            message: stripeResponse.Message
        );
    }

    private static long ConvertToCents(decimal amount)
    {
        return (long)(amount * 100);
    }
}

public class CheckoutService
{
    private readonly IPaymentGateway _paymentGateway;

    public CheckoutService(IPaymentGateway paymentGateway)
    {
        _paymentGateway = paymentGateway;
    }

    public void Checkout(decimal totalAmount)
    {
        PaymentResult result = _paymentGateway.Pay(totalAmount, "USD");

        if (result.Success)
        {
            Console.WriteLine($"Payment success: {result.TransactionId}");
        }
        else
        {
            Console.WriteLine($"Payment failed: {result.Message}");
        }
    }
}

public class Program
{
    public static void Main()
    {
      var stripeService = new StripeService();
      IPaymentGateway gateway = new StripePaymentAdapter(stripeService);

      var checkoutService = new CheckoutService(gateway);
      checkoutService.Checkout(19.99m);
    }
}