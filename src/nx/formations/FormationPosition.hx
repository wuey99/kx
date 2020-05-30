//------------------------------------------------------------------------------------------
package nx.formations;
	
	import assets.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.world.objects.enemy.*;
	
	import gx.mickey.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class FormationPosition extends XLogicObjectCX {
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;
		
		public var script:XTask;
		
		public var m_pairedObject:FormationXLogicObject;
		public var m_pairedObjectIsDead:Bool;
		public var m_pairedObjectInuse:Bool;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
				
			script = addEmptyTask ();
			
			setPairedObject (null);
			setPairedObjectIsDead (false);
			setPairedObjectInuse (true);
			
			Idle_Script ();
		}

		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			m_sprite = createXMovieClip ("FormationTrigger:FormationTrigger");
			x_sprite = addSpriteAt (m_sprite, m_sprite.dx, m_sprite.dy);
			
			show ();
		}

		//------------------------------------------------------------------------------------------
		public function setPairedObject (__object:FormationXLogicObject):Void {
			m_pairedObject = __object;
		}
		
		//------------------------------------------------------------------------------------------
		public function getPairedObject ():FormationXLogicObject {
			return m_pairedObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function getPairedObjectIsDead ():Bool {
			return m_pairedObjectIsDead;
		}

		//------------------------------------------------------------------------------------------
		public function setPairedObjectIsDead (__value:Bool):Void {
			m_pairedObjectIsDead = __value;
		}
		
		//------------------------------------------------------------------------------------------
		public function getPairedObjectInuse ():Bool {
			return m_pairedObjectInuse;
		}
		
		//------------------------------------------------------------------------------------------
		public function setPairedObjectInuse (__flag:Bool):Void {
			m_pairedObjectInuse = __flag;
		}
		
		//------------------------------------------------------------------------------------------
		public function Idle_Script ():Void {
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
						
							function ():Void {
							},
						
						XTask.GOTO, "loop",
						
						XTask.RETN,
					]);
					
				},
				
				//------------------------------------------------------------------------------------------
				// animation
				//------------------------------------------------------------------------------------------	
				XTask.LABEL, "loop",
					function ():Void {
						m_sprite.gotoAndStop (1);
						
					}, XTask.WAIT, 0x0200,
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }