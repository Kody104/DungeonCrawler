package battledata 
{
	import org.flixel.FlxText;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Kody104
	 */
	public class BattleText extends FlxText
	{
		public var bufferText:Array;
		protected var index:uint;
		protected var timer:Timer;
		
		public function BattleText(X:Number, Y:Number, Width:uint, Text:String=null, EmbeddedFont:Boolean=false)
		{
			super(X, Y, Width, Text, EmbeddedFont);
			bufferText = [];
			index = 0;
			timer = new Timer(2);
		}
		
		override public function update():void
		{
			if (visible)
			{
				if (timer.IsActive()) // Each time timer goes off, add a new character to dmg text
				{
					if (index < bufferText.length) // As long as we aren't over the bufferText length, add characters
					{
						text += bufferText[index];
						index++;
						timer.reset();
					}
					else if (index < bufferText.length + 9) // Give the text some time to display
					{
						index++;
						timer.reset();
					}
					else // Display off
					{
						visible = false; 
						timer.reset();
						index = 0;
						text = "";
						bufferText = [];
					}
				}
				else {
					timer.increment();
				}
			}
			super.update();
		}
		
	}

}