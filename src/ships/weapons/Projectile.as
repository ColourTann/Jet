package ships.weapons 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.errors.StackOverflowError;
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
		protected var projectileImage:Bitmap;
		protected var ship:Ship;
		protected var vector:maths.Pair;
		protected var life:Number;
		protected var collider:Collider;
		protected var radius:Number = 4;
		protected var destroyOnHit:Boolean = false; 
		protected var playDeathSound:Boolean = true; 
		public var angle:Number;
		public var dead:Boolean = false;
	
		public function Projectile(ship:Ship, radius:Number, life:Number, image:Bitmap) 
		{	
			
			this.ship = ship;
			this.radius = radius;
			this.life = life;
			projectileImage = image;
			
			angle = ship.angle;
			vector = Pair.unitAngle(angle);
			
		
			x = ship.getFrontX(20);// ship.x;
			y = ship.getFrontY(20);// ship.y;
			collider = new Collider(radius);
			updateCollider();
			if(Main.debugColliders){
				Main.map.addChild(collider);
			}
			projectileImage.x = -projectileImage.width / 2;
			projectileImage.y = -projectileImage.height / 2;
			addChild(projectileImage);
		}
		
		public static function add(proj:Projectile):void {
			projectiles.push(proj);
			Main.map.addChild(proj);
		}
		
		public static function updateBullets(delta:Number):void {

			for (var i:int = projectiles.length - 1; i >= 0; i--) {
				var p:Projectile = projectiles[i];
				p.update(delta);
				if (p.dead) {
					projectiles.splice(i, 1);
				}
			}
		}
		
		public function fire():void{
			
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
			move(delta);
			advancedMove(delta);
			
			if (dead) return;
			
			for each (var s:Ship in Main.shipList) {
				if (s == ship||s.dead||s.invincible>0) {
					continue;
				}
				if (s.getCollider().collide(collider)) {
					if(!s.alreadyDead){
						ship.addKill();
					}
					s.destroy(playDeathSound);
					if(destroyOnHit){
						dead = true;
						destroy();
						dispose();
					}
					return;
				}
			}
		}
		
		protected function move(delta:Number):void {
			x += vector.x * delta;
			y += vector.y * delta;
			updateCollider();
			life -= delta;
			if (life < 0) {
				dead = true;
				destroy();
				dispose();
			}
			if (x > Main.stageWidth+ radius) x = -radius;
			if (x < -radius) x = Main.stageWidth+ radius;
			if (y > Main.stageHeight + radius) y = -radius;
			if (y < -radius) y = Main.stageHeight+ radius;
		}
		
		protected function advancedMove(delta:Number):void {
			//override me//
		}
		
		protected function destroy():void {
			
		}
		
		public function dispose():void {
			if(Main.map.contains(this)){
				Main.map.removeChild(this);
			}
		}
		
		public function updateCollider():void {
			collider.setPosition(x, y);
		}
	}
		
		
}