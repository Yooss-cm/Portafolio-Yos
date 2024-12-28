<?php

namespace App\Http\Controllers;

use Kreait\Firebase\Database;

class FirebaseController extends Controller
{
    protected $database;

    public function __construct(Database $database)
    {
        $this->database = $database;
    }

    // Método para leer datos
    public function getData()
    {
        // Referencia al nodo en la base de datos
        $reference = $this->database->getReference('categoria_nombre');
        // Obtener los datos
        $value = $reference->getValue();
        
        // Devolver los datos como JSON
        return response()->json($value);
    }
    

    // // Para añadir datos a Firebase, puedes crear otro método dentro del mismo controlador
    // public function setData(Request $request)
    // {
    //     // Referencia al nodo en la base de datos
    //     $reference = $this->database->getReference('nombre_del_nodo');
    //     // Guardar el dato enviado en la solicitud
    //     $reference->set($request->input('dato'));

    //     return response()->json(['success' => true]);
    // }

}
