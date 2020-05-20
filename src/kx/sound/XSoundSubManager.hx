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
package kx.sound;

	import kx.*;
	import kx.collections.*;
	import kx.task.*;
	import kx.type.*;
	
	import openfl.media.*;
	import openfl.utils.*;
	
//------------------------------------------------------------------------------------------	
	class XSoundSubManager {
		public var m_soundManager:XSoundManager;
		public var m_soundChannels:Map<Int, Float>; // <Int, Float>
		public var m_maxChannels:Int;
		public var m_numChannels:Int;
		
//------------------------------------------------------------------------------------------
		public function new (__soundManager:XSoundManager) {
			m_soundManager = __soundManager;

			m_soundChannels = new Map<Int, Float> ();  // <Int, Float>
			
			m_maxChannels = 8;
			m_numChannels = 0;
		}

//------------------------------------------------------------------------------------------
		public function setup (__maxChannels:Int):Void {
			m_maxChannels = __maxChannels;
			m_numChannels = 0;
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
			removeAllSounds ();
		}
		
//------------------------------------------------------------------------------------------
		public function setSoundManager (__soundManager:XSoundManager):Void {
			m_soundManager = __soundManager;
		}

//------------------------------------------------------------------------------------------
		public function playSoundFromClass (
			__class:Class<Dynamic> /* <Dynamic> */,
			__priority:Float = 1.0,
			__loops:Int = 0,
			__transform:SoundTransform = null,
			__successListener:Dynamic /* Function */ = null,
			__completeListener:Dynamic /* Function */ = null
			):Int {
			
			if (!channelAvailable (__priority)) {
				return -1;
			}
				
			return m_soundManager.playSoundFromClass (
				__class,
				__priority,
				__loops,
				__transform,
				
				function (__guid:Int):Void {
					m_soundChannels.set (__guid, __priority);
					m_numChannels++;
					
					if (__successListener != null) {
						__successListener (__guid);
					}					
				},
				
				function (__guid:Int):Void {
					if (__completeListener != null) {
						__completeListener (__guid);
					}
					
					if (m_soundChannels.exists (__guid)) {
						m_soundChannels.remove (__guid);	
						m_numChannels--;
					}
				}
			);
		}

//------------------------------------------------------------------------------------------
		public function playSoundFromClassName (
			__className:String,
			__priority:Float = 1.0,
			__loops:Int = 0,
			__transform:SoundTransform = null,
			__successListener:Dynamic /* Function */ = null,
			__completeListener:Dynamic /* Function */ = null
			):Int {
			
			if (!channelAvailable (__priority)) {
				return -1;
			}
			
			return m_soundManager.playSoundFromClassName (
				__className,
				__priority,
				__loops,
				__transform,
				
				function (__guid:Int):Void {					
					m_soundChannels.set (__guid, __priority);
					m_numChannels++;

					if (__successListener != null) {
						__successListener (__guid);
					}					
				},
				
				function (__guid:Int):Void {
					if (__completeListener != null) {
						__completeListener (__guid);
					}
					
					if (m_soundChannels.exists (__guid)) {
						m_soundChannels.remove (__guid);	
						m_numChannels--;
					}
				}
			);
		}
		
		//------------------------------------------------------------------------------------------
		public function playPitchSoundFromClass (
			__class:Class<Dynamic> /* <Dynamic> */,
			__priority:Float = 1.0,
			__loops:Int = 0,
			__transform:SoundTransform = null,
			__successListener:Dynamic /* Function */ = null,
			__completeListener:Dynamic /* Function */ = null
		):Int {
			
			if (!channelAvailable (__priority)) {
				return -1;
			}
			
			return m_soundManager.playPitchSoundFromClass (
				__class,
				__priority,
				__loops,
				__transform,
				
				function (__guid:Int):Void {
					m_soundChannels.set (__guid, __priority);
					m_numChannels++;
					
					if (__successListener != null) {
						__successListener (__guid);
					}					
				},
				
				function (__guid:Int):Void {
					if (__completeListener != null) {
						__completeListener (__guid);
					}
					
					if (m_soundChannels.exists (__guid)) {
						m_soundChannels.remove (__guid);	
						m_numChannels--;
					}
				}
			);
		}
		
		//------------------------------------------------------------------------------------------
		public function playPitchSoundFromClassName (
			__className:String,
			__priority:Float = 1.0,
			__loops:Int = 0,
			__transform:SoundTransform = null,
			__successListener:Dynamic /* Function */ = null,
			__completeListener:Dynamic /* Function */ = null
		):Int {
			
			if (!channelAvailable (__priority)) {
				return -1;
			}
			
			return m_soundManager.playPitchSoundFromClassName (
				__className,
				__priority,
				__loops,
				__transform,
				
				function (__guid:Int):Void {					
					m_soundChannels.set (__guid, __priority);
					m_numChannels++;
					
					if (__successListener != null) {
						__successListener (__guid);
					}					
				},
				
				function (__guid:Int):Void {
					if (__completeListener != null) {
						__completeListener (__guid);
					}
					
					if (m_soundChannels.exists (__guid)) {
						m_soundChannels.remove (__guid);	
						m_numChannels--;
					}
				}
			);
		}
		
//------------------------------------------------------------------------------------------
		private function channelAvailable (__priority:Float):Bool {
			if (m_numChannels < m_maxChannels) {
				return true;
			}
			
			var __firstChoice:Int = -1;
			var __secondChoice:Int = -1;
			
			XType.forEach (m_soundChannels, 
				function (__targetGuid:Int):Void {
					var __targetPriority:Float = m_soundChannels.get (__targetGuid);
					
					if (__priority > __targetPriority) {
						__firstChoice = __targetGuid;
					}
					
					if (__priority == __targetPriority) {
						__secondChoice = __targetGuid;
					}
				}
			);
			
			if (__firstChoice != -1) {
				removeSound (__firstChoice);
				
				return true;
			}
			
			if (__secondChoice != -1) {
				removeSound (__secondChoice);
				
				return true;
			}
			
			return false;
		}
		
//------------------------------------------------------------------------------------------
		public function stopSound (__guid:Int):Void {
			removeSound (__guid);
		}

//------------------------------------------------------------------------------------------
		public function removeSound (__guid:Int):Void {
			if (m_soundChannels.exists (__guid)) {
				m_soundChannels.remove (__guid);
				
				m_soundManager.removeSound (__guid);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllSounds ():Void {
			XType.forEach (m_soundChannels, 
				function (__guid:Dynamic /* */):Void {
					removeSound (cast __guid /* as Int */);
				}
			);
		}

//------------------------------------------------------------------------------------------
		public function getSoundChannel (__guid:Int):MP3Sound {
			return m_soundManager.getSoundChannel (__guid);
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
