package ships.weapons.shotgun 
{
	import flash.media.Sound;
	import ships.Ship;
	import ships.weapons.Projectile;
	import ships.weapons.Weapon;
	/**
	 * ...
	 * @author ...
	 */
	public class Shotgun extends Weapon
	{
		[Embed(source="../../../../assets/shotgun.mp3")]
		public static var shotgunSoundFile:Class;
		public function Shotgun(ship:Ship) 
		{
			super(.8, new shotgunSoundFile() as Sound, ship);
		}
		
		override public function fire():void {
			if (!canFire()) {
				return;
			}
			shotAvailable = shotCooldown;
			sound.play();
			for (var i:int = 0; i < 10;i++){
				var b:Projectile = new ShotgunProjectile(ship);
				Projectile.add(b);
			}
		}
		
	}

}