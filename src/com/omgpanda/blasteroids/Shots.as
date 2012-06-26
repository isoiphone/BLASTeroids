package com.omgpanda.blasteroids {
	import flash.geom.Point;
	import flash.display.Stage;

	public class Shots extends Entity {
		public var mShots:Vector.<Entity> = new Vector.<Entity>();

		[Embed(source = "../art/projectile.png")]
		private var Projectile:Class;

		public function Shots(theStage:Stage) {
			super(theStage, null);
		}

		override public function update() : void {
			for each (var ent : Entity in mShots) {
				ent.update();
				ent.rotation += 3.0;
				
				if (ent.mAge > 1.0) {
					ent.alpha *= 0.8;
					if (ent.alpha <= 0.0 || ent.mAge >= 100.0)
						ent.destroy();
				}
			}
				
			// prune the dead
			mShots = mShots.filter(function(item:Entity, index:int, vector:Vector.<Entity>):Boolean {
				return (item.stage!=null);
			});
			
			//super.update();
		}
		
		public function spawn(position:Point, velocity:Point) : Entity {
			var ent:Entity = new Entity(stage, Projectile);
			ent.mPosition.setTo(position.x, position.y);
			ent.mVelocity.setTo(velocity.x, velocity.y);
			ent.x = position.x;
			ent.y = position.y;
			mShots.push(ent);
			return ent;
		}
		
		public function clear() : void {
			for each (var ent : Entity in mShots) {
				ent.destroy();
			}
			mShots.length = 0;
		}
	}
}
