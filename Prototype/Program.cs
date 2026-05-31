using System;
using System.Collections.Generic;
using System.Linq;

public interface IEnemyPrototype
{
    IEnemyPrototype Clone();
}

public class Enemy : IEnemyPrototype
{
    public string Name { get; set; }
    public int Health { get; set; }
    public int Damage { get; set; }
    public int Level { get; set; }
    public Position Position { get; set; }
    public List<string> Skills { get; set; }

    public Enemy(
        string name,
        int health,
        int damage,
        int level,
        Position position,
        List<string> skills)
    {
        Name = name;
        Health = health;
        Damage = damage;
        Level = level;
        Position = position;
        Skills = skills;
    }

    public IEnemyPrototype Clone()
    {
        // Deep copy cho các object mutable như Position và List<string>.
        return new Enemy(
            Name,
            Health,
            Damage,
            Level,
            new Position(Position.X, Position.Y),
            Skills.ToList()
        );
    }

    public override string ToString()
    {
        return $"{Name} | HP: {Health} | Damage: {Damage} | Level: {Level} | Position: ({Position.X}, {Position.Y}) | Skills: {string.Join(", ", Skills)}";
    }
}

public class Position
{
    public int X { get; set; }
    public int Y { get; set; }

    public Position(int x, int y)
    {
        X = x;
        Y = y;
    }
}

public class EnemyRegistry
{
    private readonly Dictionary<string, IEnemyPrototype> _prototypes = new();

    public void Register(string key, IEnemyPrototype prototype)
    {
        _prototypes[key] = prototype;
    }

    public Enemy Create(string key)
    {
        if (!_prototypes.ContainsKey(key))
        {
            throw new ArgumentException($"Prototype '{key}' does not exist.");
        }

        return (Enemy)_prototypes[key].Clone();
    }
}

public class Program
{
    public static void Main()
    {
        var registry = new EnemyRegistry();

        var goblinPrototype = new Enemy(
            name: "Goblin",
            health: 100,
            damage: 15,
            level: 1,
            position: new Position(0, 0),
            skills: new List<string> { "Slash", "Dodge" }
        );

        registry.Register("goblin", goblinPrototype);

        var goblinA = registry.Create("goblin");
        goblinA.Position.X = 10;
        goblinA.Position.Y = 5;

        var goblinB = registry.Create("goblin");
        goblinB.Level = 3;
        goblinB.Health = 150;
        goblinB.Position.X = 30;
        goblinB.Skills.Add("Poison Attack");

        Console.WriteLine(goblinPrototype);
        Console.WriteLine(goblinA);
        Console.WriteLine(goblinB);
    }
}