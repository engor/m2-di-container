
Namespace di.demo1

#Import "<std>"
#Import "di.monkey2"

Using std..
Using di

Function Main()
	
	' we must setup types before using them
	SetupDi()
	
	' let's get data provider
	' we know nothing about its realization
	' all we need to know that it is IDataProvider with GetData() method
	Local provider:=Di.Resolve<IDataProvider>()
	
	' we can do some work with data
	Local data:=provider.GetData()
	If data And data.Length>0
		Local k:=1
		Local min:=data[0],max:=data[0]
		For Local i:=Eachin data
			Print k+": "+i ' print each value
			min=Min( min,i )
			max=Max( max,i )
			k+=1
		Next
		Print "min: "+min
		Print "max: "+max
	Endif
	
End

' setup our types here
Function SetupDi()
	
	' we can bind any realization of IDataProvider
	' and not need to change anything in business logic
	
'	Di.Bind( Lambda:IDataProvider()
'		Print "create production DataProvider"
'		Return New DataProvider
'	End )
	
	Di.Bind( Lambda:IDataProvider()
		Print "create develop DataProvider"
		Return New TestDataProvider
	End )
	
End

Interface IDataProvider
	
	Method GetData:Int[]()
	
End

Class DataProvider Implements IDataProvider
	
	Method GetData:Int[]()
		
		Local arr:=New Int[100]
		For Local i:=0 Until 100
			arr[i]=Rnd( 0,1000 )
		Next
		
		Return arr
	End
	
End

Class TestDataProvider Implements IDataProvider
	
	Method GetData:Int[]()
		
		Local arr:=New Int[20]
		For Local i:=0 Until 20
			arr[i]=Rnd( -1000,0 )
		Next
		
		Return arr
	End
	
End
