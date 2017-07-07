package Creatures 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Animation 
	{
		private var animToPlay:String;
		private var numOfFrames:int;
		
		public function Animation(AnimToPlay:String, NumOfFrames:int) 
		{
			animToPlay = AnimToPlay;
			numOfFrames = NumOfFrames;
		}
		
		public function tick():void
		{
			numOfFrames--;
		}
		
		public function getAnimToPlay():String
		{
			return animToPlay;
		}
		
		public function getNumOfFrames():int
		{
			return numOfFrames;
		}
		
	}

}