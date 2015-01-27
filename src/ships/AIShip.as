package ships 
{
	/**
	 * ...
	 * @author ...
	 */
	public class AIShip extends Ship
	{
		var dir:Number;
		public function AIShip() 
		{
			super();
			dir = Math.random() - .5;
			x = Math.random() * Main.stageWidth;
			y = Math.random() * Main.stageHeight;
		}
		
		override function input(delta:Number):void {
			angle+= delta*dir;
			
		}
	
		
	}

}