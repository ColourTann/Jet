package ships 
{
	import flash.display.Bitmap;
	import flash.display.ColorCorrection;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.media.Sound;
	import io.arkeus.ouya.controller.Xbox360Controller;
	import maths.Collider;
	import maths.Pair;
	import maths.Utility;
	import ships.weapons.Projectile;
	import ships.weapons.Weapon;
	/**
	 * ...
	 * @author ...
	 */
	public class Ship extends Sprite
	{
		
		
		public static var colArray:Array = [63,63,116,118,66,138,143,86,59,75,105,47];
	
		
		[Embed(source = "../../assets/explode.mp3")]
		public static var explodeSoundFile:Class;
		
		protected var explodeSound:Sound = new explodeSoundFile() as Sound;
		protected var trails:Array = new Array();
		protected var hull:Bitmap;
		protected var leftwing:Bitmap;
		protected var rightwing:Bitmap;
	
		//sound//
		[Embed(source = "../../assets/boost.mp3")]
		public static var boostSoundFile:Class;
		protected var boostSound:Sound = new boostSoundFile() as Sound;
		
		//constants//
		protected var power:Number = 300; //accel//
		protected var drag:Number = .2; 
		protected var gravity:Number = 250; 
		
		//boost//
		protected var boostCooldown:Number = 1;
		protected var boostPower:Number = 700;
		protected var boostAvailable:Number = 0;
		
		//movement//
		public var angle:Number = 1.55;
		protected var velocity:Number = 0;
		protected var currentSpeed:Number = 0;
		protected var engineEngaged:Boolean = true;
		public var vector:maths.Pair = new maths.Pair(0, 0);
		protected var enginePower:Number = 0;
		public static var shipWidth:Number = 20;
		
		protected var weapons:Array = new Array();
		
		protected var collider:Collider;
		public var dead:Boolean = false;
		public var disposed:Boolean = false;
		public var invincible:Number = 0;
		protected var deathCounter:Number = 0;
		
		public var controller:Xbox360Controller;
		public var ID:int;
		public var markedForSwitching:Boolean;
		public var score:Score;
		
		
		protected var energy:EnergyBar = new EnergyBar();
		
		public function Ship(controller:Xbox360Controller, ahull:Bitmap, arightWing:Bitmap, aleftWing:Bitmap ) 
		{
			this.controller = controller;
			collider = new Collider(10);
			if (Main.debugColliders) {
				Main.map.addChild(collider);
			}
			for (var i:int = 0; i < 3; i++) {
				var tail:Sprite = new Sprite();
				tail.graphics.beginFill(0xDEEED6);
				tail.graphics.drawRect(0, 0, 1, 1);
				tail.x = -15;
				tail.y = -5 + i * 2; 
				tail.alpha = .5 + i * .25;
				trails.push(tail);
			}
			for (i = 0; i < 3; i++) {
				tail= new Sprite();
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
		
			hull = ahull;
			rightwing = arightWing;
			leftwing = aleftWing;

			
			hull.x = -hull.width/2;
			hull.y = -hull.height / 2;
			addChild(hull); 
			addChild(leftwing);
			addChild(rightwing);
			scaleX = 1;
			scaleY = 1;
			
			tint(hull);
			tint(leftwing);
			tint(rightwing);
			//Main.map.addChild(energy);
			
		}
		
		public function addKill():void {
			if (score != null) {
				score.addKill();
			}
		}
		
		public function startMatch():void {
			respawn();
			if (score != null) {
					score.reset();
			}
			
			addScore();
		}
		
		private function respawn():void {
			
			if (Main.isPaused()) {
				return;
			}
			Main.map.addChild(energy);
			trace("respawning");
			alreadyDead = false;
			deathCounter = 0;
			dead = false;
			invincible = 1;
			if (ID %2== 0) {
				x = Main.stageWidth / 4;
			}
			else {
				x = Main.stageWidth * 3 / 4;
			}
			if (ID == 0 || ID == 3) {
				y = Main.stageHeight / 4;
			}
			else {
				y = Main.stageHeight * 3 / 4;
			}
		}
		
		private function addScore():void {
			
			score = new Score(this, colArray[ID * 3], colArray[ID * 3 + 1], colArray[ID * 3 + 2]);
			Main.map.addChild(score);
			
		}
		
		private function tint(s:Bitmap):void {
			s.transform.colorTransform = new ColorTransform(colArray[ID * 3] / 255, colArray[ID * 3 + 1] / 255, colArray[ID * 3 + 2] / 255, 1, 0, 0, 0, 0);
			respawn();
		}
		
		
		
		public function setPlayerID(ID:int):void {
			this.ID = ID;
			tint(hull);
			tint(leftwing);
			tint(rightwing);
			
			
		}
		
		public function update(delta:Number):void {
			if (dead) {
				if(!disposed){
					dispose(false);
				}
				return;
			}
			if (checkDeath(delta)) return;
			input(delta);
			movement(delta);
			updateSpecial(delta)
			updateDeath(delta);
			updateWeapons(delta);
			updateCollider();
			updateGraphics();
			
			energy.setLocation(x, y);
			energy.gainEnergy(delta/2);
		}
		
		protected function checkDeath(delta:Number):Boolean {
			if (dead) return true;
			if (deathCounter > 0) {
				if (Main.isPaused()) {
					return true;
				}
				deathCounter -= delta;
				if (deathCounter <= 0) {
					respawn();
				}
				return true;
			}
			
			return false;
		}
		
		protected function input(delta:Number):void {
			if (controller.leftStick.distance > .5) {
				angle = Utility.lerpAngle(angle, controller.leftStick.angle, .2);
			}
			
			checkSpecials(delta);
			
			if (controller.a.held) {
				weapons[0].fire();
			}
			if (controller.x.held) {
				weapons[1].fire();
			}
			if (controller.lb.pressed||controller.rb.pressed) {
				markedForSwitching = true;
			}
		}
		
		protected function movement(delta:Number):void {
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
			if (x > stage.stageWidth+ shipWidth) x  -=(Main.stageWidth+shipWidth);
			if (x < -shipWidth) x += stage.stageWidth+ shipWidth;
			if (y > stage.stageHeight + shipWidth) y -= (Main.stageHeight+shipWidth);
			if (y < -shipWidth) y += stage.stageHeight+ shipWidth;
		}
		
		protected function updateSpecial(delta:Number):void {
			boostAvailable-= delta;
		}
		
		protected function updateDeath(delta:Number):void {
			if (invincible > 0) {
				invincible-= delta;	
				alpha = .5;
			}
			else {
				alpha = 1;
			}
		}
		
		protected function updateWeapons(delta:Number):void {
			for each (var w:Weapon in weapons) {
				w.update(delta);
			}
		}
		
		protected function updateCollider():void {
			collider.setPosition(x, y);
		}
		
		protected function updateGraphics():void {
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
		
		
		protected function checkSpecials(delta:Number):void {
			//override me//
		}
		
		
		public function getFrontX(dist:int):Number {
			return x + Math.cos(angle) * dist;
		}
		public function getFrontY(dist:int):Number {
			return y - Math.sin(angle) * dist;
		}
		public function getCollider():Collider {
			return collider;
		}
		public var alreadyDead:Boolean;
		
		public function destroy(playSound:Boolean):void {
			if (dead) return;
			alreadyDead = true;
			deathCounter = 1.8;
			alpha = 0;
			
			if (playSound) explodeSound.play();
			
			if (Main.map.contains(energy)) {
				Main.map.removeChild(energy);		
			}
			
		}
		public function dispose(playSound:Boolean):void {
			dead = true;
			disposed = true;
			if (Main.map.contains(energy)) {
				Main.map.removeChild(energy);		
			}
			Main.map.removeChild(this);
			if(playSound)explodeSound.play();
		}
		
		public function setWeapon(weapon:Weapon, button:int):void {
			weapons[button] = weapon;
		}
		
		public function getEnergy():Number {
			return energy.getEnergy();
		}
		
		public function spend(cost:Number):void {
			energy.spend(cost);
		}
	}

}