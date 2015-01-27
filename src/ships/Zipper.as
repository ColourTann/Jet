package ships 
{
	import io.arkeus.ouya.controller.Xbox360Controller;
	import maths.Utility;
	import ships.weapons.Projectile;
	import ships.weapons.shotgun.Shotgun;
	import ships.weapons.shotgun.ShotgunProjectile;
	import ships.weapons.sniper.Sniper;
	/**
	 * ...
	 * @author ...
	 */
	public class Zipper extends Ship
	{
		//graphics//
		
		[Embed(source="../../assets/zipperhull.png")]
		public static var zipHull:Class;
		[Embed(source="../../assets/zipperleftwing.png")]
		public static var zipLWing:Class;
		[Embed(source="../../assets/zipperrightwing.png")]
		public static var zipRWing:Class;
		
		
		public function Zipper(controller:Xbox360Controller) 
		{
			super(controller, new zipHull(), new zipLWing(), new zipRWing());
			setWeapon(new Sniper(this), 0);
			setWeapon(new Shotgun(this), 1);
		}
		
		protected override function checkSpecials(delta:Number):void {
			if (controller.lt.pressed) {
				stall();
			}
			
			if (controller.rt.pressed) {
				boost();
			}
			
		}
	
		protected function stall():void {
			velocity = 0;
			engineEngaged = false;
		}
		
		protected function boost():void {
			if (boostAvailable > 0) return;
			boostAvailable = boostCooldown;
			boostSound.play();
			enginePower = 5;
			engineEngaged = true;
			//velocity = Pair.getMagnitudeInDirection(Pair.unitAngle(angle), vector);
			//velocity = Pair.average(Pair.unitAngle(angle).multiplySingle(velocity), vector).getMagnitude();
			velocity = vector.getMagnitude()+boostPower;
			
		}
			
		
	}

}