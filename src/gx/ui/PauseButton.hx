//------------------------------------------------------------------------------------------
package gx.ui;

// X classes
	import kx.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.ui.*;
	import kx.world.sprite.*;
	
	import openfl.events.*;
	import openfl.text.*;
	import openfl.utils.*;

//------------------------------------------------------------------------------------------
	class PauseButton extends XButton {
		public var m_highlightTask:XTask;
				
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}

//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic>  /* <Dynamic> */):Void {
			super.setup (__xxx, args);
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
			
			xxx.getXTaskManager  ().removeTask (m_highlightTask);
		}

//------------------------------------------------------------------------------------------
		public override function createHighlightTask ():Void {
			m_highlightTask = xxx.getXTaskManager ().addTask ([
				XTask.LABEL, "__loop",
					XTask.WAIT, 0x0100,
					
					function ():Void {
						m_sprite.gotoAndStop (m_label);
					},
									
				XTask.GOTO, "__loop",
			]);
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
// }
