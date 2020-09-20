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
	import kx.type.*;
	
//------------------------------------------------------------------------------------------	
	class XTaskManager {
		private var m_XTasks:Map<XTask, Int>; // <XTask, Int>
		private var m_paused:Int;
		private var m_XApp:XApp;
		private var m_poolManager:XObjectPoolManager;
		
//------------------------------------------------------------------------------------------
		public function new (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_XTasks = new Map<XTask, Int> (); // <XTask, Int>
			
			m_paused = 0;
			
			m_poolManager = createPoolManager ();
		}
		
//------------------------------------------------------------------------------------------	
		public function cleanup ():Void {
			m_poolManager.returnAllObjects ();
			
			m_poolManager = null;
		}
		
//------------------------------------------------------------------------------------------	
		public function createPoolManager ():XObjectPoolManager {
			return new XObjectPoolManager (
				function ():Dynamic /* */ {
					return new XTask ();
				},
					
				function (__src:Dynamic /* */, __dst:Dynamic /* */):Dynamic /* */ {
					return null;
				},
					
				1024, 256,
					
				function (x:Dynamic /* */):Void {
				}
			);
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
			XType.forEach (m_XTasks, 
				function (__task:Dynamic /* */):Void {
					removeTask (__task);
				}
			);
		}		
		
//------------------------------------------------------------------------------------------
		public function addTask (__taskList:Array<Dynamic> /* <Dynamic> */, __findLabelsFlag:Bool = true):XTask {
//			var __task:XTask = cast m_poolManager.borrowObject (); /* as XTask */
			var __task:XTask = new XTask ();
			__task.setup (__taskList, __findLabelsFlag);
			
			__task.setManager (this);
			__task.setParent (this);
			
			m_XTasks.set (__task, 0);
			
			return __task;
		}

//------------------------------------------------------------------------------------------
		public function addTaskFromClass (__class:Class<Dynamic>, __taskList:Array<Dynamic> /* <Dynamic> */, __findLabelsFlag:Bool = true):XTask {
			var __task:XTask = cast XType.createInstance (__class); /* as XTask */
			__task.setup (__taskList, __findLabelsFlag);
			
			__task.setManager (this);
			__task.setParent (this);
			
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
				
				m_poolManager.returnObject (__task);
				
				m_XTasks.remove (__task);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateTasks ():Void {	
			if (m_paused > 0) {
				return;
			}

			XType.forEach (m_XTasks, 
				function (x:XTask):Void {
					var __task:XTask = cast x; /* as XTask */
					
					__task.run ();
				}
			);
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
