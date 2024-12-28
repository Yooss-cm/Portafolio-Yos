@if ($errors->any())
    <div class="alert alert-danger">
        <ul>
            @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif

@if (session('success'))
    <div class="alert alert-success">
        {{ session('success') }}
    </div>
@endif


@extends('layouts.app')

@section('content')

<form method="POST" action="{{ route('subcategoriasprueba.update', $subcategoria['id']) }}" enctype="multipart/form-data">
    @csrf
    @method('PUT') <!-- Método PUT para actualizar -->
    
    <div class="form-group">
        <label for="nombre_negocio">Nombre del Negocio</label>
        <input type="text" id="nombre_negocio" name="nombre_negocio" class="form-control" value="{{ $subcategoria['nombre_negocio'] }}" required>
    </div>
    <div class="form-group">
        <label for="direccion">Dirección</label>
        <input type="text" id="direccion" name="direccion" class="form-control" value="{{ $subcategoria['direccion'] }}" required>
    </div>
    <div class="form-group">
        <label for="telefono">Teléfono</label>
        <input type="text" id="telefono" name="telefono" class="form-control" value="{{ $subcategoria['telefono'] }}" required>
    </div>
    <div class="form-group">
        <label for="correo">Correo</label>
        <input type="email" id="correo" name="correo" class="form-control" value="{{ $subcategoria['correo'] }}">
    </div>
    <div class="form-group">
        <label for="instagram">Instagram</label>
        <input type="text" id="instagram" name="instagram" class="form-control" value="{{ $subcategoria['instagram'] }}">
    </div>
    <div class="form-group">
        <label for="whatsapp">WhatsApp</label>
        <input type="text" id="whatsapp" name="whatsapp" class="form-control" value="{{ $subcategoria['whatsapp'] }}">
    </div>
    <div class="form-group">
        <label for="facebook">Facebook</label>
        <input type="text" id="facebook" name="facebook" class="form-control" value="{{ $subcategoria['facebook'] }}">
    </div>
    <div class="form-group">
        <label for="telegram">Telegram</label>
        <input type="text" id="telegram" name="telegram" class="form-control" value="{{ $subcategoria['telegram'] }}">
    </div>
    <div class="form-group">
        <label for="youtube">YouTube</label>
        <input type="text" id="youtube" name="youtube" class="form-control" value="{{ $subcategoria['youtube'] }}">
    </div>
    <div class="form-group">
        <label for="tiktok">TikTok</label>
        <input type="text" id="tiktok" name="tiktok" class="form-control" value="{{ $subcategoria['tiktok'] }}">
    </div>
    <div class="form-group">
        <label for="info_adicional">Información Adicional</label>
        <textarea id="info_adicional" name="info_adicional" class="form-control">{{ $subcategoria['info_adicional'] }}</textarea>
    </div>
    <div class="form-group">
        <label for="id_categoria">Categoría</label>
        <select id="id_categoria" name="id_categoria" class="form-control" required>
            @foreach($categorias as $id => $categoria)
                <option value="{{ $id }}" {{ $subcategoria['id_categoria'] == $id ? 'selected' : '' }}>{{ $categoria['tipo_negocio'] }}</option>
            @endforeach
            <option value="nueva_categoria">Nueva Categoría</option>
        </select>
    </div>
    <div class="form-group" id="nueva_categoria_fields" style="display: none;">
        <label for="tipo_negocio">Tipo de Negocio</label>
        <input type="text" id="tipo_negocio" name="tipo_negocio" class="form-control">
        <label for="info">Información</label>
        <textarea id="info" name="info" class="form-control"></textarea>
        <!-- Campo de imagen para la nueva categoría -->
        <label for="imagen_categoria">Imagen del tipo de categoría de los negocios</label>
        <input type="file" id="imagen_categoria" name="imagen_categoria" class="form-control">
    </div>
    <div class="form-group">
        <label for="imagen">Logo del Negocio</label>
        <input type="file" id="imagen" name="imagen" class="form-control">
        @if($subcategoria['imagen'])
            <img src="{{ $subcategoria['imagen'] }}" alt="Logo del negocio" width="100">
        @endif
    </div>
    
    <!-- Botón de enviar -->
    <button type="submit" class="btn btn-primary">Guardar Cambios</button>
</form>

<script>
    document.querySelector('select[name="id_categoria"]').addEventListener('change', function() {
        var nuevaCategoriaFields = document.getElementById('nueva_categoria_fields');
        if (this.value === 'nueva_categoria') {
            nuevaCategoriaFields.style.display = 'block';
        } else {
            nuevaCategoriaFields.style.display = 'none';
        }
    });
</script>

@endsection
