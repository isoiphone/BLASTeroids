package com.omgpanda.blasteroids {
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.events.Event;

	[SWF(backgroundColor="#181818", frameRate="60", width="800", height="600")]
	public class BLASTeroids extends Sprite {
		private var mShip : Ship;
		private var mShots : Shots;
		public var mParticles : ParticleSystem;
		private var mAsteroids : Vector.<Asteroid> = new Vector.<Asteroid>();
		private var mLevel : int = 0;
		private var mText : TextField = new TextField();
		private var mFormat : TextFormat = new TextFormat();
		private static var mInst : BLASTeroids;
		
		public function BLASTeroids() {
			addEventListener(Event.ADDED_TO_STAGE, init);
			mInst = this;
		}
		
		public static function GetInstance() : BLASTeroids {
			return mInst;
		}

		private function startGame() : void {
			for each (var ast : Asteroid in mAsteroids) {
				ast.destroy();
			}
			mAsteroids.length = 0;
			mShots.clear();
			mShip.reset();
			
			mLevel = 0;
			startLevel(mLevel);
		}
		
		private function startLevel(level:int) : void {
			var count : int = 2 + Math.random()*2 + mLevel*2;
			for (var i : int = 0; i < count; ++i) {
				var ast : Asteroid = null;
				do {
					if (ast) ast.destroy();
					ast = new Asteroid(stage);
				} while ( ast.mPosition.subtract(mShip.mPosition).length < 100 );
				
				mAsteroids.push(ast);
			}
		}
		
		private function init(e : Event = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, update);

			mFormat.size = 48;
			mFormat.font = "_sans";
			
			mText.x = 8;
			mText.y = 8*4;
			mText.width = stage.stageWidth;
			mText.textColor = 0x323232;
			
			stage.addChild(mText);
			
			//
			mShots = new Shots(stage);
			mParticles = new ParticleSystem(stage);
			mShip = new Ship(stage, mShots);
			
			startGame();
		}

		private function update(e : Event) : void {
			//
			mText.text = (mLevel == 0) ? 'blasteroids' : ''+mLevel; 
			mText.setTextFormat(mFormat);

			// physics and input
			mShip.update();
			mShots.update();
			mParticles.update();
			
			var ast : Asteroid;
			for each (ast in mAsteroids)
				ast.update();
			
			// collisions
			for each (ast in mAsteroids) {
				//ast.checkCollideMany( Vector.<Entity>(mAsteroids) );
				ast.checkCollideMany( Vector.<Entity>(mShots.mShots) );
				
				if (ast.checkCollideOne(mShip, false)) {
					//mParticles.explode(mShip.mPosition.x, mShip.mPosition.y);
					mParticles.explode(ast.mPosition.x, ast.mPosition.y);
					var i : int;
					for (i = 0; i<25; ++i)
						mParticles.smoke(mShip.mPosition.x, mShip.mPosition.y, 0, 0);
					for (i = 0; i<50; ++i)
						mParticles.smoke(mShip.mPosition.x, mShip.mPosition.y, mShip.mVelocity.x*0.01, mShip.mVelocity.y*0.01, 0x0097e6);
					for (i = 0; i<25; ++i)
						mParticles.smoke(mShip.mPosition.x, mShip.mPosition.y, 0, 0, 0xd9512b);
					for (i = 0; i<25; ++i)
						mParticles.smoke(mShip.mPosition.x, mShip.mPosition.y, -mShip.mVelocity.x*0.005, -mShip.mVelocity.y*0.005, 0xd9512b);
					startGame();
					return;
				}
			}

			// prune the dead items
			mAsteroids = mAsteroids.filter(function(item:Asteroid, index:int, vector:Vector.<Asteroid>):Boolean {
				return (item.stage!=null);
			});
			
			if (mAsteroids.length == 0)
				startLevel(++mLevel);
		}
	}
}
