package ships 
{
	import io.arkeus.ouya.controller.Xbox360Controller;
	import maths.Utility;
	import ships.weapons.Bullet;
	import ships.weapons.Projectile;
	import ships.weapons.shotgun.Shotgun;
	import ships.weapons.shotgun.ShotgunProjectile;
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerShip extends Ship
	{
		private var controller:Xbox360Controller;
		public function PlayerShip(controller:Xbox360Controller) 
		{
			super();
			this.controller = controller;
			setWeapon(new Shotgun(), 0);
			
		}
		
		static var twoPI:Number = Math.PI * 2;
		override function input(delta:Number):void {
			
			var turning: Boolean = false;
			if (controller.leftStick.distance > .5) {
				angle = Utility.lerpAngle(angle, controller.leftStick.angle, .2);
			}
			
			if (controller.lt.pressed) {
				stall();
			}
			
			if (controller.rt.pressed) {
				engage();
			}
			
			if (controller.a.held) {
				weapons[0].fire();
				
			}
			
			if (Main.keyLEFT) {
				angle += delta * turnSpeed;
				turning = true;
			}
			if (Main.keyRIGHT) {
				angle -= delta * turnSpeed;
				turning = true;
			}
		}
		
		override public function destroy():void {
			if (dead) return;
			deathCounter = 1;
			alpha = 0;
			invincible = 1;
			explodeSound.play();
			//dead = true;
			x = Main.stageWidth / 2;
			y = Main.stageHeight / 2;
		}
	
		
	}

}