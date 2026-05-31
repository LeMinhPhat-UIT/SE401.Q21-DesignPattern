namespace ChainOfResponsibility;

public class RequestContext
{
    public string UserName { get; set; } = string.Empty;
    public bool IsAuthenticated { get; set; }
    public bool HasPermission { get; set; }
    public string Payload { get; set; } = string.Empty;
    public bool IsRejected { get; set; }
    public string? ErrorMessage { get; set; }
}

public interface IRequestHandler
{
    IRequestHandler SetNext(IRequestHandler next);
    Task HandleAsync(RequestContext context);
}

public abstract class BaseRequestHandler : IRequestHandler
{
    private IRequestHandler? _next;

    public IRequestHandler SetNext(IRequestHandler next)
    {
        _next = next;
        return next;
    }

    public virtual async Task HandleAsync(RequestContext context)
    {
        if (_next != null && !context.IsRejected)
        {
            await _next.HandleAsync(context);
        }
    }
}

public class LoggingHandler : BaseRequestHandler
{
    public override async Task HandleAsync(RequestContext context)
    {
        Console.WriteLine($"[LOG] User: {context.UserName}, Payload: {context.Payload}");
        await base.HandleAsync(context);
    }
}

public class AuthenticationHandler : BaseRequestHandler
{
    public override async Task HandleAsync(RequestContext context)
    {
        if (!context.IsAuthenticated)
        {
            context.IsRejected = true;
            context.ErrorMessage = "User is not authenticated.";
            return;
        }

        await base.HandleAsync(context);
    }
}

public class AuthorizationHandler : BaseRequestHandler
{
    public override async Task HandleAsync(RequestContext context)
    {
        if (!context.HasPermission)
        {
            context.IsRejected = true;
            context.ErrorMessage = "User does not have permission.";
            return;
        }

        await base.HandleAsync(context);
    }
}

public class ValidationHandler : BaseRequestHandler
{
    public override async Task HandleAsync(RequestContext context)
    {
        if (string.IsNullOrWhiteSpace(context.Payload))
        {
            context.IsRejected = true;
            context.ErrorMessage = "Payload must not be empty.";
            return;
        }

        await base.HandleAsync(context);
    }
}

public class BusinessHandler : BaseRequestHandler
{
    public override Task HandleAsync(RequestContext context)
    {
        Console.WriteLine("Business logic executed successfully.");
        return Task.CompletedTask;
    }
}

public class Program
{
    public static async Task Main(string[] args)
    {
        var logging = new LoggingHandler();
        var authentication = new AuthenticationHandler();
        var authorization = new AuthorizationHandler();
        var validation = new ValidationHandler();
        var business = new BusinessHandler();

        logging
            .SetNext(authentication)
            .SetNext(authorization)
            .SetNext(validation)
            .SetNext(business);

        var context = new RequestContext
        {
            UserName = "phat",
            IsAuthenticated = true,
            HasPermission = true,
            Payload = "Create order"
        };

        await logging.HandleAsync(context);

        if (context.IsRejected)
        {
            Console.WriteLine($"Request rejected: {context.ErrorMessage}");
        }
    }
}