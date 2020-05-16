//------------------------------------------------------------------------------------------
package nx.formations;
	
	import assets.*;
	import js.html.ConstrainDOMStringParameters;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.world.objects.enemy.*;	

	import nx.task.*;
	
	import gx.mickey.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class FormationXLogicObject extends XLogicObjectCX {
		public var m_XTaskSubManager9:XTaskSubManager;
		
		public var script:XTask;
		public var gravity:XTask;
		
		public var m_targetX:Float;
		public var m_targetY:Float;
		public var m_speed:Float;
		public var m_autoSpeed:Bool;
		
		public var m_targetRotation:Float;
		public var m_rotationTicks:Float;
		public var m_rotationSpeed:Float;
		public var m_autoRotation:Bool;

		public var m_startPos:XPoint; // -> ctrlPos	
		public var m_startDelta:XPoint;
		public var m_ctrlPos:XPoint; // -> targetPos
		public var m_ctrlDelta:XPoint;
		public var m_targetPos:XPoint;
		
		public var m_id:String;
		
		public var movementPattern:XTask9;
		
		public var m_formation:Formation;
		
		public static inline var PATTERN_STATE:Int = 0;
		public static inline var HOME_STATE:Int = 1;
		public static inline var FORMATION_ATTACK_STATE:Int = 2;
		public static inline var ATTACK_STATE:Int = 3;
		
		public var m_state:Int;
		
		//------------------------------------------------------------------------------------------
		public function new (__xxx:XWorld = null) {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
						
			m_targetX = 0;
			m_targetY = 0;
			m_speed = 0;
			m_targetRotation = 180;
			m_rotationTicks = 0x0000;
			m_rotationSpeed = 0;
			m_autoSpeed = false;
			m_autoRotation = false;
				
			m_startPos = cast xxx.getXPointPoolManager ().borrowObject ();
			m_startDelta = cast xxx.getXPointPoolManager ().borrowObject ();	
			m_ctrlPos = cast xxx.getXPointPoolManager ().borrowObject ();
			m_ctrlDelta = cast xxx.getXPointPoolManager ().borrowObject ();
			m_targetPos = cast xxx.getXPointPoolManager ().borrowObject ();
			
			m_XTaskSubManager9 = new XTaskSubManager (getXTaskManager ());
			
			movementPattern = cast addEmptyTask ();
			
			addTask ([				
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					function ():Void {
						if (m_autoRotation) {
							applyRotation ();
						}
						
						if (m_autoSpeed) {
							applySpeed ();
						}
					},
					
					XTask.GOTO, "loop",
					
				XTask.RETN,
			]);
		}
		
	//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
			
			xxx.getXPointPoolManager ().returnObject (m_startPos);
			xxx.getXPointPoolManager ().returnObject (m_startDelta);
			xxx.getXPointPoolManager ().returnObject (m_ctrlPos);
			xxx.getXPointPoolManager ().returnObject (m_ctrlDelta);
			xxx.getXPointPoolManager ().returnObject (m_targetPos);
			
			m_XTaskSubManager9.removeAllTasks ();
		}

//------------------------------------------------------------------------------------------
		public function setID (__id:String):Void {
			m_id = __id;
		}
		
//------------------------------------------------------------------------------------------
		public function setFormation (__formation:Formation):Void {
			m_formation = __formation;
		}
		
//------------------------------------------------------------------------------------------
		public function getFormation ():Formation {
			return m_formation;
		}
		
//------------------------------------------------------------------------------------------
		public function applyRotation ():Void {
			if (m_rotationTicks < 0x0080) {
				oRotation = m_targetRotation;
			
				return;
			}
			
			m_rotationTicks -= 0x0100;
	
			oRotation = (oRotation + m_rotationSpeed) % 360;
		}
		
//------------------------------------------------------------------------------------------
		public function applySpeed ():Void {
			var __angle:Float = ((oRotation - 90.0) % 360);
			var __radians:Float = __angle * (Math.PI / 180);
			
			oDX = Math.cos (__radians) * m_speed;
			oDY = Math.sin (__radians) * m_speed;			
		}

//------------------------------------------------------------------------------------------
		public function calculateDelta (__target:XPoint, __start:XPoint, __delta:XPoint, __ticks:Float):Void {
			__delta.x = (__target.x - __start.x) / ticksToSeconds (__ticks);
			__delta.y = (__target.y - __start.y) / ticksToSeconds (__ticks);
		}

//------------------------------------------------------------------------------------------
		public function ticksToSeconds (__ticks:Float):Float {
			var __seconds:Float = __ticks / 256;
			var __frac:Float = (Std.int (__ticks) & 255) / 256;
			
			return __seconds + __frac;
		}
		
//------------------------------------------------------------------------------------------
		public function setPattern (__pattern:Array<Dynamic>):Void {
			movementPattern.gotoTask (__pattern);
		}

