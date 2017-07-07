package Creatures 
{
	import Abilities.Ability;
	import Abilities.StatusEffect;
	import flash.accessibility.Accessibility;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Kody104
	 */
	
	public class CreatureBase extends FlxSprite
	{
		
		protected var name:String;
		protected var maxHp:int;
		protected var curHp:int;
		protected var maxMp:int;
		protected var curMp:int;
		protected var atk:int;
		protected var mag:int;
		protected var spd:Number;
		protected var amr:Number;
		protected var mr:Number;
		
		protected var abilities:Array;
		protected var statuses:Array;
		protected var activeEffects:Array;
		protected var passiveEffects:Array;
		
		protected var animationQueue:Array;
		
		public function CreatureBase():void
		{
			abilities = new Array();
			statuses = new Array();
			animationQueue = new Array();
		}
		
		public function IsAnimating():Boolean
		{
			if(animationQueue.length > 0)
				return animationQueue[0].getNumOfFrames() > 0;
			return false;
		}
		
		public function playAnimation(anim:String, numOfFrames:uint):void
		{
			animationQueue.push(new Animation(anim, numOfFrames));
		}
		
		public function canAttack():Boolean
		{
			for each(var se:StatusEffect in statuses)
			{
				if (se.getType() == StatusEffect.STUN)
					return false;
			}
			return true;
		}
		
		public function tickStatuses():void
		{
			for (var i:uint = 0; i < statuses.length; i++)
			{
				var se:StatusEffect = statuses[i];
				switch(se.getType())
				{
					case StatusEffect.BLEED:
						{
							var amr:uint = getAmr();
							var reduction:Number = (100 / (100 + amr));
							var dmg:uint = Math.floor(se.getPwr() * reduction);
							curHp -= dmg;
							break;
						}
					case StatusEffect.POISON:
						{
							var mr:uint = getMr();
							var reduction:Number = (100 / (100 + mr));
							var dmg:uint = Math.floor(se.getPwr() * reduction);
							curHp -= dmg;
							break;
						}
				}
				se.setCurrentDuration(se.getCurrentDuration() - 1);
				if (se.getCurrentDuration() <= 0)
				{
					statuses.removeAt(i);
					i--;
					continue;
				}
			}
		}
		
		public function takeDamage(attacker:CreatureBase, ability:Ability = null)
		{
			if (ability == null) // Basic Attack
			{
				var atk:uint = attacker.getAtk();
				if (hasStatusEffect(StatusEffect.MARK))
				{
					trace("UNMARKED: " + atk);
					var se:StatusEffect = getStatusEffect(StatusEffect.MARK);
					atk *= se.getPwr();
					trace("MARKED: " + atk);
				}
				var amr:uint = getAmr();
				var reduction:Number = (100 / (100 + amr));
				var dmg:uint = Math.floor(atk * reduction);
				curHp -= dmg;
				return dmg;
			}
			else if (ability.getDamageType() == 0) // Physical damage
			{
				var hpDmg:uint = Math.floor(attacker.getMaxHp() * ability.getHpScale());
				var mpDmg:uint = Math.floor(attacker.getMaxMp() * ability.getMpScale());
				var atkDmg:uint = Math.floor(attacker.getAtk() * ability.getAtkScale());
				var magDmg:uint = Math.floor(attacker.getMag() * ability.getMagScale());
				var spdDmg:uint = Math.floor(attacker.getSpd() * ability.getSpdScale());
				var amrDmg:uint = Math.floor(attacker.getAmr() * ability.getAmrScale());
				var mrDmg:uint = Math.floor(attacker.getMr() * ability.getMrScale());
				var amr:uint = getAmr();
				var reduction:Number = (100 / (100 + amr));
				var dmg:uint = ability.getBaseDmg() + hpDmg + mpDmg + atkDmg + magDmg + spdDmg + amrDmg + mrDmg;
				if (hasStatusEffect(StatusEffect.MARK))
				{
					trace("UNMARKED: " + dmg);
					var se:StatusEffect = getStatusEffect(StatusEffect.MARK);
					dmg *= se.getPwr();
					trace("MARKED: " + dmg);
				}
				dmg = Math.floor(dmg * reduction);
				curHp -= dmg;
				if (ability.getStatusEffect() != null)
				{
					statuses.push(ability.getStatusEffect());
				}
				return dmg;
			}
			else if (ability.getDamageType() == 1) // Magical damage
			{
				var hpDmg:uint = Math.floor(attacker.getMaxHp() * ability.getHpScale());
				var mpDmg:uint = Math.floor(attacker.getMaxMp() * ability.getMpScale());
				var atkDmg:uint = Math.floor(attacker.getAtk() * ability.getAtkScale());
				var magDmg:uint = Math.floor(attacker.getMag() * ability.getMagScale());
				var spdDmg:uint = Math.floor(attacker.getSpd() * ability.getSpdScale());
				var amrDmg:uint = Math.floor(attacker.getAmr() * ability.getAmrScale());
				var mrDmg:uint = Math.floor(attacker.getMr() * ability.getMrScale());
				var mr:uint = getMr();
				var reduction:Number = (100 / (100 + mr));
				var dmg:uint = ability.getBaseDmg() + hpDmg + mpDmg + atkDmg + magDmg + spdDmg + amrDmg + mrDmg;
				if (hasStatusEffect(StatusEffect.MARK))
				{
					trace("UNMARKED: " + dmg);
					var se:StatusEffect = getStatusEffect(StatusEffect.MARK);
					dmg *= se.getPwr();
					trace("MARKED: " + dmg);
				}
				dmg = Math.floor(dmg * reduction);
				curHp -= dmg;
				if (ability.getStatusEffect() != null)
				{
					statuses.push(ability.getStatusEffect());
				}
				return dmg;
			}
			return 0;
		}
		
		public function addStatusEffect(statusEffect:StatusEffect):void
		{
			for (var i:uint = 0; i < statuses.length; i++)
			{
				if (statuses[i].getType() == statusEffect.getType()) // If the status effect is the same type, then combine them together
				{
					if (statuses[i].getPwr() > statusEffect.getPwr())
					{
						statuses[i].setPwr(statuses[i].getPwr() + (statusEffect.getPwr() * 0.5)); // Halve the weaker status effect pwr
						statuses[i].setCurrentDuration(statuses[i].getDuration());
						return;
					}
					else
					{
						statuses[i].setPwr((statuses[i].getPwr() * 0.5) + statusEffect.getPwr() * 0.5);
						statuses[i].setCurrentDuration(statuses[i].getDuration());
						return;
					}
				}
			}
			statuses.push(statusEffect); // If the status effect type doesn't already exist, add it.
		}
		
		public function removeStatusEffect(statusEffect:uint):void
		{
			for (var i:uint = 0; i < statuses.length; i++)
			{
				var s:StatusEffect = statuses[i];
				if (s.getType() == statusEffect)
				{
					statuses.removeAt(i);
					return;
				}
			}
		}
		
		public function hasStatusEffect(statusEffect:uint):Boolean
		{
			for each (var s:StatusEffect in statuses )
			{
				if (s.getType() == statusEffect)
				{
					return true;
				}
			}
			return false;
		}
		
		public function useAbility(ability:Ability):void
		{
			curMp -= ability.getMpCost();
			if (curMp < 0)
				curMp = 0;
		}
		
		public function getName():String
		{
			return name;
		}
		
		public function getMaxHp():int
		{
			return maxHp;
		}
		
		public function getCurHp():int
		{
			return curHp;
		}
		
		public function getMaxMp():int
		{
			return maxMp;
		}
		
		public function getCurMp():int
		{
			return curMp;
		}
		
		public function getAtk():int
		{
			return atk;
		}
		
		public function getMag():int
		{
			return mag;
		}
		
		public function getSpd():int
		{
			return (Math.floor(spd)) as int;
		}
		
		public function getAmr():int
		{
			return (Math.floor(amr)) as int;
		}
		
		public function getMr():int
		{
			return (Math.floor(mr)) as int;
		}
		
		public function getAbility(index:uint):Ability
		{
			return abilities[index];
		}
		
		public function getAbilities():Array
		{
			return abilities;
		}
		
		public function getActiveEffects():Array
		{
			return activeEffects;
		}
		
		public function getPassiveEffects():Array
		{
			return passiveEffects;
		}
		
		public function getStatusEffect(statusEffect:uint):StatusEffect
		{
			for each(var s:StatusEffect in statuses)
			{
				if (s.getType() == statusEffect)
				{
					return s;
				}
			}
			return null;
		}
		
		public function getStatuses():Array
		{
			return statuses;
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}

}