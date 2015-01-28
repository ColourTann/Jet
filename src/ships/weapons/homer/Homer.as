package ships.weapons.homer 
{
	import flash.media.Sound;
	import maths.Pair;
	import ships.Ship;
	import ships.weapons.Projectile;
	import ships.weapons.Weapon;
	/**
	 * ...
	 * @author ...
	 */
	public class Homer extends Weapon
	{	
	[Embed(source = "../../../../assets/homer.mp3")]
	public static var homerSoundFile:Class;	
	
	
	
	private static var range:Number = 300;
	
		public function Homer(ship:Ship) 
		{
			super(.8, 2, new homerSoundFile() as Sound, ship);
		}
		
		override public function fire():void {
			if (!canFire()) {
				return;
			}
			var fired:Boolean = false;
			for each (var s:Ship in Main.shipList) {
				if (s == ship) continue;
				var distance:Number = new Pair(s.x - ship.x, s.y - ship.y).getMagnitude();
				if (distance < range) {
					for (var i:int = -1; i <= 1; i += 2){
						var h:Projectile = new HomerProjectile(ship, s, i);
						Projectile.add(h);
						fired = true;
					}
				}
			}
			if(fired){
				shotAvailable = shotCooldown;
				ship.spend(cost);
				sound.play();
			}
		}
	}
}