package ships 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.media.Sound;
	import io.arkeus.ouya.controller.Xbox360Controller;
	import maths.Collider;
	import maths.Pair;
	import ships.weapons.Bullet;
	import ships.weapons.Projectile;
	import ships.weapons.Weapon;
	/**
	 * ...
	 * @author ...
	 */
	public class Ship extends Sprite
	{
		[Embed(source="../../assets/hull.png")]
		public static var playerHull:Class;
		[Embed(source="../../assets/leftwing.png")]
		public static var leftwingpic:Class;
		[Embed(source="../../assets/rightwing.png")]
		public static var rightwingpic:Class;
		
		[Embed(source="../../assets/shotgun.mp3")]
		public static var shotgunSoundFile:Class;
		internal var shotgunSound:Sound = new shotgunSoundFile() as Sound;
		
		[Embed(source = "../../assets/explode.mp3")]
		public static var explodeSoundFile:Class;
		internal var explodeSound:Sound = new explodeSoundFile() as Sound;
		
		[Embed(source = "../../assets/boost.mp3")]
		public static var boostSoundFile:Class;
		internal var boostSound:Sound = new boostSoundFile() as Sound;
		
		internal var hull:Bitmap;
		internal var leftwing:Bitmap;
		internal var rightwing:Bitmap;
		
		//constants//
		internal var turnSpeed:Number = 4; //turning speed//
		
		internal var power:Number = 300; //throttle factor//
	

		internal var drag:Number = .2; 
		internal var gravity:Number = 250; 
		internal var boostCooldown:Number = 1;
		internal var boost:Number = 700;
		
		internal var boostAvailable:Number = 0;
		public var angle:Number = 1.55;
		internal var velocity:Number = 0;
		
		internal var currentSpeed:Number = 0;
		internal var engineEngaged:Boolean = true;
		public var vector:maths.Pair = new maths.Pair(0, 0);
		internal var trails:Array = new Array();
		internal var enginePower:Number = 0;
		
		internal var shipWidth:Number = 20;
		
		internal var collider:Collider;
		
		internal var bullets:Vector.<Projectile> = new Vector.<Projectile>();
		public var dead:Boolean = false;
		internal var shotCooldown:Number = .8;
		internal var shotAvailable:Number = 0;
		public var invincible:Number = 0;
		internal var deathCounter:Number = 0;
		internal var weapons:Array = new Array();
		public function Ship() 
		{
			
			collider = new Collider(10);
			
			
			for (var i:int = 0; i < 3; i++) {
				var tail:Sprite = new Sprite();
				tail.graphics.beginFill(0xDEEED6);
				tail.graphics.drawRect(0, 0, 1, 1);
				tail.x = -15;
				tail.y = -5 + i * 2; 
				tail.alpha = .5 + i * .25;
				trails.push(tail);
			}
			for (var i:int = 0; i < 3; i++) {
				var tail:Sprite = new Sprite();
				tail.graphics.beginFill(0xDEEED6);
				tail.graphics.drawRect(0, 0, 1, 1);
				tail.x = -15;
				tail.y = i * 2;
				tail.alpha = 1-(i * .25);
				trails.push(tail);
			}
			
			for each (var t:Sprite in trails) {
				addChild(t);
			}
			//var bgshape :Sprite= new Sprite();
			//bgshape.graphics.beginFill(0x597DCE);
			//bgshape.graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
			
			x = 200;
			y = 200
			hull = new playerHull();
			leftwing = new leftwingpic();
			rightwing = new rightwingpic();
			hull.x = -hull.width/2;
			hull.y = -hull.height / 2;
			
			
			addChild(hull); 
			addChild(leftwing);
			addChild(rightwing);
			
			scaleX = 1;
			scaleY = 1;
			
		}
		
		
		
		public function update(delta:Number):void {
			if (dead) return;
			if(deathCounter>0){
				deathCounter -= delta;
				if (deathCounter <= 0) {
					//alpha = 1;
					dead = false;
					
				}
				return;
			}
			
			collider.position.x = x;
			collider.position.y = y;
			input(delta);
			movement(delta);
			updateBullets(delta);
			setWings();
			boostAvailable-= delta;
			shotAvailable-= delta;
			if (invincible > 0) {
				invincible-= delta;	
				alpha = .5;
			}
			else {
				alpha = 1;
			}
			
		}
		
		internal function input(delta:Number):void {
		}
		
		internal var stallTimer:Number = 0;
		
		internal function stall():void {
			velocity = 0;
			engineEngaged = false;
		}
		
		internal function engage():void {
			if (boostAvailable > 0) return;
			boostAvailable = boostCooldown;
			boostSound.play();
			enginePower = 5;
			engineEngaged = true;
			//velocity = Pair.getMagnitudeInDirection(Pair.unitAngle(angle), vector);
			//velocity = Pair.average(Pair.unitAngle(angle).multiplySingle(velocity), vector).getMagnitude();
			velocity = vector.getMagnitude()+boost;
			
		}
		
		internal function movement(delta:Number):void {
			
			if(engineEngaged){
				velocity += delta * power;
				velocity -= Math.sin(angle) * delta * gravity;
				velocity *= Math.pow(drag, delta);
				var targetDX:Number = Math.cos(angle) * velocity;
				var targetDY:Number = -Math.sin(angle) * velocity;
				vector.x+= (targetDX - vector.x) * delta*5;
				vector.y+= (targetDY - vector.y) * delta*5;
				vector.x = targetDX;
				vector.y = targetDY;
			}
			else {
				vector.y += gravity * delta;
				vector = vector.multiplySingle(Math.pow(drag, delta));	
			}
			
			
			x += vector.x * delta;
			y += vector.y * delta;
			currentSpeed = vector.getMagnitude();
			
			//wraparound//
			
			if (x > stage.stageWidth+ shipWidth) x = -shipWidth;
			if (x < -shipWidth) x = stage.stageWidth+ shipWidth;
			if (y > stage.stageHeight + shipWidth) y = -shipWidth;
			if (y < -shipWidth) y = stage.stageHeight+ shipWidth;
			
		}
		
		internal function updateBullets(delta:Number) {

			for (var i:int = bullets.length - 1; i >= 0; i--) {
				var b:Projectile = bullets[i];
				b.update(delta);
				if (b.dead) {
					bullets.splice(i, 1);
				}
				
			}
		}
		
		internal function setWings():void {
			//UGH : ( //
			rotation = -angle * 57.3;			
			var wingspan:Number = Math.abs(Math.abs(rotation)) / 90 + .05;
			wingspan *= 3.14159 / 2;
			wingspan = Math.sin(wingspan);
			leftwing.scaleY = wingspan;
			rightwing.scaleY = wingspan;
			rightwing.x = -leftwing.width / 2;
			leftwing.x = -leftwing.width / 2;
			rightwing.y = -leftwing.height / 2;
			leftwing.y = -leftwing.height / 2;
			
			if(engineEngaged){
			enginePower += (1 - enginePower) * .1;
			}
			else {
				enginePower += (0 - enginePower) * .3;
			}
			
			
			
			
			for (var i:int = 0; i < 3; i++) {
				var base:Number = -5 - i * 2;
				var variance:Number = -Math.random() * (i + 1);
				var power:Number = (base+variance) * enginePower;
					trails[i].scaleX = power
					trails[trails.length - 1 - i].scaleX = power;
			}
			trails[3].scaleX = trails[2].scaleX;
			
		}
		
		
		public function getFrontX(dist:int):Number {
			return x + Math.sin(angle) * dist;
		}
		public function getFrontY(dist:int):Number {
			return y + Math.cos(angle) * dist;
		}
		public function getCollider():Collider {
			return collider;
		}
		public function destroy():void {
			if (dead) return;
			dead = true;
			dispose();
		}
		public function dispose():void {
			Main.map.removeChild(this);
			explodeSound.play();
		}
		
		public function setWeapon(weapon:Weapon, button:int) {
			weapons[int] = weapon;
		}
	}

}