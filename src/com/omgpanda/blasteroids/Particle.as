package com.omgpanda.blasteroids {
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.display.Shape;
	public class Particle extends Shape {
		public var life : int = 0;
		public var x0 : Number = 0;
		public var y0 : Number = 0;
		public var x1 : Number = 0;
		public var y1 : Number = 0;
		
		public function Particle() {
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(-1,-1, 3, 3);
			graphics.endFill();
			setColor(0xFF00FF);
		}
		
		public function setColor(color : uint) : void {
			var c : ColorTransform = new ColorTransform();
			c.color = color;
			transform.colorTransform = c;
		}
	}
}
