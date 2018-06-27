package kx.utils;
	
// see: http://www.rgbeffects.com/blog/actionscript/actionscript-3-guid-%E2%80%93-generating-unique-ids-for-users-in-as3/

	import openfl.display.Sprite;
	import openfl.system.Capabilities;
	
	import kx.type.*;
	
	class GUID extends Sprite {

		private static var counter:Int = 0;
		
		function new (){
			super();
		}
		
		public static function create():String {
			var dt:Date = XType.getNowDate();
			var id1:Float = dt.getTime();
			var id2:Float = Math.random()*XType.Number_MAX_VALUE();
			var id3:String = Capabilities.serverString;
			var rawID:String = calculate(id1+id3+id2+counter++).toUpperCase();
			var finalString:String = rawID.substring(0, 8) + "-" + rawID.substring(8, 12) + "-" + rawID.substring(12, 16) + "-" + rawID.substring(16, 20) + "-" + rawID.substring(20, 32);
			return finalString;
		}
	
		private static function calculate(src:String):String {
				return hex_sha1(src);
		}
	
		private static function hex_sha1(src:String):String {
				return binb2hex(core_sha1(str2binb(src), src.length*8));
		}
			
		private static function core_sha1(
			x:Array<Int> /* <Int> */,
			len:Int
		):Array<Int> /* <Int> */ {
			x[len >> 5] |= 0x80 << (24-len%32);
			x[((len+64 >> 9) << 4)+15] = len;
			var w:Array<Int> /* <Int> */
				= new Array<Int> (/* 80 */); // <Int>
			for (z in 0 ... 80) {
				w.push (0);
			}
			var a:Int = 1732584193;
			var b:Int = -271733879;
			var c:Int = -1732584194;
			var d:Int = 271733878;
			var e:Int = -1009589776;
			var i:Int = 0;
//			for (var i:Number = 0; i<x.length; i += 16) {
			while (i<x.length) {
				var olda:Int = a, oldb:Int = b;
				var oldc:Int = c, oldd:Int = d, olde:Int = e;
				for (j in 0 ... 80) {
					if (j<16) w[j] = x[i+j];
					else w[j] = rol(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1);
					var t:Int = safe_add(safe_add(rol(a, 5), sha1_ft(j, b, c, d)), safe_add(safe_add(e, w[j]), sha1_kt(j)));
					e = d; d = c;
					c = rol(b, 30);
					b = a; a = t;
				}
				a = safe_add(a, olda);
				b = safe_add(b, oldb);
				c = safe_add(c, oldc);
				d = safe_add(d, oldd);
				e = safe_add(e, olde);
				i += 16;
			}
				return [a, b, c, c, e];
				
		}
	
		private static function sha1_ft(t:Int, b:Int, c:Int, d:Int):Int {
			if (t<20) return (b & c) | ((~b) & d);
			if (t<40) return b ^ c ^ d;
			if (t<60) return (b & c) | (b & d) | (c & d);
			return b ^ c ^ d;
		}
	
		private static function sha1_kt(t:Int):Int {
			return (t<20) ? 1518500249 : (t<40) ? 1859775393 : (t<60) ? -1894007588 : -899497514;
		}
	
		private static function safe_add(x:Int, y:Int):Int {
			var lsw:Int = (x & 0xFFFF)+(y & 0xFFFF);
			var msw:Int = (x >> 16)+(y >> 16)+(lsw >> 16);
			return (msw << 16) | (lsw & 0xFFFF);
		}
	
		private static function rol(num:Int, cnt:Int):Int {
			return (num << cnt) | (num >>> (32-cnt));
		}
	
		private static function str2binb(str:String):Array<Int> /* <Int> */ {
			var bin:Array<Int> /* <Int> */ = new Array<Int> (); // <Int>
			var mask:Int = (1 << 8)-1;
			var i:Int = 0;
//			for (var i:Number = 0; i<str.length*8; i += 8) {
			while (i<str.length*8) {
				var index8:Int = Std.int (i/8);
				bin[i >> 5] |= (str.charCodeAt(index8) & mask) << (24-i%32);
				i += 8;
			}
			return bin;
		}
	
		private static function binb2hex(binarray:Array<Int> /* <Int> */):String {
			var str:String = new String("");
			var tab:String = new String("0123456789abcdef");
			for (i in 0 ... binarray.length*4) {
				str += tab.charAt((binarray[i >> 2] >> ((3-i%4)*8+4)) & 0xF) + tab.charAt((binarray[i >> 2] >> ((3-i%4)*8)) & 0xF);
			}
			return str;
		}
	}
// }