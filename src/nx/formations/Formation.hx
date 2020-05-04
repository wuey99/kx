//------------------------------------------------------------------------------------------
package nx.formations;
	
	import assets.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.type.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.world.objects.enemy.*;
	
	import gx.mickey.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	import nx.task.*;
	
	//------------------------------------------------------------------------------------------
	typedef FormationDef = {
		id:String,
		x:Float,
		y:Float,
	}
	
	//------------------------------------------------------------------------------------------
	class Formation extends FormationXLogicObject {
		public var m_formationPositions:Map<String, FormationPosition>;
	
		public var skyRect(get, set):XRect;
		public var m_skyRect:XRect;
		
		public var offScreenLeft(get, null):Float;
		public var offScreenRight(get, null):Float;
		public var offScreenTop(get, null):Float;
		public var offScreenBottom(get, null):Float;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic>):Void {
			super.setup (__xxx, args);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
			createFormation ();
			
			script = addEmptyTask ();
			
			Idle_Script ();	
		}
		
		//------------------------------------------------------------------------------------------
		public function addFormationPositions (formationDefs:Array<FormationDef>):Void {
			if (m_formationPositions == null) {
				m_formationPositions = new Map<String, FormationPosition> ();
			}

			var __skyRect:XRect = G.appX.getLevelObjectX ().getSkyRect ();
			var __groundRect:XRect = G.appX.getLevelObjectX ().getGroundRect ();
			var __skyPos:XPoint = xxx.getXPointPoolManager ().borrowObject ();
									
			__skyPos.x = oX;
			__skyPos.y = oY;
			
			__skyPos = G.appX.getLevelObjectX ().translateGroundToSky (__skyPos);
			
			var __x:Float = __skyRect.x + __skyRect.width / 2;
			var __y:Float = __skyPos.y;
			
			var __formationPosition:FormationPosition;
			
			for (formationDef in formationDefs) {
				__formationPosition = cast xxx.getXLogicManager ().initXLogicObject (
					// parent
					G.appX.getLevelObject (),
					// logicObject
					new FormationPosition (),
					// item, layer, depth
					null, G.appX.SKY_LAYER, getDepth (),
					// x, y, z
					__x + formationDef.x, __y + formationDef.y, 0,
					// scale, rotation
					1.0, 0
				);
				
				m_formationPositions.set (formationDef.id, __formationPosition);
				
				G.appX.getLevelObject ().addXLogicObject (__formationPosition);
			}
			
			xxx.getXPointPoolManager ().returnObject (__skyPos);
		}
		
		//------------------------------------------------------------------------------------------
		public function createFormation ():Void {
		}

		//------------------------------------------------------------------------------------------
		public override function getFormationPositionById (__id:String):FormationPosition {
			return m_formationPositions.get (__id);
		}
		
		//------------------------------------------------------------------------------------------
		public override function spawnEnemy (__id:String, __class:Class<Dynamic>, __pattern:Array<Dynamic>, __x:Float, __y:Float):Void {
			var __enemyObject:FormationXLogicObject = cast xxx.getXLogicManager ().initXLogicObjectFromPool (
				// parent
				G.appX.getLevelObject (),
				// logicObject
				__class,
				// item, layer, depth
				null, G.appX.SKY_LAYER, getDepth (),
				// x, y, z
				__x, __y, 0,
				// scale, rotation
				1.0, 0
			);
				
			__enemyObject.setID (__id);
			__enemyObject.setFormation (this);
			
			__enemyObject.setXMapModel (
				G.appX.SKY_LAYER,
				getXMapModel ()
			);
			
			__enemyObject.setPattern (__pattern);
			
			__enemyObject.gotoPatternState ();
			
			G.appX.getLevelObject ().addXLogicObject (__enemyObject);
		}
		
		//------------------------------------------------------------------------------------------
		public function get_offScreenTop ():Float {
			return skyRect.y - 128;
		}

		//------------------------------------------------------------------------------------------
		public function get_offScreenBottom ():Float {
			return skyRect.y + skyRect.height + 128;
		}
		
		//------------------------------------------------------------------------------------------
		public function get_offScreenLeft ():Float {
			return skyRect.x - 224;
		}

		//------------------------------------------------------------------------------------------
		public function get_offScreenRight ():Float {
			return skyRect.x + skyRect.width + 224;
		}

		//------------------------------------------------------------------------------------------
		public function getScreenX (__percentage:Float):Float {
			return skyRect.x + skyRect.width * __percentage;
		}
		
		//------------------------------------------------------------------------------------------
		public function getScreenY (__percentage:Float):Float {
			return skyRect.y + skyRect.height * __percentage;
		}
		
		//------------------------------------------------------------------------------------------
		public function get_skyRect ():XRect {
			if (m_skyRect == null) {
				m_skyRect = G.appX.getSkyRect ();
			}
			
			return m_skyRect;
		}
		
		//------------------------------------------------------------------------------------------
		public function set_skyRect (__rect:XRect):XRect {
			m_skyRect = __rect;
			
			return m_skyRect;
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			show ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function Idle_Script ():Void {
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
						
					}, XTask.WAIT, 0x0200,
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
			
		//------------------------------------------------------------------------------------------
		public function moveToHomePositionX ():Array<Dynamic> {
			return [
				XTask9.MOVE_TO_HOME_POS, 0x2000,
				XTask9.ROTATE_TO, 0, 0x2000,
				XTask.WAIT, 0x2000,
				XTask9.SET_SPEED, 0,
				XTask9.SET_HOME_POS,

				XTask.RETN,
			];
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }