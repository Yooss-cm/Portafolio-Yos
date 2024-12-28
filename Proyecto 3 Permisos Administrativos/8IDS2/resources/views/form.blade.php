@extends('layout')

@section('title','login')
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
@section('content')

  
    <div class="container mt-5">
        <form action="{{ route('login.store')}}" method="POST">
            @csrf
            <div class="form-group">
                <label for="username">Usuario: </label>
                <input type="text" class="form-control" id="username" name="username" required>
                <br>
                <br>
                <br>
            </div>
            <div class="form-group">
                <label for="password">Contraseña: </label>
                <input type="password" class="form-control" id="password" name="password" required>
                <br>
                <br>

                <button class="btn-neon" id="saberBtn" type="submit">
                            <span id="span1"></span>
                            <span id="span2"></span>
                            <span id="span3"></span>
                            <span id="span4"></span>
                            Entrar</button>
                <!--<button id="saberBtn" type="submit" class="btn btn-primary">Entrar</button>-->
            </form>
    </div>
@endsection
