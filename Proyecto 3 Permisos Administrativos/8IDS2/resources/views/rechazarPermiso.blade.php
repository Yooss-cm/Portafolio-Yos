@extends('adminlte::page')

@section('title', 'Rechazar permiso')

@section('content_header')

    <link href="http://mx.geocities.com/mipagina/favicon.ico" type="image/x-icon" rel="shortcut icon" />
@stop

@section('content')

<div class="container mt-5">
    <div>
        <div>
        <div>
                <h2 class="text-center">Rechazar permiso</h2>
            </div>
            <form action="{{route('permisos.rechazar')}}" method="GET">
                @csrf
                <input type="hidden" name="id" value="{{$permiso->id}}">
                <div style="text-align: center">
                    <label class="col-sm-3 col-form-label" for="estado">Estado: </label>
                    <div>
                        <input type="text" class="form-control input-animation" id="observaciones" name="observaciones" value="{{$permiso->estado='R'}}" readonly required>
                    </div>
                </div>
                <br>
                <div style="text-align: center">
                    <label for="observaciones" class="col-sm-3 col-form-label">Observaciones:</label>
                    <div>
                        <input type="text" class="form-control input-animation" id="observaciones" name="observaciones" value="{{$permiso->observaciones}}" required>
                    </div>
                </div>
                <br>
                <center>
                <button id="saberBtn" type="submit" class="btn btn-success">Aceptar</button>
                </center>
            </form>
        </div>
    </div>
</div>
@stop
