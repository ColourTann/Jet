package maths 
{
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Collider
	{
		
		public var radius:Number;
		public var position:maths.Pair;
		public function Collider(radius:Number)
		{
			this.radius = radius;
			position = new maths.Pair(0, 0);
		}
		public function setPosition(x:Number, y:Number) {
			position.x = x;
			position.y = y;
		}
		public function collide(other:Collider):Boolean {
			return position.getDistance(other.position) < radius + other.radius;
		}
		
	}

}