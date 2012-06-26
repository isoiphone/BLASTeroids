package com.omgpanda.blasteroids {
	import flash.utils.getQualifiedClassName;
	import flash.display.Stage;

	public class Asteroid extends Entity {
		[Embed(source = "../art/asteroid.png")]
		private var MyBitmap : Class;

		public function Asteroid(theStage : Stage) {
			super(theStage, MyBitmap);

			var heading : Number = Math.random() * Math.PI * 2.0;
			var speed : Number = Math.random() * 16.0;
			setToAngle(mVelocity, heading, speed);
			mPosition.setTo(Math.random() * stage.stageWidth, Math.random() * stage.stageHeight);
			
			this.x = mPosition.x;
			this.y = mPosition.y;
		}

		override public function onCollide(other : Entity) : void {
			var className:String = getQualifiedClassName(other);
			
			if (className == "com.omgpanda.blasteroids::Asteroid") {
				this.mVelocity.x *= -1.0;
				this.mVelocity.y *= -1.0;
				
				other.mVelocity.x *= -1.0;
				other.mVelocity.y *= -1.0;
			} else if (className == "com.omgpanda.blasteroids::Entity") {
				this.destroy();
				BLASTeroids.GetInstance().mParticles.explode(other.mPosition.x, other.mPosition.y);
				//other.destroy();
				other.mAge += 100.0;
			} else if (className == "com.omgpanda.blasteroids::Ship") {
			}
		}
	}
}
