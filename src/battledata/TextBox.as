package battledata 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author Kody104
	 */
	public class TextBox extends FlxSprite
	{
		protected var childrenVisible:Boolean;
		protected var text:Array;
		protected var lastMove:String;
		protected var numOfFrameSlide:uint;
		
		public function TextBox(X:Number=0,Y:Number=0,SimpleGraphic:Class=null, Text:Array=null) 
		{
			super(X, Y, SimpleGraphic);
			childrenVisible = true;
			lastMove = "";
			numOfFrameSlide = 0;
			if (Text == null)
				text = [];
			else
				text = Text;
		}
		
		public function setVisible(Visible:Boolean):void
		{
			this.visible = Visible;
			childrenVisible = Visible;
			for each(var i:FlxText in text)
			{
				i.visible = Visible;
			}
		}
		
		public function setChildrenVisible(Visible:Boolean):void
		{
			childrenVisible = Visible;
			for each(var i:FlxText in text)
			{
				i.visible = Visible;
			}
		}
		
		public function setText(Text:Array):void
		{
			text = Text;
		}
		
		public function getText():Array
		{
			return text;
		}
		
		public function isAnimating():Boolean
		{
			return numOfFrameSlide > 0;
		}
		
		public function slide(Direction:String, NumOfFrames:uint = 10):void
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
		
		public function addTo(layer:FlxGroup):void
		{
			layer.add(this);
			for each (var i in text)
			{
				layer.add(i);
			}
		}
		
		public function updateText():void
		{
			for (var i:uint = 0; i < text.length; i++)
			{
				text[i].x = x + 8;
				if (i > 0)
					text[i].y = (y + 16) + (10 * i);
				else
					text[i].y = y + 16;
			}
		}
		
		override public function update():void
		{
			if (numOfFrameSlide > 0)
			{
				for each (var i in text) // Make children flash objects unvisible
				{
					if (i.visible)
						i.visible = false;
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
					for each (var i in text) // Make children flash objects visible
					{
						if (childrenVisible) // Make sure it's wanted to be visible
						{
							if (!i.visible)
							{
								i.visible = true;
							}
							updateText();
						}
					}
					if (childrenVisible)
					{
						if(!visible)
							visible = true;
					}
				}
				else {
					if(visible)
						visible = false;
				}
			}
			
			super.update();
		}
	}

}