package ships 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import maths.Utility;
	/**
	 * ...
	 * @author ...
	 */
	public class HopperPort extends Sprite
	{
		[Embed(source="../../assets/teleport.png")]
		public static var telefile:Class;
		
		public function HopperPort() 
		{
			
		}
		
		public static function addTrails(x:Number, y:Number, angle:Number, scaleX:Number):void {
			for (var xx:int = -1; xx <= 1; xx++) {
				for (var yy:int = -1; yy <= 1; yy++) {
					addTrail(x, y, angle, scaleX, xx, yy);
				}
			}
			
		}
		
		private static function addTrail(x:Number, y:Number, angle:Number, scaler:Number, bonusX, bonusY):void {
			var telep:Bitmap = new telefile();
			telep.x = x+bonusX*Main.stageWidth;
			telep.y = y + bonusY * Main.stageHeight;
			telep.scaleX = scaler;
			telep.scaleY = -1;
			telep.rotation = Utility.rad2Deg( -angle);
			
			Main.map.addChild(telep);
		}
		
	}

}