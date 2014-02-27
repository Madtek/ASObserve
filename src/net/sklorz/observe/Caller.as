package net.sklorz.observe 
{
	import flash.utils.Dictionary;

	/**
	 * Simple callback Manager
	 * 
	 * @author gregor@sklorz.net
	 */ 
	public class Caller
	{
		private var _observer:Dictionary = new Dictionary();
		
		/**
		 * Add a new callback Function for notifications.
		 * 
		 * Callback format:
		 * public function callback( para:Object ):void;
		 * 
		 * If the signal parameter is not given, this callback will be called on each call().
		 * 
		 * @param callback The function which should be called by the the call() method.
		 * @param signal A specific String ID for the callback shall be called.
		 * @return false if callback could not be added
		 */ 
		public function addCallback(callback:Function, signal:String = null):Boolean 
		{
			var list:Vector.<Function>;
			
			if(signal == null)
			{
				list = new Vector.<Function>();
				_observer[this] = list;
			}
			else if (_observer[signal])
			{
				list = Vector.<Function>(_observer[signal]);
			}
			else
			{
				list = new Vector.<Function>();
				_observer[signal] = list;
			}
			
			if(list.indexOf(callback) >= 0) 
			{
				trace("Caller.addCallback(" + callback, signal + ") : Callback already added for signal");
				return false;
			} 
			
			list.push(callback);
			return true;
		}
		
		/**
		 * Checks if the give callback is already registerd at this caller.
		 * If the signal parameter is not given, all signls will be checked.
		 * 
		 * @param callback The callback which is searched.
		 * @param signal Check if this specific signal is listening for the given callback.
		 * @return Whether the callback was found or not.
		 */
		public function hasCallback(callback:Function, signal:String = null) : Boolean 
		{
			var list:Vector.<Function>;
			
			if(signal != null)
			{
				list = Vector.<Function>(_observer[signal]);
				
				if(list != null)
				{
					return list.indexOf(callback) >= 0;
				}	
			}
			else
			{
				for each (var vec : Vector.<Function> in _observer)
				{
					if(vec.indexOf(callback) >= 0)
					{
						return true;
					}
				}
			}
			
			return false;
		}

		
		/**
		 * Removes a callback Function.
		 * 
		 * If no signal parameter is given, callback will be removed from each signal.
		 * 
		 * @param callback The function which shall be removed.
		 * @param signal The signal from which the given callback shall be removed.
		 * @return false if callback could not be removed.
		 */ 
		public function removeCallback(callback:Function, signal:String = null):Boolean 
		{
			var list:Vector.<Function>;
			var i:int;
			var found:Boolean = false;
			
			if(signal != null)
			{
				list = Vector.<Function>(_observer[signal]);
				
				if(!list)
				{
					trace("Caller.removeCallback(" + callback, signal + ") : No callbacks available for signal.");
					return false;
				}
				
				i = list.indexOf(callback);
				
				if(i < 0)
				{
					trace("Caller.removeCallback(" + callback, signal + ") : Callback not found for signal.");
					return false;
				}
				
				list.splice(i, 1);
			}
			else
			{
				for each (list in _observer)
				{
					i = list.indexOf(callback);
					
					if(i < 0)
					{
						continue;
					}
					
					found = true;
					list.splice(i, 1);
				}
				
				if (!found)
				{
					trace("Caller.removeCallback(" + callback + ") : Callbacks not found.");
					return false;
				}
			}
			
			return true;
		}
		
		/**
		 * Calls the specific callbacks to all callbacks
		 * 
		 * If no signal is given, each callback will be called.
		 * 
		 * @param value The Object which is supported to the called callbacks.
		 * @param signal The signal which shall be called.
		 * @return false if no callback could be called.
		 */
		public function call(value:Object, signal:String = null):Boolean
		{
			var list:Vector.<Function>;
			var found:Boolean = false;
			var j:int; 
			var n:int;
			
			if(signal != null)
			{
				if(!_observer[signal])
				{
					trace("Caller.call(" + value, signal + ") : No callbacks available for signal.");
					return false;
				}
				
				list = Vector.<Function>(_observer[signal]);
				
				if(list.length == 0)
				{
					trace("Caller.call(" + value, signal + ") : No callbacks available for signal.");
					return false;
				}
				
				list = list.concat();
				n = list.length;
				for (j = 0; j < n; j++)
				{
					list[j](value);
				}
			}
			else
			{
				for each (list in _observer)
				{
					list = list.concat();
					n = list.length;
					for (j = 0; j < n; j++)
					{
						found = true;
						list[j](value);
					}
				}
				
				if (!found)
				{
					trace("Caller.call(" + value + ") : Callbacks not found.");
					return false;
				}
			}
			
			return true;
		}
		
		/**
		 * Removes all callbacks.
		 */
		public function dispose() : void 
		{
			for each (var vec:Vector.<Function> in _observer)
			{
				vec.length = 0;
			}
			
			for (var signal:Object in _observer) 
			{
				delete _observer[signal];
			}
		}
	}
}