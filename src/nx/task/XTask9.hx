//------------------------------------------------------------------------------------------
package nx.task;
	
	import kx.geom.XRect;
	import openfl.system.*;
	import openfl.utils.*;
	
	import kx.*;
	import kx.collections.*;
	import kx.pool.*;
	import kx.type.*;
	import kx.task.*;
	import kx.world.logic.*;
	
	import nx.formations.*;
	
	//------------------------------------------------------------------------------------------
	// test
	//------------------------------------------------------------------------------------------
	class XTask9 extends XTask {
		
		public static inline var SET_ROTATION:Int = XTask.XTask_OPCODES + 0;
		public static inline var SET_POS:Int =  XTask.XTask_OPCODES + 1;
		public static inline var SET_SCALE:Int = XTask.XTask_OPCODES + 2;
		public static inline var SET_ALPHA:Int = XTask.XTask_OPCODES + 3;
		public static inline var SET_HOME_POS:Int =  XTask.XTask_OPCODES + 4;
		public static inline var SET_SPEED:Int =  XTask.XTask_OPCODES + 5;
		public static inline var SET_ACCEL_TO:Int = XTask.XTask_OPCODES + 6;
		public static inline var ROTATE:Int =  XTask.XTask_OPCODES + 7;
		public static inline var ROTATE_TO:Int =  XTask.XTask_OPCODES + 8;
		public static inline var ROTATE_TO_POS:Int = XTask.XTask_OPCODES + 9;
		public static inline var ROTATE_TO_HOME_POS:Int = XTask.XTask_OPCODES + 10;		
		public static inline var MOVE_TO:Int =  XTask.XTask_OPCODES + 11;
		public static inline var SPLINE_TO:Int = XTask.XTask_OPCODES + 12;
		public static inline var MOVE_TO_HOME_POS:Int = XTask.XTask_OPCODES + 13;
		public static inline var RETURN_TO_HOME_POS:Int = XTask.XTask_OPCODES + 14;
		public static inline var ENABLE_AUTO_ROTATION:Int = XTask.XTask_OPCODES + 15;
		public static inline var DISABLE_AUTO_ROTATION:Int = XTask.XTask_OPCODES + 16;
		public static inline var ENABLE_AUTO_SPEED:Int = XTask.XTask_OPCODES + 17;
		public static inline var DISABLE_AUTO_SPEED:Int = XTask.XTask_OPCODES + 18;
		public static inline var ENABLE_AUTO_SPEED_AND_ROTATION:Int = XTask.XTask_OPCODES + 19;
		public static inline var DISABLE_AUTO_SPEED_AND_ROTATION:Int = XTask.XTask_OPCODES + 20;
		public static inline var SPAWN_FORMATION_ENEMY:Int = XTask.XTask_OPCODES + 21;
		public static inline var SPAWN_ENEMY_AT_INDEX:Int = XTask.XTask_OPCODES + 22;		
		public static inline var SPAWN_RANDOM_ENEMY:Int = XTask.XTask_OPCODES + 23;
		public static inline var GET_NEXT_ENEMY_FROM_FORMATION:Int = XTask.XTask_OPCODES + 24;
		public static inline var GET_RANDOM_ENEMY_FROM_FORMATION:Int = XTask.XTask_OPCODES + 25;
		public static inline var LAUNCH_ENEMY:Int =  XTask.XTask_OPCODES + 26;
		public static inline var LAUNCH_ATTACK:Int = XTask.XTask_OPCODES + 27;
		public static inline var ALL_ENEMIES_DEAD:Int =  XTask.XTask_OPCODES + 28;
		public static inline var NUKE:Int = XTask.XTask_OPCODES + 29;
			
		public var m_object:FormationXLogicObject;
		public var m_targetObject:FormationXLogicObject;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();	
		}
		
		//------------------------------------------------------------------------------------------
		public function getObject ():FormationXLogicObject {
			return m_object;
		}

		//------------------------------------------------------------------------------------------
		public function getTargetObject ():FormationXLogicObject {
			return m_targetObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function setObject (__value:FormationXLogicObject):Void {
			m_object = __value;
		}
		
		//------------------------------------------------------------------------------------------
		public function getFormation ():Formation {
			return m_object.getFormation ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function findMoreLabels (x:Int, i:Int):Int {
			
			switch (x) {
				// XTask9.SET_ROTATION, <degrees>
				case SET_ROTATION:
					i++;
					
				// XTask9.SET_POS, <xpos>, <ypos>
				case SET_POS:
					i += 2;
					
				// XTask9.SET_ALPHA, <value>
				case SET_ALPHA:
					i++;
					
				// XTask9.SET_SCALE, <value>
				case SET_SCALE:
					i++;
					
				// XTask9.SET_HOME_POS
				case SET_HOME_POS:
					
				// XTask9.SET_SPEED, <speed>
				case SET_SPEED:
					i++;
					
				// XTask9.SET_ACCEL_TO, <targetSpeed>, <initalSpeed>, <accel>
				case SET_ACCEL_TO:
					i += 3;
					
				// XTask9.ROTATE, <degrees>, <ticks>
				case ROTATE:
					i += 2;
					
				// XTask9.ROTATE_TO, <angle>, <ticks>
				case ROTATE_TO:
					i += 2;
					
				// XTask9.ROTATE_TO_POS, <xpos>, <ypos>, <ticks>
				case ROTATE_TO_POS:
					i += 3;
					
				// XTask9.ROTATE_TO_HOME_POS, <ticks>
				case ROTATE_TO_HOME_POS:
					i += 1;	
					
				// XTask9.MOVE_TO, <xpos>, <ypos>, <ticks>
				case MOVE_TO:
					i += 3;
					
				// XTask9.SPLINE_TO, <targetX>, <targetY>, <ctrlX>, <ctrlY>, <ticks>
					i += 5;
					
				// XTask9.MOVE_TO_HOME_POS, <ticks>
				case MOVE_TO_HOME_POS:
					i += 1;
					
				// XTask9.RETURN_TO_HOME_POS, <ticks>
				case RETURN_TO_HOME_POS:
					i += 1;
					
				// XTask9.ENABLE_AUTO_ROTATION
				case ENABLE_AUTO_ROTATION:
					
				// XTask9.DISBLE_AUTO_ROTATION
				case DISABLE_AUTO_ROTATION:
					
				// XTask9.ENABLE_AUTO_SPEED
				case ENABLE_AUTO_SPEED:
					
				// XTask9.DISABLE_AUTO_SPEED
				case DISABLE_AUTO_SPEED:
					
				// XTask9.ENABLE_AUTO_SPEED_AND_ROTATION
				case ENABLE_AUTO_SPEED_AND_ROTATION:
				
				// XTask9.DISABLE_AUTO_SPEED_AND_ROTATION
				case DISABLE_AUTO_SPEED_AND_ROTATION:
					
				// XTask9.SPAWN_FORMATION_ENEMY, <id>, <class>, <task>, <x>, <y>, <params>
				case SPAWN_FORMATION_ENEMY:
					i += 6;
					
				// XTask9.SPAWN_ENEMY_AT_INDEX, <index>, <id>, <class>, <task>, <x>, <y>, <params>
				case SPAWN_ENEMY_AT_INDEX:
					i += 7;
					
				// XTask9.SPAWN_RANDOM_ENEMY, <id>, <class>, <task>, <x>, <y>, <params>
				case SPAWN_RANDOM_ENEMY:
					i += 6;
					
				// XTask9.GET_NEXT_ENEMY_FROM_FORMATION, <sequenceIndex>, ["01", "02", "03"]
				case GET_NEXT_ENEMY_FROM_FORMATION:
					i += 2;
					
				// XTask9.GET_RANDOM_ENEMY_FROM_FORMATION, ["01", "02", "03"]
				case GET_RANDOM_ENEMY_FROM_FORMATION:
					i += 1;
					
				// XTask9.LAUNCH_ENEMY, <task>
				case LAUNCH_ENEMY:
					i += 1;
					
				// XTask9.LAUNCH_ATTACK
				case LAUNCH_ATTACK:
		
				// XTask9.ALL_ENEMIES_DEAD, ["01", "02", "03"]
				case ALL_ENEMIES_DEAD:
					i += 1;
					
				// XTask9.NUKE
				case NUKE:
			}
			
			return i;
		}
		
		//------------------------------------------------------------------------------------------
		public override function evalMoreInstructions (value:Int):Bool {
			
			//------------------------------------------------------------------------------------------
			switch (value) {
				//------------------------------------------------------------------------------------------
				
				//------------------------------------------------------------------------------------------
				// XTask9.SET_ROTATION, <degrees>	
				//------------------------------------------------------------------------------------------
				case SET_ROTATION:
				//------------------------------------------------------------------------------------------
					getObject ().oRotation = getObject ().m_targetRotation = __evalNumber ();
					
				//------------------------------------------------------------------------------------------
				// XTask9.SET_POS, <xpos>, <ypos>
				//------------------------------------------------------------------------------------------
				case SET_POS:
				//------------------------------------------------------------------------------------------
					getObject ().oX = __evalNumber ();
					getObject ().oY = __evalNumber ();
				
				//------------------------------------------------------------------------------------------
				// XTask9.SET_ALPHA, <value>
				//------------------------------------------------------------------------------------------
				case SET_ALPHA:
				//------------------------------------------------------------------------------------------
					getObject ().oAlpha = __evalNumber ();
					
				//------------------------------------------------------------------------------------------
				// XTask9.SET_SCALE, <value>
				//------------------------------------------------------------------------------------------
				case SET_SCALE:
				//------------------------------------------------------------------------------------------
					getObject ().oScale = __evalNumber ();
					
				//------------------------------------------------------------------------------------------
				// XTask9.SET_HOME_POS:
				//------------------------------------------------------------------------------------------
				case SET_HOME_POS:
					var __formationPosition:FormationPosition = getObject ().getFormationPositionById (getObject ().m_id);

					if (__formationPosition != null) {
						getObject ().oX = __formationPosition.oX;
						getObject ().oY = __formationPosition.oY;
						getObject ().oDX = 0;
						getObject ().oDY = 0;
						getObject ().oRotation = __formationPosition.oRotation;
						getObject ().m_autoRotation = false;
						getObject ().m_autoSpeed = false;
					
						getObject ().gotoHomeState ();
					}
					
				//------------------------------------------------------------------------------------------
					
				//------------------------------------------------------------------------------------------
				// XTask9.SET_SPEED, <speed>
				//------------------------------------------------------------------------------------------
				case SET_SPEED:
				//------------------------------------------------------------------------------------------
					getObject ().m_speed = __evalNumber ();
					getObject ().applySpeed ();
					
				//------------------------------------------------------------------------------------------
				// XTask9.SET_ACCEL_TO, <targetSpeed>, <initalSpeed>, <accel>
				//------------------------------------------------------------------------------------------
				case SET_ACCEL_TO:
				//------------------------------------------------------------------------------------------
					getObject ().m_targetSpeed = __evalNumber ();
					getObject ().m_speed = __evalNumber ();
					getObject ().m_accel = __evalNumber ();
					getObject ().applySpeed ();
					
				//------------------------------------------------------------------------------------------
				// XTask9.ROTATE, <degrees>, <ticks>
				//------------------------------------------------------------------------------------------
				case ROTATE:
				//------------------------------------------------------------------------------------------
					var __degrees:Float = __evalNumber ();
					var __ticks:Float = __evalNumber ();
					
					getObject ().m_targetRotation = (getObject ().oRotation + __degrees) % 360;
					getObject ().m_rotationSpeed = __degrees / ticksToSeconds (__ticks);
					getObject ().m_rotationTicks += __ticks;
					
				//------------------------------------------------------------------------------------------
				// XTask9.ROTATE_TO, <angle>, <ticks>
				//------------------------------------------------------------------------------------------
				case ROTATE_TO:
				//------------------------------------------------------------------------------------------
					rotateTo (getObject ().oRotation, __evalNumber (), __evalNumber ());
					
				//------------------------------------------------------------------------------------------
				// XTask9.ROTATE_TO_POS, <xpos>, <ypos>, <ticks>
				//------------------------------------------------------------------------------------------
				case ROTATE_TO_POS:
				//------------------------------------------------------------------------------------------
					var __targetX:Float = __evalNumber ();
					var __targetY:Float = __evalNumber ();
					var __ticks:Float =  __evalNumber ();
					
					var __targetRotation:Float = getAngleToTarget (__targetX, __targetY);
									
					rotateTo (getObject ().oRotation, __targetRotation, __ticks);
					
				//------------------------------------------------------------------------------------------
				// XTask9.ROTATE_TO_HOME_POS, <ticks>
				//------------------------------------------------------------------------------------------
				case ROTATE_TO_HOME_POS:
				//------------------------------------------------------------------------------------------		
					var __ticks:Float = __evalNumber ();
					
					var __formationPosition:FormationPosition = getObject ().getFormationPositionById (getObject ().m_id);

					if (__formationPosition != null) {
						var __targetRotation:Float = getAngleToTarget (__formationPosition.oX, __formationPosition.oY);
						
						rotateTo (getObject ().oRotation, __targetRotation, __ticks);
					}
					
				//------------------------------------------------------------------------------------------
				// XTask9.MOVE_TO, <xpos>, <ypos>, <ticks>
				//------------------------------------------------------------------------------------------
				case MOVE_TO:
				//------------------------------------------------------------------------------------------
					moveTo (getObject ().oX, getObject ().oY, __evalNumber (), __evalNumber (), __evalNumber ());
					
				//------------------------------------------------------------------------------------------
				// XTask9.SPLINE_TO, <targetX>, <targetY>, <ctrlX>, <ctrlY>, <ticks>
				//------------------------------------------------------------------------------------------
				case SPLINE_TO:
					var __targetX:Float = __evalNumber ();
					var __targetY:Float = __evalNumber ();
					var __ctrlX:Float = __evalNumber ();
					var __ctrlY:Float = __evalNumber ();
					var __ticks:Float = __evalNumber ();
					
					getObject ().startSplineMovement (
						getObject ().oX, getObject ().oY,
						__targetX, __targetY,
						__ctrlX, __ctrlY,
						__ticks
					);
					
				//------------------------------------------------------------------------------------------
				// XTask9.MOVE_TO_HOME_POS, <ticks>	
				//------------------------------------------------------------------------------------------		
				case MOVE_TO_HOME_POS:
				//------------------------------------------------------------------------------------------	
					var __formationPosition:FormationPosition = getObject ().getFormationPositionById (getObject ().m_id);
	
					if (__formationPosition != null) {
						// moveTo (getObject ().oX, getObject ().oY, __formationPosition.oX, __formationPosition.oY, __evalNumber ());
						moveToObject (getObject ().oX, getObject ().oY, __formationPosition, __evalNumber ());
					}
					
				//------------------------------------------------------------------------------------------
				// XTask9.RETURN_TO_HOME_POS, <ticks>
				//------------------------------------------------------------------------------------------		
				case RETURN_TO_HOME_POS:
					var __formationPosition:FormationPosition = getObject ().getFormationPositionById (getObject ().m_id);
	
					if (__formationPosition != null) {
						getObject ().returnHome ();

						getObject ().oX = __formationPosition.oX;
						getObject ().oY = getObject ().offScreenTop;
						
						// moveTo (getObject ().oX, getObject ().oY, __formationPosition.oX, __formationPosition.oY, __evalNumber ());
						moveToObject (getObject ().oX, getObject ().oY, __formationPosition, __evalNumber ());
					}
					
				//------------------------------------------------------------------------------------------
				// XTask9.ENABLE_AUTO_ROTATION
				//------------------------------------------------------------------------------------------
				case ENABLE_AUTO_ROTATION:
				//------------------------------------------------------------------------------------------
					getObject ().m_autoRotation = true;
				
				//------------------------------------------------------------------------------------------
				// XTask9.DISABLE_AUTO_ROTATION
				//------------------------------------------------------------------------------------------
				case DISABLE_AUTO_ROTATION:
				//------------------------------------------------------------------------------------------
					getObject ().m_autoRotation = false;
					
				//------------------------------------------------------------------------------------------
				// XTask9.ENABLE_AUTO_SPEED
				//------------------------------------------------------------------------------------------
				case ENABLE_AUTO_SPEED:
				//------------------------------------------------------------------------------------------
					getObject ().m_autoSpeed = true;
					
				//------------------------------------------------------------------------------------------
				// XTask9.DISABLE_AUTO_SPEED
				//------------------------------------------------------------------------------------------
				case DISABLE_AUTO_SPEED:
				//------------------------------------------------------------------------------------------
					getObject ().m_autoSpeed = false;
					
				//------------------------------------------------------------------------------------------
				// XTask9.ENABLE_AUTO_SPEED_AND_ROTATION
				//------------------------------------------------------------------------------------------
				case ENABLE_AUTO_SPEED_AND_ROTATION:
				//------------------------------------------------------------------------------------------
					getObject ().m_autoRotation = true;
					getObject ().m_autoSpeed = true;
					
				//------------------------------------------------------------------------------------------
				// XTask9.DISABLE_AUTO_SPEED_AND_ROTATION
				//------------------------------------------------------------------------------------------
				case DISABLE_AUTO_SPEED_AND_ROTATION:
				//------------------------------------------------------------------------------------------
					getObject ().m_autoRotation = false;
					getObject ().m_autoSpeed = false;
					
				//------------------------------------------------------------------------------------------
				// XTask9.SPAWN_FORMATION_ENEMY
				//------------------------------------------------------------------------------------------
				case SPAWN_FORMATION_ENEMY:
					var __id:String = cast m_taskList[m_taskIndex++];
					var __class:Class<Dynamic> = cast m_taskList[m_taskIndex++];
					var __script:Array<Dynamic> = cast m_taskList[m_taskIndex++];
					var __x:Float = __evalNumber ();
					var __y:Float = __evalNumber ();
					var __params:Array<Dynamic> = cast m_taskList[m_taskIndex++];
					
					getObject ().spawnFormationEnemy (__id, __class, __script, __x, __y, __params);
					
				//------------------------------------------------------------------------------------------
				// XTask9.SPAWN_ENEMY_AT_INDEX
				//------------------------------------------------------------------------------------------
				case SPAWN_ENEMY_AT_INDEX:
					var __index:XNumber = cast m_taskList[m_taskIndex++];
					var __enemyList:Array<Dynamic> = cast m_taskList[m_taskIndex++];
					var __class:Class<Dynamic> = cast m_taskList[m_taskIndex++];
					var __script:Array<Dynamic> = cast m_taskList[m_taskIndex++];
					var __x:Float = __evalNumber ();
					var __y:Float = __evalNumber ();
					var __params:Array<Dynamic> = cast m_taskList[m_taskIndex++];

					var __id:String = __enemyList[Std.int (__index.value)];
					
					m_targetObject = getObject ().spawnEnemy (__id, __class, __script, __x, __y, __params);
					
				//------------------------------------------------------------------------------------------
				// XTask9.SPAWN_RANDOM_ENEMY
				//------------------------------------------------------------------------------------------
				case SPAWN_RANDOM_ENEMY:
					var __enemyList:Array<Dynamic> = cast m_taskList[m_taskIndex++];
					var __class:Class<Dynamic> = cast m_taskList[m_taskIndex++];
					var __script:Array<Dynamic> = cast m_taskList[m_taskIndex++];
					var __x:Float = __evalNumber ();
					var __y:Float = __evalNumber ();
					var __params:Array<Dynamic> = cast m_taskList[m_taskIndex++];
					
					var __id:String = null;
					
					if (__enemyList != null) {
						__id = __enemyList[Std.random (__enemyList.length)];
					}
					
					m_targetObject = getObject ().spawnEnemy (__id, __class, __script, __x, __y, __params);
					
				//------------------------------------------------------------------------------------------
				// XTask9.GET_NEXT_ENEMY_FROM_FORMATION
				//------------------------------------------------------------------------------------------
				case GET_NEXT_ENEMY_FROM_FORMATION:
					var __index:XNumber = cast m_taskList[m_taskIndex++];
					var __enemyList:Array<Dynamic> = cast m_taskList[m_taskIndex++];
					var __id:String;
					var __formationPosition:FormationPosition;
									
					setFlagsEQ ();
					
					trace (": allEnemiesInUse: ", allEnemiesInuse (__enemyList));
					
					if (!allEnemiesInuse (__enemyList)) {
						var __processed:Bool = false;
						
						while (!__processed) {
							if (__index.value >= __enemyList.length) {
								__index.value = 0;
							}
							
							__id = cast __enemyList[Std.int (__index.value++)];
								
							__formationPosition = getObject ().getFormationPositionById (__id);
								
							if (__formationPosition.getPairedObject () != null && !__formationPosition.getPairedObjectIsDead () && !__formationPosition.getPairedObjectInuse ()) {
								trace (": GET_NEXT_ENEMY: ", __id);
								
								m_targetObject = __formationPosition.getPairedObject ();
								
								__processed = true;
							}
						}
					} else {
						setFlagsNE ();
					}
		
										
				//------------------------------------------------------------------------------------------
				// XTask9.GET_RANDOM_ENEMY_FROM_FORMATION
				//------------------------------------------------------------------------------------------
				case GET_RANDOM_ENEMY_FROM_FORMATION:
					var __enemyList:Array<Dynamic> = cast m_taskList[m_taskIndex++];
					var __id:String;
					var __formationPosition:FormationPosition;
					
					setFlagsEQ ();
					
					if (!allEnemiesInuse (__enemyList)) {
						var __processed:Bool = false;
						
						while (!__processed) {
							var __index:Int = Std.random (__enemyList.length);
							
							__id = cast __enemyList[Std.int (__index)];
								
							__formationPosition = getObject ().getFormationPositionById (__id);
								
							if (__formationPosition.getPairedObject () != null && !__formationPosition.getPairedObjectIsDead () && !__formationPosition.getPairedObjectInuse ()) {
								trace (": GET_RANDOM_ENEMY: ", __id);
								
								m_targetObject = __formationPosition.getPairedObject ();	
							
								__processed = true;
							}
						}						
					} else {
						setFlagsNE ();
					}
					
				//------------------------------------------------------------------------------------------
				// XTask9.LAUNCH_ENEMY
				//------------------------------------------------------------------------------------------
				case LAUNCH_ENEMY:
					var __pattern:Array<Dynamic> = cast m_taskList[m_taskIndex++];
					
					m_targetObject.setPattern (__pattern);
					
					m_targetObject.gotoFormationAttackState ();
					
				//------------------------------------------------------------------------------------------
				// XTask9.LAUNCH_ATTACK
				//------------------------------------------------------------------------------------------
				case LAUNCH_ATTACK:
					m_targetObject.gotoAttackState ();
					
				//------------------------------------------------------------------------------------------
				// XTask9.ALL_ENEMIES_DEAD
				//------------------------------------------------------------------------------------------
				case ALL_ENEMIES_DEAD:
					if (allEnemiesDead (cast m_taskList[m_taskIndex++])) {
						setFlagsEQ ();
					} else {
						setFlagsNE ();
					}
					
				//------------------------------------------------------------------------------------------
				// XTask9.NUKE	
				//------------------------------------------------------------------------------------------
				case NUKE:
					getObject ().nukeLater ();
					
				//------------------------------------------------------------------------------------------	
			}
			
			return true;
		}

		//------------------------------------------------------------------------------------------
		public function allEnemiesInuse (__enemyList:Array<Dynamic>):Bool {
			for (__id in __enemyList) {
				if (!isEnemyInUse (__id)) {
					return false;
				}
			}
			
			return true;
		}
		
		//------------------------------------------------------------------------------------------
		public function isEnemyInUse (__id:String):Bool {
			var __formationPosition:FormationPosition = getObject ().getFormationPositionById (__id);
				
			return __formationPosition.getPairedObjectInuse ();
		}
		
		//------------------------------------------------------------------------------------------
		public function allEnemiesDead (__enemyList:Array<Dynamic>):Bool {
			for (__id in __enemyList) {
				if (!isEnemyDead (__id)) {
					return false;
				}
			}
			
			return true;
		}
		
		//------------------------------------------------------------------------------------------
		public function isEnemyDead (__id:String):Bool {
			var __formationPosition:FormationPosition = getObject ().getFormationPositionById (__id);
				
			return __formationPosition.getPairedObjectIsDead ();
		}
		
		//------------------------------------------------------------------------------------------
		private function moveTo (__startX:Float, __startY:Float, __targetX:Float, __targetY:Float, __ticks:Float):Void {
			getObject ().moveTo (__startX, __startY, __targetX, __targetY, __ticks);		
		}
		
		//------------------------------------------------------------------------------------------
		private function moveToObject (__startX:Float, __startY:Float, __logicObject:XLogicObject, __ticks:Float):Void {
			getObject ().moveToObject (__startX, __startY, __logicObject, __ticks);
		}
		
		//------------------------------------------------------------------------------------------
		private function rotateTo (__rotation:Float, __targetRotation:Float, __ticks:Float):Void {
			var __delta:Float = getDelta (__rotation, __targetRotation) / ticksToSeconds (__ticks);
            
			getObject ().m_targetRotation = __targetRotation;
			getObject ().m_rotationSpeed = __delta;
			getObject ().m_rotationTicks += __ticks;			
		}
		
		//------------------------------------------------------------------------------------------	
		private function getAngleToTarget (__targetX:Float, __targetY:Float):Float {
			var __dx:Float = __targetX - getObject ().oX;
			var __dy:Float = __targetY - getObject ().oY;
			
			var __radians:Float = Math.atan2 (__dy, __dx);
			
			var __angle:Float = -__radians*180/Math.PI;					
			__angle = __angle > 0 ? __angle : __angle + 360;
			
			__angle = 360 - __angle + 90;  if (__angle >= 360) __angle -= 360;
			
			return __angle % 360;
		}
		
		//------------------------------------------------------------------------------------------
		private function getDelta (__currentRotation:Float, __targetRotation:Float):Float {
			 var __delta1:Float = Std.int (__targetRotation - __currentRotation) % 360;
			
			if (__delta1 < -180) {
				__delta1 += 360;
			}
				
			var __delta2:Float = -Std.int ((__currentRotation + 360) - __targetRotation) % 360;

			if (__delta2 < -180) {
				__delta2 += 360;
			}
				 
			var __delta:Float;
			
			if (Math.abs (__delta1) < Math.abs (__delta2)) {
				__delta = __delta1;
			} else {
				__delta = __delta2;
			}
			
			return __delta;
		}
		
		//------------------------------------------------------------------------------------------
		public function ticksToSeconds (__ticks:Float):Float {
			var __seconds:Float = __ticks / 256;
			var __frac:Float = (Std.int (__ticks) & 255) / 256;
			
			return __seconds + __frac;
		}
		
		//------------------------------------------------------------------------------------------
		public override function addTask (
			__taskList:Array<Dynamic> /* <Dynamic> */,
			__findLabelsFlag:Bool = true
		):XTask {
			var __task:XTask9 = cast m_XTaskSubManager.addTask (__taskList, __findLabelsFlag);
			
			__task.setObject (m_object);
			
			return __task;
		}
		
		//------------------------------------------------------------------------------------------
		public override function execTask ():Bool {
			if (m_subTask == null) {
				// get new XTask Array run it immediately
				m_subTask = addTask ((cast(m_taskList[m_taskIndex], Array<Dynamic>) ), true);
				m_subTask.tag = tag;
				m_subTask.setManager (m_manager);
				m_subTask.setParent (self);
				cast (m_subTask, XTask9).setObject (m_object);
				m_subTask.run ();
				m_taskIndex--;
			}
				
			// if the sub-task is still active, wait another tick and check again
			else if (m_XTaskSubManager.isTask (m_subTask)) {
				m_ticks += 0x0100;
				m_taskIndex--;
				return false;
			}
				// move along
			else
			{
				m_subTask = null;
				m_taskIndex++;
			}
			
			return true;
		}
	}
	
	//------------------------------------------------------------------------------------------
// }