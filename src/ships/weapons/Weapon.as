package ships.weapons 
{
	import flash.media.Sound;
	import ships.Ship;
	/**
	 * ...
	 * @author ...
	 */
	public class Weapon 
	{
		protected var shotAvailable:Number = 0;
		protected var shotCooldown:Number;
		protected var sound:Sound;
		protected var ship:Ship
		public function Weapon(cooldown:Number, sound:Sound, ship:Ship) 
		{
			this.shotCooldown = cooldown;
			this.sound = sound;
			this.ship = ship;
		}
		public function fire():void {
		
		}
		protected function canFire():Boolean {
			return shotAvailable <= 0;
		}
		public function update(delta:Number):void {
			shotAvailable-= delta;
		}
	}
}