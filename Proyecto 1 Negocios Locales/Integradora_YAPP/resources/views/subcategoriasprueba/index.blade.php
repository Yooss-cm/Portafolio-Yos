@extends('layouts.app')

@section('content')
<div class="container">
    <h1 class="mb-4">Lista de Subcategorías</h1>

    @if(session('success'))
        <div class="alert alert-success">
            {{ session('success') }}
        </div>
    @endif

    <a href="{{ route('subcategoriasprueba.create') }}" class="btn btn-primary mb-3">Agregar Nueva Subcategoría</a>

    @if(isset($subcategorias) && !empty($subcategorias))
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Nombre del Negocio</th>
                    <th>Dirección</th>
                    <th>Teléfono</th>
                    <th>Correo</th>
                    <th>Categoría</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                @foreach($subcategorias as $subcategoria)
                    <tr>
                        <td>{{ $subcategoria['nombre_negocio'] }}</td>
                        <td>{{ $subcategoria['direccion'] }}</td>
                        <td>{{ $subcategoria['telefono'] }}</td>
                        <td>{{ $subcategoria['correo'] }}</td>
                        <td>{{ $subcategoria['id_categoria'] ?? 'No disponible' }}</td> <!-- Manejo de clave no definida -->
                        <td>
                            <!-- Aquí puedes agregar botones para editar o eliminar -->
                            <a href="{{ route('subcategoriasprueba.edit', $subcategoria['id']) }}" class="btn btn-warning btn-sm">Editar</a>
                            <form action="{{ route('subcategoriasprueba.destroy', $subcategoria['id']) }}" method="POST" style="display:inline-block;">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('¿Estás seguro de que quieres eliminar esta subcategoría?')">Eliminar</button>
                            </form>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
    @else
        <p>No hay subcategorías disponibles.</p>
    @endif
</div>
@endsection
