package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import io.arkeus.ouya.controller.GameController;
	import io.arkeus.ouya.controller.Xbox360Controller;
	import io.arkeus.ouya.ControllerInput;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import ships.AIShip;
	import ships.Ship;
	import ships.PlayerShip;
	import ships.weapons.Bullet;
	/**
	 * ...
	 * @author Tann
	 */
	
	public class Main extends Sprite 
	{
		public static var stWidth:int;
		public static var stHeight:int;
		
		
		
		
		public static var keyUP:Boolean = false;
		public static var keyDOWN:Boolean = false;
		public static var keyRIGHT:Boolean = false;
		public static var keyLEFT:Boolean = false;		
		public static var map:Sprite = new Sprite();
		
		private var players:Vector.<Ship>;
		public static var shipList:Vector.<Ship>;
		private var controllers:Vector.<Xbox360Controller>;
	
		public static var stageWidth:Number;
		public static var stageHeight:Number;
		
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
			players = new Vector.<ships.Ship>();
			shipList = new Vector.<ships.Ship>();
		//	if (ControllerInput.hasReadyController()) {
			//	cont = ControllerInput.getReadyController() as Xbox360Controller;
		//	}
			for (var i:int = 0; i < 5; i++) {
				map.addChild(new Cloud());
			}
			
			stWidth = stage.stageWidth;
			stHeight = stage.stageHeight;
			removeEventListener(Event.ADDED_TO_STAGE, init);

			for (var i:int = 0; i < 00; i++) {
				var s:Ship = new AIShip();
				shipList.push(s);
				map.addChild(s);
			}
			
			//throttle = new Throttleometer(player);
			//addChild(throttle);
			//for each (var r:Rectangle in shapes) {
		
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
		
		private function update(delta:Number): void {
			
			
			

			for (var i:int = shipList.length - 1; i >= 0; i--) {
				var s:Ship = shipList[i];
				
				if (s.dead) {
					shipList.splice(i, 1);
					continue;
				}
				s.update(delta);
			}
			
			
		
			if (ControllerInput.hasReadyController() && players.length < 2) {
				var newShip:Ship = new ships.PlayerShip(ControllerInput.getReadyController() as Xbox360Controller);
				players.push(newShip);
				shipList.push(newShip);
				map.addChild(newShip);
			}
			
		}
	}
}
	

