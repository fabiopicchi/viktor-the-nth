package assets 
{
	/**
	 * ...84 x 45
	 * @author Fabio e Helo
	 */
	public final class Assets 
	{
		[Embed(source = '../../../Arte/alavanca.png')] public static const ALAVANCA_ASSET: Class;
		[Embed(source = '../../../Arte/fundo_montanha.png')] public static const MONTANHA: Class;
		[Embed(source = '../../../Arte/fundo_ceu1.jpg')] public static const CEU1: Class;
		[Embed(source = '../../../Arte/fundo_ceu2.jpg')] public static const CEU2: Class;
		[Embed(source = '../../../Arte/tileset.png')] public static const TILE_MAP2:Class;
		[Embed(source = '../../../Arte/viktor-spritesheet.png')] public static const VIKTOR:Class;
		[Embed(source = '../../../Arte/viktor-spritesheet_castanho.png')] public static const VIKTOR_CASTANHO:Class;
		[Embed(source = '../../../Arte/viktor-spritesheet_preto.png')] public static const VIKTOR_PRETO:Class;
		[Embed(source = '../../../Arte/viktor-spritesheet_ruivo.png')] public static const VIKTOR_RUIVO:Class;
		[Embed(source = '../../../Arte/viktor-spritesheet_velho.png')] public static const VIKTOR_VELHO:Class;
		[Embed(source = '../../../Arte/viktor-jr.png')] public static const VIKTORJR:Class;
		[Embed(source = '../../../Arte/viktor-jr-preto.png')] public static const VIKTORJR_PRETO:Class;
		[Embed(source = '../../../Arte/viktor-jr-ruivo.png')] public static const VIKTORJR_RUIVO:Class;
		[Embed(source = '../../../Arte/viktor-jr-castanho.png')] public static const VIKTORJR_CASTANHO:Class;
		[Embed(source = '../../../Arte/menu_bg.jpg')] public static const MAIN_MENU:Class;
		[Embed(source = '../../../Arte/menu.png')] public static const MENU_ITEMS:Class;
		[Embed(source = '../../../Arte/logo.png')] public static const LOGO:Class;
		[Embed(source = '../../../Arte/howtoplay.png')] public static const HOW_TO:Class;
		[Embed(source = '../../../Arte/credits.png')] public static const CREDITS:Class;
		[Embed(source = '../../../Arte/espinhos.png')] public static const SPIKES:Class;
		[Embed(source = '../../../Arte/movelver2.png')] public static const VER2:Class;
		[Embed(source = '../../../Arte/movelver3.png')] public static const VER3:Class;
		[Embed(source = '../../../Arte/movelver4.png')] public static const VER4:Class;
		[Embed(source = '../../../Arte/movelver5.png')] public static const VER5:Class;
		[Embed(source = '../../../Arte/movelhor2.png')] public static const HOR2:Class;
		[Embed(source = '../../../Arte/movelhor3.png')] public static const HOR3:Class;
		[Embed(source = '../../../Arte/movelhor4.png')] public static const HOR4:Class;
		[Embed(source = '../../../Arte/movelhor5.png')] public static const HOR5:Class;
		[Embed(source = '../../../Arte/totem.png')] public static const TOTEM:Class;
		[Embed(source = '../../../Arte/tumulo.png')] public static const TOMB:Class;
		[Embed(source = '../../../Arte/arvoretimer.png')] public static const ARVORE:Class;
		[Embed(source = '../../../Arte/hud.png')] public static const TIMER:Class;
		[Embed(source = '../../../Arte/options.png')] public static const OPTIONS:Class;
		[Embed(source = '../../../Arte/wolf-spritesheet.png')] public static const WOLF:Class;
		[Embed(source = '../../../Arte/arrow.png')] public static const ARROW:Class;
		[Embed(source = '../../../Arte/lapide.png')] public static const LAPIDE:Class;
		[Embed(source = '../../../Arte/splash.jpg')] public static const SPLASH:Class;
		[Embed(source = '../../../Arte/letterfrompa.jpg')] public static const LETTER:Class;
		[Embed(source = '../../../Arte/ending.jpg')] public static const ENDING:Class;
		[Embed(source = '../../../Arte/pausescreen.png')] public static const PAUSE:Class;
		[Embed(source = '../../../Arte/troll-spritesheet.png')] public static const TROLL:Class;
		[Embed(source = '../../../Arte/projetil-spritesheet.png')] public static const SNOW_BALL:Class;
		[Embed(source = '../../../Arte/flecha.png')] public static const DART:Class;
		[Embed(source = '../../../Arte/lanca_flecha.png')] public static const DART_LAUNCHER:Class;
		[Embed(source = '../../../Arte/botao_flecha.png')] public static const BUTTON:Class;
		[Embed(source = '../../../Arte/botaozao.png')] public static const KEY_BUTTON:Class;
		[Embed(source = '../../../Arte/checkpoint1x4.png')] public static const CHECK_VER_4:Class;
		[Embed(source = '../../../Arte/checkpoint3x1.png')] public static const CHECK_HOR_3:Class;
		[Embed(source = '../../../Arte/checkpoint5x1.png')] public static const CHECK_HOR_5:Class;
		[Embed(source = '../../../Arte/snow1.png')] public static const SNOW_FLAKE_1:Class;
		[Embed(source = '../../../Arte/snow2.png')] public static const SNOW_FLAKE_2:Class;
		[Embed(source = '../../../Arte/snow3.png')] public static const SNOW_FLAKE_3:Class;
		[Embed(source = '../../../Arte/snow4.png')] public static const SNOW_FLAKE_4:Class;
		[Embed(source = '../../../Arte/snow5.png')] public static const SNOW_FLAKE_5:Class;
		[Embed(source = '../../../Arte/snow6.png')] public static const SNOW_FLAKE_6:Class;
		[Embed(source = '../../../Arte/lente.png')] public static var LENTE:Class;
		[Embed(source = '../../../Arte/onOff.png')] public static var ON_OFF:Class;
		[Embed(source = '../../../Arte/fundo_nuvem1.png')] public static var CLOUD_1:Class;
		[Embed(source = '../../../Arte/fundo_nuvem2.png')] public static var CLOUD_2:Class;
		[Embed(source = '../../../Arte/fundo_nuvem3.png')] public static var CLOUD_3:Class;
		[Embed(source = '../../../Arte/fundo_nuvem4.png')] public static var CLOUD_4:Class;
		[Embed(source = '../../../Arte/sure.png')] public static var SURE:Class;
		
		[Embed(source = '../../../GameDesign/carta_intro.txt', mimeType = 'application/octet-stream')] public static const CARTA_INTRO:Class;
		[Embed(source = '../../../GameDesign/carta_ending.txt', mimeType = 'application/octet-stream')] public static const CARTA_ENDING:Class;
		
		public function Assets() 
		{
			
		}
		
		public static function getFlake () : Class
		{
			var i : int = Math.floor (Math.random() * 6);
			
			switch (i)
			{
				case 0:
					return SNOW_FLAKE_1;
					break;
				case 1:
					return SNOW_FLAKE_2;
					break;
				case 2:
					return SNOW_FLAKE_3;
					break;
				case 3:
					return SNOW_FLAKE_4;
					break;
				case 4:
					return SNOW_FLAKE_5;
					break;
				case 5:
					return SNOW_FLAKE_6;
					break;
			}
			
			return SNOW_FLAKE_1;
		}
		
		public static function getText (str : String) : String
		{
			switch (str)
			{
				case "intro":
					return new CARTA_INTRO ();
				case "ending":
					return new CARTA_ENDING ();
			}
			return "";
		}
	}

}