package com.omgpanda.blasteroids {
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.display.Stage;

	public class Ship extends Entity {
		public var mHeading : Number = Math.PI*-0.5;
		
		private var mShoot : int;
		private var mUp : int;
		private var mDown : int;
		private var mLeft : int;
		private var mRight : int;
		
		private var mShots : Shots;
		private var mCooldown : int = 0;
		
		[Embed(source = "../art/ship.png")]
		private var MyBitmap : Class;

		public function Ship(theStage : Stage, theShots : Shots) {
			super(theStage, MyBitmap);
			mShots = theShots;

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKey);
			mPosition.setTo(stage.stageWidth * 0.5, stage.stageHeight * 0.5);
		}

		override public function update() : void {
			if (mShoot && mCooldown <= 0) {
				onFire();
				mCooldown += stage.frameRate/6;
			} else if (mCooldown > 0) {
				--mCooldown;
			}
			
			if (mUp || mDown) {
				var thrust : Point = new Point();
				setToAngle(thrust, mHeading, (mUp - mDown) * 20.0);
				mVelocity = mVelocity.add(thrust);
				
				const MAX_SPEED : Number = 500;
				var speed : Number = mVelocity.length;
				if (speed > MAX_SPEED) {
					mVelocity.normalize(MAX_SPEED);
				}
				
				BLASTeroids.GetInstance().mParticles.smoke(mPosition.x, mPosition.y, thrust.x*-0.1, thrust.y*-0.1);
			}

			if (mLeft || mRight) {
				mHeading -= (mLeft - mRight) * 0.05;
			}

			this.rotation = mHeading * (180.0 / Math.PI);

			//
			super.update();
		}

		private function onKey(e : KeyboardEvent) : void {
			var isDown : int = (e.type == KeyboardEvent.KEY_DOWN) ? 1 : 0;

			if (e.keyCode == Keyboard.SPACE)
				mShoot = isDown;
			if (e.keyCode == Keyboard.UP)
				mUp = isDown;
			if (e.keyCode == Keyboard.DOWN)
				mDown = isDown;
			if (e.keyCode == Keyboard.LEFT)
				mLeft = isDown;
			if (e.keyCode == Keyboard.RIGHT)
				mRight = isDown;
		}

		private function onFire() : void {
			trace("Pew!");
			var umph:Point = new Point();
			setToAngle(umph, mHeading, 400.0);
			
			var offset:Point = new Point();
			setToAngle(offset, mHeading, 16); // the front of the ship is ~16px from the center
			
			mShots.spawn(mPosition.add(offset), mVelocity.add(umph));
		}

		override public function onCollide(other : Entity) : void {
			//this.destroy();
		}
		
		override public function destroy() : void {
			if (stage) {
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
				stage.removeEventListener(KeyboardEvent.KEY_UP, onKey);
			}
			super.destroy();
		}
		
		public function reset() : void {
			mPosition.setTo(stage.stageWidth*0.5, stage.stageHeight*0.5)
			mVelocity.setTo(0, 0);
			mHeading = Math.PI*-0.5;
			mUp = mDown = mLeft = mRight = mShoot = 0;
		}
	}
}
