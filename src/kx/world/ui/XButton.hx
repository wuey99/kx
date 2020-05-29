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
	import openfl.events.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	import kx.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;

//------------------------------------------------------------------------------------------
	class XButton extends XLogicObject {
		private var m_sprite:XMovieClip;
		private var x_sprite:XDepthSprite;
		private var m_buttonClassName:String;
		private var m_mouseDownSignal:XSignal;
		private var m_mouseUpSignal:XSignal;
		private var m_mouseOutSignal:XSignal;
		private var m_keyboardDownSignal:XSignal;
		private var m_keyboardUpSignal:XSignal;

		public static inline var NORMAL_STATE:Int = 1;
		public static inline var OVER_STATE:Int = 2;
		public static inline var DOWN_STATE:Int = 3;
		public static inline var SELECTED_STATE:Int = 4;
		public static inline var DISABLED_STATE:Int = 5;
				
		public var m_label:Int;
		public var m_currState:Int;
		private var m_disabledFlag:Bool;
		private var m_keyboardDownListener:Int;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}

//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_buttonClassName = args[0];

			m_mouseDownSignal = createXSignal ();	
			m_mouseOutSignal = createXSignal ();
			m_mouseUpSignal = createXSignal ();
			m_keyboardDownSignal = createXSignal ();
			m_keyboardUpSignal = createXSignal ();
			
			createSprites ();
			
			if (true /* CONFIG::flash */) {
				m_sprite.mouseEnabled = true;
			}
			
			m_disabledFlag = false;
			
			setupListeners ();
			
			__gotoState (getNormalState ());
			
			m_currState = getNormalState ();
		
			createHighlightTask ();	
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
			
			cleanupListeners ();
		}

//------------------------------------------------------------------------------------------
		public function setupListeners ():Void {		
			xxx.getXTaskManager ().addTask ([
				function ():Void {
					m_sprite.addEventListener (xxx.MOUSE_OVER, onMouseOver);
					m_sprite.addEventListener (xxx.MOUSE_DOWN, onMouseDown);
					m_sprite.addEventListener (xxx.MOUSE_MOVE, onMouseMove);
					m_sprite.addEventListener (xxx.MOUSE_UP, onMouseUp);
					m_sprite.addEventListener (xxx.MOUSE_OUT, onMouseOut);
					m_keyboardDownListener = xxx.addKeyboardDownListener (onKeyboardDown);	
				},
				
				XTask.RETN,
			]);
		}
		
//------------------------------------------------------------------------------------------
		public function cleanupListeners ():Void {
			m_sprite.removeEventListener (xxx.MOUSE_OVER, onMouseOver);
			m_sprite.removeEventListener (xxx.MOUSE_DOWN, onMouseDown);
			m_sprite.removeEventListener (xxx.MOUSE_MOVE, onMouseMove);
			m_sprite.removeEventListener (xxx.MOUSE_UP, onMouseUp);
			m_sprite.removeEventListener (xxx.MOUSE_OUT, onMouseOut);
			xxx.removeKeyboardDownListener (m_keyboardDownListener);	
		}

//------------------------------------------------------------------------------------------
		public function onKeyboardDown (e:KeyboardEvent):Void {
			m_keyboardDownSignal.fireSignal (e);
		}
		
//------------------------------------------------------------------------------------------
		public function onKeyboardUp (e:KeyboardEvent):Void {
			m_keyboardUpSignal.fireSignal (e);
		}

//------------------------------------------------------------------------------------------
		public function addKeyboardDownListener (__listener:Dynamic /* Function */):Int {
			return m_keyboardDownSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function addKeyboardUpListener (__listener:Dynamic /* Function */):Int {
			return m_keyboardUpSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function createHighlightTask ():Void {
			addTask ([
				XTask.LABEL, "__loop",
					XTask.WAIT, 0x0100,
					
					function ():Void {
						m_sprite.gotoAndStop (m_label);
					},
									
				XTask.GOTO, "__loop",
			]);
		}
		
//------------------------------------------------------------------------------------------
		public function addMouseUpEventListener (func:Dynamic /* Function */):Void {
			m_sprite.addEventListener (xxx.MOUSE_UP, func);
		}

//------------------------------------------------------------------------------------------
		public function __onMouseOver ():Void {
			if (m_disabledFlag) {
				return;
			}
			
			__gotoState (OVER_STATE);
			
			m_currState = OVER_STATE;
		}
		
//------------------------------------------------------------------------------------------
		public function __onMouseDown ():Void {	
			if (m_disabledFlag) {
				return;
			}
			
			__gotoState (DOWN_STATE);	
			
			m_currState = DOWN_STATE;
			
			fireMouseDownSignal ();
		}

//------------------------------------------------------------------------------------------
		public function __onMouseUp ():Void {
			if (m_disabledFlag) {
				return;
			}
			
			__gotoState (getNormalState ());
			
			m_currState = getNormalState ();
			
			fireMouseUpSignal ();			
		}
		
//------------------------------------------------------------------------------------------
		public function __onMouseMove ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public function __onMouseOut ():Void {
			if (m_disabledFlag) {
				return;
			}
			
			__gotoState (getNormalState ());
			
			m_currState = getNormalState ();
			
			fireMouseOutSignal ();
		}
		
//------------------------------------------------------------------------------------------
		public function onMouseOver (e:MouseEvent):Void {
			trace (": onMouseOver: ", e);
			
			__onMouseOver ();
		}			

//------------------------------------------------------------------------------------------
		public function onMouseDown (e:MouseEvent):Void {
			__onMouseDown ();
		}			

//------------------------------------------------------------------------------------------
		public function onMouseUp (e:MouseEvent):Void {
			__onMouseUp ();
		}			

//------------------------------------------------------------------------------------------
		public function onMouseMove (e:MouseEvent):Void {	
			__onMouseMove ();
		}			
		
//------------------------------------------------------------------------------------------	
		public function onMouseOut (e:MouseEvent):Void {
			__onMouseOut ();
		}			

//------------------------------------------------------------------------------------------
		public function setNormalState ():Void {
			__gotoState (getNormalState ());
			
			m_currState = getNormalState ();		
		}

//------------------------------------------------------------------------------------------
		private function getNormalState ():Int {
			return NORMAL_STATE;
		}
		
//------------------------------------------------------------------------------------------
		public function isDisabled ():Bool {
			return m_disabledFlag;
		}
			
//------------------------------------------------------------------------------------------
		public function setDisabled (__disabled:Bool):Void {
			if (__disabled) {
				__gotoState (DISABLED_STATE);
							
				m_disabledFlag = true;
			}
			else
			{
				setNormalState ();
				
				m_disabledFlag = false;
			}
		}
		
//------------------------------------------------------------------------------------------
		public override function setValues ():Void {
			setRegistration (-getPos ().x, -getPos ().y);
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {			
			m_sprite = createXMovieClip (m_buttonClassName);
			x_sprite = addSpriteAt (m_sprite, 0, 0);
			
			__gotoState (NORMAL_STATE);
			
			m_currState = getNormalState ();
			
			show ();
		}

//------------------------------------------------------------------------------------------
		public function gotoState (__label:Int):Void {
			m_label = __label;
		}
		
//------------------------------------------------------------------------------------------
		private function __gotoState (__label:Int):Void {
			m_label = __label;
		}

//------------------------------------------------------------------------------------------
		public function addMouseDownListener (__listener:Dynamic /* Function */):Int {
			return m_mouseDownSignal.addListener (__listener);
		}

//------------------------------------------------------------------------------------------
		public function fireMouseDownSignal ():Void {
			m_mouseDownSignal.fireSignal ();
		}
						
//------------------------------------------------------------------------------------------
		public function addMouseUpListener (__listener:Dynamic /* Function */):Int {
			return m_mouseUpSignal.addListener (__listener);
		}

//------------------------------------------------------------------------------------------
		public function fireMouseUpSignal ():Void {
			m_mouseUpSignal.fireSignal ();
		}

//------------------------------------------------------------------------------------------
		public function addMouseOutListener (__listener:Dynamic /* Function */):Int {
			return m_mouseOutSignal.addListener (__listener);
		}

//------------------------------------------------------------------------------------------
		public function fireMouseOutSignal ():Void {
			m_mouseOutSignal.fireSignal ();
		}
			
//------------------------------------------------------------------------------------------
		public function removeAllListeners ():Void {
			m_mouseDownSignal.removeAllListeners ();
			m_mouseUpSignal.removeAllListeners ();
			m_mouseOutSignal.removeAllListeners ();
		}
			
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
// }
