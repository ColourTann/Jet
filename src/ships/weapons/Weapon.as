package ships.weapons 
{
	import flash.media.Sound;
	/**
	 * ...
	 * @author ...
	 */
	public class Weapon 
	{
		internal var shotAvailable:Number = 0;
		internal var shotCooldown:Number;
		internal var sound:Sound;
		public function Weapon(cooldown:Number, sound:Sound) 
		{
			this.shotCooldown = cooldown;
			this.sound = sound;
		}
		public function fire() {
		
		}
		internal function canFire():Boolean {
			return shotAvailable <= 0;
		}
		internal function update(delta:Number):void {
			shotAvailable-= delta;
		}
	}
}