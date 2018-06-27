//------------------------------------------------------------------------------------------
package kx.utils;

	import openfl.display.*;
	
	//------------------------------------------------------------------------------------------
	// returns the Domain from where this application was loaded
	//------------------------------------------------------------------------------------------
	class Domain  {
	
		//------------------------------------------------------------------------------------------
		public function new () {
		}
		
		//------------------------------------------------------------------------------------------
		public static function getDomain (__root:Sprite):String {
			var __urlString:String = __root.loaderInfo.url;
			var __urlArray:Array<String> /* <String> */ =
				__urlString.split("://");
			var __fullDomainString:String = __urlArray[1].split("/")[0];
			
			var __domainParts:Array<String> /* <String> */ = __fullDomainString.split (".");
			
			if (__domainParts.length > 2) {
				return  __domainParts[1] + "." + __domainParts[2];
			}
			else
			{
				return __fullDomainString;
			}		
		}
		
	//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------
// }