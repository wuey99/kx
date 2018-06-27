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
package kx.world.sprite;

// X classes
	import kx.geom.*;
	
// flash classes
	import openfl.geom.*;
		
//------------------------------------------------------------------------------------------	
	interface XRegistration {
		
//------------------------------------------------------------------------------------------
		function globalToParent():Point;

//------------------------------------------------------------------------------------------
		function setRegistration(x:Float=0, y:Float=0):Void;

//------------------------------------------------------------------------------------------
		function getRegistration():XPoint;
	
		//------------------------------------------------------------------------------------------		
		function get_x2():Float;
		
		//------------------------------------------------------------------------------------------
		function set_x2(value:Float):Float;
		
		//------------------------------------------------------------------------------------------
		function get_y2():Float;
		
		//------------------------------------------------------------------------------------------
		function set_y2(value:Float):Float;
		
		//------------------------------------------------------------------------------------------
		function get_scaleX2():Float;
		
		//------------------------------------------------------------------------------------------
		function set_scaleX2(value:Float):Float;
		
		//------------------------------------------------------------------------------------------
		function get_scaleY2():Float;
		
		//------------------------------------------------------------------------------------------
		function set_scaleY2(value:Float):Float;
		
		//------------------------------------------------------------------------------------------
		function get_rotation2():Float;
		
		//------------------------------------------------------------------------------------------
		function set_rotation2(value:Float):Float;
		
		//------------------------------------------------------------------------------------------
		function get_mouseX2():Float;
		
		//------------------------------------------------------------------------------------------
		function get_mouseY2():Float;
		
		
//------------------------------------------------------------------------------------------
		function setProperty2(prop:String, n:Float):Void;	
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
