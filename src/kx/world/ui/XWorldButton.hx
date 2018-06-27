//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "X-Engine"
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
package kx.world.ui;
	
	// X classes
	import kx.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.world.ui.*;
	import kx.geom.*;
	
	import openfl.events.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class XWorldButton extends XButton {
		public var m_width:Float;
		public var m_height:Float;
		public var m_mouseDownListenerID:Int;
		public var m_mouseMoveListenerID:Int;
		public var m_mouseUpListenerID:Int;
		public var m_mouseOutListenerID:Int;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_width = getArg (args, 1);
			m_height = getArg (args, 2);
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
		}

		//------------------------------------------------------------------------------------------
		public override function __onMouseOver ():Void {	
			if (isMouseInRange ()) {
				super.__onMouseOver ();
			}
			else
			{
				super.__onMouseOut ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function __onMouseDown ():Void {
			if (isMouseInRange ()) {
				super.__onMouseDown ();
			}
			else
			{
				super.__onMouseOut ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function __onMouseUp ():Void {
			if (isMouseInRange ()) {
				super.__onMouseUp ();
			}
			else
			{
				super.__onMouseOut ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function __onMouseMove ():Void {
			if (m_currState == XButton.DOWN_STATE) {
				return;
			}
			
			if (isMouseInRange ()) {
				super.__onMouseOver ();
			}
			else
			{
				super.__onMouseOut ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function __onMouseOut ():Void {
			super.__onMouseOut ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupListeners ():Void {	
			xxx.getXTaskManager ().addTask ([
				function ():Void {
					/*
//					xxx.getParent ().stage.addEventListener (xxx.MOUSE_OVER, onMouseOver);
					xxx.getParent ().stage.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
					xxx.getParent ().stage.addEventListener (MouseEvent.MOUSE_MOVE, onMouseMove);
					xxx.getParent ().stage.addEventListener (MouseEvent.MOUSE_UP, onMouseUp);
					xxx.getParent ().stage.addEventListener (MouseEvent.MOUSE_OUT, onMouseOut);
					*/
					
					m_mouseDownListenerID = xxx.addMouseDownListener (onMouseDown);
					m_mouseMoveListenerID = xxx.addPolledMouseMoveListener (onPolledMouseMove);
					m_mouseUpListenerID = xxx.addMouseUpListener (onMouseUp);
					m_mouseOutListenerID = xxx.addMouseOutListener (onMouseOut);
					xxx.getFlashStage ().addEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);	
				},
				
				XTask.RETN,
			]);
		}

		//------------------------------------------------------------------------------------------
		public override function cleanupListeners ():Void {
			xxx.removeMouseDownListener (m_mouseDownListenerID);
			xxx.removeMouseMoveListener (m_mouseMoveListenerID);
			xxx.removeMouseUpListener (m_mouseUpListenerID);
			xxx.removeMouseOutListener (m_mouseOutListenerID);
			xxx.getFlashStage ().removeEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);	
		}
		
		//------------------------------------------------------------------------------------------
		public function onPolledMouseMove (__point:XPoint):Void {
			__onMouseMove ();
		}
		
		//------------------------------------------------------------------------------------------
		private function getWorldCoordinates ():XPoint {
			var __logicObject:XLogicObject = this.getParent ();
			
			var __x:Float = oX, __y:Float = oY;
			
			while (__logicObject != null) {
				__x += __logicObject.oX;
				__y += __logicObject.oY;
				
				__logicObject = __logicObject.getParent ();
			}
			
			return new XPoint (__x, __y);
		}
		
		//------------------------------------------------------------------------------------------
		private function isMouseInRange ():Bool {
			var __button:XPoint = getWorldCoordinates ();
			
			var __mouse:XPoint = xxx.getXWorldLayer (getLayer ()).globalToLocalXPoint (new XPoint (xxx.mouseX, xxx.mouseY));
			
			var __dx:Float = __mouse.x - __button.x;
			var __dy:Float = __mouse.y - __button.y;
	
//			trace (": XWorldButton (mouseX, mouseY): ", xxx.mouseX, xxx.mouseY, __mouse.x, __mouse.y, __button.x, __button.y);
			
			if (__dx < 0 || __dx > m_width) {
				return false;
			}
			
			if (__dy < 0 || __dy > m_height) {
				return false;
			}
			
			return true;
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {			
			m_sprite = createXMovieClip (m_buttonClassName);
			x_sprite = addSpriteAt (m_sprite, 0, 0);
			x_sprite.setDepth (getDepth ());
		
			gotoState (XButton.NORMAL_STATE);
			
			m_currState = getNormalState ();
			
			show ();
		}

	//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
// }
