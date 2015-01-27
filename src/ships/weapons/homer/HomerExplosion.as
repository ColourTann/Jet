package ships.weapons.homer 
{
	import flash.media.Sound;
	import maths.Pair;
	import ships.Ship;
	import ships.weapons.Projectile;
	/**
	 * ...
	 * @author ...
	 */
	public class HomerExplosion extends Projectile
	{
		[Embed(source = "../../../../assets/homerexplosion.png")]
		public static var homerExplosion:Class;
		
		[Embed(source = "../../../../assets/homerexplosion.mp3")]
		public static var homerSoundFile:Class;	
		
		public function HomerExplosion(ship:Ship, origin:HomerProjectile) 
		{
			super(ship, 30, .4, new homerExplosion());
			(new homerSoundFile() as Sound).play();
			vector = new Pair(0, 0);
			x = origin.x;
			y = origin.y;
			destroyOnHit = false;
			playDeathSound = false;
		}
		protected override function advancedMove(delta:Number):void {
			alpha = life*2;
		}
	}

}