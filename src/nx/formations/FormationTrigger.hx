//------------------------------------------------------------------------------------------
package nx.formations;
	
	import assets.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.type.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.world.objects.enemy.*;
	
	import gx.mickey.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class FormationTrigger extends XLogicObjectCX {
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;
		
		public var script:XTask;

		public var m_formation:Formation;
		
		// params
		public var m_id:String;
		public var m_formationClassName:String;
		public var m_formationTriggerY:Float;
		
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
			
			__setupItemParamsXML ();
				
			script = addEmptyTask ();
			
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
		public function createFormation ():Void {
			if (m_formationClassName == "kill") {
				G.appX.fireTriggerXSignal ("kill, " + m_id);
				
				nukeLater ();
				
				return;
			}
			
			if (m_formation == null) {
				m_formation = cast xxx.getXLogicManager ().initXLogicObject (
					// parent
					G.appX.getLevelObject (),
					// logicObject
					XType.createInstance (resolveClassName (m_formationClassName)),
					// item, layer, depth
					null, getLayer (), getDepth (),
					// x, y, z
					oX, oY, 0,
					// scale, rotation
					1.0, 0
				);
				
				m_formation.setXMapModel (
					getLayer (),
					getXMapModel ()
				);
				
				G.appX.getLevelObject ().addXLogicObject (m_formation);								
			}			
		}
		
		//------------------------------------------------------------------------------------------
		private function resolveClassName (__className:String):Class<Dynamic> {
			return null;
		}
		
		//------------------------------------------------------------------------------------------
		// <params
		//		id						= String
		//		formationClassName		= String
		//		triggerY				= Float
		// />
		//------------------------------------------------------------------------------------------
		private function __setupItemParamsXML ():Void {
			setupItemParamsXML ();
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
								var __point:XPoint = cast xxx.getXPointPoolManager ().borrowObject ();	
								
								__point.x = oX;
								__point.y = oY;
								
								G.appX.getLevelObjectX ().translateGroundToSky (__point);
								
								if (m_formation == null && __point.y > G.appX.getSkyRect ().top + m_formationTriggerY) {
									createFormation ();
								}
								
								xxx.getXPointPoolManager ().returnObject (__point);
							},
							
							function ():Void {
								if (m_formation != null) {
									FadeOut_Script ();
								}
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
		public function FadeOut_Script ():Void {
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([
						XTask.LOOP, 10,
						
							function ():Void {
								oAlpha = Math.max (0, oAlpha - 0.10);
							}, XTask.WAIT, 0x0100,
						
						XTask.NEXT,
							
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