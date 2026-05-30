using System;
using System.Collections.Generic;

public class TreeType
{
    public string Name { get; }
    public string Color { get; }
    public string Texture { get; }

    public TreeType(string name, string color, string texture)
    {
        Name = name;
        Color = color;
        Texture = texture;
    }

    public void Draw(int x, int y)
    {
        Console.WriteLine(
            $"Drawing {Name} tree at ({x}, {y}) with color {Color} and texture {Texture}"
        );
    }
}

public class TreeFactory
{
    private readonly Dictionary<string, TreeType> _treeTypes = new();

    public TreeType GetTreeType(string name, string color, string texture)
    {
        string key = $"{name}_{color}_{texture}";

        if (!_treeTypes.ContainsKey(key))
        {
            _treeTypes[key] = new TreeType(name, color, texture);
            Console.WriteLine($"Created new TreeType: {key}");
        }

        return _treeTypes[key];
    }
}

public class Tree
{
    private readonly int _x;
    private readonly int _y;
    private readonly TreeType _type;

    public Tree(int x, int y, TreeType type)
    {
        _x = x;
        _y = y;
        _type = type;
    }

    public void Draw()
    {
        _type.Draw(_x, _y);
    }
}

public class Forest
{
    private readonly List<Tree> _trees = new();
    private readonly TreeFactory _treeFactory = new();

    public void PlantTree(int x, int y, string name, string color, string texture)
    {
        TreeType type = _treeFactory.GetTreeType(name, color, texture);
        Tree tree = new Tree(x, y, type);
        _trees.Add(tree);
    }

    public void Draw()
    {
        foreach (Tree tree in _trees)
        {
            tree.Draw();
        }
    }
}

public class Program
{
    public static void Main()
    {
        Forest forest = new Forest();

        forest.PlantTree(10, 20, "Oak", "Green", "oak.png");
        forest.PlantTree(30, 40, "Oak", "Green", "oak.png");
        forest.PlantTree(50, 60, "Oak", "Green", "oak.png");

        forest.PlantTree(70, 80, "Pine", "Dark Green", "pine.png");

        Console.WriteLine();

        forest.Draw();
    }
}