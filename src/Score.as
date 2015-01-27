package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import ships.Ship;
	/**
	 * ...
	 * @author ...
	 */
	public class Score extends Sprite
	{
		[Embed(source = "../assets/skull.png")]
		public static var skullGraphic:Class;
		
		private static var gap:int = 17;
		private static var totalWidth:Number = gap * 5+gap*2/3;
		private static var totalHeight:Number= gap * 2+gap*2/3;
		private var kills:int;
		private var ship:Ship;
		private var r:int;
		private var g:int;
		private var b:int;
		public function Score(ship:Ship, r:int, g:int, b:int) 
		{
			if (ship.ID %2== 0) {
				x = 0;
			}
			else {
				x = Main.stageWidth -totalWidth;
			}
			if (ship.ID == 0 || ship.ID == 3) {
				y = 0;
			}
			else {
				y = Main.stageHeight -totalHeight;
			}
			this.r = r;
			this.g = g;
			this.b = b;
			
			this.ship = ship;

			alpha = 1;
		}
		
		
		public function addKill():void {
			
			if (Main.isPaused()) {
				return;
			}
			var skull:Bitmap = new skullGraphic();
			skull.x = gap/3 + (kills % 5) * gap;
			skull.y = gap/3 + ((kills < 5)?0:gap);
			skull.scaleX = 2;
			skull.scaleY = 2;
			skull.transform.colorTransform = new ColorTransform(r / 255, g / 255, b / 255, 1, 0, 0, 0, 0);
			addChild(skull);
			kills++;
			if (kills >= 10) {
				Main.win(r, g, b);
			}
		}
		
	}

}