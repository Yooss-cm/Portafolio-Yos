@extends('layout')

@section('title','dashboard')

@section('content')
    <h1>Bienvenido al Dashboard {{ $user->name}}</h1>
    <div class="container-fluid">
        <div class="col-sm-4 bg-primary">
            <h2>Ventas</h2>
            <h2>Enero 2023 $ 2,000</h2>
            <br>
        </div>
        <div class="col-sm-4 bg-primary">
            <h2>Compras</h2>
            <h2>Enero 2023 $ 3,000</h2>
            <br>
        </div>
        <div class="col-sm-4 bg-primary">
            <h2>Clientes</h2>
            <h2>Enero 2023 $ 5,000</h2>
            <br>
        </div>
    </div>
@endsection


