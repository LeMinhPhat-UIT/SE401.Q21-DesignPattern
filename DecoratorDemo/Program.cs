using DecoratorDemo.Implements;
using DecoratorDemo.Implements.DecoratorConcretes;
using DecoratorDemo.Interfaces;

ISword diamondSword = new DiamondSword();

PrintInformation(diamondSword);

diamondSword = new Unbreaking_III(diamondSword);
PrintInformation(diamondSword);

diamondSword = new Sharpness_V(diamondSword);
PrintInformation(diamondSword);

void PrintInformation(ISword sword)
{
    Console.WriteLine
    (
        $"""
        DiamondSword information:
            AttackDamage: {diamondSword.AttackDamage}
            AttackSpeed: {diamondSword.AttackSpeed}
            Durability: {diamondSword.Durability}
        """
    );
}