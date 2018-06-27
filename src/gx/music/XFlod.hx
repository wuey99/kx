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
package gx.music;
	
// X
	import kx.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.logic.*;
	
	import openfl.utils.*;
	
		
	//------------------------------------------------------------------------------------------
	class XFlod extends XLogicObject {
		public var m_player:CorePlayer;
		public var m_source:Class<Dynamic>; // <Dynamic>
		public var m_volume:Float;
		
		//------------------------------------------------------------------------------------------
		public function new () {	
			super ();
		}

		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic>  /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_volume = 1.0;
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
		}
		
		//------------------------------------------------------------------------------------------
		public function playSong (__source:Class<Dynamic> /* <Dynamic> */):Void {
			if (m_player != null) {
				stopSong ();
			}
		
			m_source = __source;
			
			if (getVolume () == 0.0) {
				m_player = null;
				
				return;
			}
			
		}

		//------------------------------------------------------------------------------------------
		public function setVolume (__volume:Float):Void {
			m_volume = __volume;

			if (m_player != null) {
				m_player.volume = Std.int (m_volume);
			}

			if (m_player == null && m_source != null && m_volume > 0.0) {
				playSong (m_source);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function getVolume ():Float {
			return m_volume;
		}
		
		//------------------------------------------------------------------------------------------
		public function fadeOutAndStopSong ():Void {
			var __volume:Float = 1.0;
			
			if (isPlaying ()) {
				addTask ([
					XTask.LABEL, "loop",
						XTask.WAIT, 0x0100,
						
						XTask.FLAGS, function (__task:XTask):Void {
							__volume = Math.max (0.0, __volume - 0.10);
							
							m_player.volume = Std.int (__volume);
							
							__task.ifTrue (__volume == 0.0);
						}, XTask.BNE, "loop",
					
					function ():Void {
						stopSong ();	
					},
					
					XTask.RETN,
				]);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function stopSong ():Void {
			if (isPlaying ()) {
				m_player.stop ();
			
				m_player = null;
				m_source = null;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function pauseSong ():Void {
			if (isPlaying ()) {
				m_player.pause ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function resumeSong ():Void {
			if (isPlaying ()) {
				m_player.play ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function isPlaying ():Bool {
			if (m_player != null) {
				return true;
			}
			else
			{
				return false;
			}
		}
		
	//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
	class CorePlayer {
		public var volume:Int;
		
		public function new () {
			
		}
		
		public function play ():Void {
			
		}
		
		public function pause ():Void {
			
		}
		
		public function stop ():Void {
			
		}
	}
	
//------------------------------------------------------------------------------------------
// }