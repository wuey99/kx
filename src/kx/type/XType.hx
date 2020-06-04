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
package kx.type;
	import kx.collections.XDict;

	
	//------------------------------------------------------------------------------------------	
	class XType {

		//------------------------------------------------------------------------------------------
		public function new () {
			// super ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setup ():Void {		
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}

		//------------------------------------------------------------------------------------------
		public static function createInstance (__class:Class<Dynamic> /* <Dynamic> */):Dynamic /* */ {
				return Type.createInstance (__class, []);
		}
		
		//------------------------------------------------------------------------------------------
		public static function createInstanceByName (__className:String):Dynamic /* */ {
			return Type.createInstance (Type.resolveClass (__className), []);
		}
		
		//------------------------------------------------------------------------------------------
		public static function createError (__message:String):String {
			return __message;
		}
		
		//------------------------------------------------------------------------------------------
		public static function min (__value1:Int, __value2:Int):Int {
			if (__value1 < __value2) {
				return __value1;
			}
			else
			{
				return __value2;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public static function max (__value1:Int, __value2:Int):Int {
			if (__value1 > __value2) {
				return __value1;
			}
			else
			{
				return __value2;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public static function clearArray (__array:Array<Dynamic> /* <Dynamic> */):Void {
			#if (cpp||php)
				__array.splice( 0, __array.length);           
			#else
				untyped __array.length = 0;
			#end
		}
		
		//------------------------------------------------------------------------------------------
		public static function initArray (__array:Array<Dynamic> /* <Dynamic> */, __length:Int, __val:Dynamic /* */):Void {
			var i:Int;
			
			for (i in 0 ... __length) {
				__array.push (__val);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public static function copyArray (__array:Array<Dynamic>):Array<Dynamic> {
			return __array.copy();
		}
		
		//------------------------------------------------------------------------------------------
		public static function getNowDate ():Date {
				return Date.now ();
		}
		
		//------------------------------------------------------------------------------------------
		public static function Number_MAX_VALUE ():Float {
				return 179 * Math.pow(10, 306);
		}
		
		//------------------------------------------------------------------------------------------
		public static function int_MAX_VALUE ():Int {
			return 2147483647;
		}
		
		//------------------------------------------------------------------------------------------
		public static function isFunction (__val:Dynamic /* */):Bool {
			return Reflect.isFunction (__val);
		}

		//------------------------------------------------------------------------------------------
		public static function isType (__val:Dynamic /* */, __type:Dynamic /* */):Bool {
			return Std.is (__val, __type);
		}
		
		//------------------------------------------------------------------------------------------
		public static function parseInt (__val:String):Int {
			return Std.parseInt (__val);
		}
		
		//------------------------------------------------------------------------------------------
		public static function parseFloat_ (__val:String):Float {
			return Std.parseFloat (__val);
		}
		
		//------------------------------------------------------------------------------------------
		public static function hasField (__map:Dynamic /* */, __key:String):Bool {
			return Reflect.hasField (__map, __key);
		}
		
		//------------------------------------------------------------------------------------------
		public static function replace (__string:String, __from:String, __to:String):String {
			return StringTools.replace (__string, __from, __to);
		}
		
		//------------------------------------------------------------------------------------------
		public static function array2XDict (__array:Array<Dynamic> /* <Dynamic> */):Map<String, Dynamic> /* <String, Dynamic> */ {
			var __dict:Map<String, Dynamic> = new Map<String, Dynamic> (); // <String, Dynamic>
			
			var i:Int = 0;
			
			while (i < __array.length) {
				__dict.set (__array[i+0], __array[i+1]);
				
				i += 2;
			}		
			
			return __dict;
		}
		
		//------------------------------------------------------------------------------------------
		public static function trim (__string:String):String {
				return StringTools.trim (__string);
		}
		
		//------------------------------------------------------------------------------------------
		public static function errorMessage (e:Dynamic):String {
			return e;
		}
		
		//------------------------------------------------------------------------------------------
		public static function forEach (__map:Map<Dynamic, Dynamic>, __callback:Dynamic):Void {
			for (__key in __map.keys ()) {
				__callback (__key);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public static function doWhile (__map:Map<Dynamic, Dynamic>, __callback:Dynamic):Void {
			for (__key in __map.keys ()) {
				if (!__callback (__key)) {
					return;
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		public static function removeAllKeys (__map:Map<Dynamic, Dynamic>):Void {
			for (__key in __map.keys ()) {
				__map.remove (__key);
			}
		}
	}
	
	//------------------------------------------------------------------------------------------
// }