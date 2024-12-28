<?php

namespace App\Http\Controllers;

use App\Models\Puesto;
use Illuminate\Http\Request;

class PuestoController extends Controller
{
    public function index(Request $req)
    {
        if($req->id){
            $puesto = Puesto::find($req->id);
        }else{
            $puesto = new Puesto();
        }

        return view('puesto', compact('puesto'));
    }

    public function store(Request $req)
    {
        //Validar el formulario
        $validar = $req->validate([
            'codigo' => ['required', 'integer','numeric', 'min:0', 'max:100', 'unique:puesto,codigo'],
            'nombre' => ['required', 'string', 'alpha', 'min:1', 'regex:/^[^\d]+$/']
        ]);
        
        if($req->id !=0){
            $puesto = Puesto::find($req->id);
        }else{
            $puesto = new Puesto();
        }

        $puesto->codigo = $req->codigo;
        $puesto->nombre = $req->nombre;

        $puesto->save();//insert

        //return redirect()->to('/divisiones');
        return redirect()->route('puestos.lista');
    }

    public function list()
    {
        $puestos = Puesto::all();

        return view('puestos', compact('puestos'));
    }

    public function delete($id){
        $puesto = Puesto::find($id);
        $puesto->delete();
        return redirect()->route('puestos.lista');
    }
}
