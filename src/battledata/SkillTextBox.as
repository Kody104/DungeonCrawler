package battledata 
{
	import flash.utils.Dictionary;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author Kody104
	 */
	public class SkillTextBox extends FlxSprite
	{
		protected var dict:Dictionary;
		protected var activeIndex:uint;
		protected var childrenVisible:Boolean;
		protected var lastMove:String;
		protected var numOfFrameSlide:uint;
		
		public function SkillTextBox(X:Number=0,Y:Number=0,SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			dict = new Dictionary();
			activeIndex = 0;
			childrenVisible = true;
			lastMove = "";
			numOfFrameSlide = 0;
		}
		
		public function setActiveIndex(ActiveIndex:uint):void
		{
			activeIndex = ActiveIndex;
		}
		
		public function getActiveIndex():uint
		{
			return activeIndex;
		}
		
		public function getDict():Dictionary
		{
			return dict;
		}
		
		public function setDict(hero:uint, text:Array):void
		{
			dict[hero] = text;
		}
		
		public function addTo(layer:FlxGroup):void
		{
			layer.add(this);
			for each (var value:Array in dict)
			{
				for each(var text:FlxText in value)
				{
					text.visible = false;
					layer.add(text);
				}
			}
		}
		
		public function isAnimating():Boolean
		{
			return numOfFrameSlide > 0;
		}
		
		public function slide(Direction:String, NumOfFrames:uint=10):void
		{
			if (Direction == "LEFT")
			{
				lastMove = Direction;
				numOfFrameSlide = NumOfFrames;
			}
			else if (Direction == "RIGHT")
			{
				lastMove = Direction;
				numOfFrameSlide = NumOfFrames;
			}
		}
		
		public function updateText():void
		{
			for (var i:uint = 0; i < dict[activeIndex].length; i++)
			{
				dict[activeIndex][i].x = x + 8;
				if (i > 0)
					dict[activeIndex][i].y = (y + 16) + (10 * i);
				else
					dict[activeIndex][i].y = y + 16;
			}
		}
		
		override public function update():void
		{
			if (numOfFrameSlide > 0)
			{
				for each (var v:Array in dict)
				{
					for each(var i:FlxText in v)
					{
						if (i.visible)
							i.visible = false; // Make children flash objects unvisible
					}
				}
				if (lastMove == "LEFT")
				{
					x -= 5.05;
				}
				else if (lastMove == "RIGHT")
				{
					x += 5.05;
				}
				numOfFrameSlide--;
			}
			else {
				if(x > -1 && y > -1) {
					for each (var i:FlxText in dict[activeIndex]) // Make children flash objects visible
					{
						if (childrenVisible) // Make sure it's wanted to be visible
						{
							if (!i.visible)
							{
								i.visible = true;
							}
							updateText();
						}
						else
						{
							if (i.visible)
								i.visible = false
						}
					}
				}
				else {
					visible = false;
				}
			}
			
			super.update();
		}
	}

}