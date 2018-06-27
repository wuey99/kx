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
		public var rp:XPoint;
		
//------------------------------------------------------------------------------------------
		public function globalToParent():XPoint {
			return parent.globalToLocal (localToGlobal (rp));
		}

//------------------------------------------------------------------------------------------
		public function setRegistration(x:Float=0, y:Float=0):Void {
			rp = new XPoint(x, y);
		}

//------------------------------------------------------------------------------------------
		public function getRegistration():XPoint {
			return rp;
		}
				
//------------------------------------------------------------------------------------------		
		public function get x2():Float {
			var p:XPoint = globalToParent ();
			
			return p.x;
		}

//------------------------------------------------------------------------------------------
		public function set x2(value:Float):Void {
			var p:XPoint = globalToParent ();
			
			this.x += value - p.x;
		}

//------------------------------------------------------------------------------------------
		public function get y2():Float {
			var p:XPoint = globalToParent ();
			
			return p.y;
		}

//------------------------------------------------------------------------------------------
		public function set y2(value:Float):Void {
			var p:XPoint = globalToParent ();
			
			this.y += value - p.y;
		}

//------------------------------------------------------------------------------------------
		public function get scaleX2():Float {
			return this.scaleX;
		}

//------------------------------------------------------------------------------------------
		public function set scaleX2(value:Float):Void {
			var a:XPoint = globalToParent ();			
			this.scaleX = value;
			this.validateNow (); 			
			var b:XPoint = globalToParent ();
			x -= b.x - a.x;
		}

//------------------------------------------------------------------------------------------
		public function get scaleY2():Float {
			return this.scaleY;
		}

//------------------------------------------------------------------------------------------
		public function set scaleY2(value:Float):Void {
			var a:XPoint = globalToParent ();	
			this.scaleY = value;
			this.validateNow ();
			var b:XPoint = globalToParent ();	
			y -= b.y - a.y;
		}

//------------------------------------------------------------------------------------------
		public function get rotation2():Float {
			return this.rotation;
		}

//------------------------------------------------------------------------------------------
		public function set rotation2(value:Float):Void {
			var a:XPoint = globalToParent ();
			this.rotation = value;
			this.validateNow ();
			var b:XPoint = globalToParent ();
			x -= b.x - a.x;
			y -= b.y - a.y;
		}

//------------------------------------------------------------------------------------------
		public function get mouseX2():Float {
			return Math.round(this.mouseX - rp.x);
		}

//------------------------------------------------------------------------------------------
		public function get mouseY2():Float {
			return Math.round(this.mouseY - rp.y);
		}

//------------------------------------------------------------------------------------------
		public function setProperty2(prop:String, n:Float):Void {	
		}
		