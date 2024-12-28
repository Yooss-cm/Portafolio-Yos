@extends('adminlte::page')

@section('title', 'Dashboard')
    <style>
        .contenedor{
            display: flex;
            justify-content: center;

        }
        .card{
            margin-left: 10px;
            margin-right: 10px;
            border-radius: 15px; 
        }
        .chat{
            margin-left: 10px;
            margin-right: 10px;
        }
        h1{
            text-transform: uppercase;
            letter-spacing: 6px;
        }
        h2{
            text-transform:uppercase;
            letter-spacing: 6px;
        }
        
    </style>
@section('content_header')
    <center>
        <h1 class="h1">Panel administrativo</h1>
    </center>
@stop

@section('content')
    <div class="contenedor">
        <div class="card">
            <div class="card-header">
                <center>
                <h2 class="h2">¡Bienvenido, {{ Auth::user()->name }}!</h2>   
                </center>
            </div>

            <div class="card-body">
            <font style="vertical-align: inherit;"><font style="text-align:justify">
                <p>Es un placer verte de nuevo. Como administradores, tenemos la responsabilidad de garantizar que la Universidad UTTEC tenga los permisos necesarios para operar de manera efectiva y eficiente. Para que los profesores, estudiantes y personal puedan realizar sus tareas de manera segura y eficaz. Al otorgar estos permisos, debemos tener en cuenta la privacidad y la seguridad, asegurándonos de que solo las personas adecuadas tengan acceso a la información y los recursos adecuados. Además, debemos estar dispuestos a revisar y ajustar estos permisos según sea necesario para adaptarnos a las cambiantes necesidades y circunstancias de la universidad. Al hacerlo, podemos ayudar a la Universidad UTTEC a alcanzar su máximo potencial, proporcionando una educación de calidad y creando un ambiente de aprendizaje positivo y productivo para todos.</p>
                </font></font>
            </div>
        </div>

    <div class="chat">

        <div class="card" id="chat1" style="border-radius: 15px;">
          <div
            class="card-header d-flex justify-content-between align-items-center p-3 bg-info text-white border-bottom-0"
            style="border-top-left-radius: 15px; border-top-right-radius: 15px;">
                <i class="fas fa-angle-left"></i>
                    <p class="mb-0 fw-bold">Chat UTTEC</p>
                <i class="fas fa-times"></i>
          </div>

            <div class="card-body">

                <div class="d-flex flex-row justify-content-start mb-4">
                    <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-chat/ava1-bg.webp"
                        alt="avatar 1" style="width: 45px; height: 100%;">
                    <div class="p-3 ms-3" style="border-radius: 15px; background-color: rgba(57, 192, 237,.2);">
                        <p class="small mb-0">Hola {{ Auth::user()->name }}!</p>
                    </div>
                </div>

                <div class="d-flex flex-row justify-content-end mb-4">
                    <div class="p-3 me-3 border" style="border-radius: 15px; background-color: #fbfbfb;">
                        <p class="small mb-0">Más información...</p>
                    </div>
                    <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-chat/ava2-bg.webp"
                    alt="avatar 1" style="width: 45px; height: 100%;">
                </div>

                    <div class="form-outline">
                        <textarea class="form-control" id="textAreaExample" rows="1"></textarea>
                        <label class="form-label" for="textAreaExample">Mensaje</label>
                    </div>

                </div>
            </div>
        </div>
    </div>

@stop

