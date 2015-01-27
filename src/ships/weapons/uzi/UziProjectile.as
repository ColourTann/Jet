package ships.weapons.uzi 
{
	import maths.Utility;
	import ships.Ship;
	import ships.weapons.Projectile;
	/**
	 * ...
	 * @author ...
	 */
	public class UziProjectile extends Projectile
	{
		[Embed(source = "../../../../assets/uzi.png")]
		public static var uziGraphic:Class;
		public function UziProjectile(ship:Ship) 
		{
			super(ship, 4, .5 + (Math.random() - .5) * .4, new uziGraphic());
			randomiseAngle(.2);
			multiplyVector(900);
			rotation = Utility.rad2Deg(-angle);
		}
		protected override function advancedMove(delta:Number):void {
			vector = vector.multiplySingle(.98);
		}
	}

}