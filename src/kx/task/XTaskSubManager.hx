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
	import kx.world.logic.*;
	
//------------------------------------------------------------------------------------------	
	class XTaskSubManager {
		public var m_manager:XTaskManager;
		
		private var m_XTasks:Map<XTask, Int>;  // <XTask, Int>
		
//------------------------------------------------------------------------------------------
		public function new (__manager:XTaskManager) {
			// super ();
			
			m_manager = __manager;
			
			m_XTasks = new Map<XTask, Int> ();  // <XTask, Int>
		}

//------------------------------------------------------------------------------------------
		public function setup ():Void {
		}	
		
//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
			removeAllTasks ();
		}

//------------------------------------------------------------------------------------------
		public function getManager ():XTaskManager {
			return m_manager;
		}
				
//------------------------------------------------------------------------------------------
		public function setManager (__manager:XTaskManager):Void {
			m_manager = __manager;
		}
		
//------------------------------------------------------------------------------------------
		public function addTask (
			__taskList:Array<Dynamic> /* <Dynamic> */,
			__findLabelsFlag:Bool = true
			):XTask {
				
			var __task:XTask = m_manager.addTask (__taskList, __findLabelsFlag);
			
			if (!(m_XTasks.exists (__task))) {
				m_XTasks.set (__task, 0);
			}
			
			return __task;
		}
		
//------------------------------------------------------------------------------------------
		public function addXTask (__task:XTask):XTask {
			var __task:XTask = m_manager.addXTask (__task);
			
			if (!m_XTasks.exists (__task)) {
				m_XTasks.set (__task, 0);
			}
			
			return __task;			
		}
		
//------------------------------------------------------------------------------------------
		public function changeTask (
			__oldTask:XTask,
			__taskList:Array<Dynamic> /* <Dynamic> */,
			__findLabelsFlag:Bool = true
			):XTask {
				
			if (!(__oldTask == null)) {
				removeTask (__oldTask);
			}
					
			return addTask (__taskList, __findLabelsFlag);
		}

//------------------------------------------------------------------------------------------
		public function changeXTask (
			__oldTask:XTask,
			__newTask:XTask
			):XTask {
				
			if (!(__oldTask == null)) {
				removeTask (__oldTask);
			}
					
			return addXTask (__newTask);
		}
		
//------------------------------------------------------------------------------------------
		public function isTask (__task:XTask):Bool {
			return m_XTasks.exists (__task);
		}		

//------------------------------------------------------------------------------------------
		public function removeTask (__task:XTask):Void {	
			if (m_XTasks.exists (__task)) {
				m_XTasks.remove (__task);
					
				m_manager.removeTask (__task);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllTasks ():Void {	
			for (__key__ in m_XTasks.keys ()) {
				function (x:Dynamic /* */):Void {
					removeTask (cast x /* as XTask */);
				} (__key__);
			}
		}

//------------------------------------------------------------------------------------------
		public function addEmptyTask ():XTask {
			return addTask (getEmptyTaskX ());
		}
			
//------------------------------------------------------------------------------------------
		public function getEmptyTaskX ():Array<Dynamic> /* <Dynamic> */ {
			return [
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
			];
		}	
		
//------------------------------------------------------------------------------------------
		public function gotoLogic (__logic:Dynamic /* Function */):Void {
			removeAllTasks ();
			
			__logic ();
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
