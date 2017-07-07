package Heroes 
{
	import Abilities.Ability;
	import Creatures.CreatureBase;
	import org.flixel.FlxU;
	import enum.IMG;
	/**
	 * ...
	 * @author Kody104
	 */
	public class Hero extends CreatureBase
	{
		protected var lvl:uint;
		protected var exp:int;
		protected var learnRate:uint;
		protected var heroType:uint;
		
		public function Hero(heroType:uint, Name:String)
		{
			super();
			name = Name;
			this.heroType = heroType;
			lvl = 1;
			learnRate = ((FlxU.random() * 99) + 1)
			initAnimations();
			initStats();
			initAbilities();
		}
		
		public function getLvl():uint
		{
			return lvl;
		}
		
		private function initAnimations():void
		{
			switch(heroType)
			{
				case HeroType.BRAWLER:
					{
						loadGraphic(IMG.HERO_1, false, false, 18, 26);
						addAnimation("Standard", [0]);
						addAnimation("WalkL", [0, 1], 8);
						addAnimation("WalkR", [0, 1], 8);
						addAnimation("Attack", [1, 3], 6);
						addAnimation("Cast", [0, 4], 4);
						break;
					}
				case HeroType.GUNSLINGER:
					{
						loadGraphic(IMG.HERO_2, false, false, 18, 26);
						addAnimation("Standard", [0]);
						addAnimation("WalkL", [0, 1], 8);
						addAnimation("WalkR", [0, 1], 8);
						addAnimation("Attack", [1, 3], 6);
						addAnimation("Cast", [0, 4], 4);
						break;
					}
			}
		}
		
		private function initStats():void
		{
			switch(heroType)
			{
				case HeroType.BRAWLER:
					{
						maxHp = ((FlxU.random() * 30) + 70);
						curHp = maxHp;
						maxMp = ((FlxU.random() * 15) + 55);
						curMp = maxMp;
						atk = ((FlxU.random() * 10) + 10);
						mag = 0;
						spd = (FlxU.random() * 2) + 1;
						amr = 10;
						mr = 5;
						break;
					}
				case HeroType.GUNSLINGER:
					{
						maxHp = ((FlxU.random() * 15) + 45);
						curHp = maxHp;
						maxMp = ((FlxU.random() * 15) + 55);
						curMp = maxMp;
						atk = ((FlxU.random() * 25) + 25);
						mag = ((FlxU.random() * 5) + 5);
						spd = (FlxU.random() * 2) + 3;
						amr = 8;
						mr = 6;
						break;
					}
			}
		}
		
		private function initAbilities():void
		{
			switch(heroType)
			{
				case HeroType.BRAWLER:
					{
						for each(var a:Ability in HeroAbilities.BRAWLER)
						{
							abilities.push(a);
						}
						break;
					}
				case HeroType.GUNSLINGER:
					{
						for each(var a:Ability in HeroAbilities.GUNSLINGER)
						{
							abilities.push(a);
						}
						break;
					}
			}
		}
		
		public function getExpToNextLvl():int
		{
			var rate:Number = learnRate / 100;
			return Math.floor(15 * ((lvl / 2) + (3 * (lvl * rate)))) as int;
		}
		
		public function gainExp(expToGain:uint):void
		{
			exp += expToGain;
			while (exp >= getExpToNextLvl())
			{
				levelUp();
			}
		}
		
		private function levelUp():void
		{
			exp -= getExpToNextLvl();
			lvl++;
			switch(heroType)
			{
				case HeroType.BRAWLER:
					{
						maxHp += 3;
						curHp = maxHp;
						maxMp += 2;
						curMp = maxMp;
						atk += 1;
						mag += 0;
						spd += 0.2;
						amr += 0.5;
						mr += 0.25;
						break;
					}
			}
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