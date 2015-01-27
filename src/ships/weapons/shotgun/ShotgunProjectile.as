package ships.weapons.shotgun 
{
	import maths.Pair;
	import ships.Ship;
	import ships.weapons.Projectile;
	/**
	 * ...
	 * @author ...
	 */
	public class ShotgunProjectile extends Projectile
	{
		[Embed(source="../../../../assets/shotgun.png")]
		public static var bulletGraphic:Class;
		public function ShotgunProjectile(ship:Ship) 
		{
			super(ship, 4, .5+(Math.random()-.5)*.3, new bulletGraphic());
			randomiseAngle(.7);
			multiplyVector(Pair.getMagnitudeInDirection(ship.vector, Pair.unitAngle(ship.angle)) + 600 + Math.random() * 300);
		}
		protected override function advancedMove(delta:Number):void {
			vector = vector.multiplySingle(.85);
		}
		
		
		
	}

}