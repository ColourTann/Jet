package ships.weapons.uzi 
{
	import flash.media.Sound;
	import ships.Ship;
	import ships.weapons.Projectile;
	import ships.weapons.Weapon;
	/**
	 * ...
	 * @author ...
	 */
	public class Uzi extends Weapon
	{
		[Embed(source = "../../../../assets/uzi.mp3")]
		public static var uziSoundFile:Class;
		public function Uzi(ship:Ship) 
		{
			super(.1, .1, new uziSoundFile() as Sound, ship);
		}
		override public function fire():void {
			if (!canFire()) {
				return;
			}
			ship.spend(cost);
			shotAvailable = shotCooldown;
			sound.play();
			for (var i:int = 0; i < 1;i++){
				var b:Projectile = new UziProjectile(ship);
				Projectile.add(b);
			}
		}
		
	}

}