//------------------------------------------------------------------------------------------
		public function getHomePosX ():Float {
			var __formationPosition = m_formation.getFormationPositionById (m_id);
			
			return __formationPosition.oX;
		}
		
//------------------------------------------------------------------------------------------
		public function getHomePosY ():Float {
			var __formationPosition = m_formation.getFormationPositionById (m_id);
			
			return __formationPosition.oY;		
		}
		
//------------------------------------------------------------------------------------------
		public function getFormationPositionById (__id:String):FormationPosition {
			return m_formation.getFormationPositionById (__id);
		}

//------------------------------------------------------------------------------------------
		public function setToHomePos ():Void {
			var __formationPosition = m_formation.getFormationPositionById (m_id);
			
			oX = __formationPosition.oX;
			oY = __formationPosition.oY;
		}
		
//------------------------------------------------------------------------------------------
		public function spawnEnemy (__id:String, __class:Class<Dynamic>, __script:Array<Dynamic>, __x:Float, __y:Float):Void {
		}

//------------------------------------------------------------------------------------------
		public function returnFromHitScript ():Void {
			switch (m_state) {
				case PATTERN_STATE:
					Pattern_Script ();
					
				case HOME_STATE:
					Home_Script ();
	
				case FORMATION_ATTACK_STATE:
					Idle_Script ();
					
				case ATTACK_STATE:
					Idle_Script ();
			}
		}

//-----------------------------------------------------------------------------------------
		public function getState ():Int {
			return m_state;
		}
		
//-----------------------------------------------------------------------------------------
		public function gotoFormationAttackState ():Void {
			m_state = FORMATION_ATTACK_STATE;
			
			Idle_Script ();
		}
		
//-----------------------------------------------------------------------------------------
		public function gotoAttackState ():Void {
			m_state = ATTACK_STATE;
			
			Idle_Script ();
		}
		
//-----------------------------------------------------------------------------------------
		public function gotoPatternState ():Void {
			m_state = PATTERN_STATE;
			
			Pattern_Script ();
		}
		
//-----------------------------------------------------------------------------------------
		public function gotoHomeState ():Void {
			m_state = HOME_STATE;
			
			Home_Script ();
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
					XTask.WAIT, 0x0100,
					
					function ():Void {
						
					},
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
//------------------------------------------------------------------------------------------
		public function Pattern_Script ():Void {
			
			Idle_Script ();
			
			//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		public function Home_Script ():Void {
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
						
							function ():Void {
								setToHomePos ();
							},
						
						XTask.GOTO, "loop",
						
						XTask.RETN,
					]);
					
				},
				
				//------------------------------------------------------------------------------------------
				// animation
				//------------------------------------------------------------------------------------------	
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					function ():Void {
						
					},
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
//------------------------------------------------------------------------------------------
// XTaskManager
//------------------------------------------------------------------------------------------
		public override function getXTaskManager ():XTaskManager {
			return cast (getXLogicManager (), XLogicManager9).getXTaskManager9 ();
		}
		
//------------------------------------------------------------------------------------------
		public override function addTask (
			__taskList:Array<Dynamic> /* <Dynamic> */,
			__findLabelsFlag:Bool = true
			):XTask {

			var __task:XTask9 = cast m_XTaskSubManager9.addTask (__taskList, __findLabelsFlag);
			
			__task.setParent (this);
			__task.setObject (this);
	
			return __task;
		}

//------------------------------------------------------------------------------------------
		public override function changeTask (
			__task:XTask,
			__taskList:Array<Dynamic> /* <Dynamic> */,
			__findLabelsFlag:Bool = true
			):XTask {
				
			return m_XTaskSubManager9.changeTask (__task, __taskList, __findLabelsFlag);
		}

//------------------------------------------------------------------------------------------
		public override function isTask (__task:XTask):Bool {
			return m_XTaskSubManager9.isTask (__task);
		}		
		
//------------------------------------------------------------------------------------------
		public override function removeTask (__task:XTask):Void {
			m_XTaskSubManager9.removeTask (__task);	
		}

//------------------------------------------------------------------------------------------
		public override function removeAllTasks ():Void {
			m_XTaskSubManager9.removeAllTasks ();
		}

//------------------------------------------------------------------------------------------
		public override function addEmptyTask ():XTask {
			var __task:XTask9 = cast m_XTaskSubManager9.addEmptyTask ();
			
			__task.setObject (this);
			
			return __task;
		}

//------------------------------------------------------------------------------------------
		public override function getEmptyTaskX ():Array<Dynamic> /* <Dynamic> */ {
			return m_XTaskSubManager9.getEmptyTaskX ();
		}	
		
//------------------------------------------------------------------------------------------
		public override function gotoLogic (__logic:Dynamic /* Function */):Void {
			m_XTaskSubManager9.gotoLogic (__logic);
		}

	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }