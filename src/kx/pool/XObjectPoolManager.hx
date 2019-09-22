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
	import kx.type.*;
	
	import haxe.ds.ObjectMap;
	
//------------------------------------------------------------------------------------------	
	class XObjectPoolManager {
		public var m_freeObjects:Array<Array<Dynamic>>;
		public var m_numFreeObjects:Int;
		private var m_inuseObjects:Map<{}, Int>; // <Dynamic, Int>
		private var m_newObject:Dynamic /* Function */;
		private var m_cloneObject:Dynamic /* Function */;
		private var m_overflow:Int;
		private var m_cleanup:Dynamic /* Function */;
		private var m_numberOfBorrowedObjects:Int;
		private var m_sectionSize:Int;
		private var m_otherSize:Int;
		private var m_section:Int;
		private var m_otherSection:Int;
		private var m_sectionIndex:Int;
		
//------------------------------------------------------------------------------------------
		public function new (
			__newObject:Dynamic /* Function */,
			__cloneObject:Dynamic /* Function */,
			__numObjects:Int,
			__overflow:Int,
			__cleanup:Dynamic /* Function */ = null
		) {
				
			m_freeObjects = new Array<Array<Dynamic>> ();
			m_inuseObjects = new Map<{}, Int> (); // <Dynamic, Int>
			m_newObject = __newObject;
			m_cloneObject = __cloneObject;
			m_overflow = __overflow;
			m_cleanup = __cleanup;
			
			m_freeObjects.push (new Array<Dynamic> () /* <Dynamic> */);
			m_freeObjects.push (new Array<Dynamic> () /* <Dynamic> */);
			
			m_sectionSize = 0;
			m_otherSize = 0;
			
			m_section = 0;
			m_otherSection = 1;
			
			m_sectionIndex = 0;
			
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
			
			for (i in 0 ... m_sectionSize) {
				m_cleanup (m_freeObjects[m_section][i]);
			}
			
			for (i in 0 ... m_otherSize) {
				m_cleanup (m_freeObjects[m_otherSection][i]);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function addMoreObjects (__numObjects:Int):Void {
			var i:Int;
			
			for (i in 0 ... __numObjects) {
				m_freeObjects[0].push (null);
				m_freeObjects[1].push (null);
			}
			
			for (i in 0 ... __numObjects) {
				m_freeObjects[m_section][m_sectionSize + i] = m_newObject ();
			}
			
			m_sectionSize += __numObjects;
			
			m_numFreeObjects += __numObjects;
		}

//------------------------------------------------------------------------------------------
		public var freeObjects (get, set):Array<Dynamic>;
		
		public function get_freeObjects ():Array<Dynamic> /* <Dynamic> */ {
			return m_freeObjects[m_section];
		}

		public function set_freeObjects (__val:Dynamic /* */): Array<Dynamic> {
			return null;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function totalNumberOfObjects ():Int {
			return m_sectionSize + m_otherSize + m_numberOfBorrowedObjects;	
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
		public function getObjects ():Map<{}, Int> /* <Dynamic, Int> */ {
			return m_inuseObjects;
		}

//------------------------------------------------------------------------------------------
		public function cloneObject (__src:Dynamic /* Object */):Dynamic /* */ {
			var __dst:Dynamic /* Object */ = borrowObject ();
			
			return m_cloneObject (__src, __dst);
		}
		
//------------------------------------------------------------------------------------------
		public function returnAllObjects ():Void {
			XType.forEach (m_inuseObjects, 
				function (__object:Dynamic /* */):Void {
					returnObject (cast __object /* as Object */);
				}
			);
		}		
		
//------------------------------------------------------------------------------------------
		public function returnObject (__object:Dynamic /* Object */):Void {
			if (m_inuseObjects.exists (__object)) {
				m_freeObjects[m_otherSection][m_otherSize++] = __object;
				m_numFreeObjects++;
				
				m_inuseObjects.remove (__object);
				
				m_numberOfBorrowedObjects--;
			}
		}

//------------------------------------------------------------------------------------------
		public function returnObjectTo (__pool:XObjectPoolManager, __object:Dynamic /* Object */):Void {
			if (m_inuseObjects.exists (__object)) {
				__pool.m_freeObjects[m_otherSection][m_otherSize++] = __object;
				__pool.m_numFreeObjects++;
				
				m_inuseObjects.remove (__object);
				
				m_numberOfBorrowedObjects--;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function borrowObject ():Dynamic /* Object */ {
			if (m_numFreeObjects == 0) {
				addMoreObjects (m_overflow);
			}
			
			if (m_sectionIndex == m_sectionSize) {
				m_sectionSize = m_otherSize;
				m_otherSection = m_section;
				m_section = (m_section + 1) & 1;
				m_sectionIndex = 0;
				m_otherSize = 0;
			}
			
			var __object:Dynamic /* Object */ = m_freeObjects[m_section][m_sectionIndex++];
			m_numFreeObjects--;
				
			m_inuseObjects.set (__object, 0);
			
			m_numberOfBorrowedObjects++;
			
			return __object;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
