package ships 
{
	import flash.display.Bitmap;
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
		
		
		
		
		private var chargeAmount:Number = 0;
		public function Hopper(controller:Xbox360Controller) 
		{
			super(controller, new hopHull(), new hopLWing(), new hopRWing());
			setWeapon(new Uzi(this), 0);
			setWeapon(new Homer(this), 1);
			
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
			
			var p:Pair = Pair.unitAngle(angle);
			p = p.multiplySingle(chargeAmount * 350);
			var scaleX:Number = p.getMagnitude() / 128*((chargeAmount>0)?1:-1);
			HopperPort.addTrails(x, y, angle-.05, scaleX);
			
			
			
			teleport(p);
			
			
			chargeAmount = 0;
		}
		
		private function teleport(p:Pair):void {
			x += p.x;
			y += p.y;
		}
	}

}