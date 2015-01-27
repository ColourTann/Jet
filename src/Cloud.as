package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Cloud extends Sprite
	{
		[Embed(source = "../assets/cloud.png")]
		public static var embed:Class;
		
		
		public function Cloud() 
		{
			x = Math.random() * Main.stageWidth;
			y = Math.random() * Main.stageHeight;
			var cloudImage:Bitmap = new embed();
			addChild(cloudImage);
			
		}
		
	}

}