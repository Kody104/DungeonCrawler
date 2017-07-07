package 
{
	import org.flixel.FlxGame;
	
	[SWF(width = "512", height = "512", backgroundColor = "#000000")]
	
	/**
	 * ...
	 * @author Kody104
	 */
	
	public class Main extends FlxGame
	{
		
		public function Main():void 
		{
			super(512, 512, TestState);
		}		
	}
	
}