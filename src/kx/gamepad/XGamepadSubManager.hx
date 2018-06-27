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
package kx.gamepad;
	
	import kx.*;
	import kx.collections.*;
	import kx.gamepad.*;
	
	//------------------------------------------------------------------------------------------	
	class XGamepadSubManager {
		public var m_manager:XGamepadManager;
		
		private var m_analogChangedSignalIDs:Map<Int, String>;  // <Int, String>
		private var m_buttonUpSignalIDs:Map<Int, String>; // <Int, String>
		private var m_buttonDownSignalIDs:Map<Int, String>; // <Int, String>
		
		//------------------------------------------------------------------------------------------
		public function new (__manager:XGamepadManager) {
			// super ();
			
			m_manager = __manager;
			
			m_analogChangedSignalIDs = new Map<Int, String> ();  // <Int, String>
			m_buttonUpSignalIDs = new Map<Int, String> ();  // <Int, String>
			m_buttonDownSignalIDs = new Map<Int, String> ();  // <Int, String>
		}
		
		//------------------------------------------------------------------------------------------
		public function setup ():Void {
		}	
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
			removeAllListeners ();
		}

		//------------------------------------------------------------------------------------------
		public function connected ():Bool {
			return m_manager.connected ();
		}
		
		//------------------------------------------------------------------------------------------
		public function addAnalogChangedListener (__analog:String, __listener:Dynamic /* Function */):Int {
			var __id:Int;
			
			__id = m_manager.addAnalogChangedListener (__analog, __listener);
			
			m_analogChangedSignalIDs.set (__id, __analog);
			
			return __id;
		}
		
		//------------------------------------------------------------------------------------------
		public function addButtonUpListener (__button:String, __listener:Dynamic /* Function */):Int {
			var __id:Int;
			
			__id = m_manager.addButtonUpListener (__button, __listener);
		
			m_buttonUpSignalIDs.set (__id, __button);
			
			return __id;
		}
		
		//------------------------------------------------------------------------------------------
		public function addButtonDownListener (__button:String, __listener:Dynamic /* Function */):Int {
			var __id:Int;
			
			__id = m_manager.addButtonDownListener (__button, __listener);
			
			m_buttonDownSignalIDs.set (__id, __button);
			
			return __id;
		}
		
		//------------------------------------------------------------------------------------------
		public function removeAllListeners ():Void {	
			for (__key__ in m_analogChangedSignalIDs.keys ()) {
				function (__id:Int):Void {
					m_manager.removeAnalogChangedListener (m_analogChangedSignalIDs.get (__id), __id);	
				} (__key__);
			}
			
			for (__key__ in m_buttonUpSignalIDs.keys ()) {
				function (__id:Int):Void {
					m_manager.removeButtonUpListener (m_buttonUpSignalIDs.get (__id), __id);	
				} (__key__);
			}
			
			for (__key__ in m_buttonDownSignalIDs.keys ()) {
				function (__id:Int):Void {
					m_manager.removeButtonDownListener (m_buttonDownSignalIDs.get (__id), __id);	
				} (__key__);
			}
		}
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
// }
