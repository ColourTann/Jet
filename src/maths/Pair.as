package maths 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Pair 
	{
		public var x:Number;
		public var y:Number;
		
		public function Pair(x:Number, y:Number) 
		{
			this.x = x;
			this.y = y;
		}
		
		public function getMagnitude():Number {
			return Math.sqrt(x * x + y * y);
		}
		
		public function normalise():Pair {
			var magnitude:Number = getMagnitude();
			return new Pair (x / magnitude, y / magnitude);
		}
		
		public function subtract(otherPair:Pair):Pair {
			return new Pair(x - otherPair.x, y - otherPair.y);
		}
		
		public function add(otherPair:Pair):Pair {
			return new Pair(x + otherPair.x, y + otherPair.y);
		}
		
		public function multiply(multiplier:Pair):Pair {
			return new Pair(x * multiplier.x, y * multiplier.y);
		}
		
		public function multiplySingle(multiplier:Number):Pair {
			return new Pair(x * multiplier, y * multiplier);
		}
		
		public function getDistance(otherPair:Pair):Number {
			var xDiff:Number = x - otherPair.x;
			var yDiff:Number = y - otherPair.y;
			return Math.sqrt(xDiff * xDiff + yDiff * yDiff);
		}
		
		public function getAngle():Number {
			return Math.atan2(-y, x);
		}
		
		public static function getMagnitudeInDirection(direction:Pair, speed:Pair):Number {
			var vector:Pair = direction.normalise().multiply(speed);
			return vector.x + vector.y;
		}
		
		public static function unitAngle(angle:Number):Pair {
			return new Pair(Math.cos(angle), -Math.sin(angle));
		}
		
		public static function average(a:Pair, b:Pair):Pair {
			return new Pair((a.x + b.x) / 2, (a.y + b.y) / 2);
		}
		
	}

}