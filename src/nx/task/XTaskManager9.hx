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
	}