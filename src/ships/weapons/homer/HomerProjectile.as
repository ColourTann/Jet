package ships.weapons.homer 
{
	import flash.display.Sprite;
	import maths.Pair;
	import maths.Utility;
	import ships.Hopper;
	import ships.Ship;
	import ships.weapons.Projectile;
	/**
	 * ...
	 * @author ...
	 */
	public class HomerProjectile extends Projectile
	{
		[Embed(source = "../../../../assets/homer.png")]
		public static var homerGraphic:Class;
		private static var speed:Number = 250;
		
		private var target:Ship;
		public function HomerProjectile(source:Ship, target:Ship, direction:int) 
		{
			super(source, 7, 3, new homerGraphic());
			this.target = target;
			angle+= Math.PI / 2 * direction;
			vector = Pair.unitAngle(angle);
			rotation = Utility.rad2Deg(vector.getAngle());
			playDeathSound = false;
			destroyOnHit = true;
		}
		override protected function advancedMove(delta:Number):void {
			
			if (target.alpha < 1) {
				dead = true;
				dispose();
				destroy();
				return;
			}
			
			var targetAngle:Number = new Pair(target.x, target.y).subtract(new Pair(x, y)).getAngle();
			if(Math.abs(angle-targetAngle)>.5){
				angle = Utility.addAngle(angle, targetAngle, .1);
			}
			vector = Pair.unitAngle(angle);
			multiplyVector(speed);			
			rotation = Utility.rad2Deg( -angle);
			
		}
		override protected function destroy():void {
			Projectile.add(new HomerExplosion(ship, this));
		}
	}

}