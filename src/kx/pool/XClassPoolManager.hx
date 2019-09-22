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
	
	import kx.pool.*;
	import kx.collections.*;
	import kx.type.*;
	import kx.world.*;
	
	@:coreType abstract ClassKey from Class<Dynamic> to {} {}
	
//------------------------------------------------------------------------------------------	
	class XClassPoolManager {
		private var m_pools:Map<ClassKey, XObjectPoolManager>; // <Class<Dynamic>, XObjectPoolManager>
		
//------------------------------------------------------------------------------------------
		public function new () {
			m_pools = new Map<ClassKey, XObjectPoolManager> (); // <Class<Dynamic>, XObjectPoolManager>
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}

//------------------------------------------------------------------------------------------
		public function setupPool (
			__class:Class<Dynamic> /* <Dynamic> */,
			__numObjects:Int,
			__overflow:Int
		):XObjectPoolManager {
			
			return new XObjectPoolManager (
				function ():Dynamic /* */ {
					return XType.createInstance (__class);
				},
				
				function (__src:Dynamic /* */, __dst:Dynamic /* */):Dynamic /* */ {
					return null;
				},
				
				__numObjects, __overflow,
				
				function (x:Dynamic /* */):Void {
				}
			);
		}

//------------------------------------------------------------------------------------------
		public function preAllocate (__class:Class<Dynamic> /* <Dynamic> */, __numObjects:Int):Void {
			var __pool:XObjectPoolManager;
			
			if (!m_pools.exists (__class)) {
				__pool = setupPool (__class, 16, 16);
				
				m_pools.set (__class, __pool);
			}	
			
			__pool = m_pools.get (__class);
			
			var i:Int;
			
			for (i in 0 ... __numObjects) {
				__pool.borrowObject ();
			}
			
			returnAllObjects (__class);
		}
		
//------------------------------------------------------------------------------------------
		public function returnAllObjects (__class:Class<Dynamic> /* <Dynamic> */ = null):Void {
			var __pool:XObjectPoolManager;
			
			if (__class != null) {
				if (m_pools.exists (__class)) {
					__pool = m_pools.get (__class);
					
					__pool.returnAllObjects ();
				}
			}
			else
			{
				XType.forEach (m_pools, 
					function (x:Dynamic /* */):Void {
						__pool = m_pools.get (__class);
						
						__pool.returnAllObjects ();
					}
				);
			}
		}		
		
//------------------------------------------------------------------------------------------
		public function returnObject (__class:Class<Dynamic> /* <Dynamic> */, __object:Dynamic /* Object */):Void {
			var __pool:XObjectPoolManager;
			
			if (m_pools.exists (__class)) {
				__pool = m_pools.get (__class);
				
				__pool.returnObject (__object);
			}
		}

//------------------------------------------------------------------------------------------
		public function borrowObject (__class:Class<Dynamic> /* <Dynamic> */):Dynamic /* Object */ {
			var __pool:XObjectPoolManager;
			
			if (!m_pools.exists (__class)) {
				__pool = setupPool (__class, 16, 16);
				
				m_pools.set (__class, __pool);
			}
			else
			{
				__pool = m_pools.get (__class);
			}
			
			return __pool.borrowObject ();
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
