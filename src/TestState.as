package  
{
	import Creatures.Creature;
	import Creatures.CreatureType;
	import Heroes.Hero;
	import Heroes.HeroAbilities;
	import Heroes.HeroType;
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	import org.flixel.FlxButton;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Kody104
	 */
	public class TestState extends FlxState
	{
		protected var heroes:Array;
		protected var creatures:Array;
		
		public function TestState() 
		{
			HeroAbilities.init();
			heroes = new Array();
			heroes.push(new Hero(HeroType.BRAWLER, "Devin"));
			heroes.push(new Hero(HeroType.GUNSLINGER, "Kevin"));
			creatures = new Array();
			creatures.push(new Creature(CreatureType.RAT));
			creatures.push(new Creature(CreatureType.RAT));
			creatures.push(new Creature(CreatureType.RAT));
			creatures.push(new Creature(CreatureType.RAT));
			creatures.push(new Creature(CreatureType.RAT));
			creatures.push(new Creature(CreatureType.RAT));
			creatures.push(new Creature(CreatureType.RAT));
			creatures.push(new Creature(CreatureType.RAT));
			creatures.push(new Creature(CreatureType.RAT));
			
			var button:FlxButton = new FlxButton(0, 0 , switchState);
			button.x = 206 - button.width;
			button.y = 206 - button.height;
			var text:FlxText = new FlxText(button.width / 2 - (4.15 * 6), button.height / 2 - 6 , button.width, "BATTLE!");
			button.loadText(text);
			add(button);
		}
		
		public function switchState():void
		{
			FlxG.state = new BattleState(creatures, heroes);
		}
		
	}

}