<?php

use App\Http\Controllers\PermisoController;
use App\Http\Controllers\LoginController;
use Illuminate\Auth\Events\Login;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

    
    //APIS DE PERMISOS

    Route::post('permiso/guardar', [PermisoController::class, 'store']);
    Route::post('permiso/modificar', [PermisoController::class, 'modify']);
    Route::post('permiso/borrar',[PermisoController::class, 'delete']);
    Route::get('permisos', [PermisoController::class, 'list']);
    Route::get('permiso',[PermisoController::class, 'index']);


    //API PERMISO REACT

    Route::post('permiso/nuevo',[PermisoController::class, 'nuevo']);


    //API LOGIN
    Route::post('login', [LoginController::class, 'login']);
