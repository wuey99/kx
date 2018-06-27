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
	class DoorX extends XLogicObjectCX {
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;

		public var script:XTask;
		public var gravity:XTask;
		
		public var m_trigger:Int;
		
		public var m_opened:Bool = false;
		
		public var m_triggerListener:Int;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic>  /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
			setCX (-8, 8, -8, 8);
			
			var __xml:XSimpleXMLNode = m_xml = new XSimpleXMLNode ();
			__xml.setupWithXMLString (item.params);

			m_trigger = -1;
			if (__xml.hasAttribute ("trigger")) {
				m_trigger = __xml.getAttribute ("trigger");
			}

			gravity = addEmptyTask ();
			script = addEmptyTask ();
			
			gravity.gotoTask (getPhysicsTaskX (0.25));
			
			Idle_Script ();
			
			m_triggerListener = GX.appX.addTriggerListener (triggerDoor);
			
			m_opened = false;
			
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
			
			GX.appX.removeTriggerListener (m_triggerListener);
		}
		
		//------------------------------------------------------------------------------------------
		public override function cullObject ():Void {	
		}
		
		//------------------------------------------------------------------------------------------
		public override function setXMapModel (__layer:Int, __XMapModel:XMapModel, __XMapView:XMapView=null):Void {
			trace (":  GateX: setXMapModel: ", __layer, __XMapModel, __XMapView);
			trace (": xml: ", m_xml.toXMLString ());
			
			super.setXMapModel (__layer, __XMapModel, __XMapView);
			
			trace (": getXMapLayerModel: ", getXMapLayerModel ());

			setCXTiles ();
		}

		//------------------------------------------------------------------------------------------
		public function triggerDoor (__trigger:Int):Void {
			if (m_opened) {
				return;
			}
			
			if (__trigger == m_trigger) {
				m_opened = true;
				
				Open_Script (
					function ():Void {
					}
				);
			}
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
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
		
		//------------------------------------------------------------------------------------------
		public function Open_Script (__finallyCallback:Dynamic /* Function */):Void {
			
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
	
				XTask.LABEL, "wait",
					XTask.WAIT, 0x0100,
					
					XTask.GOTO, "wait",
				
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