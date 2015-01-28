package ships 
{
	import flash.display.Bitmap;
	import flash.media.Sound;
	import io.arkeus.ouya.controller.Xbox360Controller;
	import maths.Pair;
	import maths.Utility;
	import ships.weapons.homer.Homer;
	import ships.weapons.shotgun.Shotgun;
	import ships.weapons.sniper.Sniper;
	import ships.weapons.uzi.Uzi;
	/**
	 * ...
	 * @author ...
	 */
	public class Hopper extends Ship
	{
		
		private static var minimumCharge:Number = .2;
		private static var maximumCharge:Number = 1.2;

		
		[Embed(source="../../assets/hopperhull.png")]
		public static var hopHull:Class;
		[Embed(source="../../assets/hopperleftwing.png")]
		public static var hopLWing:Class;
		[Embed(source="../../assets/hopperrightwing.png")]
		public static var hopRWing:Class;
		
		[Embed(source="../../assets/teleport.mp3")]
		public static var teleSoundFile:Class;
		
		private var outlines:Vector.<HopperOutline>= new Vector.<HopperOutline>();
		
		private var teleSound:Sound = new teleSoundFile() as Sound;
		
		private var chargeAmount:Number = 0;
		public function Hopper(controller:Xbox360Controller) 
		{
			super(controller, new hopHull(), new hopLWing(), new hopRWing());
			setWeapon(new Uzi(this), 0);
			setWeapon(new Homer(this), 1);
			for (var i:int = 0; i < 9; i++) {
				var ol:HopperOutline = new HopperOutline();
				outlines.push(ol);
				Main.map.addChild(ol);
			}
			
			
		}
		
		protected override function checkSpecials(delta:Number):void {
			
			
			if (controller.lt.held) {
				charge(-delta);
			}
			else if (controller.rt.held) {
				charge(+delta);
			}
			else {
				release();
			}
		
			var index:int = 0;
			for (var xx:int = -1; xx <= 1; xx++) {
				for (var yy:int = -1; yy <= 1; yy++) {
					var outline:HopperOutline = outlines[index];
					outline.alpha = (Math.abs(chargeAmount) < minimumCharge)?0:1;
					outline.rotation = Utility.rad2Deg( -angle);
					var p:Pair = getTeleportLoc();
					var wiggle:Pair = Pair.unitAngle(angle+Math.PI/2).multiplySingle(16);
					outline.x = x+p.x		+wiggle.x			+(xx*(Main.stageWidth+shipWidth*1));
					outline.y = y+p.y		+wiggle.y			+(yy*(Main.stageHeight+shipWidth*1));
					index++;
				}
			}
			
			
			
			//need sound//
			
		}
	
		protected function charge(amount:Number):void {
			chargeAmount += amount;
			//trace(chargeAmount);
			if (Math.abs(chargeAmount) > maximumCharge) {
				chargeAmount = maximumCharge * ((chargeAmount > 0)?1: -1);
			}
		}
		
		protected function release():void {
			if (Math.abs(chargeAmount) < minimumCharge) {
				chargeAmount = 0;
				return;
			}
			
			var p:Pair = getTeleportLoc();
			var scaleX:Number = p.getMagnitude() / 128 * ((chargeAmount > 0)?1: -1);
			
			var wiggle:Pair = Pair.unitAngle(angle+Math.PI/2).multiplySingle(6);
			
			
			HopperTrail.addTrails(x+wiggle.x , y + wiggle.y, angle, scaleX);
			
			
			
			teleport(p);
			
			
			chargeAmount = 0;
		}
		
		protected function getTeleportLoc():Pair {
			var p:Pair = Pair.unitAngle(angle);
			p = p.multiplySingle(chargeAmount * 350);
			return p;
		}
		
		private function teleport(p:Pair):void {
			x += p.x;
			y += p.y;
			teleSound.play();
		}
	}

}