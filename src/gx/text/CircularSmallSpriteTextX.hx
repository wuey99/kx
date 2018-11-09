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
package gx.text;
	
	import gx.assets.*;

	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class CircularSmallSpriteTextX extends SmallSpriteTextX {
		private var m_angle:Float;
		private var m_dist:Float;
		private var m_delta:Float;
		private var m_speed:Float;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic>  /* <Dynamic> */):Void {
			angle = 45;
			dist = 75;
			delta = 25;
			speed = 4.0;
			
			super.setup (__xxx, args);
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					function ():Void {
						updateSprites ();
					},
						
					XTask.GOTO, "loop",
				
				XTask.RETN,
			]);
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					function ():Void {
						m_angle -= m_speed;
						
						if (m_angle < 0) m_angle += 360;
						if (m_angle > 360) m_angle -= 360;
					},
					
					XTask.GOTO, "loop",
					
				XTask.RETN,
			]);
		}

		//------------------------------------------------------------------------------------------
		public var angle (get, set):Float;
		
		public function get_angle ():Float {
			return m_angle;
		}
		
		public function set_angle (__val:Float): Float {
			m_angle = __val;
				
			return 0;			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		public var dist (get, set):Float;
		
		public function get_dist ():Float {
			return m_dist;
		}

		public function set_dist (__val:Float): Float {
			m_dist = __val;
				
			return 0;			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		public var delta (get, set):Float;
		
		public function get_delta ():Float {
			return m_delta;
		}
		
		public function set_delta (__val:Float): Float {
			m_delta = __val;
			
			return 0;			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		public var speed (get, set):Float;
		
		public function get_speed ():Float {
			return m_speed;
		}
		
		public function set_speed (__val:Float): Float {
			m_speed = __val;
			
			return 0;			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		public override function updateSprites ():Void {
			var __dx:Float = 0;
			var __dy:Float = 0;
			var __radians:Float;
			var __rotation:Float;
			
			var __angle:Float = m_angle;
			
			for (i in 0 ... m_text.length) {
				var __c:Int = m_text.charCodeAt (i) - 32;
				if (__c >= 64) __c -= 32;
				m_bitmap[i].gotoAndStop (__c + 1);
//				m_bitmap[i].setRegistration (getWidths ()[__c]/2, 21);
				__rotation = 360 - __angle;  if (__rotation >= 360) __rotation -= 360;
				m_bitmap[i].rotation = __rotation - 90;
				__radians = __rotation * Math.PI/180;
				__dx = Math.cos (__radians) * m_dist;
				__dy = Math.sin (__radians) * m_dist;
				x_sprite[i].setRegistration (m_bitmap[i].dx + __dx, m_bitmap[i].dy + __dy);
				__angle -= m_delta * (getWidths ()[__c]/22);
				if (__angle < 0) __angle += 360;
				if (__angle > 360) __angle -= 360;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function getWidths ():Array<Float> /* <Float> */ {
			return  [
				10,		// space
				7,		// !
				14,		// "
				17,		// #
				17,		// $
				22,		// %
				18,		// &
				6,		// '
				10,		// (
				10,		// }
				10,		// .
				14,		// +
				10,		// ,
				11,		// -
				6,		// .
				10,		// /
				14,		// 0
				10,		// 1
				14,		// 2
				14,		// 3
				14,		// 4
				14,		// 5
				14,		// 6
				14,		// 7
				14,		// 8
				14,		// 9
				6,		// :
				10,		// ;
				10,		// <
				11,		// =
				10,		// >
				13,		// ?
				21,		// @
				18,		// A
				18,		// B
				18,		// C
				18,		// D
				16,		// E
				16,		// F
				18,		// G
				18,		// H
				9,		// I
				14,		// J
				18,		// K
				16,		// L
				22,		// M
				18,		// N
				18,		// O
				18,		// P
				18,		// Q
				18,		// R
				18,		// S
				14,		// T
				18,		// U
				14,		// V
				22,		// W
				22,		// X
				22,		// Y
				14,		// Z
				10,		// [
				10,		// \
				10,		// ]
				14,		// ^
			];
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }