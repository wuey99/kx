//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "GX-Engine"
//
// Copyright (c) 2014 Jimmy Huey (wuey99@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// <$end$/>
//------------------------------------------------------------------------------------------
package gx.zone;
	
	import gx.*;
	import gx.messages.*;
	import gx.text.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.type.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xml.*;
	import kx.xmap.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class GateX extends XLogicObjectCX {
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;
		public var m_goSprite:XMovieClip;
		public var x_goSprite:XDepthSprite;
		
		public var script:XTask;
		public var gravity:XTask;
		
		public var m_zone:Float;
		public var m_exit:Bool;
		public var m_gate:Float;
		public var m_direction:String;
		public var m_go:Bool;
		
		public var m_GateArrowX:Class<Dynamic>; // <Dynamic>
		
		public var m_zoneStartedListenerID:Int;
		public var m_zoneFinishedListenerID:Int;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			if (args.length == 0) {
				m_GateArrowX = null;
			}
			else
			{
				m_GateArrowX = getArg (args, 0);
			}
			
			createSprites ();
			
//			x_sprite.visible2 = false;
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
			setCX (-8, 8, -8, 8);
			
			var __xml:XSimpleXMLNode = m_xml = new XSimpleXMLNode ();
			__xml.setupWithXMLString (item.params);
			
			m_zone = __xml.getAttribute ("zone");
			m_exit = __xml.getAttribute ("exit") == "true";
			
			m_direction = "null";
			if (__xml.hasAttribute ("direction")) {
				m_direction = __xml.getAttribute ("direction");
			}
			
			if (!m_exit) {
				m_gate = __xml.getAttribute ("gate");
			}
			
			m_go = false;
			
			trace (": zone, exit: ", m_zone, m_exit, m_gate);
			
			if (!m_exit) {
				if (m_gate == 1) {
					x_sprite.visible2 = false;
				}
				else
				{
					x_sprite.visible2 = true;
				}
			}
			
			m_zoneStartedListenerID = GX.appX.addZoneStartedListener (onZoneStarted);
			m_zoneFinishedListenerID = GX.appX.addZoneFinishedListener (onZoneFinished);
			
			createGoSprite ();
			
			gravity = addEmptyTask ();
			script = addEmptyTask ();
			
			gravity.gotoTask (getPhysicsTaskX (0.25));
			
			Locked_Script ();
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					function ():Void {
					}, 
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
			]);
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
			
			GX.appX.removeZoneStartedListener (m_zoneStartedListenerID);
			GX.appX.removeZoneFinishedListener (m_zoneFinishedListenerID);
		}

		//------------------------------------------------------------------------------------------
		public function createGoSprite ():Void {
			if (m_direction == "null" || m_GateArrowX == null) {
				return;
			}
			
			m_goSprite = createXMovieClip ("GO:GO");
			
			var __r:XRect = boundingRect;
			
			x_goSprite = addSpriteAt (m_goSprite, -(__r.right-__r.left)/2, -(__r.bottom - __r.top)/2);
			
			m_goSprite.gotoAndStop (3);
			x_goSprite.visible2 = false;
			m_go = false;
			
			if (m_direction == "right") {
				m_goSprite.rotation = 0;
			}
			if (m_direction == "up") {
				m_goSprite.rotation = 270;
			}
			if (m_direction == "left") {
				m_goSprite.rotation = 180;
			}
			if (m_direction == "down") {
				m_goSprite.rotation = 90;
			}
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					XTask.FLAGS, function (__task:XTask):Void {
						__task.ifTrue (m_go);
					}, XTask.BNE, "loop",
					
					XTask.LOOP, 3,
					
						XTask.WAIT, 0x0900,
						
						function ():Void {
							var __logicObject:XLogicObject = cast xxx.getXLogicManager ().initXLogicObject (
								// parent
								GX.appX.getLevelObject (),
								// logicObject
								cast XType.createInstance (m_GateArrowX) /* as XLogicObject */,
								// item, layer, depth
								null, 0, getDepth () + 1,
								// x, y, z
								getPos ().x + (__r.right - __r.left)/2, getPos ().y + (__r.bottom - __r.top)/2 , 0,
								// scale, rotation
								1.0, 0,
								[
									m_direction
								]
							) /* as XLogicObject */;
							
							GX.appX.getLevelObject ().addXLogicObject (__logicObject);
						},
					
					XTask.NEXT,
					
					XTask.WAIT, 0x1400,
					
					XTask.GOTO, "loop",
					
					XTask.RETN,
			]);
		}
		
		//------------------------------------------------------------------------------------------
		public override function cullObject ():Void {	
		}
		
		//------------------------------------------------------------------------------------------
		public override function setXMapModel (__layer:Int, __XMapModel:XMapModel, __XMapView:XMapView=null):Void {
			trace (":  GateX: setXMapModel: ", __layer, __XMapModel, __XMapView);
			trace (": xml: ", m_xml.toXMLString ());
			
			super.setXMapModel (__layer, __XMapModel, __XMapView);

			if (!hasItemStorage ()) {
				initItemStorage ({"state": 1});
			}
			
			trace (": getXMapLayerModel: ", getXMapLayerModel ());
			
			if (m_exit) {
				setCXTiles ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function getZone ():Float {
			return m_zone;
		}
		
		//------------------------------------------------------------------------------------------
		private function onZoneStarted (__zone:Float):Void {		
			if (getZone () != __zone || m_exit) {
				return;
			}
			
			if (m_gate == 1) {				
				Lowering_Script (
					function ():Void {}
				);
			}
			else
			{
				eraseCXTiles ();
				
				Opening_Script (Unlocked_Entry_Script);
			}
		}
		
		//------------------------------------------------------------------------------------------
		private function onZoneFinished (__zone:Float):Void {
			if (getZone () != __zone || !m_exit) {
				return;
			}
			
			eraseCXTiles ();

			trace (": ---------->: ", getItemStorage ().state);
			
			if (getItemStorage ().state == 2) {
				return;
			}
			
			getItemStorage ().state = 2;
			
			Opening_Script (Unlocked_Exit_Script);
		}
		
		//------------------------------------------------------------------------------------------
		public function eraseCXTiles ():Void {
			var c1:Int, r1:Int, c2:Int, r2:Int;
			
			var __r:XRect = cast xxx.getXRectPoolManager ().borrowObject (); /* as XRect;	 */
			getBoundingRect ().copy2 (__r);
			__r.offsetPoint (getPos ());
	
			c1 = Std.int (__r.left/XSubmapModel.CX_TILE_WIDTH);
			r1 = Std.int (__r.top/XSubmapModel.CX_TILE_HEIGHT);
			c2 = Std.int (__r.right/XSubmapModel.CX_TILE_WIDTH);
			r2 = Std.int (__r.bottom/XSubmapModel.CX_TILE_HEIGHT);
			
			var __length:Int = (c2-c1) * (r2-r1);
			
			var __tiles:Array<Int> /* <Int> */ = new Array<Int> (); /* <Int> */
	
			var i:Int;
			
			for (i in 0 ... __length) {
				__tiles.push (XSubmapModel.CX_EMPTY);
			}
			
			trace (": xml: ", m_xml.toXMLString ());
			trace (": c1, r1, c2, r2: ", c1, r1, c2, r2);
			trace (": layerModel: ", getXMapLayerModel ());
			
			if (getXMapLayerModel () != null) {
				getXMapLayerModel ().setCXTiles (__tiles, c1, r1, c2-1, r2-1);
			}
			
			xxx.getXRectPoolManager ().returnObject (__r);
		}
		
		//------------------------------------------------------------------------------------------
		public function setCXTiles ():Void {
			var c1:Int, r1:Int, c2:Int, r2:Int;
			
			var __r:XRect = cast xxx.getXRectPoolManager ().borrowObject (); /* as XRect */
			getBoundingRect ().copy2 (__r);
			__r.offsetPoint (getPos ());
			
			c1 = Std.int (__r.left/XSubmapModel.CX_TILE_WIDTH);
			r1 = Std.int (__r.top/XSubmapModel.CX_TILE_HEIGHT);
			c2 = Std.int (__r.right/XSubmapModel.CX_TILE_WIDTH);
			r2 = Std.int (__r.bottom/XSubmapModel.CX_TILE_HEIGHT);
			
			var __length:Int = (c2-c1) * (r2-r1);
			
			var __tiles:Array<Int> /* <Int> */ = new Array<Int> (); /* <Int> */
			
			var i:Int;
			
			for (i in 0 ... __length) {
				__tiles.push (XSubmapModel.CX_SOLID);
			}

			trace (": ----------------------------------------------: ");
			trace (": xml: ", m_xml.toXMLString ());
			trace (": c1, r1, c2, r2: ", c1, r1, c2, r2);
			trace (": layerModel: ", getXMapLayerModel ());

			if (getXMapLayerModel () != null) {
				getXMapLayerModel ().setCXTiles (__tiles, c1, r1, c2-1, r2-1);
			}
			
			xxx.getXRectPoolManager ().returnObject (__r);
		}
		
		//------------------------------------------------------------------------------------------
		public function getPhysicsTaskX (DECCEL:Float):Array<Dynamic> /* <Dynamic> */ {
			return [
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					updatePhysics,	
					XTask.GOTO, "loop",
				
				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public override function updatePhysics ():Void {
		}

		//------------------------------------------------------------------------------------------
		public function getBoundingRect ():XRect {
			return new XRect (0, 0, 128, 128);	
		}
		
		//------------------------------------------------------------------------------------------
		public function Locked_Script ():Void {
			
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
					function ():Void { m_sprite.gotoAndStop (1); }, XTask.WAIT, 0x0300,					
				
				XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		public function Opening_Script (__finallyCallback:Dynamic /* Function */):Void {

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
					XTask.EXEC, openGateAnimationX (),
					
					function ():Void {
						__finallyCallback ();
					},
	
//						XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
		//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		public function Lowering_Script (__finallyCallback:Dynamic /* Function */):Void {

			setCXTiles ();
			
			x_sprite.visible2 = true;
			
			m_sprite.gotoAndStop (25);
				
			//------------------------------------------------------------------------------------------
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
					XTask.EXEC, closeGateAnimationX (),
					
					function ():Void {
						__finallyCallback ();
					},
				
//					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		public function Unlocked_Exit_Script ():Void {
//			x_goSprite.visible2 = true;
			m_go = true;
			
			if (x_goSprite == null) {
				return;
			}
			
			var __rp:XPoint = x_goSprite.getRegistration ();
			
			//------------------------------------------------------------------------------------------		
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
					XTask.LOOP, 6,
					function ():Void {
						__rp.x -= 4.0;
					}, XTask.WAIT, 0x0100,
					XTask.NEXT,
					
					XTask.LOOP, 12,
					function ():Void {
						__rp.x += 4.0;
					}, XTask.WAIT, 0x0100,
					XTask.NEXT,
					
					XTask.LOOP, 6,
					function ():Void {
						__rp.x -= 4.0;
					}, XTask.WAIT, 0x0100,
					XTask.NEXT,	
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		public function Unlocked_Entry_Script ():Void {

			//------------------------------------------------------------------------------------------		
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
						eraseCXTiles ();
					},
					
//					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		public function openGateAnimationX ():Array<Dynamic> /* <Dynamic> */ {
			return [				
				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public function closeGateAnimationX ():Array<Dynamic> /* <Dynamic> */ {
			return [
				XTask.RETN,
			];
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }