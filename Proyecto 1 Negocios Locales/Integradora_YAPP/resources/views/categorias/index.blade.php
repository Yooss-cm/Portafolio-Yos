<!-- resources/views/categorias/index.blade.php -->
@extends('layouts.app')

@section('content')
<div class="container">
    <h1>Categorías</h1>
    <table class="table">
        <thead>
            <tr>
                <th>Imagen</th>
                <th>Info</th>
                <th>Tipo de Negocio</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            @foreach($categorias as $id => $categoria)
            <tr>
                <td><img src="{{ $categoria['img_url'] }}" alt="Imagen" width="100"></td>
                <td>{{ $categoria['info'] }}</td>
                <td>{{ $categoria['tipo_negocio'] }}</td>
                <td>
                    <a href="{{ route('categorias.edit', $id) }}" class="btn btn-primary">Editar</a>
                    <form action="{{ route('categorias.destroy', $id) }}" method="POST" style="display:inline;">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="btn btn-danger">Eliminar</button>
                    </form>
                </td>
            </tr>
            @endforeach
        </tbody>
    </table>
    <a href="{{ route('categorias.create') }}" class="btn btn-success">Agregar Nueva Categoría</a>
</div>
@endsection
