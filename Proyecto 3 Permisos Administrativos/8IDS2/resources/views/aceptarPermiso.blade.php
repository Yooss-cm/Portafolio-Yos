@extends('adminlte::page')

@section('title', 'Aceptar permiso')
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
        <div>
                <h2 class="text-center">Aceptar permiso</h2>
            </div>
            <form action="{{route('permisos.aceptar')}}" method="GET">
                @csrf
                <input type="hidden" name="id" value="{{$permiso->id}}">
                <div style="text-align: center">
                    <label class="col-sm-3 col-form-label" for="estado">Estado: </label>
                    <div>
                        <input type="text" class="form-control input-animation" id="observaciones" name="observaciones" value="{{$permiso->estado='A'}}" readonly required>
                    </div>
                </div>
                <br>
                <div style="text-align: center">
                    <label for="observaciones" class="col-sm-3 col-form-label">Observaciones:</label>
                    <div>
                        <input type="text" class="form-control input-animation" id="observaciones" name="observaciones" value="{{$permiso->observaciones}}">
                    </div>
                </div>
                <br>
                <center>
                <button class="btn-neon" id="saberBtn" type="submit">
                            <span id="span1"></span>
                            <span id="span2"></span>
                            <span id="span3"></span>
                            <span id="span4"></span>
                            Aceptar</button>
                <!--<button id="saberBtn" type="submit" class="btn btn-success" >Aceptar</button>-->
                </center>
            </form>
        </div>
    </div>
</div>
@stop
