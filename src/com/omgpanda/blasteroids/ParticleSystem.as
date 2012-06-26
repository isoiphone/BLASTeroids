package com.omgpanda.blasteroids {
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.display.Stage;
	import flash.display.Sprite;
	public class ParticleSystem extends Entity {
		private const MAX : int = 5000;
		private const BORDER : Number = 50;
		private var mCount : int = 0; 
		private var mParticle : Vector.<Particle> = new Vector.<Particle>();
		
		public function ParticleSystem(theStage : Stage) {
			super(theStage, null);
			
			for (var i : int = 0; i<MAX; ++i) {
				var particle : Particle = new Particle();
				particle.visible = false; 
				stage.addChild(particle);
				mParticle.push(particle); 
			}
		}
		
		override public function update() : void {
			for (var i : int = 0; i<mCount; ++i) {
				var p : Particle = mParticle[i];
				
				// objects in motion...
				const dx : Number = p.x0-p.x1;
				const dy : Number = p.y0-p.y1;
				
				p.x1 = p.x0;
				p.y1 = p.y0;
				
				p.x0 += dx;
				p.y0 += dy;
				
				// edges of screen, die
				if (p.x < -BORDER || p.y < -BORDER || p.x > stage.stageWidth+BORDER || p.y > stage.stageHeight+BORDER)
					p.life = 0;
				
				// old age, die
				if (--p.life <= 0) {
					p.visible = false;
					
					// swap the dead particle with the end o' the list
					if (i < mCount) {
						mParticle[i] = mParticle[mCount-1];
						mParticle[mCount-1] = p;
					}
					--mCount;
				} else {
					// actual screen positions
					p.x = p.x0;
					p.y = p.y0;
					
					if (p.life < 60) {
						const t : Number = (p.life/60);
						p.alpha = t*t;
					}
				}
			}
		}
		
		public function smoke(cx : Number, cy : Number, fx : Number, fy : Number, color : uint=0x919b9e) : void {
			const count : int = Math.random()*2 + 1.0;
			
			for (var i:int=mCount; i<(mCount+count) && i<MAX; ++i) {
				var p : Particle = mParticle[i];
				
				const speed : Number = (Math.random()*2)+0.1;
				const angle : Number = Math.random()*Math.PI*2.0;
				const vx : Number = Math.cos(angle)*speed;
				const vy : Number = Math.sin(angle)*speed;
				const ox : Number = (Math.random()-0.5)*3;
				const oy : Number = (Math.random()-0.5)*3;
				
				p.visible = true;
				p.alpha = 1.0;
				p.life = stage.frameRate*Math.random()*2;
				p.x = p.x0 = cx-ox;
				p.y = p.y0 = cy-oy;
				p.x1 = cx-vx-ox-fx;
				p.y1 = cy-vy-oy-fy;
				
				p.setColor(color);
			}
			
			mCount += count;
		}
		
		public function explode(cx : Number, cy : Number) : void {
			const count : int = 100+Math.random()*25;
			
			for (var i:int=mCount; i<(mCount+count) && i<MAX; ++i) {
				var p : Particle = mParticle[i];
				
				const speed : Number = (Math.random()*4)+2.0;
				const angle : Number = Math.random()*Math.PI*2.0;
				const vx : Number = Math.cos(angle)*speed;
				const vy : Number = Math.sin(angle)*speed;
				const ox : Number = (Math.random()-0.5)*8;
				const oy : Number = (Math.random()-0.5)*8;
				
				p.visible = true;
				p.alpha = 1.0;
				p.life = stage.frameRate*3+(Math.random()*2);
				p.x = p.x0 = cx-ox;
				p.y = p.y0 = cy-oy;
				p.x1 = cx-vx-ox;
				p.y1 = cy-vy-oy;
				
				if (Math.random() < 0.15) {
					p.setColor(0xFF00FF);
					// even faster!
					p.x1 -= vx*0.5;
					p.y1 -= vy*0.5;
				} else {
					p.setColor(0x00FFFF);
				}
			}
			
			mCount += count;
		}
	}
}
