package battledata 
{
	import Abilities.Ability;
	import Creatures.CreatureBase;
	/**
	 * ...
	 * @author Kody104
	 */
	public class Target
	{
		protected var targeter:CreatureBase;
		protected var target:CreatureBase;
		protected var ability:Ability;
		
		public function Target(targeter:CreatureBase, target:CreatureBase, ability:Ability=null) 
		{
			this.target = target;
			this.targeter = targeter;
			this.ability = ability;
		}
		
		public function getTargeter():CreatureBase
		{
			return targeter;
		}
		
		public function getTarget():CreatureBase
		{
			return target;
		}
		
		public function getAbility():Ability
		{
			return ability;
		}
		
	}

}