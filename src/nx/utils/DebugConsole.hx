//------------------------------------------------------------------------------------------
package nx.utils;

	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.signals.XSignal;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import openfl.display.Sprite;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	import openfl.events.*;
	
	import openfl.Assets;
	
	//------------------------------------------------------------------------------------------
	class DebugConsole extends XLogicObject {
		public var m_consoleBox:Sprite;
		public var x_consoleBox:XDepthSprite;
		
		public var m_text:XTextSprite;
		public var x_text:XDepthSprite;
		
		public var script:XTask;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
		
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
			script = addEmptyTask ();
			
			Idle_Script ();
			
			oY = 25;
			oAlpha = 0.66;
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setMessage (__messages:Array<String>):Void {
			var __messageString:String = "";
			
			for (__message in __messages) {
				__messageString += "" + __message + ", ";
			}
			
			m_text.text = __messageString;
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			var __padding:Float = 16;
			var __x:Float = __padding;
			var __y:Float = __padding;			
			var __width:Float = xxx.getXApp ().getDeviceWidth () - __padding * 2;
			var __height:Float = 150 - __padding * 2;
			
			m_consoleBox = new Sprite ();
			x_consoleBox = addSpriteAt (m_consoleBox, 0, 0);
			
			m_consoleBox.graphics.beginFill (0xc0c0c0);
			m_consoleBox.graphics.drawRect (__x, __y, __width, __height);
			m_consoleBox.graphics.endFill ();
						
			m_consoleBox.graphics.lineStyle (2.0, 0x000000);
			m_consoleBox.graphics.moveTo (__x, __y);
			m_consoleBox.graphics.lineTo (__x + __width, __y);
			m_consoleBox.graphics.lineTo (__x + __width, __y + __height);
			m_consoleBox.graphics.lineTo (__x, __y + __height);
			m_consoleBox.graphics.lineTo (__x, __y);
			
			var font:Font = Assets.getFont ("fonts/Aller_Rg.ttf");
			
			m_text = createXTextSprite (
				__width, __height,
				"",
				font.fontName,
				20,
				false,
				true
			);
			
			m_text.getTextField ().multiline = true;
			m_text.getTextField ().wordWrap = true;
			
			x_text = addSpriteAt (m_text, 0, 0);
			
			m_text.x = __padding + 8;
			m_text.y = __padding + 8;

			m_consoleBox.addEventListener (MouseEvent.CLICK, function (e:MouseEvent):Void {
				trace (": DebugConsole: mouseClick: ", e);
			});
			
			show ();
		}
		
		//------------------------------------------------------------------------------------------
		public function Idle_Script ():Void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
						
							function ():Void {
							},
						
						XTask.GOTO, "loop",
						
						XTask.RETN,
					]);
					
				},
				
				//------------------------------------------------------------------------------------------
				// animation
				//------------------------------------------------------------------------------------------	
				XTask.LABEL, "loop",	
					XTask.WAIT, 0x0100,	
				
				XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
		//------------------------------------------------------------------------------------------
		}

	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }