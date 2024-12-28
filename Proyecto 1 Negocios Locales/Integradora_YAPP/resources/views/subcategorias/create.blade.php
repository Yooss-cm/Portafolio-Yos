@extends('layouts.app')

@section('content')
<div class="container">
    <h1>Agregar Nueva Subcategoría</h1>
    <form action="{{ route('subcategorias.store') }}" method="POST" enctype="multipart/form-data">
        @csrf
        <div class="form-group">
            <label for="nombre_negocio">Nombre del Negocio</label>
            <input type="text" name="nombre_negocio" class="form-control" required>
        </div>
        <div class="form-group">
            <label for="descripcion">Descripción</label>
            <textarea name="descripcion" class="form-control" required></textarea>
        </div>
        <div class="form-group">
            <label for="direccion">Dirección</label>
            <input type="text" name="direccion" class="form-control" required>
        </div>
        <div class="form-group">
            <label for="telefono">Teléfono</label>
            <input type="text" name="telefono" class="form-control" required>
        </div>
        <div class="form-group">
            <label for="correo">Correo</label>
            <input type="email" name="correo" class="form-control">
        </div>
        <div class="form-group">
            <label for="instagram">Instagram</label>
            <input type="text" name="instagram" class="form-control">
        </div>
        <div class="form-group">
            <label for="whatsapp">WhatsApp</label>
            <input type="text" name="whatsapp" class="form-control">
        </div>
        <div class="form-group">
            <label for="facebook">Facebook</label>
            <input type="text" name="facebook" class="form-control">
        </div>
        <div class="form-group">
            <label for="telegram">Telegram</label>
            <input type="text" name="telegram" class="form-control">
        </div>
        <div class="form-group">
            <label for="youtube">YouTube</label>
            <input type="text" name="youtube" class="form-control">
        </div>
        <div class="form-group">
            <label for="tiktok">TikTok</label>
            <input type="text" name="tiktok" class="form-control">
        </div>
        <div class="form-group">
            <label for="id_categoria">Categoría</label>
            <select name="id_categoria" class="form-control" required>
                @foreach($categorias as $id => $categoria)
                <option value="{{ $id }}">{{ $categoria['tipo_negocio'] }}</option>
                @endforeach
            </select>
        </div>
        <div class="form-group">
            <label for="imagen">Imagen</label>
            <input type="file" name="imagen" class="form-control">
        </div>

        <!-- Nuevo campo Horario -->
        <div class="form-group">
            <label for="horario">Horario (Días de apertura)</label>
            <input type="text" name="horario" class="form-control" placeholder="Ej. Lunes a Viernes" required>
        </div>

        <!-- Campos de Hora Apertura y Hora Cierre -->
        <div class="form-group">
            <label for="hora_apertura">Hora de Apertura</label>
            <input type="time" name="hora_apertura" class="form-control" required>
        </div>

        <div class="form-group">
            <label for="hora_cierre">Hora de Cierre</label>
            <input type="time" name="hora_cierre" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-primary">Guardar</button>
    </form>
</div>
@endsection