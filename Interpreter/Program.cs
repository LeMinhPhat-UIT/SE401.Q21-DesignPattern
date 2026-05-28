using System;
using System.Collections.Generic;

// Context: chứa dữ liệu đầu vào để các Expression sử dụng
public class UserContext
{
    private readonly Dictionary<string, bool> _variables = new();

    public void Set(string name, bool value)
    {
        _variables[name] = value;
    }

    public bool Get(string name)
    {
        if (!_variables.ContainsKey(name))
        {
            throw new Exception($"Variable '{name}' is not defined.");
        }

        return _variables[name];
    }
}

// Abstract Expression
public interface IExpression
{
    bool Interpret(UserContext context);
}

// Terminal Expression
public class VariableExpression : IExpression
{
    private readonly string _name;

    public VariableExpression(string name)
    {
        _name = name;
    }

    public bool Interpret(UserContext context)
    {
        return context.Get(_name);
    }
}

// Non-terminal Expression: AND
public class AndExpression : IExpression
{
    private readonly IExpression _left;
    private readonly IExpression _right;

    public AndExpression(IExpression left, IExpression right)
    {
        _left = left;
        _right = right;
    }

    public bool Interpret(UserContext context)
    {
        return _left.Interpret(context) && _right.Interpret(context);
    }
}

// Non-terminal Expression: OR
public class OrExpression : IExpression
{
    private readonly IExpression _left;
    private readonly IExpression _right;

    public OrExpression(IExpression left, IExpression right)
    {
        _left = left;
        _right = right;
    }

    public bool Interpret(UserContext context)
    {
        return _left.Interpret(context) || _right.Interpret(context);
    }
}

// Non-terminal Expression: NOT
public class NotExpression : IExpression
{
    private readonly IExpression _expression;

    public NotExpression(IExpression expression)
    {
        _expression = expression;
    }

    public bool Interpret(UserContext context)
    {
        return !_expression.Interpret(context);
    }
}

// Client code
public class Program
{
    public static void Main()
    {
        var context = new UserContext();

        context.Set("admin", true);
        context.Set("active", true);
        context.Set("premium", false);
        context.Set("banned", false);

        // Biểu thức: admin AND active
        IExpression expression1 = new AndExpression(
            new VariableExpression("admin"),
            new VariableExpression("active")
        );

        // Biểu thức: admin OR premium
        IExpression expression2 = new OrExpression(
            new VariableExpression("admin"),
            new VariableExpression("premium")
        );

        // Biểu thức: NOT banned
        IExpression expression3 = new NotExpression(
            new VariableExpression("banned")
        );

        // Biểu thức: admin AND NOT banned
        IExpression expression4 = new AndExpression(
            new VariableExpression("admin"),
            new NotExpression(new VariableExpression("banned"))
        );

        Console.WriteLine($"admin AND active = {expression1.Interpret(context)}");
        Console.WriteLine($"admin OR premium = {expression2.Interpret(context)}");
        Console.WriteLine($"NOT banned = {expression3.Interpret(context)}");
        Console.WriteLine($"admin AND NOT banned = {expression4.Interpret(context)}");
    }
}