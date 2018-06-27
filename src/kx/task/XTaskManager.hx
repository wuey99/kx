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
package kx.task;

	import kx.*;
	import kx.collections.*;
	import kx.pool.*;
	import kx.task.*;
	import kx.world.logic.*;
	
//------------------------------------------------------------------------------------------	
	class XTaskManager {
		private var m_XTasks:Map<XTask, Int>; // <XTask, Int>
		private var m_paused:Int;
		private var m_XApp:XApp;
		private var m_pools:Array<XObjectPoolManager>; // <XObjectPoolManager>
		private var m_currentPool:Int;
		private var m_poolCycle:Int;

		public static inline var NUM_POOLS:Int = 8;
		public static inline var POOL_MASK:Int = 7;
		
//------------------------------------------------------------------------------------------
		public function new (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_XTasks = new Map<XTask, Int> (); // <XTask, Int>
			
			m_paused = 0;
			
			m_pools = new Array<XObjectPoolManager> (); // <XObjectPoolManager>
			
			for (i in 0 ... NUM_POOLS) {
				m_pools.push (null);
			}
			
			for (i in 0 ... NUM_POOLS) {
				m_pools[i] = new XObjectPoolManager (
					function ():Dynamic /* */ {
						return new XTask ();
					},
					
					function (__src:Dynamic /* */, __dst:Dynamic /* */):Dynamic /* */ {
						return null;
					},
					
					2048, 256,
					
					function (x:Dynamic /* */):Void {
					}
				);
			}
			
			m_currentPool = 0;
			m_poolCycle = 0;
		}

//------------------------------------------------------------------------------------------
		public function getXApp ():XApp {
			return m_XApp;
		}
		
//------------------------------------------------------------------------------------------
		public function pause ():Void {
			m_paused++;
		}
		
//------------------------------------------------------------------------------------------
		public function unpause ():Void {
			m_paused--;
		}

//------------------------------------------------------------------------------------------
		public function isTask (__task:XTask):Bool {
			return m_XTasks.exists (__task);
		}	

//------------------------------------------------------------------------------------------
		public function getTasks ():Map<XTask, Int> /* <XTask, Int> */ {
			return m_XTasks;
		}

//------------------------------------------------------------------------------------------
		public function removeAllTasks ():Void {
			for (__key__ in m_XTasks.keys ()) {
				function (__task:Dynamic /* */):Void {
					removeTask (__task);
				} (__key__);
			}
		}		
		
//------------------------------------------------------------------------------------------
		public function addTask (__taskList:Array<Dynamic> /* <Dynamic> */, __findLabelsFlag:Bool = true):XTask {
			var __pool:XObjectPoolManager = m_pools[m_currentPool];
			
			var __task:XTask = cast __pool.borrowObject (); /* as XTask */
			__task.setup (__taskList, __findLabelsFlag);
			
			__task.setManager (this);
			__task.setParent (this);
			__task.setPool (__pool);
			
			m_XTasks.set (__task, 0);
			
			return __task;
		}

//------------------------------------------------------------------------------------------
		public function addXTask (__task:XTask):XTask {
			__task.setManager (this);
			__task.setParent (this);
			
			m_XTasks.set (__task, 0);
			
			return __task;
		}
		
//------------------------------------------------------------------------------------------
		public function removeTask (__task:XTask):Void {
			if (m_XTasks.exists (__task)) {
				__task.kill ();
				
				__task.getPool ().returnObjectTo (m_pools[(m_currentPool + POOL_MASK) & (POOL_MASK)], __task);
				
				m_XTasks.remove (__task);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateTasks ():Void {	
			if (m_paused > 0) {
				return;
			}
			
			m_poolCycle++; m_poolCycle &= 63;
			
			if (m_poolCycle == 0) {
				m_currentPool = (m_currentPool + 1) & (POOL_MASK);
			}
			
			for (__key__ in m_XTasks.keys ()) {
				function (x:XTask):Void {
					var __task:XTask = cast x; /* as XTask */
					
					__task.run ();
				} (__key__);
			}
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
