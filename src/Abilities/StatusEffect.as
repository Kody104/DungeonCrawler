package Abilities 
{
	import Creatures.CreatureBase;
	import enum.IMG;
	/**
	 * ...
	 * @author Kody104
	 */
	public class StatusEffect 
	{
		
		public static const STUN:uint = 0; // No actions
		public static const MARK:uint = 1; // Increased damage against
		public static const BLEED:uint = 2; // Dot over time - Physical
		public static const PRIORITY:uint = 3; // Chance to get atk'd
		public static const SILENCE:uint = 4; // No spells
		public static const FEAR:uint = 5; // Attack allies
		public static const POISON:uint = 6; //Dot over time - Magical
		public static const DEFENSE_MARK:uint = 7; // When attacked, enemy is stunned and take no damage
		public static const BUFF:uint = 8; // A buff for a period of time
		
		
		protected var image:Class;
		protected var type:uint;
		protected var duration:uint;
		protected var currentDuration:uint;
		protected var pwr:Number;
		
		public function StatusEffect(Type:uint, Duration:uint, Pwr:Number) 
		{
			type = Type;
			switch(Type)
			{
				case MARK:
					{
						image = IMG.MARK_STATUSEFFECT;
					}
			}
			duration = Duration;
			currentDuration = duration;
			pwr = Pwr;
		}
		
		public function getImage():Class
		{
			return image;
		}
		
		public function getType():uint
		{
			return type;
		}
		
		public function getDuration():uint
		{
			return duration;
		}
		
		public function setCurrentDuration(CurrentDuration:uint):void
		{
			currentDuration = CurrentDuration;
		}
		
		public function getCurrentDuration():uint
		{
			return currentDuration;
		}
		
		public function setPwr(Pwr:Number):void
		{
			pwr = Pwr;
		}
		
		public function getPwr():Number
		{
			return pwr;
		}
	}

}