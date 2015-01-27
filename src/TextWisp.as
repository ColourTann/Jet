package 
{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	/**
	 * ...
	 * @author ...
	 */
	public class TextWisp extends Sprite
	{
		public var dead:Boolean;
		private var t:Number = .5;
		public function TextWisp(text:String, delay:Number, r:int, g:int, b:int) 
		{
			t = delay;
			var tf:TextField = new TextField();
			tf.text = text;
			tf.textColor = 0xffffff;
			tf.x = -tf.textWidth / 2;
			tf.y = -tf.textHeight / 2;
			tf.transform.colorTransform = new ColorTransform(r / 255, g / 255, b / 255, 1, 0, 0, 0, 0);
			addChild(tf);
			x = Main.stageWidth / 2;
			y = Main.stageHeight / 2;
			scaleX = 20;
			scaleY = 20;
		}
		public function update(delta:Number):void {
			t -= delta;
			if(t<=0){
				alpha -= delta*2;
				y -= delta * 150;
			}
			if (alpha <= 0) dead = true;
		}
		
	}

}