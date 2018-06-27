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
	
	import kx.collections.*;
	import kx.pool.*;
	import kx.task.*;
	import kx.XApp;
	
	import openfl.events.*;
	import openfl.media.*;
	import openfl.utils.*;
	
//------------------------------------------------------------------------------------------	
	class MP3Pitch extends MP3Sound  {
		private static inline var BLOCK_SIZE:Int = 3072;
		
		private var _loop:Bool;
		
//		private var m_mp3: Sound;
		private var _sound:Sound;
		
		private var _target:ByteArray;
		
		private var _position:Float;
		private var _rate:Float;
		private var _volume:Float;
		
		private var _length:Float;
		private var _isPlaying:Bool;
		
		private var m_function:Dynamic /* Function */;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}

//------------------------------------------------------------------------------------------
		public override function setup (__mp3:Sound):Void {
			super.setup (__mp3);
			
			_isPlaying = false;
			
			initSoundCompleteListeners();
			
			_target = new ByteArray();
			_position = 0.0;
			_rate = 1.0;
			_volume = 1.0;
		}
		
//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
		}
		
		
		//---------------------------------------------------------------------
		//  Events
		//---------------------------------------------------------------------
		
		/**
		 * Init sound load event listeners.
		 * @private
		 */
		private function initSoundCompleteListeners():Void {
			m_mp3.addEventListener( Event.COMPLETE, soundCompleteHandler );
		}
		
		/**
		 * Init a SampleData listener.
		 * @private
		 */
		private function initSampleDataEventListeners():Void {
			_sound.addEventListener( SampleDataEvent.SAMPLE_DATA, sampleDataHandler );
		}
		
		/**
		 * Exit sound load event listeners.
		 * @private
		 */
		private function exitSoundCompleteListeners():Void {
			m_mp3.removeEventListener( Event.COMPLETE, soundCompleteHandler );
		}
		
		/**
		 * Exit a SampleData listener.
		 * @private
		 */
		private function exitSampleDataEventListeners():Void {
			_sound.removeEventListener( SampleDataEvent.SAMPLE_DATA, sampleDataHandler );
		}
		
		//---------------------------------------------------------------------
		//  Event handlers
		//---------------------------------------------------------------------
		
		/**
		 * Handles a sound complete event.
		 * @private
		 */
		private function soundCompleteHandler( event: Event ):Void
		{
			exitSoundCompleteListeners();
			_length = m_mp3.length * 44.1;
			dispatchEvent(new Event(Event.COMPLETE));
			if (m_function != null) {
				m_function ();
			}
		}
		
		/**
		 * Handles a sampleData event.
		 * @private
		 */
		private function sampleDataHandler( event: SampleDataEvent ):Void
		{
			//-- REUSE INSTEAD OF RECREATION
			_target.position = 0;
			
			//-- SHORTCUT
			var data: ByteArray = event.data;
			
			var scaledBlockSize:Float = BLOCK_SIZE * _rate;
			var positionInt:Int = Std.int (_position);
			var alpha:Float = _position - positionInt;
			
			var positionTargetNum:Float = alpha;
			
			//-- COMPUTE NUMBER OF SAMPLES NEED TO PROCESS BLOCK (+2 FOR INTERPOLATION)
			var need:Int = Math.ceil( scaledBlockSize ) + 2;
			
			//-- EXTRACT SAMPLES
			
			#if (windows || html5)
			var read:Int = 0;
			#else
			var read:Int = Std.int (m_mp3.extract( _target, need, positionInt ));
			#end
			
			var n:UInt;
			
			if (read == need) {
				n = BLOCK_SIZE;
			}
			else {
				n = Std.int (read / _rate);
			}
			
			writeData(data, alpha, n, positionTargetNum);
			
			if( n < BLOCK_SIZE )
			{
				if (_loop) {
					positionTargetNum = 0;
					_position = 0;
					n = BLOCK_SIZE - n;
					
					writeData(data, alpha, n, positionTargetNum);
					
					_position = n;
				}
				else {
					//-- SET AT START OF SOUND FOR REPLAY
					_position = 0;
					stop();
				}
			}
			else {
				//-- INCREASE SOUND POSITION
				_position += scaledBlockSize;
			}
		}
		
		private function writeData(data:ByteArray, alpha:Float, n:UInt, positionTargetNum:Float):Void {
			var positionTargetInt:Int = -1;
			
			var l0:Float = 0;
			var r0:Float = 0;
			var l1:Float = 0;
			var r1:Float = 0;
			
			for (i in 0 ... n)
			{
				//-- AVOID READING EQUAL SAMPLES, IF RATE < 1.0
				if(Std.int (positionTargetNum) != positionTargetInt )
				{
					positionTargetInt = Std.int (positionTargetNum);
					
					//-- SET TARGET READ POSITION
					_target.position = positionTargetInt << 3;
					
					//-- READ TWO STEREO SAMPLES FOR LINEAR INTERPOLATION
					try {
						l0 = _target.readFloat();
						r0 = _target.readFloat();
						
						l1 = _target.readFloat();
						r1 = _target.readFloat();
					} catch (e:Dynamic) {
						// IF WE ENTER AN END_OF_FILE FILL REST OF STREAM WITH ZEROs
						l0 = 0;
						r0 = 0;
						
						l1 = 0;
						l1 = 0;
					}
				}
				
				//-- WRITE INTERPOLATED AMPLITUDES INTO STREAM
				data.writeFloat( (l0 + alpha * ( l1 - l0 )) * _volume );
				data.writeFloat(( r0 + alpha * ( r1 - r0 )) * _volume );
				
				//-- INCREASE TARGET POSITION
				positionTargetNum += _rate;
				
				//-- INCREASE FRACTION AND CLAMP BETWEEN 0 AND 1
				alpha += _rate;
				while( alpha >= 1.0 ) --alpha;
			}
		}
		
		//---------------------------------------------------------------------
		//  Getters & Setters
		//---------------------------------------------------------------------
		
		/* @:override2 get, set rate Float */
		
		public override function get_rate():Float {
			return _rate;
		}
		
		public override function set_rate( value:Float ): Float { // void {
			if( value < 0.1 ) {
				value = 0.1;
			}
			
			_rate = value;
			
			return 0;
		}
		/* @:end */
		
		/* @:override2 get, set volume Float */
		
		public override function get_volume():Float {
			return _volume;
		}
		
		public override function set_volume( value:Float ): Float { // void {
			if( value < 0.0 ) {
				value = 0;
			}
			
			_volume = value;
			
			return 0;
		}
		/* @:end */
		
		/* @:override2 get, set position Float */
		
		public override function get_position():Float {
			return _position;
		}
		/* @:end */
		
		/* @:override2 get, set length Float */
		
		public override function get_length():Float {
			return _length;
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public override function play (__startTime:Float, __loops:Int, __soundTransform:SoundTransform):Void {
			_loop = (__loops > 1);
			
			if  (!_isPlaying) {
				_sound = new Sound();
				initSampleDataEventListeners();
				_sound.play();
				_isPlaying = true;
			}
		}

//------------------------------------------------------------------------------------------
		public override function stop ():Void {
			if  (_isPlaying) {
				exitSampleDataEventListeners();
				_isPlaying = false;
				_sound = null;
			}
		}
		
//------------------------------------------------------------------------------------------
		public override function addCompleteListener (__function:Dynamic /* Function */):Void {	
			m_function = __function;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
