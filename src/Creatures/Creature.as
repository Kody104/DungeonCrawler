package Creatures 
{	
	import Heroes.Hero;
	import enum.IMG;
	import Abilities.StatusEffect;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author Kody104
	 */
	public class Creature extends CreatureBase
	{
		protected var creatureType:uint;
		protected var expDrop:uint;
		
		public function Creature(type:uint):void
		{
			super();
			creatureType = type;
			switch(type)
			{
				case CreatureType.RAT:
					{
						loadGraphic(IMG.RAT, false, false, 34, 34);
						addAnimation("Standard", [0]);
						addAnimation("Special", [1]);
						addAnimation("WalkL", [0]);
						addAnimation("WalkR", [0]);
						addAnimation("Attack", [0, 1], 20);
						name = "Rat";
						maxHp = 35;
						curHp = maxHp;
						maxMp = 20;
						curMp = maxMp;
						atk = 4;
						mag = 1;
						spd = 3;
						amr = 4;
						mr = 2;
						expDrop = 5;
						break;
					}
			}
		}
		
		public function selectTarget(heroes:Array):Hero
		{
			var topPriority:uint = 0;
			var index:int = -1;
			for ( var i:uint; i < heroes.length; i++ )
			{
				var h:Hero = heroes[i];
				if (h.hasStatusEffect(StatusEffect.PRIORITY))
				{
					if (h.getStatusEffect(StatusEffect.PRIORITY).getPwr() > topPriority)
					{
						topPriority = h.getStatusEffect(StatusEffect.PRIORITY).getPwr();
						index = i;
					}
				}
			}
			if (topPriority > 0)
			{
				var chance:uint = (FlxU.random() * 100) + 1;
				if (chance <= topPriority)
				{
					return heroes[index];
				}
			}
			var randSelect:uint = Math.round(FlxU.random() * (heroes.length - 1));
			trace(randSelect);
			trace(heroes.length);
			return heroes[randSelect];
		}
		
		public function getExpDrop():uint
		{
			return expDrop;
		}
		
		public function getCreatureType():uint
		{
			return creatureType;
		}
		
		override public function update():void
		{
			if (animationQueue.length > 0)
			{
				if (animationQueue[0].getNumOfFrames() > 0)
				{
					if (_curAnim != null)
					{
						if (_curAnim.name == animationQueue[0].getAnimToPlay())
						{
							animationQueue[0].tick();
						}
						else
						{
							play(animationQueue[0].getAnimToPlay());
						}
						
						if (animationQueue[0].getAnimToPlay() == "WalkL")
						{
							x--;
						}
						else if (animationQueue[0].getAnimToPlay() == "WalkR")
						{
							x++;
						}
					}
				}
				else
				{
					animationQueue.shift();
				}
			}
			else
			{
				play("Standard");
			}
			
			super.update();
		}
		
	}

}