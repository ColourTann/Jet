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
			super(ship, 4, new bulletGraphic());
			randomiseAngle(.6);
			multiplyVector(Pair.getMagnitudeInDirection(ship.vector, Pair.unitAngle(ship.angle)) + 700 + Math.random() * 300);
		}
		
		override public function fire() {
			if (shotAvailable > 0) {
				return;
			}
			shotAvailable = shotCooldown;
			sound.play();
			for (var i:int = 0; i < 10;i++){
				var b:Projectile=new ShotgunProjectile(this);
				bullets.push(b);
				Main.map.addChild(b);
			}
		}
		
	}

}