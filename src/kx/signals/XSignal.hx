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
package kx.signals;

	import kx.collections.*;
	import kx.type.*;

	import haxe.ds.ObjectMap;
	
//------------------------------------------------------------------------------------------
	class XSignal {
		private var m_listeners:Map<Int, Dynamic>; // <Int, Dynamic>
		private var m_parent:Dynamic /* */;
		private var m_id:Int;
		public var fireSignal:Dynamic /* Function */;
		
//------------------------------------------------------------------------------------------
		public function new () {
			m_listeners = new Map<Int, Dynamic> (); // <Int, Dynamic>
			m_id = 0;
			
			fireSignal = Reflect.makeVarArgs (__fireSignal);
		}

//------------------------------------------------------------------------------------------
		public function getParent ():Dynamic /* */ {
			return m_parent;
		}
		
//------------------------------------------------------------------------------------------
		public function setParent (__parent:Dynamic /* */):Void {
			m_parent = __parent;
		}
		
//------------------------------------------------------------------------------------------
		public function addListener (__listener:Dynamic /* Function */):Int {
			m_listeners.set (++m_id, __listener);
			
			return m_id;
		}

//------------------------------------------------------------------------------------------
		public function __fireSignal (args:Array<Dynamic>):Void {
			var __listener:Dynamic /* Function */;
			var __id:Int;
		
			switch (args.length) {
				case 0:
					for (__id in m_listeners.keys ()) {
						__listener = m_listeners.get (__id);
		
						__listener ();
					}
		
				case 1:
					for (__id in m_listeners.keys ()) {
						__listener = m_listeners.get (__id);
		
						__listener (args[0]);
					}
		
				case 2:
					for (__id in m_listeners.keys ()) {
						__listener = m_listeners.get (__id);
		
						__listener (args[0], args[1]);
					}
		
				case 3:
					for (__id in m_listeners.keys ()) {
						__listener = m_listeners.get (__id);
		
						__listener (args[0], args[1], args[2]);
					}
		
				case 4:
					for (__id in m_listeners.keys ()) {
						__listener = m_listeners.get (__id);
		
						__listener (args[0], args[1], args[2], args[3]);
					}
			}
		}
		
//------------------------------------------------------------------------------------------
		public function removeListener (__id:Int):Void {
			if (m_listeners.exists (__id)) {
				m_listeners.remove (__id);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllListeners ():Void {
			XType.forEach (m_listeners, 
				function (__id:Int):Void {
					m_listeners.remove (__id);
				}
			);
		}
				
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }