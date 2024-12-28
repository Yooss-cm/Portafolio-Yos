@extends('adminlte::page')

@section('title', 'Agregar profesor')
<style>
    .btn-neon{
    position: relative;
    display: inline-block;
    padding: 15px 30px;
    color:white;
    background-color: black;
    letter-spacing: 4px;
    text-decoration: none;
    font-size: 10px;
    overflow: hidden;
    transition: 0.2s;
    border-radius: 10px;
    }
    .btn-neon:hover{
        background: forestgreen;
        box-shadow: 0 0 2.5px forestgreen, 0 0 10px forestgreen, 0 0 20px forestgreen;
        transition-delay: 1s;
    }
    .btn-neon span{
        position: absolute;
        display: block;
    }
    #span1{
        top: 0;
        left: -100%;
        width: 100%;
        height: 2px;
        background: linear-gradient(90deg, transparent,white);
        
    }
    .btn-neon:hover #span1{
        left: 100%;
        transition: 1s;
    }
    #span3{
        bottom: 0;
        right: -100%;
        width: 100%;
        height: 2px;
        background: linear-gradient(270deg, transparent,white);
    }
    .btn-neon:hover #span3{
        right: 100%;
        transition: 1s;
        transition-delay: 0.5s;
    }
    #span2{
        top: -100%;
        right: 0;
        width: 2px;
        height: 100%;
        background: linear-gradient(180deg,transparent,white);
    }
    .btn-neon:hover #span2{
        top: 100%;
        transition: 1s;
        transition-delay: 0.25s;
    }
    #span4{
        bottom: -100%;
        left: 0;
        width: 2px;
        height: 100%;
        background: linear-gradient(360deg,transparent,white);
    }
    .btn-neon:hover #span4{
        bottom: 100%;
        transition: 1s;
        transition-delay: 0.75s;
    }
</style>

@section('content_header')


    <link href="http://mx.geocities.com/mipagina/favicon.ico" type="image/x-icon" rel="shortcut icon" />

@stop

@section('content')

<div class="container mt-5">
    <div>
        <div>
            <div >
                <h2 class="text-center">Registrar profesor</h2>
            </div>
            <form action="{{ route('profesor.guardar')}}" method="POST">
                @csrf
                <input type="hidden" name="id" value="{{$profesor->id}}">

                    <div style="text-align: center">
                        <label for="numero" class="col-sm-3 col-form-label">Número:</label>
                        <div>
                            <input type="text" class="form-control input-animation" id="numero" name="numero" value="{{$profesor->numero == ''? old('numero') :$profesor->numero}}">
                            <!--Mostrar error-->
                            @error('numero')
                            <small style="color: red">{{$message}}</small>
                            @enderror
                        </div>
                    </div>

                    <div style="text-align: center">
                         <label class="col-sm-3 col-form-label" for="nombre">Nombre: </label>
                        <div>
                            <input type="text" class="form-control input-animation" id="nombre" name="nombre" value="{{$profesor->nombre == ''? old('nombre') :$profesor->nombre}}">
                            <!--Mostrar error-->
                            @error('nombre')
                            <small style="color: red">{{$message}}</small>
                            @enderror
                        </div>
                    </div>

                     <div style="text-align: center">
                        <label class="col-sm-5 col-form-label" for="numero">Horas asignadas: </label>
                        <div>
                            <input type="text" class="form-control input-animation" id="horas_asignadas" name="horas_asignadas" value="{{$profesor->horas_asginadas == ''? old('horas_asginadas') :$profesor->horas_asginadas}}">
                            <!--Mostrar error-->
                            @error('horas_asginadas')
                            <small style="color: red">{{$message}}</small>
                            @enderror
                        </div>
                    </div>

                    <div style="text-align: center">
                        <label class="col-sm-5 col-form-label" for="numero">Dias económicos: </label>
                        <div>
                            <input type="text" class="form-control input-animation" id="dias_economicos_correspondientes" name="dias_economicos_correspondientes" value="{{$profesor->dias_economicos_correspondientes == ''? old('dias_economicos_correspondientes') :$profesor->dias_economicos_correspondientes}}">
                            <!--Mostrar error-->
                            @error('dias_economicos_correspondientes')
                            <small style="color: red">{{$message}}</small>
                            @enderror
                        </div>
                    </div>

                    <div style="text-align: center">
                        <label class="col-sm-3 col-form-label" for="id_division">Usuario: </label>
                        <div>
                            <select name="id_usuario" class="form-control input-animation">
                            @foreach ($users as $user)
                            <option value="{{$user->id}}"{{$user->id == $profesor->id_usuario ? 'selected':''}}>{{$user->name}}</option>
                            @endforeach
                            </select>
                            <!--mostrar el error de validacion -->
                            @error('id_usuario')
                            <small style="color: red" > {{$message}}</small>
                            @enderror
                        </div>
                    </div>
            
                    <div style="text-align: center">
                        <label class="col-sm-3 col-form-label" for="id_division">División: </label>
                        <div>
                            <select name="id_division" class="form-control input-animation">
                            @foreach ($divisiones as $division)
                            <option value="{{$division->id}}"{{$division->id==$profesor->id_division ? 'selected':''}}>{{$division->nombre}}</option>
                            @endforeach
                            </select>
                            <!--mostrar el error de validacion -->
                            @error('id_division')
                            <small style="color: red" > {{$message}}</small>
                            @enderror
                        </div>
                    </div>

                    <div style="text-align: center">
                        <label class="col-sm-3 col-form-label" for="id_puesto">Puesto: </label>
                        <div>
                            <select name="id_puesto" class="form-control input-animation">
                            @foreach ($puestos as $puesto)
                            <option value="{{$puesto->id}}"{{$puesto->id==$profesor->id_puesto ? 'selected':''}}>{{$puesto->nombre}}</option>
                            @endforeach
                            </select>
                            <!--mostrar el error de validacion -->
                            @error('id_puesto')
                            <small style="color: red" > {{$message}}</small>
                            @enderror
                        </div>
                    </div>
                    <br>  
                    <div>
                    <center>
                        <button class="btn-neon" id="saberBtn" type="submit" >
                                <span id="span1"></span>
                                <span id="span2"></span>
                                <span id="span3"></span>
                                <span id="span4"></span>
                                Aceptar</button>
                        <!--<button id="saberBtn" type="submit" class="btn btn-success">Aceptar</button>-->
                    </center>
                    </div>
                 </form>
            </div>
        </div>
    </div>
</div>
@stop
