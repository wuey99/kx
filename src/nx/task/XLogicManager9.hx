//------------------------------------------------------------------------------------------
package nx.task;

// X classes
	import kx.*;
	import kx.collections.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.type.*;
	import kx.world.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	
	import openfl.geom.*;
	
//------------------------------------------------------------------------------------------	
	class XLogicManager9 extends XLogicManager {
		private var m_XTaskManager9:XTaskManager9;
		
//------------------------------------------------------------------------------------------
		public function new (__XApp:XApp, __xxx:XWorld) {
			super (__XApp, __xxx);
			
			m_XTaskManager9 = new XTaskManager9 (__XApp);
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
			
			m_XTaskManager9.removeAllTasks ();
		}
		
//------------------------------------------------------------------------------------------
		public override function updateTasks ():Void {
			m_XTaskManager0.updateTasks ();
			m_XTaskManager9.updateTasks ();
			m_XTaskManager.updateTasks ();
			m_XTaskManagerCX.updateTasks ();
		}

//------------------------------------------------------------------------------------------
		public function getXTaskManager9 ():XTaskManager9 {
			return m_XTaskManager9;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
