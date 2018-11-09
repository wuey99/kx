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
		public var CX_COLLIDE_LF:Int = 0x0001;
		public var CX_COLLIDE_RT:Int = 0x0002;
		public var CX_COLLIDE_HORZ:Int = 0x0001 | 0x0002; 
		public var CX_COLLIDE_UP:Int = 0x0004;
		public var CX_COLLIDE_DN:Int = 0x0008;
		public var CX_COLLIDE_VERT:Int = 0x0004 | 0x0008;
	
		// empty
		public static inline var CX_EMPTY:Int = 0;
		
		// solid solid
		public static inline var CX_SOLID:Int = 1;
		
		// soft
		public static inline var CX_SOFT:Int = 2;	
		
		// jump thru
		public static inline var CX_JUMP_THRU:Int = 3;
		
		// 45 degree diagonals
		public static inline var CX_UL45:Int = 4;
		public static inline var CX_UR45:Int = 5;
		public static inline var CX_LL45:Int = 6;
		public static inline var CX_LR45:Int = 7;
		
		// 22.5 degree diagonals
		public static inline var CX_UL225A:Int = 8;
		public static inline var CX_UL225B:Int = 9;
		public static inline var CX_UR225A:Int = 10;
		public static inline var CX_UR225B:Int = 11;
		public static inline var CX_LL225A:Int = 12;
		public static inline var CX_LL225B:Int = 13;
		public static inline var CX_LR225A:Int = 14;
		public static inline var CX_LR225B:Int = 15;
		
		// 67.5 degree diagonals
		public static inline var CX_UL675A:Int = 16;
		public static inline var CX_UL675B:Int = 17;
		public static inline var CX_UR675A:Int = 18;
		public static inline var CX_UR675B:Int = 19;
		public static inline var CX_LL675A:Int = 20;
		public static inline var CX_LL675B:Int = 21;
		public static inline var CX_LR675A:Int = 22;
		public static inline var CX_LR675B:Int = 23;
		
		// soft tiles
		public static inline var CX_SOFTLF:Int = 24;
		public static inline var CX_SOFTRT:Int = 25;
		public static inline var CX_SOFTUP:Int = 26;
		public static inline var CX_SOFTDN:Int = 27;
	
		// special solids
		public static inline var CX_SOLIDX001:Int = 28;
		
		// death
		public static inline var CX_DEATH:Int = 29;
		
		// ice
		public static inline var CX_ICE:Int = 30;
		
		// max
		public static inline var CX_MAX:Int = 31;
		
		// collision tile width, height
		public static inline var CX_TILE_WIDTH:Int = 16;
		public static inline var CX_TILE_HEIGHT:Int = 16;
		
		public static inline var CX_TILE_WIDTH_MASK:Int = 15;
		public static inline var CX_TILE_HEIGHT_MASK:Int = 15;
		
		public static inline var CX_TILE_WIDTH_UNMASK:Int = 0xfffffff0;
		public static inline var CX_TILE_HEIGHT_UNMASK:Int = 0xfffffff0;
		
		// alternate tile width, height
		public static inline var TX_TILE_WIDTH:Int = 64;
		public static inline var TX_TILE_HEIGHT:Int = 64;
		
		public static inline var TX_TILE_WIDTH_MASK:Int = 63;
		public static inline var TX_TILE_HEIGHT_MASK:Int = 63;
		
		public static inline var TX_TILE_WIDTH_UNMASK:Int = 0xffffffc0;
		public static inline var TX_TILE_HEIGHT_UNMASK:Int = 0xffffffc0;
		
		// (tikiedit) tile width, height
		public static inline var CX_BOTH_WIDTH:Int = 64;
		public static inline var CX_BOTH_HEIGHT:Int = 64;
		
		public static inline var CX_BOTH_WIDTH_MASK:Int = 63;
		public static inline var CX_BOTH_HEIGHT_MASK:Int = 63;
		
		public static inline var CX_BOTH_WIDTH_UNMASK:Int = 0xffffffc0;
		public static inline var CX_BOTH_HEIGHT_UNMASK:Int = 0xffffffc0;