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
	import gx.mickey.*;
	import gx.messages.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.type.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xml.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class StarterRingControllerX extends XLogicObjectCX {
		public var m_sprite:XBitmap;
		public var x_sprite:XDepthSprite;
		public var script:XTask;
		public var m_zone:Int;
		
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
			
			setCX (-8, 8, -8, 8);
			
			var __xml:XSimpleXMLNode = new XSimpleXMLNode ();
			__xml.setupWithXMLString (item.params);
			
			m_zone = __xml.getAttribute ("zone");

			script = addEmptyTask ();
			
			Ring_Script ();
		
			create ();
		}
		
		//------------------------------------------------------------------------------------------
		public function create ():Void {
			
			if (GX.appX.__getMickeyObject () != null) {
				GX.appX.__getMickeyObject ().addWaitingListener (
					function ():Void {
						trace (": waiting: ");
						
						oVisible = true;
					}
				);
				
				GX.appX.__getMickeyObject ().addPlayingListener (
					function ():Void {
						trace (": playing: ");
						
						oVisible = false;
					}
				);
			}
			
			__createClickHereSprite ();
			
			addTask ([
				XTask.LABEL, "loop",
					function ():Void { __spawnStarterRing (0.20); }, XTask.WAIT, 0x0200,
					function ():Void { __spawnStarterRing (0.40); }, XTask.WAIT, 0x0200,
					function ():Void { __spawnStarterRing (0.80); }, XTask.WAIT, 0x0200,
					function ():Void { __spawnStarterRing (1.20); }, XTask.WAIT, 0x0200,
					function ():Void { __spawnStarterRing (1.60); }, XTask.WAIT, 0x0200,
					
					XTask.WAIT, 0x0400,
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
			]);
		}

		//------------------------------------------------------------------------------------------
		public override function cullObject ():Void {	
		}

		//------------------------------------------------------------------------------------------
		private function __createClickHereSprite ():Void {
			var __logicObject:XLogicObject = cast xxx.getXLogicManager ().initXLogicObject (
				// parent
				this,
				// logicObject
				cast new ClickHereMessageX () /* as XLogicObject */,
				// item, layer, depth
				null, 0, 0,
				// x, y, z
				0, 0, 0,
				// scale, rotation
				1.0, 0
			) /* as ClickHereMessageX */;
			
			addXLogicObject (__logicObject);
		}
		
		//------------------------------------------------------------------------------------------
		private function __spawnStarterRing (__scale:Float):Void {
			if (getDistanceToMickey () > 192) {
				return;
			}
			
			var __logicObject:StarterRingX = cast xxx.getXLogicManager ().initXLogicObjectFromPool (
				// parent
				this,
				// class
				cast StarterRingX,
				// item, layer, depth
				null, getLayer (), getDepth (),
				// x, y, z
				0, 0, 0,
				// scale, rotation
				__scale, 0
			) /* as StarterRingX */;
			
			addXLogicObject (__logicObject);
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			show ();
		}
		
		//------------------------------------------------------------------------------------------
		public function getZone ():Int {
			return m_zone;
		}
		
		//------------------------------------------------------------------------------------------
		public override function updatePhysics ():Void {
			super.updatePhysics ();
		}
		
		//------------------------------------------------------------------------------------------
		public function Ring_Script ():Void {
			
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
					
					/*
					function ():Void { m_sprite.gotoAndStop (1); }, XTask.WAIT, 0x0800,
					function ():Void { m_sprite.gotoAndStop (2); }, XTask.WAIT, 0x0800,
					*/
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
			//------------------------------------------------------------------------------------------			
			]);
			
		//------------------------------------------------------------------------------------------
		}

		//------------------------------------------------------------------------------------------	
		private function getDistanceToMickey ():Float {
			if (GX.appX.__getMickeyObject () != null) {
				var __mickeyObject:_MickeyX = GX.appX.__getMickeyObject ();
				
				var __dx:Float = __mickeyObject.oX - oX;
				var __dy:Float = __mickeyObject.oY - oY;
				
				var __distance:Float = xxx.approxDistance (__dx, __dy);
				
				return __distance;
			} else {
				return 0;
			}
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }