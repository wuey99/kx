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
package gx.mickey;

	import kx.*;
	import kx.geom.*;
	import kx.signals.XSignal;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	
	import openfl.events.KeyboardEvent;
	import openfl.events.MouseEvent;
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
		
//------------------------------------------------------------------------------------------
	class _MickeyX extends EnemyCollidableX {
		private var m_dead:Bool;
		private var m_mouseDownSignal:XSignal;
		private var m_waitingSignal:XSignal;
		private var m_playingSignal:XSignal;
		private var m_ready:Bool;
		private var m_invincible:Int;
		private var m_levelCompleteSignal:XSignal;
		private var m_extraDX:Float;
		private var m_extraDY:Float;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
								
//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
		}

//------------------------------------------------------------------------------------------
		public var extraDX (get, set):Float;
		
public function get_extraDX ():Float {			return m_extraDX;
		}
		
public function set_extraDX (__val:Float): Float {			m_extraDX = __val;
			
			return 0;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var extraDY (get, set):Float;
		
public function get_extraDY ():Float {			return m_extraDY;
		}
		
public function set_extraDY (__val:Float): Float {			m_extraDY = __val;
			
			return 0;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function addLevelCompleteListener (__listener:Dynamic /* Function */):Int {
			return m_levelCompleteSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removeLevelCompleteListener (__id:Int):Void {
			m_levelCompleteSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function fireLevelCompleteSignal ():Void {
			m_levelCompleteSignal.fireSignal ();
		}
				
//------------------------------------------------------------------------------------------
		public function isReady ():Bool {
			return m_ready;
		}

//------------------------------------------------------------------------------------------
		public function addWaitingListener (__listener:Dynamic /* Function */):Int {
			return m_waitingSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removeWaitingListener (__id:Int):Void {
			m_waitingSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function fireWaitingSignal ():Void {
			m_waitingSignal.fireSignal ();
		}

//------------------------------------------------------------------------------------------
		public function addPlayingListener (__listener:Dynamic /* Function */):Int {
			return m_playingSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removePlayingListener (__id:Int):Void {
			m_playingSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function firePlayingSignal ():Void {
			m_playingSignal.fireSignal ();
		}

	//------------------------------------------------------------------------------------------
		public function setMessage (__message:String):Void {	
		}
		
	//------------------------------------------------------------------------------------------
		public function getMessage ():String {
			return null;
		}
		
	//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
// }