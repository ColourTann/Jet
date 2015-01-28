package ships 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import maths.Utility;
	/**
	 * ...
	 * @author ...
	 */
	public class HopperTrail extends Sprite
	{
		
		private static var hopperTrails:Vector.<HopperTrail> = new Vector.<HopperTrail>();
		
		[Embed(source="../../assets/teleport.png")]
		public static var telefile:Class;
		
		public var dead:Boolean;
		
		public function HopperTrail() 
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
			telep.x = x+bonusX*(Main.stageWidth-Ship.shipWidth*1);
			telep.y = y + bonusY * (Main.stageHeight + Ship.shipWidth * 1);
			telep.scaleX = scaler;
			telep.rotation = Utility.rad2Deg(-angle);
			var trail:HopperTrail = new HopperTrail();
			trail.addChild(telep);
			hopperTrails.push(trail);
			Main.map.addChild(trail);
		}
		
		private function update (delta:Number):void {
			alpha -= delta * 3;
			if (alpha <= 0) dead = true;
		}
		
		public static function updateTrails(delta:Number):void {
			for (var i:int = hopperTrails.length - 1; i >= 0; i--) {
				var trail:HopperTrail = hopperTrails[i];
				trail.update(delta);
				if (trail.dead) {
					Main.map.removeChild(trail);
					hopperTrails.splice(i, 1);
				}
			}
		}
		
		
	}

}