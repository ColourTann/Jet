package maths 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Utility 
	{
		
		
		public static function lerpAngle(startAngle:Number, targetAngle:Number, multiplier:Number):Number {
				var rotationFactor:Number = (targetAngle-startAngle);
				if (Math.abs(rotationFactor) > Math.PI) {
					if (rotationFactor < 0) {
						rotationFactor += Math.PI * 2;
					}
					else {
						rotationFactor -= Math.PI * 2;
					}
				}
				return (startAngle+ rotationFactor * multiplier)%(Math.PI*2);
		}
		
		public static function addAngle(startAngle:Number, targetAngle:Number, adder:Number):Number {
				var rotationFactor:Number = (targetAngle-startAngle);
				if (Math.abs(rotationFactor) > Math.PI) {
					if (rotationFactor < 0) {
						rotationFactor += Math.PI * 2;
					}
					else {
						rotationFactor -= Math.PI * 2;
					}
				}
				return (startAngle+ ((rotationFactor > 0)?adder: -adder))% (Math.PI * 2);
		}
		

		
		public static function rad2Deg(rad:Number):Number {
			return rad * 57.3;
		}
		
	}

}