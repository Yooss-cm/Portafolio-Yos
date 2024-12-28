<?php
use App\Http\Controllers\CategoriaController;
use App\Http\Controllers\SubcategoriaController;
use App\Http\Controllers\SubcategoriaPruebaController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});


//////////////////////Rutas de CATEGORIAS
Route::get('categorias', [CategoriaController::class, 'listarCategorias'])->name('categorias.index');
Route::get('categorias/create', function () {
    return view('categorias.create');
})->name('categorias.create');
Route::post('categorias', [CategoriaController::class, 'agregarNuevaCategoria'])->name('categorias.store');
Route::get('categorias/{id}/edit', [CategoriaController::class, 'editarCategoria'])->name('categorias.edit');
Route::post('categorias/{id}', [CategoriaController::class, 'editarCategoria'])->name('categorias.update');
Route::delete('categorias/{id}', [CategoriaController::class, 'eliminarCategoria'])->name('categorias.destroy');


////////////////////Rutas de SUBCATEGORIAS

Route::get('/subcategorias', [SubcategoriaController::class, 'listarSubcategorias'])->name('subcategorias.index');
Route::get('/subcategorias/create', [SubcategoriaController::class, 'agregarNuevaSubcategoria'])->name('subcategorias.create');
Route::post('/subcategorias', [SubcategoriaController::class, 'agregarNuevaSubcategoria'])->name('subcategorias.store');
Route::get('/subcategorias/{id}/edit', [SubcategoriaController::class, 'editarSubcategoria'])->name('subcategorias.edit');
Route::post('/subcategorias/{id}/update', [SubcategoriaController::class, 'editarSubcategoria'])->name('subcategorias.update');
Route::delete('/subcategorias/{id}', [SubcategoriaController::class, 'eliminarSubcategoria'])->name('subcategorias.destroy');




////////////////////Rutas de SUBCATEGORIAS ACTUALIZADAS

// Ruta para mostrar el formulario de creación de subcategorías
// Route::get('/subcategoriasprueba/create', [SubcategoriaPruebaController::class, 'create'])->name('subcategoriasprueba.create');


// Route::get('/subcategoriasprueba', [SubcategoriaPruebaController::class, 'index'])->name('subcategoriasprueba.index');
// Route::get('/subcategoriasprueba', [SubcategoriaPruebaController::class, 'index'])->name('subcategoriasprueba.index');


// // Ruta para almacenar la nueva subcategoría (POST)
// Route::post('/subcategoriasprueba', [SubcategoriaPruebaController::class, 'agregarSubcategoria'])->name('subcategoriasprueba.store');
// // Route::post('/subcategorias/store', [SubcategoriaController::class, 'agregarSubcategoria'])->name('subcategorias.store');


// // Mostrar el formulario para editar una subcategoría
// Route::get('/subcategoriasprueba/{id}/edit', [SubcategoriaPruebaController::class, 'editarSubcategoria'])->name('subcategoriasprueba.edit');

// // Actualizar la subcategoría
// Route::put('/subcategoriasprueba/{id}', [SubcategoriaPruebaController::class, 'editarSubcategoria'])->name('subcategoriasprueba.update');

// // Eliminar la subcategoría
// Route::delete('/subcategoriasprueba/{id}', [SubcategoriaPruebaController::class, 'eliminarSubcategoria'])->name('subcategoriasprueba.destroy');




