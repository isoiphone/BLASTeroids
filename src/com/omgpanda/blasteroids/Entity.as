package com.omgpanda.blasteroids {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.display.Stage;

	public class Entity extends Sprite {
		public var mDisplay : Bitmap = null;
		public var mPosition : Point = new Point();
		public var mVelocity : Point = new Point();
		public var mAge : Number = 0.0;
		
		public function Entity(theStage : Stage, DisplayClass : Class) {
			theStage.addChild(this);

			if (DisplayClass != null) {
				mDisplay = new DisplayClass();
				mDisplay.x -= mDisplay.width * 0.5;
				mDisplay.y -= mDisplay.height * 0.5;
				this.addChild(mDisplay);
			}
		}

		public function update() : void {
			var elapsed : Number = (1.0 / stage.frameRate);
			
			mAge += elapsed;
			mPosition.x += mVelocity.x * elapsed;
			mPosition.y += mVelocity.y * elapsed;

			// screen wrap
			while (mPosition.x < 0)
				mPosition.x += stage.stageWidth;
			while (mPosition.y < 0)
				mPosition.y += stage.stageHeight;
			while (mPosition.x > stage.stageWidth)
				mPosition.x -= stage.stageWidth;
			while (mPosition.y > stage.stageHeight)
				mPosition.y -= stage.stageHeight;

			this.x = mPosition.x;
			this.y = mPosition.y;
		}

		public function onCollide(other : Entity) : void {
			//trace("collision: " + other + " <-> " + this);
		}

		// check this entity against every other one. if there is a collision then fire the onCollide() for both.
		public function checkCollideMany(entities : Vector.<Entity>) : Boolean {
			var didCollide : Boolean = false;
			var self_rad2 : Number = mDisplay ? (mDisplay.width*mDisplay.width*0.23) : 1;
			for each (var other : Entity in entities) {
				if (other === this)
					continue;
				var other_rad2 : Number = other.mDisplay ? (other.mDisplay.width*other.mDisplay.width*0.23) : 1;
				var dx : Number = this.mPosition.x - other.mPosition.x;
				var dy : Number = this.mPosition.y - other.mPosition.y;
				if ((dx * dx + dy * dy) < (self_rad2+other_rad2)) {
					other.onCollide(this);
					this.onCollide(other);
					didCollide = true;
				}
			}
			return didCollide;
		}

		public function checkCollideOne(other : Entity, doNotify : Boolean=true) : Boolean {
			if (other === this)
				return false;
			
			var self_rad2 : Number = mDisplay ? (mDisplay.width*mDisplay.width*0.23) : 1;
			var other_rad2 : Number = other.mDisplay ? (other.mDisplay.width*other.mDisplay.width*0.23) : 1;
			var dx : Number = this.mPosition.x - other.mPosition.x;
			var dy : Number = this.mPosition.y - other.mPosition.y;
			if ((dx * dx + dy * dy) < (self_rad2+other_rad2)) {
				if (doNotify) {
					other.onCollide(this);
					this.onCollide(other);
				}
				return true;
			}
			return false;
		}

		public function destroy() : void {
			if (stage)
				stage.removeChild(this);
		}

		public function setToAngle(point : Point, angle : Number, scale : Number) : void {
			point.setTo(Math.cos(angle) * scale, Math.sin(angle) * scale);
		}
	}
}
