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
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xml.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class ZoneX extends XLogicObjectCX {
		public var script:XTask;
		
		public var m_zone:Int;
		public var m_direction:String;
		public var m_size:Float;
		
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
			
			setCX (0, 96, 0, 96);
		
			__setupItemParamsXML ();
		}

		//------------------------------------------------------------------------------------------
		public override function cullObject ():Void {	
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
		}
		
		//------------------------------------------------------------------------------------------
		public function getZone ():Int {
			return m_zone;
		}

		//------------------------------------------------------------------------------------------
		private function __setupItemParamsXML ():Void {
			var __mickeyRect:XRect = new XRect ();
			var __zoneRect:XRect = new XRect ();
			var __zoneRectX:XRect = new XRect ();
			
			boundingRect.copy2 (__zoneRect);
			__zoneRect.offset (oX, oY);
			
			setupItemParamsXML ();
			
			if (itemHasAttribute ("x") && itemHasAttribute ("y") && itemHasAttribute ("width") && itemHasAttribute ("height")) {
				boundingRect.setRect (
					itemGetAttributeFloat ("x"),
					itemGetAttributeFloat ("y"),
					itemGetAttributeFloat ("width"),
					itemGetAttributeFloat ("height")
				);
			}
			else
			{
				boundingRect.setRect (0, 0, 0, 0);
			}
			
			m_direction = "both";
			if (m_xml.hasAttribute ("direction")) {
				m_direction = m_xml.getAttribute ("direction");	
			}
			
			m_size = 256;
			if (m_xml.hasAttribute ("size")) {
				m_size = m_xml.getAttribute ("size");
			}
			
			m_zone = itemGetAttributeInt ("zone");
			
			script = addEmptyTask ();
			
			getCX ().copy2 (__zoneRectX);
			__zoneRectX.offset (oX, oY);
			if (m_direction == "both") {
				__zoneRectX.inflate (m_size, m_size);
			}		
			if (m_direction == "horz") {
				__zoneRectX.inflate (m_size, 64);
			}
			if (m_direction == "vert") {
				__zoneRectX.inflate (64, m_size);
			}
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					XTask.FLAGS, function (__task:XTask):Void {
						if (GX.appX.__getMickeyObject () != null && !GX.appX.getLevelComplete ()) {
							GX.appX.__getMickeyObject ().getCX ().copy2 (__mickeyRect);
							__mickeyRect.offsetPoint (GX.appX.__getMickeyObject ().getPos ());
							
							__task.ifTrue (__zoneRect.intersects (__mickeyRect));
							
							if (__zoneRectX.intersects (__mickeyRect)) {
								var __dx:Float, __dy:Float;
								
								__dx = oX - GX.appX.__getMickeyObject ().getPos ().x;
								__dy = oY - GX.appX.__getMickeyObject ().getPos ().y;
								
								__dx = Math.abs (__dx);  __dy = Math.abs (__dy);
								
								if (m_direction == "horz" && __dy < 32) {
									__task.ifTrue (true);
								}
								
								if (m_direction == "vert" && __dx < 32) {
									__task.ifTrue (true);
								}
							}
						}
						else
						{
							__task.ifTrue (false);
						}
						
//						trace (": zone: ", __zoneRect.intersects (__mickeyRect));
						
					}, XTask.BNE, "loop",
				
				function ():Void {
// #TODO make sure this uses the ZoneManager
					if (GX.appX.getCurrentZone () != m_zone) {
						GX.appX.setCurrentZone (m_zone);	
						
						GX.appX.fireZoneStartedSignal ();
					}
				},
				
				XTask.RETN,
			]);			
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }