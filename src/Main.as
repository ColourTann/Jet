package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.engine.DigitWidth;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import io.arkeus.ouya.controller.GameController;
	import io.arkeus.ouya.controller.Xbox360Controller;
	import io.arkeus.ouya.ControllerInput;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import ships.Hopper;
	import ships.Ship;
	import ships.Zipper;
	import ships.weapons.Projectile;
	/**
	 * ...
	 * @author Tann
	 */
	
	public class Main extends Sprite 
	{
		public static var stWidth:int;
		public static var stHeight:int;
		
		
		public static var debugColliders:Boolean = false;
		
		public static var keyUP:Boolean = false;
		public static var keyDOWN:Boolean = false;
		public static var keyRIGHT:Boolean = false;
		public static var keyLEFT:Boolean = false;		
		public static var map:Sprite = new Sprite();
		

		public static var shipList:Vector.<Ship>;
	
		public static var stageWidth:Number;
		public static var stageHeight:Number;
		
		public static var controllers:Vector.<Xbox360Controller> = new Vector.<Xbox360Controller>();
		
		public static var lobby:Boolean=true;
		
		public static var wisps:Vector.<TextWisp> = new Vector.<TextWisp>();
		
		public function Main() 
		{
			if (stage) init();
			else stage.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			
			
			stageWidth = stage.stageWidth;
			stageHeight = stage.stageHeight;
	
			
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.stageHeight = 30;
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			
			
			var maskShape:Shape = new Shape();
			maskShape.graphics.beginFill(0x0);
			maskShape.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			maskShape.graphics.endFill();
			addChild(maskShape);
			maskShape.x = 0;
			maskShape.y = 0;

			map.mask = maskShape;
			maskShape.visible = false;
			addChild(map);
	
			var bgshape :Sprite= new Sprite();
			bgshape.graphics.beginFill(0x597DCE);
			bgshape.graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
			map.addChildAt(bgshape, 0);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandleUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandleDown);
			ControllerInput.initialize(stage);
			
			shipList = new Vector.<ships.Ship>();

			for (var i:int = 0; i < 0; i++) {
				map.addChild(new Cloud());
			}
			
			stWidth = stage.stageWidth;
			stHeight = stage.stageHeight;
			removeEventListener(Event.ADDED_TO_STAGE, init);

			getTimer();
	
			
			
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function keyHandleDown(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case 32 :
					//player[0].cycleEngine();
					break;
				case 37 :
					keyLEFT = true;
					break;
				case 38 :
					keyUP = true;
					break;
				case 39 :
					keyRIGHT = true;
					break;
				case 40 :
					keyDOWN = true;	
					
			}
		}
		
		private function keyHandleUp(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case 37 :
					keyLEFT = false;
					break;
				case 38 :
					keyUP = false;
					break;
				case 39 :
					keyRIGHT = false;
					break;
				case 40 :
					keyDOWN = false;
			}
		}
		
		private var _t:int;
		private function onEnterFrame(e:Event):void {
			var t:int = getTimer();
			var dt:Number = (t - _t) * 0.001;
			_t = t;
			update(dt);
		}	
		
		private static var pauseTimer:Number = 0;
		
		private function update(delta:Number): void {
			if (delta > .5) return;
			
			checkForNewPlayers(delta);
			
			if (pauseTimer > 0) {
				pauseTimer -= delta;
				if (pauseTimer <= 0) {
					startMatch();
				}
			}
			
			for (var i:int = wisps.length - 1; i >= 0; i--) {
				var w:TextWisp = wisps[i];
				w.update(delta);
				if (w.dead) {
					wisps.splice(i, 1);
					Main.map.removeChild(w);
				}
			}
			
			
			Projectile.updateBullets(delta);
			
			for (i = shipList.length - 1; i >= 0; i--) {
				var s:Ship = shipList[i];
				
				
				s.update(delta);
				if (s.dead) {
					shipList.splice(i, 1);
					continue;
				}
			}
		}
		
		public static function isPaused():Boolean {
			return pauseTimer > 0;
		}
		
		private var ready:Number = 0;
		private function checkForNewPlayers(delta:Number):void {
	
			if (ControllerInput.hasReadyController()) {
				controllers.push(ControllerInput.getReadyController());
			}
			
			
			
			if(lobby){
			
				for each(var c:Xbox360Controller in controllers) {
				var bad:Boolean = false;
				if (c.start.held) {
					for each(var ship:Ship in shipList) {
						if (ship.controller == c) {
							bad = true;
							break;
						}
					}
					if (bad) continue;
					var newShip:Ship = new Zipper(c);
					newShip.setPlayerID(getLowestAvailableID());
					shipList.push(newShip);
					map.addChild(newShip);	
				}
				
			}
				
				for each(var cont:Xbox360Controller in controllers) {
					if (cont.back.held) {
						for each(var shipp:Ship in shipList) {
							if (shipp.controller == cont) {
								shipp.dead = true;
							}
						}
					}
				}
				
				for (var i:int = shipList.length - 1; i >= 0; i--) {
					var ship:Ship = shipList[i];
					if (ship.markedForSwitching) {
						shipList.splice(i, 1);
						var newShip:Ship;
						if (ship is Zipper) {
							newShip = new Hopper(ship.controller);
						}
						else newShip = new Zipper(ship.controller);
						newShip.setPlayerID(ship.ID);
						ship.dispose(false);
						shipList.push(newShip);
						map.addChild(newShip);
						
					}
				}
				
				if (shipList.length > 1) {
					var bad:Boolean = false;
					for each(var ship:Ship in shipList) {
						if (!(ship.controller.start.held)) {
							bad = true;
						}
					}
					if (!bad) {
						ready += delta;
						if (ready >= 1) {
							startMatch();
						}
					}
					else {
						ready = 0;
					}
				}
			
			}
		}
		
		private function getLowestAvailableID():int {
			for (var i:int = 0; i <= 3; i++) {
				var bad:Boolean = false;
				for each(var ship:Ship in shipList) {
					if (ship.ID == i) {
						bad = true;
						break;
					}
				}
				if (bad) continue;
				return i;
			}
			return 0;
		}
		
		private function startMatch() {
			lobby = false;
			for each (var s:Ship in shipList) {
				s.startMatch();
			}
			addWisp(new TextWisp("Fight!", .5, 222, 238, 214));
		}
		public static function addWisp(wisp:TextWisp) {
			Main.map.addChild(wisp);
			wisps.push(wisp);
		}
		public static function win(r:int, g:int, b:int) {
			addWisp(new TextWisp("You win!", 3.2, r, g, b));
			pauseTimer = 5;
		}
	}
}
	

