package Heroes 
{
	import Abilities.Ability;
	import Abilities.StatusEffect;
	import Abilities.CastType;
	/**
	 * ...
	 * @author Kody104
	 */
	public class HeroAbilities 
	{
		public static var BRAWLER:Array;
		public static var GUNSLINGER:Array;
		
		public static function init():void
		{
			BRAWLER = new Array();
			GUNSLINGER = new Array();
			BRAWLER.push(new Ability("Pound", CastType.ENEMIES, 0, 20, 15, new StatusEffect(StatusEffect.STUN, 3, 0), 0, 0, 0.4, 0, 0, 0, 0));
			GUNSLINGER.push(new Ability("Piercing Bullet", CastType.ENEMIES, 0, 30, 20, null, 0, 0, 0.7, 0, 0, 0, 0));
			GUNSLINGER.push(new Ability("Trap", CastType.SELF, 0, 0, 5, new StatusEffect(StatusEffect.DEFENSE_MARK, 5, 0), 0, 0, 0, 0, 0, 0, 0));
		}
	}

}