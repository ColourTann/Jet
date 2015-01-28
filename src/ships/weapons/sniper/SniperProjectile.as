package ships.weapons.sniper 
{
	import maths.Utility;
	import ships.Ship;
	import ships.weapons.Projectile;
	/**
	 * ...
	 * @author ...
	 */
	public class SniperProjectile extends Projectile
	{
		[Embed(source = "../../../../assets/snipe.png")]
		public static var bulletGraphic:Class;
		public function SniperProjectile(ship:Ship) 
		{
			super(ship, 8, .7, new bulletGraphic());
			multiplyVector(1220);
			rotation = Utility.rad2Deg(-angle);
		}
		
		protected override function advancedMove(delta:Number):void {
			vector = vector.multiplySingle(.98);
		}
		
	}

}