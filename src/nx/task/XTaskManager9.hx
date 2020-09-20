//------------------------------------------------------------------------------------------
package nx.task;

	import kx.*;
	import kx.collections.*;
	import kx.pool.*;
	import kx.task.*;
	import kx.world.logic.*;
	import kx.type.*;

	//------------------------------------------------------------------------------------------	
	class XTaskManager9 extends XTaskManager {
	
	//------------------------------------------------------------------------------------------	
		public override function createPoolManager ():XObjectPoolManager {
			return new XObjectPoolManager (
				function ():Dynamic /* */ {
					return new XTask9 ();
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
		public override function addTask (__taskList:Array<Dynamic> /* <Dynamic> */, __findLabelsFlag:Bool = true):XTask {
//			var __task:XTask = cast m_poolManager.borrowObject (); /* as XTask */
			var __task:XTask = new XTask9 ();
			__task.setup (__taskList, __findLabelsFlag);
			
			__task.setManager (this);
			__task.setParent (this);
			
			m_XTasks.set (__task, 0);
			
			return __task;
		}
	}