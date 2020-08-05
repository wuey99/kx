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
	typedef AttackDef = {
		id:String,
		percentageX:Float,
		percentageY:Float,
	}
	
	//------------------------------------------------------------------------------------------
	class Formation extends FormationXLogicObject {
		public var m_formationPositions:Map<String, FormationPosition>;
		public var m_attackPositions:Map<String, AttackPosition>;
		public var m_formationDefs:Array<FormationDef>;
		
		public var m_completeCount:Int;
		public var m_totalEnemyCount:Int;
		public var m_totalInuseCount:Int;
		
		public var m_triggerID:Int;
		public var m_buggedOut:Bool;
		
		public var m_defaultDepth:Float;
		
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
			
			createFormationPositions ();
			
			script = addEmptyTask ();
			
			m_completeCount = 0;
			m_totalEnemyCount = 0;
			m_totalInuseCount = 0;
			
			Idle_Script ();	
			
			m_buggedOut = false;
			
			m_triggerID = G.appX.addTriggerXListener (onTriggerSignal);
			
			setDefaultDepth (getDepth ());
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup():Void 
		{
			 super.cleanup();
			 
			 G.appX.removeTriggerXListener (m_triggerID);
		}
		
		//------------------------------------------------------------------------------------------
		public function onTriggerSignal (__trigger:String):Void {
			trace (": bugged out: ", __trigger);
			
			m_buggedOut = true;
		}
		
		//------------------------------------------------------------------------------------------
		public function buggedOut ():Bool {
			return m_buggedOut;
		}
		
		//------------------------------------------------------------------------------------------
		public function getDefaultAlpha ():Float {
			return 0.0;
		}

		//------------------------------------------------------------------------------------------
		public function getDefaultDepth ():Float {
			return m_defaultDepth;
		}

		//------------------------------------------------------------------------------------------
		public function setDefaultDepth (__value:Float):Void {
			m_defaultDepth = __value;
		}

		//------------------------------------------------------------------------------------------
		public function addFormationPositions (formationDefs:Array<FormationDef>):Void {
			if (m_formationPositions == null) {
				m_formationPositions = new Map<String, FormationPosition> ();
			}
			
			m_formationDefs = formationDefs;
			
			addFormationPositionsFrom (formationDefs);
		}
		
		//------------------------------------------------------------------------------------------
		public function addFormationPositionsFrom (formationDefs:Array<FormationDef>):Void {
			addFormationPositionsFromTrigger (formationDefs);
		}

		//------------------------------------------------------------------------------------------
		public function addFormationPositionsFromTrigger (formationDefs:Array<FormationDef>):Void {
			var __point:XPoint = xxx.getXPointPoolManager ().borrowObject ();
			
			calculateFormationPosition (__point);
			
			var __formationPosition:FormationPosition;
			
			for (formationDef in formationDefs) {
				__formationPosition = cast xxx.getXLogicManager ().initXLogicObject (
					// parent
					G.appX.getLevelObject (),
					// logicObject
					new FormationPosition (),
					// item, layer, depth
					null, getSpawnLayer (), getDefaultDepth (),
					// x, y, z
					__point.x + formationDef.x, __point.y + formationDef.y, 0,
					// scale, rotation
					1.0, 0
				);
				
				__formationPosition.oAlpha = getDefaultAlpha ();
				
				m_formationPositions.set (formationDef.id, __formationPosition);
				
				G.appX.getLevelObject ().addXLogicObject (__formationPosition);
			}
			
			xxx.getXPointPoolManager ().returnObject (__point);
		}
		
		//------------------------------------------------------------------------------------------
		public function calculateFormationPosition (__point:XPoint):Void {	
			__point.x = oX;
			__point.y = oY;
		}
		
		//------------------------------------------------------------------------------------------
		public function addFormationPositionsFromTriggerAbsolute (formationDefs:Array<FormationDef>):Void {			
			var __formationPosition:FormationPosition;
			
			for (formationDef in formationDefs) {
				__formationPosition = cast xxx.getXLogicManager ().initXLogicObject (
					// parent
					G.appX.getLevelObject (),
					// logicObject
					new FormationPosition (),
					// item, layer, depth
					null, getSpawnLayer (), getDefaultDepth (),
					// x, y, z
					formationDef.x, formationDef.y, 0,
					// scale, rotation
					1.0, 0
				);
				
				__formationPosition.oAlpha = getDefaultAlpha ();
				
				m_formationPositions.set (formationDef.id, __formationPosition);
				
				G.appX.getLevelObject ().addXLogicObject (__formationPosition);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function addFormationPositionsFromXLogicObject (formationDefs:Array<FormationDef>):Void {
			var __x:Float = oX;
			var __y:Float = oY;
			
			var __formationPosition:FormationPosition;
			
			for (formationDef in formationDefs) {
				__formationPosition = cast xxx.getXLogicManager ().initXLogicObject (
					// parent
					G.appX.getLevelObject (),
					// logicObject
					new FormationPosition (),
					// item, layer, depth
					null, getSpawnLayer (), getDefaultDepth (),
					// x, y, z
					__x + formationDef.x, __y + formationDef.y, 0,
					// scale, rotation
					1.0, 0
				);
				
				__formationPosition.oAlpha = getDefaultAlpha ();
				
				m_formationPositions.set (formationDef.id, __formationPosition);
				
				G.appX.getLevelObject ().addXLogicObject (__formationPosition);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function updateFormationPositions ():Void {			
			for (formationDef in m_formationDefs) {
				var __formationPosition:FormationPosition = m_formationPositions.get (formationDef.id);
				
				__formationPosition.oX = oX + formationDef.x;
				__formationPosition.oY = oY + formationDef.y;
			}
		}

		//------------------------------------------------------------------------------------------
		public function createFormationPositions ():Void {
		}

		//------------------------------------------------------------------------------------------
		public override function getFormationPositionById (__id:String):FormationPosition {
			return m_formationPositions.get (__id);
		}
		
		//------------------------------------------------------------------------------------------
		public function getSpawnLayer ():Int {
			return 0;
		}
		
		//------------------------------------------------------------------------------------------
		public override function spawnFormationEnemy (__id:String, __class:Class<Dynamic>, __pattern:Array<Dynamic>, __x:Float, __y:Float, __params:Array<Dynamic> = null):FormationXLogicObject {
			var __params2:Array<Dynamic> = ["", 0];
			
			var __enemyObject:FormationXLogicObject = cast xxx.getXLogicManager ().initXLogicObjectFromPool (
				// parent
				G.appX.getLevelObject (),
				// logicObject
				__class,
				// item, layer, depth
				null, getSpawnLayer (), getDefaultDepth (),
				// x, y, z
				__x, __y, 0,
				// scale, rotation
				1.0, 0,
				__params2.concat (__params)
			);
			
			__enemyObject.setID (__id);
			__enemyObject.setFormation (this);
			
			__enemyObject.setXMapModel (
				getSpawnLayer (),
				getXMapModel ()
			);
			
			__enemyObject.setDisableCulling (true);
			
			var __formationPosition:FormationPosition = getFormationPositionById (__id);
			__formationPosition.setPairedObject (__enemyObject);

			__enemyObject.setPattern (__pattern);
			__enemyObject.gotoPatternState ();
			
			incTotalEnemyCount ();
			incTotalInuseCount ();
			
			G.appX.getLevelObject ().addXLogicObject (__enemyObject);
			
			return __enemyObject;
		}

		//------------------------------------------------------------------------------------------
		public override function spawnEnemy (__id:String, __class:Class<Dynamic>, __pattern:Array<Dynamic>, __x:Float, __y:Float, __params:Array<Dynamic> = null):FormationXLogicObject {
			var __params2:Array<Dynamic> = ["", 0];
		
			var __formationPosition:FormationPosition = null;
			
			if (__id != null && __id != "") {
				__formationPosition = getFormationPositionById (__id);
			}
			
			trace (": spawnEnemy: ", __formationPosition);
			
			if (__formationPosition != null) {
				trace (": formationPosition: ", __formationPosition.oX, __formationPosition.oY);
				
				__x = __formationPosition.oX;
				__y = __formationPosition.oY;
			}
			
			var __enemyObject:FormationXLogicObject = cast xxx.getXLogicManager ().initXLogicObjectFromPool (
				// parent
				G.appX.getLevelObject (),
				// logicObject
				__class,
				// item, layer, depth
				null, getSpawnLayer (), getDefaultDepth (),
				// x, y, z
				__x, __y, 0,
				// scale, rotation
				1.0, 0,
				__params2.concat (__params)
			);
			
			__enemyObject.setID (__id);
			
			__enemyObject.setXMapModel (
				getSpawnLayer (),
				getXMapModel ()
			);

			if (__pattern != null) {
				__enemyObject.setPattern (__pattern);
				__enemyObject.gotoPatternState ();
			} else {
				__enemyObject.gotoIdleState ();
			}
				
			G.appX.getLevelObject ().addXLogicObject (__enemyObject);
			
			return __enemyObject;
		}

		//------------------------------------------------------------------------------------------
		public function getCompleteCount ():Int {
			return m_completeCount;
		}
		
		//------------------------------------------------------------------------------------------
		public function setCompleteCount (__count:Int):Void {
			m_completeCount = __count;
		}
		
		//------------------------------------------------------------------------------------------
		public function incCompleteCount ():Int {
			m_completeCount++;
			
			return m_completeCount;
		}
	
		//------------------------------------------------------------------------------------------
		public function getTotalEnemyCount ():Int {
			return m_totalEnemyCount;
		}
		
		//------------------------------------------------------------------------------------------
		public function setTotalEnemyCount (__count:Int):Void {
			m_totalEnemyCount = __count;
		}
		
		//------------------------------------------------------------------------------------------
		public function incTotalEnemyCount ():Int {
			m_totalEnemyCount++;
			
			return m_totalEnemyCount;
		}
		
		//------------------------------------------------------------------------------------------
		public function getTotalInuseCount ():Int {
			return m_totalInuseCount;
		}
		
		//------------------------------------------------------------------------------------------
		public override function incTotalInuseCount ():Void {
			m_totalInuseCount++;
		}
		
		//------------------------------------------------------------------------------------------
		public override function decTotalInuseCount ():Void {
			m_totalInuseCount--;
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
		public function Formation_Script ():Void {
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([						
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
		public function waitX ():Array<Dynamic> {
			return [
				XTask.LABEL, "wait",
					XTask.WAIT, 0x0100,
					
					XTask.GOTO, "wait",		
					
				XTask.RETN,
			];
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
		public function startAttackFromFromHomePosX ():Array<Dynamic> {
			return [
				XTask9.ENABLE_AUTO_SPEED_AND_ROTATION,
				XTask9.SET_ACCEL_TO, 0.0, 12.0, -0.20,
				XTask.WAIT, 0x2000,

				XTask.RETN,
			];
		}

		//------------------------------------------------------------------------------------------
		public function returnToHomePositionX ():Array<Dynamic> {
			return [
				XTask9.DISABLE_AUTO_SPEED_AND_ROTATION,
				XTask9.SET_ROTATION, 0.0,
				XTask9.RETURN_TO_HOME_POS, 0x4000,
				XTask.WAIT, 0x4000,
				XTask9.SET_HOME_POS,
				
				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public function returnToHomePositionFacingForwardX ():Array<Dynamic> {
			return [
				XTask9.DISABLE_AUTO_SPEED_AND_ROTATION,
				XTask9.SET_ROTATION, 180.0,
				XTask9.RETURN_TO_HOME_POS, 0x4000,
				XTask.WAIT, 0x4000,
				XTask9.SET_HOME_POS,
				
				XTask.RETN,
			];
		}

		//------------------------------------------------------------------------------------------
		public function waitForFormationCompletionX ():Array<Dynamic> {
			return [
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0800,
							
					XTask.FLAGS, function (__task:XTask):Void {
						trace (": ", getCompleteCount (), getTotalEnemyCount ());
						
						__task.ifTrue (getCompleteCount () == getTotalEnemyCount ());
					}, XTask.BNE, "loop",

				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public function formationDoneX ():Array<Dynamic> {
			return [
				XTask.FLAGS, function (__task:XTask9):Void {
					__task.getObject ().nukeLater ();
				},
				
				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public function isTotalInuseCountLessThan (__count:Int):Array<Dynamic> {
			return [
				XTask.FLAGS, function (__task:XTask):Void {
					__task.getParent ().ifTrue (getTotalInuseCount () < __count);
				},
							
				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public function percentChanceX (__percentage:Float):Array<Dynamic> {
			return [
				XTask.FLAGS, function (__task:XTask):Void {
					__task.getParent ().ifTrue (Math.random () * 100 <= __percentage);
				},
							
				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public function scaleToX (__start:Float, __target:Float, __ticks:Float):Array<Dynamic> {
			var __step:Float = (__target - __start) / ticksToSeconds (__ticks);
			
			trace (": step: ", __step);
					
			var __count:XNumber = new XNumber (0);
			__count.value = Std.int (__ticks) >> 8;
			
			return [
				XTask.FLAGS, function (__task:XTask9):Void {			
					__task.getObject ().oScale = __start;
					
					addTask ([
						XTask.LOOP, __count,
							XTask.WAIT, 0x0100,
							
							function ():Void {
								__task.getObject ().oScale += __step;
							},
							
						XTask.NEXT,
						
						XTask.RETN,
					]);
				},
				
				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public function fadeInX (__start:Float, __target:Float, __ticks:Float):Array<Dynamic> {
			var __step:Float = (__target - __start) / ticksToSeconds (__ticks);
			
			var __count:XNumber = new XNumber (0);
			__count.value = Std.int (__ticks) >> 8;
			
			return [
				XTask.FLAGS, function (__task:XTask9):Void {
					__task.getObject ().oAlpha = __start;
					
					addTask ([
						XTask.LOOP, __count,
							XTask.WAIT, 0x0100,
							
							function ():Void {
								__task.getObject ().oAlpha += __step;
							},
							
						XTask.NEXT,
						
						XTask.RETN,
					]);
				},
				
				XTask.RETN,
			];
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }