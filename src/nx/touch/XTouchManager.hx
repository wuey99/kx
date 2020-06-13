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
package nx.touch;
	
	import kx.*;
	import kx.collections.*;
	import kx.signals.*;
	import kx.world.XWorld;
		
	import openfl.events.*;
	import openfl.ui.*;

	//------------------------------------------------------------------------------------------	
	class XTouchManager {
		private var m_XApp:XApp;
		private var m_world:XWorld;
		
		private var m_touchTrackers:Map<Int, XTouchTracker>;
		private var m_trackerCount:Int;
		
		private var m_touchBeginSignal:XSignal;
		private var m_touchMoveSignal:XSignal;
		private var m_touchEndSignal:XSignal;
		
		//------------------------------------------------------------------------------------------
		public function new () {
		}

		//------------------------------------------------------------------------------------------
		public function setup (__XApp:XApp, __world:XWorld):Void {
			m_XApp = __XApp;
			m_world = __world;
			
			m_touchTrackers = new Map <Int, XTouchTracker> ();
			m_trackerCount = 0;
			
			m_touchBeginSignal = m_XApp.createXSignal ();
			m_touchMoveSignal = m_XApp.createXSignal ();
			m_touchEndSignal = m_XApp.createXSignal ();
			
			m_world.stage.addEventListener (TouchEvent.TOUCH_BEGIN, onTouchBegin);
			m_world.stage.addEventListener (TouchEvent.TOUCH_MOVE, onTouchMove);
			m_world.stage.addEventListener (TouchEvent.TOUCH_END, onTouchEnd);
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
			m_world.stage.removeEventListener (TouchEvent.TOUCH_BEGIN, onTouchBegin);
			m_world.stage.removeEventListener (TouchEvent.TOUCH_MOVE, onTouchMove);
			m_world.stage.removeEventListener (TouchEvent.TOUCH_END, onTouchEnd);
		}

		//------------------------------------------------------------------------------------------
		public function onTouchBegin (e:TouchEvent):Void {
			m_touchBeginSignal.fireSignal (e);
		}
		
		//------------------------------------------------------------------------------------------
		public function onTouchMove (e:TouchEvent):Void {
			if (m_touchTrackers.exists (e.touchPointID)) {
				var __touchTracker:XTouchTracker = m_touchTrackers.get (e.touchPointID);
				
				if (__touchTracker != null) {
					__touchTracker.updatePos (e);
					
					m_touchMoveSignal.fireSignal (e);
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function onTouchEnd (e:TouchEvent):Void {
			if (m_touchTrackers.exists (e.touchPointID)) {
				var __touchTracker:XTouchTracker = m_touchTrackers.get (e.touchPointID);
				
				if (__touchTracker != null) {
					__touchTracker.updatePos (e);
					
					m_touchEndSignal.fireSignal (e);
					
					__touchTracker.cleanup ();
					
					removeTouchTracker (e.touchPointID);
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function addTouchBeginListener (__listener:Dynamic):Int {
			return m_touchBeginSignal.addListener (__listener);
		}

		//------------------------------------------------------------------------------------------
		public function removeTouchBeginListener (__id:Int):Void {
			m_touchBeginSignal.removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		public function addTouchMoveListener (__listener:Dynamic):Int {
			return m_touchMoveSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeTouchMoveListener (__id:Int):Void {
			m_touchMoveSignal.removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		public function addTouchEndListener (__listener:Dynamic):Int {
			return m_touchEndSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeTouchEndListener (__id:Int):Void {
			m_touchEndSignal.removeListener (__id);
		}

		//------------------------------------------------------------------------------------------
		public function getTrackerCount ():Int {
			return m_trackerCount;
		}
		
		//------------------------------------------------------------------------------------------
		public function getTouchTrackers ():Map<Int, XTouchTracker> {
			return m_touchTrackers;
		}

		//------------------------------------------------------------------------------------------
		public function createTouchTracker ():XTouchTracker {
			return new XTouchTracker ();
		}
		
		//------------------------------------------------------------------------------------------
		public function addTouchTracker (e:TouchEvent, __type:String, __params:Array<Dynamic>):XTouchTracker {
			var __touchTracker:XTouchTracker = createTouchTracker ();
			__touchTracker.setup (m_XApp, __type, __params);

			m_touchTrackers.set (e.touchPointID, __touchTracker);
			
			__touchTracker.initPos (e);
						
			m_trackerCount++;
			
			return __touchTracker;
		}

		//------------------------------------------------------------------------------------------
		public function getTouchTracker (e:TouchEvent, __type:String, __params:Array<Dynamic>):XTouchTracker {
			var __touchTracker:XTouchTracker;
			
			if (!m_touchTrackers.exists (e.touchPointID)) {
				__touchTracker = createTouchTracker ();
				__touchTracker.setup (m_XApp, __type, __params);

				m_touchTrackers.set (e.touchPointID, __touchTracker);
			
				__touchTracker.initPos (e);
						
				m_trackerCount++;
			} else {
				__touchTracker = m_touchTrackers.get (e.touchPointID);
			}
			
			return __touchTracker;
		}
		
		//------------------------------------------------------------------------------------------
		public function removeTouchTracker (__touchPointID):Void {
			m_touchTrackers.remove (__touchPointID);
			
			m_trackerCount--;
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
