package ships 
{
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class EnergyBar extends Sprite
	{
		public var energy:Number = 1;
		private var outline:Shape = new Shape();
		private var inner:Shape = new Shape();
		
		private static var w= 50;
		private static var h= 10;
		private static var gap = 2;
		
		
		public function EnergyBar() 
		{
			outline.graphics.beginFill(0xFF0000);
			//outline.graphics.drawRect(0, 0, w, h);
			inner.graphics.beginFill(0xDEEED6);
			inner.graphics.drawRect(gap, gap, (w - gap * 2) * energy, h - gap * 2);
			inner.alpha = .5;
			addChild(outline);
			addChild(inner);
		}
		
		public function setLocation(ax:int, ay:int):void {
			x = ax - width / 2;
			y = ay + 30;
		}
		
		public function update():void {
			inner.graphics.clear();
			inner.graphics.beginFill(0xDEEED6);
			inner.graphics.drawRect(gap, gap, (w - gap * 2) * energy, h - gap * 2);
		}
		
		public function spend(cost:Number):void {
			energy -= cost;
			update();
		}
		
		public function gainEnergy(amount:Number):void {
			energy += amount;
			if (energy > 1) energy = 1;
			update();
		}
		
		
		
		public function getEnergy():Number {
			return energy;
		}
		
	}

}