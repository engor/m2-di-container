Namespace di.demo1

#Import "<std>"
#Import "di.monkey2"

Using std..
Using di

Function Main()
	
	' we must setup types before using them
	SetupDi()
	
	' get our Presenter
	' note: we know nothing about Game, Logger, Metrica!
	Local presenter:=Di.Resolve<Presenter>()
	presenter.ClickOnPlay()
	presenter.UseCheat( "monkey2-di-works")
	
End

Function SetupDi()
	
	' we can bind any realization of IMetrica and ILogger
	' and not need to change anything in business logic
	
	Di.Bind( Lambda:IMetrica()
		Return New LocalMetrica
	End )
	
	Di.Bind( Lambda:ILogger()
		Return New OutputLogger
	End )
	
	Di.Bind( Lambda:Game()
		Return New Game
	End )
	
	Di.Bind( Lambda:Presenter()
		Return New Presenter(
			' we pass instances that were already binded
			' new istance of Presenter will be created when (if) we call Di.Resolve<Presenter>()
			Di.Resolve<Game>(),
			Di.Resolve<IMetrica>(),
			Di.Resolve<ILogger>() )
	End )
	
End

Interface ILogger
	
	Method Log( msg:String )
	
End

' logger that prints to output window
Class OutputLogger Implements ILogger
	
	Method Log( msg:String )
		Print "log: "+msg
	End
	
End

Interface IMetrica
	
	Method Add( msg:String,args:String="" )
	
End

' metrica that store all data in a local file
Class LocalMetrica Implements IMetrica
	
	Method Add( msg:String,args:String="" )
		
		Local s:=LoadString( "asset::metrica.txt" )
		s += "~n"+msg+"~n"+args+"~n----------------------"
		SaveString( s,"asset::metrica.txt" )
	End
	
End

' simple game prototype
Class Game
	
	Method Play()
		Print "game. play"
	End
	
	Method Stop()
		Print "game. stop"
	End
End

' presenter manages/reacts user's actions
Class Presenter
	
	' constructor require some other types
	Method New( game:Game,metrica:IMetrica,logger:ILogger )
		
		_game=game
		_metrica=metrica
		_logger=logger
	End
	
	Method ClickOnPlay()
	
		_game.Play()
		_metrica.Add( "ClickOnPlay" )
		
	End
	
	Method ClickOnStop()
	
		_game.Stop()
		_metrica.Add( "ClickOnStop" )
	End
	
	Method UseCheat( cheatCode:String )
	
		_logger.Log( "useCheat: "+cheatCode )
	End
	
	
	Private
	
	Field _game:Game
	Field _metrica:IMetrica
	Field _logger:ILogger
	
End
