@extends('layouts.app')

@section('content')
<div class="container">
    <h1>Subcategorías</h1>
    <a href="{{ route('subcategorias.create') }}" class="btn btn-primary">Agregar Nueva Subcategoría</a>
    <table class="table">
        <thead>
            <tr>
                <th>Nombre</th>
                <th>Descripción</th>
                <th>Dirección</th>
                <th>Imagen</th>
                <th>Teléfono</th>
                <!-- <th>Categoría</th> -->
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            @foreach($subcategorias as $id => $subcategoria)
            <tr>
                <td>{{ $subcategoria['nombre_negocio'] }}</td>
                <td>{{ $subcategoria['descripcion'] }}</td>
                <td>{{ $subcategoria['direccion'] }}</td>
                <td>
                    @if(isset($subcategoria['imagen']))
                    <img src="{{ $subcategoria['imagen'] }}" alt="{{ $subcategoria['nombre_negocio'] }}" width="100">
                    @else
                    <p>No hay imagen disponible</p>
                    @endif
                </td>
                <td>{{ $subcategoria['telefono'] }}</td>
                <td>
                    <a href="{{ route('subcategorias.edit', $id) }}" class="btn btn-warning">Editar</a>
                    <form action="{{ route('subcategorias.destroy', $id) }}" method="POST" style="display:inline;">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="btn btn-danger">Eliminar</button>
                    </form>
                </td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection