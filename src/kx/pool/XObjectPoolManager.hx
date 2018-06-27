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
package kx.pool;
	
	import kx.collections.*;
	
	import haxe.ds.ObjectMap;
	
//------------------------------------------------------------------------------------------	
	class XObjectPoolManager {
		public var m_freeObjects:Array<Dynamic>; // <Dynamic>
		public var m_numFreeObjects:Int;
		private var m_inuseObjects:ObjectMap<Dynamic, Int>; // <Dynamic, Int>
		private var m_newObject:Dynamic /* Function */;
		private var m_cloneObject:Dynamic /* Function */;
		private var m_overflow:Int;
		private var m_cleanup:Dynamic /* Function */;
		private var m_numberOfBorrowedObjects:Int;
		
//------------------------------------------------------------------------------------------
		public function new (
			__newObject:Dynamic /* Function */,
			__cloneObject:Dynamic /* Function */,
			__numObjects:Int,
			__overflow:Int,
			__cleanup:Dynamic /* Function */ = null
		) {
				
			m_freeObjects = new Array<Dynamic> (); // <Dynamic>
			m_inuseObjects = new ObjectMap<Dynamic, Int> (); // <Dynamic, Int>
			m_newObject = __newObject;
			m_cloneObject = __cloneObject;
			m_overflow = __overflow;
			m_cleanup = __cleanup;
			
			m_numFreeObjects = 0;
			m_numberOfBorrowedObjects = 0;
			
			addMoreObjects (__numObjects);
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
			returnAllObjects ();
			
			if (m_cleanup == null) {
				return;
			}
			
			var i:Int;
			
			for (i in 0 ... m_freeObjects.length) {
				m_cleanup (m_freeObjects[i]);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function addMoreObjects (__numObjects:Int):Void {
			var i:Int;
			
			for (i in 0 ... __numObjects) {
				m_freeObjects[m_numFreeObjects++] = (m_newObject ());
			}
		}

//------------------------------------------------------------------------------------------
		public var freeObjects (get, set):Array<Dynamic>;
		
		public function get_freeObjects ():Array<Dynamic> /* <Dynamic> */ {
			return m_freeObjects;
		}

		public function set_freeObjects (__val:Dynamic /* */): Array<Dynamic> {
			return null;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function totalNumberOfObjects ():Int {
			return m_freeObjects.length + m_numberOfBorrowedObjects;	
		}
		
//------------------------------------------------------------------------------------------
		public function numberOfBorrowedObjects ():Int {
			return m_numberOfBorrowedObjects;
		}	
		
//------------------------------------------------------------------------------------------
		public function isObject (__object:Dynamic /* Object */):Bool {
			return m_inuseObjects.exists (__object);
		}	

//------------------------------------------------------------------------------------------
		public function getObjects ():ObjectMap<Dynamic, Int> /* <Dynamic, Int> */ {
			return m_inuseObjects;
		}

//------------------------------------------------------------------------------------------
		public function cloneObject (__src:Dynamic /* Object */):Dynamic /* */ {
			var __dst:Dynamic /* Object */ = borrowObject ();
			
			return m_cloneObject (__src, __dst);
		}
		
//------------------------------------------------------------------------------------------
		public function returnAllObjects ():Void {
			for (__key__ in m_inuseObjects.keys ()) {
				function (__object:Dynamic /* */):Void {
					returnObject (cast __object /* as Object */);
				} (__key__);
			}
		}		
		
//------------------------------------------------------------------------------------------
		public function returnObject (__object:Dynamic /* Object */):Void {
			if (m_inuseObjects.exists (__object)) {
				m_freeObjects[m_numFreeObjects++] = (__object);
				
				m_inuseObjects.remove (__object);
				
				m_numberOfBorrowedObjects--;
			}
		}

//------------------------------------------------------------------------------------------
		public function returnObjectTo (__pool:XObjectPoolManager, __object:Dynamic /* Object */):Void {
			if (m_inuseObjects.exists (__object)) {
				__pool.m_freeObjects[__pool.m_numFreeObjects++] = (__object);
				
				m_inuseObjects.remove (__object);
				
				m_numberOfBorrowedObjects--;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function borrowObject ():Dynamic /* Object */ {
			if (m_numFreeObjects == 0) {
				addMoreObjects (m_overflow);
			}
			
			var __object:Dynamic /* Object */ = m_freeObjects.pop (); m_numFreeObjects--;
				
			m_inuseObjects.set (__object, 0);
			
			m_numberOfBorrowedObjects++;
			
			return __object;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
