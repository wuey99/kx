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
		public static inline var SET_HOME_POS:Int =  XTask.XTask_OPCODES + 2;
		public static inline var SET_SPEED:Int =  XTask.XTask_OPCODES + 3;
		public static inline var ROTATE:Int =  XTask.XTask_OPCODES + 4;
		public static inline var ROTATE_TO:Int =  XTask.XTask_OPCODES + 5;
		public static inline var ROTATE_TO_POS:Int = XTask.XTask_OPCODES + 6;
		public static inline var ROTATE_TO_HOME_POS:Int = XTask.XTask_OPCODES + 7;		
		public static inline var MOVE_TO:Int =  XTask.XTask_OPCODES + 8;
		public static inline var MOVE_TO_HOME_POS:Int = XTask.XTask_OPCODES + 9;
		public static inline var ENABLE_AUTO_ROTATION:Int = XTask.XTask_OPCODES + 10;
		public static inline var DISABLE_AUTO_ROTATION:Int = XTask.XTask_OPCODES + 11;
		public static inline var ENABLE_AUTO_SPEED:Int = XTask.XTask_OPCODES + 12;
		public static inline var DISABLE_AUTO_SPEED:Int = XTask.XTask_OPCODES + 13;
		public static inline var ENABLE_AUTO_SPEED_AND_ROTATION:Int = XTask.XTask_OPCODES + 14;
		public static inline var DISABLE_AUTO_SPEED_AND_ROTATION:Int = XTask.XTask_OPCODES + 15;
		public static inline var SPAWN_ENEMY:Int = XTask.XTask_OPCODES + 16;
		public static inline var GET_NEXT_ENEMY:Int = XTask.XTask_OPCODES + 17;
		public static inline var GET_RANDOM_ENEMY:Int = XTask.XTask_OPCODES + 18;
		public static inline var LAUNCH_ENEMY:Int =  XTask.XTask_OPCODES + 19;
			
		public var m_object:FormationXLogicObject;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();	
		}
		
		//------------------------------------------------------------------------------------------
		public function getObject ():FormationXLogicObject {
			return m_object;
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
					
				// XTask9.SET_HOME_POS
				case SET_HOME_POS:
					
				// XTask9.SET_SPEED, <speed>
				case SET_SPEED:
					i++;
					
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
					
				// XTask9.MOVE_TO_HOME_POS, <ticks>
				case MOVE_TO_HOME_POS:
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
					
				// XTask9.SPAWN_ENEMY, <id>, <class>, <task>, <x>, <y>
				case SPAWN_ENEMY:
					i += 5;
					
				// XTask9.GET_NEXT_ENEMY, <sequenceIndex>, ["01", "02", "03"]
				case GET_NEXT_ENEMY:
					i += 2;
					
				// XTask9.GET_RANDOM_ENEMY, ["01", "02", "03"]
				case GET_RANDOM_ENEMY:
					i += 1;
					
				// XTask9.LAUNCH_ENEMY, <targetX>, <targetY>, <ctrlX>, <ctrlY>, <ticks>
					i += 5;
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
				// XTask9.SET_HOME_POS:
				//------------------------------------------------------------------------------------------
				case SET_HOME_POS:
					var __formationPosition:FormationPosition = getObject ().getFormationPositionById (getObject ().m_id);

					if (__formationPosition != null) {
						getObject ().oX = __formationPosition.oX;
						getObject ().oY = __formationPosition.oY;
						
						getObject ().gotoHomeState ();
						
						getFormation ().incCompleteCount();
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
				// XTask9.MOVE_TO_HOME_POS	
				//------------------------------------------------------------------------------------------		
				case MOVE_TO_HOME_POS:
				//------------------------------------------------------------------------------------------	
					var __formationPosition:FormationPosition = getObject ().getFormationPositionById (getObject ().m_id);
	
					if (__formationPosition != null) {
						moveTo (getObject ().oX, getObject ().oY, __formationPosition.oX, __formationPosition.oY, __evalNumber ());
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
				case DISABLE_AUTO_SPEED_AND_ROTATION:
				//------------------------------------------------------------------------------------------
					getObject ().m_autoRotation = false;
					getObject ().m_autoSpeed = false;
					
				//------------------------------------------------------------------------------------------
				// XTask9.SPAWN_ENEMY
				//------------------------------------------------------------------------------------------
				case SPAWN_ENEMY:
					var __id:String = cast m_taskList[m_taskIndex++];
					var __class:Class<Dynamic> = cast m_taskList[m_taskIndex++];
					var __script:Array<Dynamic> = cast m_taskList[m_taskIndex++];
					var __x:Float = __evalNumber ();
					var __y:Float = __evalNumber ();

					getObject ().spawnEnemy (__id, __class, __script, __x, __y);
					
				//------------------------------------------------------------------------------------------
				// XTask9.GET_NEXT_ENEMY
				//------------------------------------------------------------------------------------------
				case GET_NEXT_ENEMY:
					var __index:XNumber = cast m_taskList[m_taskIndex++];
					var __enemyList:Array<Dynamic> = cast m_taskList[m_taskIndex++];
					var __id:String;
					var __formationPosition:FormationPosition;
									
					setFlagsNE ();
					
					if (!allEnemiesInuse (__enemyList)) {
						var __processed:Bool = false;
						
						while (!__processed) {
							if (__index.value >= __enemyList.length) {
								__index.value = 0;
							}
							
							__id = cast __enemyList[Std.int (__index.value++)];
								
							__formationPosition = getObject ().getFormationPositionById (__id);
								
							if (__formationPosition.getPairedObject () != null) {
								trace (": GET_NEXT_ENEMY: ", __id);
								
								m_object = __formationPosition.getPairedObject ();
								
								__processed = true;
							}
						}
					} else {
						setFlagsEQ ();
					}
		
										
				//------------------------------------------------------------------------------------------
				// XTask9.GET_RANDOM_ENEMY
				//------------------------------------------------------------------------------------------
				case GET_RANDOM_ENEMY:
					var __enemyList:Array<Dynamic> = cast m_taskList[m_taskIndex++];
					var __id:String;
					var __formationPosition:FormationPosition;
					
					setFlagsNE ();
					
					if (!allEnemiesInuse (__enemyList)) {
						var __processed:Bool = false;
						
						while (!__processed) {
							var __index:Int = Std.random (__enemyList.length);
							
							__id = cast __enemyList[Std.int (__index)];
								
							__formationPosition = getObject ().getFormationPositionById (__id);
								
							if (__formationPosition.getPairedObject () != null) {
								trace (": GET_RANDOM_ENEMY: ", __id);
								
								m_object = __formationPosition.getPairedObject ();	
							
								__processed = true;
							}
						}						
					} else {
						setFlagsEQ ();
					}
					
				//------------------------------------------------------------------------------------------
				// XTask9.LAUNCH_ENEMY
				//------------------------------------------------------------------------------------------
				case LAUNCH_ENEMY:
					var __targetX:Float = __evalNumber ();
					var __targetY:Float = __evalNumber ();
					var __ctrlX:Float = __evalNumber ();
					var __ctrlY:Float = __evalNumber ();
					var __ticks:Float = __evalNumber ();
					
					getObject ().startFormationAttack (
						getObject ().oX, getObject ().oY,
						__targetX, __targetY,
						__ctrlX, __ctrlY,
						__ticks
					);
					
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
				
			return __formationPosition.inuse ();
		}
		
		//------------------------------------------------------------------------------------------
		private function moveTo (__startX:Float, __startY:Float, __targetX:Float, __targetY:Float, __ticks:Float):Void {
			getObject ().m_targetX = __targetX;
			getObject ().m_targetY = __targetY;
			
			getObject ().oDX = (__targetX - __startX) / ticksToSeconds (__ticks);
			getObject ().oDY = (__targetY - __startY) / ticksToSeconds (__ticks);
					
			getObject ().m_autoSpeed = false;			
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
	}
	
	//------------------------------------------------------------------------------------------
// }