package ships.weapons.sniper 
{
	import flash.media.Sound;
	import ships.Ship;
	import ships.weapons.Projectile;
	import ships.weapons.Weapon;
	/**
	 * ...
	 * @author ...
	 */
	public class Sniper extends Weapon
	{
		[Embed(source = "../../../../assets/sniper.mp3")]
		public static var sniperSoundFile:Class;
		public function Sniper(ship:Ship) 
		{
			super(.3, .45, new sniperSoundFile() as Sound, ship);
		}
		
		override public function fire():void {
			if (!canFire()) {
				return;
			}
			ship.spend(cost);
			shotAvailable = shotCooldown;
			sound.play();
			for (var i:int = 0; i < 1;i++){
				var b:Projectile = new SniperProjectile(ship);
				Projectile.add(b);
			}
		}
	}

}