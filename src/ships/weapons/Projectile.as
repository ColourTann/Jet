package ships.weapons 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import maths.Collider;
	import maths.Pair;
	import ships.Ship;
	/**
	 * ...
	 * @author ...
	 */
	public class Projectile extends Sprite
	{
		public static var projectiles:Vector.<Projectile> = new Vector.<Projectile>();
		internal var projectileImage:Bitmap;
		internal var ship:Ship;
		internal var vector:maths.Pair;
		internal var life:Number = 1+(Math.random()-.5)*.6;
		internal var collider:Collider;
		internal var radius:Number = 4;
		public var angle:Number;
		public var dead:Boolean = false;
		
		public function Projectile(ship:Ship, radius:Number, image:Bitmap) 
		{
			
			this.ship = ship;
			this.radius = radius;
			projectileImage = image;
			
			angle = ship.angle;
			vector = Pair.unitAngle(angle);
			
		
			x = ship.x;
			y = ship.y;
			collider = new Collider(radius);
			updateCollider();
			//Main.map.addChild(collider);
			projectileImage.x = -projectileImage.width / 2;
			projectileImage.y = -projectileImage.height / 2;
			addChild(projectileImage);
		}
		
		public static function add(proj:Projectile):void {
			projectiles.add(proj);
			Main.map.addChild(proj);
		}
		
		public static function updateBullets(delta:Number) {

			for (var i:int = projectiles.length - 1; i >= 0; i--) {
				var p:Projectile = projectiles[i];
				p.update(delta);
				if (p.dead) {
					projectiles.splice(i, 1);
				}
				
			}
		}
		
		public function randomiseAngle(amount:Number):void {
			angle += (Math.random() - .5) * amount;
			vector = Pair.unitAngle(angle);
		}
		
		public function multiplyVector(amount:Number):void {
			vector = vector.multiplySingle(amount);
		}
		
		public function update(delta:Number):void {
			if (dead) return;
			//trace(vector.x + ":" + vector.y);
		//	trace(vector.x+":"+vector.y);
			/*for each (var s:Ship in Main.shipList) {
				
				if (s == ship||s.dead||s.invincible>0) {
					continue;
				}
		
				if (s.getCollider().collide(collider)) {
					s.destroy();
					dead = true;
					dispose();
					return;
				}
			}*/
			vector = vector.multiplySingle(.85);
			x += vector.x * delta;
			y += vector.y * delta;
			updateCollider();
			life -= delta*2;
			//alpha = life*1.3;
			if (life < 0) {
				dead = true;
				dispose();
			}
		}
		
		public function dispose():void {
			Main.map.removeChild(this);
		}
		
		public function updateCollider():void {
			collider.position.x = x;
			collider.position.y = y;
		}
	}
		
		
}