package ships 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class HopperOutline extends Sprite
	{
		[Embed(source = "../../assets/hopperoutline.png")]
		public static var hopOutline:Class;
		public function HopperOutline() 
		{
			addChild(new hopOutline);
			//could add as child of hopper...//
		}
		
		
		
	}

}