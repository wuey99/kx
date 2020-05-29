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
		public var m_accel:Float;
		public var m_targetSpeed:Float;
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
		public var m_currentTicks:Float;
		public var m_totalTicks:Float;
		
		public var m_id:String;
		
		public var patternMovement:XTask9;
		
		public var m_formation:Formation;
		
		public var m_completed:Bool;
		
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
			
			patternMovement = cast addEmptyTask ();
			
			m_currentTicks = 0;
			m_totalTicks = 0;
			
			m_completed = false;
			
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
						
						applyAcceleration ();
						
						interpolateSplinePosition ();
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
			
			setInuse (true);

			setComplete ();
		}

//------------------------------------------------------------------------------------------
		public function setComplete ():Void {
			if (m_completed) {
				return;
			}
			
			m_completed = true;
			
			if (m_formation != null) {
				m_formation.incCompleteCount ();
			}
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
		public function applyAcceleration ():Void {
			if (m_accel > 0) {
				m_speed += m_accel;
				
				if (m_speed >= m_targetSpeed) {
					m_speed = m_targetSpeed;
				}
			} else {
				m_speed += m_accel;
				
				if (m_speed <= m_targetSpeed) {
					m_speed = m_targetSpeed;
				}
			}
		}
		
//------------------------------------------------------------------------------------------
		public function startSplineMovement (
			__startX:Float, __startY:Float,
			__targetX:Float, __targetY:Float,
			__ctrlX:Float, __ctrlY:Float,
			__ticks:Float
			):Void {
			
			trace (": startSplineMovement: ");
			
			m_startPos.x = __startX;
			m_startPos.y = __startY;
			
			m_targetPos.x = __targetX;
			m_targetPos.y = __targetY;
			
			m_ctrlPos.x = __ctrlX;
			m_ctrlPos.y = __ctrlY;
			
			m_currentTicks = 0;
			m_totalTicks = __ticks;
			
			calculateDelta (m_ctrlPos, m_startPos, m_startDelta, __ticks);
			calculateDelta (m_targetPos, m_ctrlPos, m_ctrlDelta, __ticks);

			gotoFormationAttackState ();
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
// move startPos to ctrlPos
// move ctrlPos to targetPos
//------------------------------------------------------------------------------------------
		public function interpolateSplinePosition ():Void {
			if (m_currentTicks == m_totalTicks) {
				return;
			}
			
			m_startPos.x += m_startDelta.x;
			m_startPos.y += m_startDelta.y;
			
			m_ctrlPos.x += m_ctrlDelta.x;
			m_ctrlPos.y += m_ctrlDelta.y;	
			
			m_currentTicks = Math.min (m_totalTicks, m_currentTicks + 0x0100);
			
			var __time:Float =  ticksToSeconds (m_currentTicks) / ticksToSeconds (m_totalTicks);
			
			var __deltaX:Float = (m_ctrlPos.x - m_startPos.x) * __time;
			var __deltaY:Float = (m_ctrlPos.y - m_startPos.y) * __time;
			
			oX = m_startPos.x + __deltaX;
			oY = m_startPos.y + __deltaY;
		}
		
//------------------------------------------------------------------------------------------
		public function setPattern (__pattern:Array<Dynamic>):Void {
			patternMovement.gotoTask (__pattern);
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
		public function setInuse (__flag:Bool):Void {
			if (m_formation != null) {
				var __formationPosition = m_formation.getFormationPositionById (m_id);
				
				if (__formationPosition != null) {
					__formationPosition.setInuse (__flag);
				}
			}
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
					FormationAttack_Script ();
					
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
			
			FormationAttack_Script ();
		}
		
//-----------------------------------------------------------------------------------------
		public function gotoAttackState ():Void {
			setInuse (true);
			
			m_state = ATTACK_STATE;
			
			Idle_Script ();
		}
		
//-----------------------------------------------------------------------------------------
		public function gotoPatternState ():Void {
			setInuse (true);
			
			m_state = PATTERN_STATE;
			
			Pattern_Script ();
		}
		
//-----------------------------------------------------------------------------------------
		public function gotoHomeState ():Void {
			setInuse (false);
						
			setComplete ();
			
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
		public function FormationAttack_Script ():Void {
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