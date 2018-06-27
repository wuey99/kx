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
package kx.task;
	
	//------------------------------------------------------------------------------------------	
	class XTask_CONSTANTS {
		public static inline var CALL:Int = 0;
		public static inline var RETN:Int = 1;
		public static inline var LOOP:Int = 2;
		public static inline var NEXT:Int = 3;
		public static inline var WAIT:Int = 4;
		public static inline var LABEL:Int = 5;
		public static inline var GOTO:Int = 6;
		public static inline var BEQ:Int = 7;
		public static inline var BNE:Int = 8;
		public static inline var FLAGS:Int = 9;
		public static inline var EXEC:Int = 10;
		public static inline var FUNC:Int = 11;
		public static inline var WAIT1000:Int = 12; 
		public static inline var UNTIL:Int = 13;
		public static inline var POP:Int = 14;
		public static inline var WAITX:Int = 15;
		
		public static inline var FLAGS_EQ:Int = 1;
		
		//------------------------------------------------------------------------------------------
		public function new () {
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
