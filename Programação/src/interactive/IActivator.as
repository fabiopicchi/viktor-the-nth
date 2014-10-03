package interactive
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface IActivator 
	{
		function on () : void;
		function off () : void;
		function get id () : int;
		function get activated () : Boolean;
		function addActivable (activable : IActivable) : void;
	}
	
}