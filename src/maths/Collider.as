package maths 
{
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Collider extends Sprite
	{
		
		public var radius:Number;
		private var position:maths.Pair;
		public function Collider(radius:Number)
		{
			if(Main.debugColliders){
				var shape:Shape = new Shape();
				shape.graphics.beginFill(0xFF794B);
				shape.graphics.drawCircle(x, y, radius);
				addChild(shape);
			}
			this.radius = radius;
			position = new maths.Pair(0, 0);
		}
		public function setPosition(x:Number, y:Number):void {
			position.x = x;
			position.y = y;
			if(Main.debugColliders){
				this.x = x;
				this.y = y;
			}
		}
		public function collide(other:Collider):Boolean {
			return position.getDistance(other.position) < radius + other.radius;
		}
		
	}

}