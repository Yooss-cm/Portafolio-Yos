<!-- resources/views/categorias/create.blade.php -->
@extends('layouts.app')

@section('content')
<div class="container">
    <h1>Agregar Nueva Categoría</h1>
    <form action="{{ route('categorias.store') }}" method="POST" enctype="multipart/form-data">
        @csrf
        <div class="form-group">
            <label for="info">Info</label>
            <input type="text" class="form-control" id="info" name="info">
        </div>
        <div class="form-group">
            <label for="tipo_negocio">Tipo de Negocio</label>
            <input type="text" class="form-control" id="tipo_negocio" name="tipo_negocio">
        </div>
        <div class="form-group">
            <label for="image">Imagen</label>
            <input type="file" class="form-control" id="image" name="image">
        </div>
        <button type="submit" class="btn btn-success">Agregar Categoría</button>
    </form>
</div>
@endsection
