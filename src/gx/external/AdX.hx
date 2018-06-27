//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "GX-Engine"
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
package gx.external;
	
	import kx.*;
	import kx.geom.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	
	import openfl.display.*;
	import openfl.events.*;
	import openfl.geom.*;
	import openfl.net.*;
	import openfl.system.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class AdX extends XLogicObjectCX {
		public var m_completeSignal:XSignal;
		public var m_errorSignal:XSignal;
		
		public var script:XTask;
		
		public var adID:String;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
		
			adID = getArg (args, 0);
			
			m_completeSignal = createXSignal ();
			m_errorSignal = createXSignal ();
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
			setCX (-8, 8, -8, 8);
			
			script = addEmptyTask ();
			
			Idle_Script ();
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					function ():Void {
					}, 
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
			]);
		}
		
		//------------------------------------------------------------------------------------------
		public function addCompleteListener (__listener:Dynamic /* Function */):Int {
			return m_completeSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireCompleteSignal ():Void {
			m_completeSignal.fireSignal ();
		}
		
		//------------------------------------------------------------------------------------------
		public function addErrorListener (__listener:Dynamic /* Function */):Int {
			return m_errorSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireErrorSignal (e:Event):Void {
			m_errorSignal.fireSignal (e);
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