package  
{
	import Abilities.Ability;
	import battledata.BattleText;
	import battledata.Target;
	import battledata.SkillTextBox;
	import battledata.TextBox;
	import battledata.Timer;
	import Abilities.StatusEffect;
	import Heroes.HeroAbilities;
	import Abilities.CastType;
	import Creatures.CreatureBase;
	import org.flixel.FlxG;
	import Creatures.Creature;
	import Creatures.CreatureType;
	import Heroes.Hero;
	import Heroes.HeroType;
	import enum.IMG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author Kody104
	 */
	public class BattleState extends FlxState
	{
		private var baseLayer:FlxGroup;
		private var midLayer:FlxGroup;
		private var topLayer:FlxGroup;
		
		private var creatures:Array;
		private var heroes:Array;
		
		private var statusDisplay:Array;
		
		private var enemyList:TextBox;
		private var heroList:TextBox;
		private var optionList:TextBox;
		private var skillInfo:TextBox;
		private var skillList:SkillTextBox;
		
		private var cursor:FlxSprite;
		private var selection:uint;
		private var battleState:int;
		
		private var hpLabel:FlxText;
		private var mpLabel:FlxText;
		private var optionSelectLabel:FlxText;
		private var dmgLabel:String;
		private var dmgText:BattleText;
		
		private var timer:Timer;
		private var selectedAbility:Array;
		
		private var enemySelect:uint;
		private var heroTurn:uint;
		private var targetList:Array;
		
		public function BattleState(Creatures:Array, Heroes:Array) 
		{
			baseLayer = new FlxGroup();
			midLayer = new FlxGroup();
			topLayer = new FlxGroup();
			
			creatures = Creatures;
			heroes = Heroes;
			targetList = new Array();
			
			statusDisplay = new Array();
			
			cursor = new FlxSprite(0, 0, IMG.CURSOR);
			cursor.visible = false;
			heroTurn = 0;
			selection = 0;
			battleState = 0;
			
			for (var i:uint = 0; i < creatures.length; i++)
			{
				if ( i > 5 )
				{
					creatures[i].x = 0;
					creatures[i].y = creatures[i].height * (i - 5);
				}
				else if ( i > 2 )
				{
					creatures[i].x = creatures[i].width;
					creatures[i].y = creatures[i].height * (i - 2);
				}
				else
				{
					creatures[i].x = creatures[i].width * 2;
					creatures[i].y = creatures[i].height * (i + 1);
				}
				midLayer.add(creatures[i]);
				
				var statusArea:FlxSprite = new FlxSprite(creatures[i].x + creatures[i].width, creatures[i].y - 2);
				statusDisplay.push(statusArea);
			}
			
			for (var i:uint = 0; i < heroes.length; i++)
			{
				heroes[i].x = 32 * 5;
				heroes[i].y = ((heroes[i].height * (i + 2)) + (i * 4));
				midLayer.add(heroes[i]);
				
				var statusArea:FlxSprite = new FlxSprite(heroes[i].x - 8, heroes[i].y - 2);
				statusDisplay.push(statusArea);
			}
			
			for (var i:uint = 0; i < statusDisplay.length; i++)
			{
				statusDisplay[i].visible = false;
				midLayer.add(statusDisplay[i]);
			}
			
			enemyList = new TextBox(0, 0, IMG.SMALLTEXTBOX);
			enemyList.x = 4;
			enemyList.y = (256 - enemyList.height) - 4;
			
			var enemyText:Array = new Array();
			for each(var c:Creature in creatures)
			{
				enemyText.push(new FlxText(0, 0, 56));
			}
			for (var i:uint = 0; i < enemyText.length; i++)
			{
				enemyText[i].x = enemyList.x + 8;
				if(i > 0)
					enemyText[i].y = ((enemyList.y + 8) + (10 * i));
				else
					enemyText[i].y = enemyList.y + 8;
				enemyText[i].text = creatures[i].getName();
			}
			enemyList.setText(enemyText);
			enemyList.addTo(topLayer);
			
			heroList = new TextBox(0, 0, IMG.BIGTEXTBOX);
			heroList.x = (256 - heroList.width) + 72.5;
			heroList.y = (256 - heroList.height) - 4;
			
			var heroText:Array = new Array();
			for each(var h:Hero in heroes)
			{
				heroText.push(new FlxText(0, 0, heroList.width - 8));
			}
			for (var i:uint = 0; i < heroText.length; i++)
			{
				heroText[i].text = heroes[i].getName() + "               " + heroes[i].getCurHp() + "/" + heroes[i].getMaxHp() + "          " + heroes[i].getCurMp() + "/" + heroes[i].getMaxMp();
			}
			heroList.setText(heroText);
			heroList.updateText();
			heroList.addTo(topLayer);
			
			optionList = new TextBox(0, 0, IMG.SMALLTEXTBOX);
			optionList.x = (256 - optionList.width) - 4;
			optionList.y = (256 - optionList.height) - 4;
			
			var optionText:Array = new Array();
			var attackText:FlxText = new FlxText(0, 0, optionList.width - 8, "Attack");
			var skillText:FlxText = new FlxText(0, 0, optionList.width - 8, "Skills");
			var itemsText:FlxText = new FlxText(0, 0, optionList.width - 8, "Items");
			var fleeText:FlxText = new FlxText(0, 0, optionList.width - 8, "Flee");
			optionText.push(attackText);
			optionText.push(skillText);
			optionText.push(itemsText);
			optionText.push(fleeText);
			optionList.setText(optionText);
			optionList.updateText();
			optionList.setVisible(false);
			optionList.addTo(topLayer);
			
			skillList = new SkillTextBox(0, 0, IMG.BIGTEXTBOX);
			skillList.x = 256;
			skillList.y = (256 - heroList.height) - 4;
			for (var i:uint = 0; i < heroes.length; i++)
			{
				var h:Hero = heroes[i];
				var text:Array = new Array();
				if (h.getAbilities().length == 0)
				{
					text.push(new FlxText(0, 0, skillList.width - 8, "No Skills..."));
				}
				for each(var a:Ability in h.getAbilities())
				{
					text.push(new FlxText(0, 0, skillList.width - 8, a.getName()));
				}
				skillList.setDict(i, text);
			}
			skillList.addTo(topLayer);
			
			skillInfo = new TextBox(0, 0, IMG.SMALLTEXTBOX);
			var skillInfoT:Array = new Array();
			skillInfoT.push(new FlxText(0, 0, skillInfo.width - 8));
			skillInfoT[0].text = "NULL";
			skillInfo.setText(skillInfoT);
			skillInfo.updateText();
			
			skillInfo.x = 434;
			skillInfo.y = (256 - heroList.height) - 4;
			skillInfo.addTo(topLayer);
			
			
			var hpX:Number = (4.15 * (heroes[0].getName().length + 15)); // 4.15 is close enough for each character right?
			var mpX:Number = hpX + (14 * 4.15);
			
			hpLabel = new FlxText(hpX, heroList.y + 6, 16, "HP");
			mpLabel = new FlxText(mpX, heroList.y + 6, 18, "MP");
			optionSelectLabel = new FlxText(optionList.x + 9, optionList.y + 6, 300, "-Select-");
			dmgText = new BattleText(0, 0, 36);
			hpLabel.visible = false;
			mpLabel.visible = false;
			optionSelectLabel.visible = false;
			dmgText.visible = false;
			
			timer = new Timer(12);
			selectedAbility = new Array();
			
			topLayer.add(hpLabel);
			topLayer.add(mpLabel);
			topLayer.add(optionSelectLabel);
			topLayer.add(dmgText);
			topLayer.add(cursor) // Make sure cursor stays on top
			
			add(baseLayer);
			add(midLayer);
			add(topLayer);
			enemyList.slide("LEFT", 30);
			heroList.slide("LEFT", 30);
		}
		
		private function sortAttacks():Array
		{
			var newList:Array = new Array();
			var copyList:Array = new Array();
			for each ( var t:Target in targetList)
			{
				var copyT:Target = new Target(t.getTargeter(), t.getTarget(), t.getAbility());
				copyList.push(copyT);
			}
			do
			{
				var best:int = -1;
				var index:int = -1;
				for (var i:uint = 0; i < copyList.length; i++)
				{
					if (copyList[i].getTargeter().getSpd() > best)
					{
						best = copyList[i].getTargeter().getSpd();
						index = i;
					}
				
				}
				newList.push(copyList[index]);
				copyList.removeAt(index);
			}
			while (copyList.length > 0);
			return newList;
		}
		
		private function updateStatusImages():void
		{
			for (var i:uint = 0; i < creatures.length; i++)
			{
				var c:Creature = creatures[i];
				if (c.getStatuses().length > 0)
				{
					var best:uint = 99;
					for each( var se:StatusEffect in c.getStatuses())
					{
						if (se.getType() < best)
						{
							best = se.getType();
						}
						switch(best)
						{
							case StatusEffect.MARK:
								{
									statusDisplay[i].loadGraphic(IMG.MARK_STATUSEFFECT, false, false, 8, 8);
									break;
								}
						}
						statusDisplay[i].visible = true;
					}
					continue;
				}
				else 
				{
					if (statusDisplay[i].visible)
						statusDisplay[i].visible = false;
				}
			}
		}
		
		private function updateHeroStats():void
		{
			for (var i:uint = 0; i < heroList.getText().length; i++)
			{
				heroList.getText()[i].text = heroes[i].getName() + "               " + heroes[i].getCurHp() + "/" + heroes[i].getMaxHp() + "          " + heroes[i].getCurMp() + "/" + heroes[i].getMaxMp();
			}
		}
		
		private function updateSkillInformation():void
		{
			var a:Ability = heroes[heroTurn].getAbilities()[selection];
			skillInfo.getText()[0].text = "Cost: " + a.getMpCost() + "\nDmg: " + a.getBaseDmg() ; 
		}
		
		private function updateCursor():void
		{
			if (battleState == 1)
			{
				cursor.x = creatures[enemySelect].x - 2;
				cursor.y = creatures[enemySelect].y + 16;
			}
			else if (battleState == 3)
			{
				cursor.x = skillList.getDict()[skillList.getActiveIndex()][selection].x - 16;
				cursor.y = skillList.getDict()[skillList.getActiveIndex()][selection].y;
			}
			else if (battleState == 4)
			{
				if (selectedAbility[heroTurn].getCastType() == CastType.ENEMIES)
				{
					cursor.x = creatures[enemySelect].x - 2;
					cursor.y = creatures[enemySelect].y;
				}
				else if (selectedAbility[heroTurn].getCastType() == CastType.SELF)
				{
					cursor.x = heroes[heroTurn].x - 2;
					cursor.y = heroes[heroTurn].y + 16;
				}
			}
			else 
			{
				switch(selection)
				{
					case 0:
						if (battleState == 0)
						{
							cursor.x = optionList.x - 8;
							cursor.y = optionList.y + 16;
						}
						else if (battleState == 1)
						{
							cursor.x = creatures[selection].x - 2;
							cursor.y = creatures[selection].y - 2;
						}
						break;
					case 1:
						if (battleState == 0)
						{
							cursor.x = optionList.x - 8;
							cursor.y = optionList.y + 26;
						}
						break;
					case 2:
						if (battleState == 0)
						{
							cursor.x = optionList.x  - 8;
							cursor.y = optionList.y + 36;
						}
						break;
					case 3:
						if (battleState == 0)
						{
							cursor.x = optionList.x - 8;
							cursor.y = optionList.y + 46;
							//cursor.scale.x *= -1 - This is how you reverse an image
						}
						break;
				}
			}
		}
		
		override public function update():void
		{	
			if (enemyList.isAnimating() || heroList.isAnimating() || optionList.isAnimating() || skillList.isAnimating() || skillInfo.isAnimating())
			{
				super.update();
				return;
			}
			else if (dmgText.visible)
			{
				super.update();
				return;
			}
			
			updateCursor();
			updateStatusImages();
			
			if (battleState == 0) // Select action
			{
				if (!cursor.visible)
				{
					cursor.visible = true;
				}
				if (!optionList.visible)
				{
					optionList.setVisible(true);
						if (!optionSelectLabel.visible)
							optionSelectLabel.visible = true;
				}
				if (!hpLabel.visible)
					hpLabel.visible = true;
				if (!mpLabel.visible)
					mpLabel.visible = true;
				if (!optionSelectLabel.visible)
					optionSelectLabel.visible = true;
				if (FlxG.keys.justPressed("W"))
				{
					if (selection > 0)
					{
						selection--;
					}
				}
				if (FlxG.keys.justPressed("S"))
				{
					if (selection < 3)
					{
						selection++;
					}
				}
				if (FlxG.keys.justPressed("SPACE"))
				{
					if (selection == 0)
					{
						battleState = 1;
						selectedAbility[heroTurn] = null;
					}
					else if (selection == 1)
					{
						selection = 0;
						heroList.slide("LEFT", 50);
						optionList.slide("LEFT", 50);
						skillList.slide("LEFT", 50);
						skillInfo.slide("LEFT", 50);
						hpLabel.visible = false;
						mpLabel.visible = false;
						optionSelectLabel.visible = false;
						battleState = 3;
						cursor.visible = false;
					}
				}
			}
			else if (battleState == 1) // Select enemy for attack.
			{
				if (FlxG.keys.justPressed("S"))
				{
					if (enemySelect < creatures.length-1)
					{
						enemySelect++;
					}
				}
				if (FlxG.keys.justPressed("W"))
				{
					if (enemySelect > 0)
					{
						enemySelect--;
					}
				}
				if (FlxG.keys.justPressed("A"))
				{
					if (enemySelect < 6)
					{
						enemySelect += 3;
					}
				}
				if (FlxG.keys.justPressed("D"))
				{
					if (enemySelect > 2)
					{
						enemySelect -= 3;
					}
				}
				if (FlxG.keys.justPressed("SPACE"))
				{
					targetList.push(new Target(heroes[heroTurn], creatures[enemySelect]));
					selection = 0;
					enemySelect = 0;
					heroTurn++;
					skillList.setActiveIndex(heroTurn);
					if (heroTurn < heroes.length)
					{
						battleState = 0;
					}
					else
					{
						heroTurn = 0;
						skillList.setActiveIndex(heroTurn);
						for each( var c:Creature in creatures )
						{
							targetList.push(new Target(c, c.selectTarget(heroes)));
						}
						targetList = sortAttacks();
						battleState = 2;
						if (targetList[0].getTargeter() instanceof Creature)
						{
							targetList[0].getTargeter().playAnimation("WalkR", 5);
							targetList[0].getTargeter().playAnimation("Attack", 8); 
							targetList[0].getTargeter().playAnimation("WalkL", 5); 
						}
						else
						{
							targetList[0].getTargeter().playAnimation("WalkL", 25); 
							targetList[0].getTargeter().playAnimation("Attack", 45); 
							targetList[0].getTargeter().playAnimation("WalkR", 25); 
						}
						cursor.visible = false;
					}
				}
				if (FlxG.keys.justPressed("ESCAPE"))
				{
					selection = 0;
					enemySelect = 0;
					battleState = 0;
				}
			}
			else if (battleState == 2) // A little time pass before the damage text displays
			{
				if (targetList.length == 0) // Reset battlestate
				{
					selection = 0;
					battleState = 0;
					enemySelect = 0;
					timer.reset();
					super.update();
					return;
				}
				else if (targetList[0].getTargeter().IsAnimating()) // Let animation go first
				{
					super.update();
					return;
				}
				else if (timer.IsActive()) // if we're finished with timer
				{
					if (dmgText.visible) // If the text is still displaying
					{
						super.update();
						return;
					}
					
					if (targetList[0].getTarget().hasStatusEffect(StatusEffect.DEFENSE_MARK)) // Stop the attack if target has a defensive mark
					{
						dmgLabel = "0";
						targetList[0].getTargeter().addStatusEffect(new StatusEffect(StatusEffect.MARK, 2, 1.25));
						targetList[0].getTarget().removeStatusEffect(StatusEffect.DEFENSE_MARK);
					}
					else // Regular attack
					{
						dmgLabel = "" + targetList[0].getTarget().takeDamage(targetList[0].getTargeter(), targetList[0].getAbility());
						if (targetList[0].getAbility() != null)
						{
							targetList[0].getTargeter().useAbility(targetList[0].getAbility());
						}
					}
					updateHeroStats();
					dmgText.bufferText = dmgLabel.split('');
					dmgText.visible = true;
					dmgText.x = targetList[0].getTarget().x + targetList[0].getTarget().width;
					dmgText.y = targetList[0].getTarget().y + (targetList[0].getTarget().height / 2) - 10;
					targetList[0].getTargeter().tickStatuses();
					targetList.shift();
					if (targetList.length > 0)
					{
						while(!targetList[0].getTargeter().canAttack())
						{
							targetList.shift();
						}
						if (targetList[0].getTargeter() instanceof Creature)
						{
							targetList[0].getTargeter().playAnimation("WalkR", 5);
							targetList[0].getTargeter().playAnimation("Attack", 5);
							targetList[0].getTargeter().playAnimation("WalkL", 5);
						}
						else
						{
							targetList[0].getTargeter().playAnimation("WalkL", 25);
							targetList[0].getTargeter().playAnimation("Attack", 45);
							targetList[0].getTargeter().playAnimation("WalkR", 25);
						}
					}
					timer.reset();
				}
				else {
					timer.increment();
				}
			}
			else if (battleState == 3) // Select skill to attack with
			{
				updateSkillInformation();
				
				if (!cursor.visible)
				{
					cursor.visible = true;
				}
				if (FlxG.keys.justPressed("W"))
				{
					if (selection > 0)
					{
						selection--;
					}
				}
				if (FlxG.keys.justPressed("S"))
				{
					if (selection < skillList.getDict()[skillList.getActiveIndex()].length - 1)
					{
						selection++;
					}
				}
				if (FlxG.keys.justPressed("SPACE"))
				{
					if (heroes[heroTurn].getAbilities()[selection].getMpCost() <= heroes[heroTurn].getCurMp())
					{
						selectedAbility[heroTurn] = heroes[heroTurn].getAbilities()[selection];
						selection = 0;
						battleState = 4;
					}
				}
				if (FlxG.keys.justPressed("ESCAPE"))
				{
					selection = 0;
					battleState = 0;
					heroList.slide("RIGHT", 50);
					optionList.slide("RIGHT", 50);
					skillList.slide("RIGHT", 50);
					skillInfo.slide("RIGHT", 50);
					cursor.visible = false;
				}
			}
			else if (battleState == 4) // Select target of skill attack.
			{
				trace(selectedAbility[heroTurn].getName());
				if (selectedAbility[heroTurn].getCastType() == CastType.ENEMIES) // Only enemies are selectable
				{
					if (FlxG.keys.justPressed("S"))
					{
						if (enemySelect < creatures.length-1)
						{
							enemySelect++;
						}
					}
					if (FlxG.keys.justPressed("W"))
					{
						if (enemySelect > 0)
						{
							enemySelect--;
						}
					}
					if (FlxG.keys.justPressed("A"))
					{
						if (enemySelect < 6)
						{
							enemySelect += 3;
						}
					}
					if (FlxG.keys.justPressed("D"))
					{
						if (enemySelect > 2)
						{
							enemySelect -= 3;
						}
					}
					if (FlxG.keys.justPressed("SPACE"))
					{
						targetList.push(new Target(heroes[heroTurn], creatures[enemySelect], selectedAbility[heroTurn]));
						heroList.slide("RIGHT", 50);
						optionList.slide("RIGHT", 50);
						skillList.slide("RIGHT", 50);
						skillInfo.slide("RIGHT", 50);
						cursor.visible = false;
						selection = 0;
						enemySelect = 0;
						heroTurn++;
						skillList.setActiveIndex(heroTurn);
						if (heroTurn < heroes.length)
						{
							battleState = 0;
						}
						else
						{
							heroTurn = 0;
							skillList.setActiveIndex(heroTurn);
							for each( var c:Creature in creatures )
							{
								targetList.push(new Target(c, c.selectTarget(heroes)));
							}
							targetList = sortAttacks();
							battleState = 2;
							if (targetList[0].getTargeter() instanceof Creature)
							{
								targetList[0].getTargeter().playAnimation("WalkR", 5);
								targetList[0].getTargeter().playAnimation("Attack", 8); 
								targetList[0].getTargeter().playAnimation("WalkL", 5); 
							}
							else
							{
								targetList[0].getTargeter().playAnimation("WalkL", 25); 
								targetList[0].getTargeter().playAnimation("Attack", 45); 
								targetList[0].getTargeter().playAnimation("WalkR", 25); 
							}
							cursor.visible = false;
						}
					}
					if (FlxG.keys.justPressed("ESCAPE"))
					{
						selection = 0;
						enemySelect = 0;
						battleState = 3;
					}
				}
				else if (selectedAbility[heroTurn].getCastType() == CastType.SELF)
				{
					if (FlxG.keys.justPressed("SPACE"))
					{
						targetList.push(new Target(heroes[heroTurn], heroes[heroTurn], selectedAbility[heroTurn]));
						heroList.slide("RIGHT", 50);
						optionList.slide("RIGHT", 50);
						skillList.slide("RIGHT", 50);
						skillInfo.slide("RIGHT", 50);
						cursor.visible = false;
						selection = 0;
						enemySelect = 0;
						heroTurn++;
						skillList.setActiveIndex(heroTurn);
						if (heroTurn < heroes.length)
						{
							battleState = 0;
						}
						else
						{
							heroTurn = 0;
							skillList.setActiveIndex(heroTurn);
							for each( var c:Creature in creatures )
							{
								targetList.push(new Target(c, c.selectTarget(heroes)));
							}
							targetList = sortAttacks();
							battleState = 2;
							if (targetList[0].getTargeter() instanceof Creature)
							{
								targetList[0].getTargeter().playAnimation("WalkR", 5);
								targetList[0].getTargeter().playAnimation("Attack", 8); 
								targetList[0].getTargeter().playAnimation("WalkL", 5); 
							}
							else
							{
								targetList[0].getTargeter().playAnimation("WalkL", 25); 
								targetList[0].getTargeter().playAnimation("Attack", 45); 
								targetList[0].getTargeter().playAnimation("WalkR", 25); 
							}
							cursor.visible = false;
						}
					}
					if (FlxG.keys.justPressed("ESCAPE"))
					{
						selection = 0;
						enemySelect = 0;
						battleState = 3;
					}
				}
			}
			
			super.update();
		}
		
	}

}