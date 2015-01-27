package ships.weapons.shotgun 
{
	import ships.weapons.Projectile;
	import ships.weapons.Weapon;
	/**
	 * ...
	 * @author ...
	 */
	public class Shotgun extends Weapon
	{
		
		public function Shotgun() 
		{
			if (!canFire()) {
				return;
			}
			shotAvailable = shotCooldown;
			sound.play();
			for (var i:int = 0; i < 10;i++){
				var b:Projectile = new ShotgunProjectile(this);
				Projectile.add(b);
			}
		}
		
	}

}