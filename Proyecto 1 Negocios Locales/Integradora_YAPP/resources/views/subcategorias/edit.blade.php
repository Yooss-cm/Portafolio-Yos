@extends('layouts.app')

@section('content')
<div class="container">
    <h1>Editar Subcategoría</h1>
    <form action="{{ route('subcategorias.update', $id) }}" method="POST" enctype="multipart/form-data">
        @csrf
        @method('PUT')
        <div class="form-group">
            <label for="nombre_negocio">Nombre del Negocio</label>
            <input type="text" id="nombre_negocio" name="nombre_negocio" class="form-control" value="{{ $subcategoria['nombre_negocio'] }}" required>
        </div>
        <div class="form-group">
            <label for="descripcion">Descripción</label>
            <textarea id="descripcion" name="descripcion" class="form-control" required>{{ $subcategoria['descripcion'] }}</textarea>
        </div>
        <div class="form-group">
            <label for="direccion">Dirección</label>
            <input type="text" id="direccion" name="direccion" class="form-control" required value="{{ $subcategoria['direccion'] }}">
        </div>
        <div class="form-group">
            <label for="telefono">Teléfono</label>
            <input type="text" id="telefono" name="telefono" class="form-control" required value="{{ $subcategoria['telefono'] }}">
        </div>

        <!-- Campos añadidos *Cambiaste el teléfono de text a number*-->
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
            <label for="id_categoria">Categoría</label>
            <select id="id_categoria" name="id_categoria" class="form-control" required>
                @foreach($categorias as $id => $categoria)
                <option value="{{ $id }}" {{ $subcategoria['id_categoria'] == $id ? 'selected' : '' }}>{{ $categoria['tipo_negocio'] }}</option>
                @endforeach
            </select>
        </div>
        <div class="form-group">
            <label for="horario">Horario (ej: Lunes a Viernes, Sábado)</label>
            <input type="text" id="horario" name="horario" class="form-control" value="{{ $subcategoria['horario'] }}" required>
        </div>

        <div class="form-group">
            <label for="hora_apertura">Hora de Apertura (Formato 12 horas, ej: 09:00 AM)</label>
            <input type="text" id="hora_apertura" name="hora_apertura" class="form-control" value="{{ date('h:i A', strtotime($subcategoria['hora_apertura'])) }}" required placeholder="hh:mm AM/PM">
        </div>
        <div class="form-group">
            <label for="hora_cierre">Hora de Cierre (Formato 12 horas, ej: 05:00 PM)</label>
            <input type="text" id="hora_cierre" name="hora_cierre" class="form-control" value="{{ date('h:i A', strtotime($subcategoria['hora_cierre'])) }}" required placeholder="hh:mm AM/PM">
        </div>


        <div class="form-group">
            <label for="imagen">Imagen</label>
            <input type="file" id="imagen" name="imagen" class="form-control">
            <img src="{{ $subcategoria['imagen'] }}" alt="{{ $subcategoria['nombre_negocio'] }}" width="100">
        </div>
        <form action="{{ route('subcategorias.update', $id) }}" method="POST" enctype="multipart/form-data">
            @csrf
            @method('POST')
            <!-- Campos del formulario -->
            <button type="submit">Actualizar</button>
        </form>

    </form>
</div>
@endsection