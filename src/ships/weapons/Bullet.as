package ships.weapons 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import maths.Collider;
	import maths.Pair;
	import ships.AIShip;
	import ships.Ship;
	/**
	 * ...
	 * @author ...
	 */
	public class Bullet extends Sprite
	{
	/*[Embed(source = "../../../assets/bullet.png")]
		public static var bulletGraphic:Class;
		internal var bulletBitmap:Bitmap = new bulletGraphic();
		internal var ship:Ship;
		internal var vector:maths.Pair;
		internal var life:Number = 1+(Math.random()-.5)*.6;
		internal var collider:Collider;
		internal var radius = 4;
		public var dead:Boolean = false;
		
		public function Bullet(ship:Ship) 
		{
			
			this.ship = ship;
			var angle:Number = ship.angle;
			angle += (Math.random() - .5) * .6;
			
			
			
			var magnitude:Number = maths.Pair.getMagnitudeInDirection(maths.Pair.unitAngle(angle), ship.vector);
			var multiplier:Number = Math.max(magnitude+700+Math.random()*300);
			
			vector = maths.Pair.unitAngle(angle).multiplySingle(multiplier);
			//magnitude = Math.max(magnitude, 30);
			//vector = vector.multiplySingle(magnitude);
			//vector = vector.multiplySingle(2);
			
			x = ship.x;
			y = ship.y;
			collider = new Collider(radius);
			updateCollider();
			
			bulletBitmap.x = -bulletBitmap.width / 2;
			bulletBitmap.y = -bulletBitmap.height / 2;
			addChild(bulletBitmap);

		}
		
		public function update(delta:Number):void {
			if (dead) return;
			for each (var s:Ship in Main.shipList) {
				
				if (s == ship||s.dead||s.invincible>0) {
					continue;
				}
		
				if (s.getCollider().collide(collider)) {
					s.destroy();
					dead = true;
					dispose();
					return;
				}
			}
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
	}*/
	}
}