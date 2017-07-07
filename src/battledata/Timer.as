package battledata 
{
	/**
	 * ...
	 * @author Kody104
	 */
	public class Timer 
	{
		private var isTerminated:Boolean;
		private var isActive:Boolean;
		private var timeCounter:Number;
		private var maxTimerCounter:Number;
		
		public function Timer(MaxTime:Number) 
		{
			isTerminated = false;
			isActive = false;
			timeCounter = 0;
			maxTimerCounter = MaxTime;
		}
		
		public function increment():void
		{
			timeCounter++;
			if (timeCounter > maxTimerCounter)
			{
				isActive = true;
			}
		}
		
		public function reset():void
		{
			timeCounter = 0;
			isActive = false;
		}
		
		public function IsTerminated():Boolean
		{
			return isTerminated;
		}
		
		public function terminate():void
		{
			isTerminated = true;
		}
		
		public function IsActive():Boolean
		{
			return isActive;
		}
		
	}

}