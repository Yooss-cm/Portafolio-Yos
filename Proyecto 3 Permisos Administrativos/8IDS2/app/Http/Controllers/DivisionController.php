<?php

namespace App\Http\Controllers;

use App\Models\Division;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use RealRashid\SweetAlert\Facades\Alert;

class DivisionController extends Controller
{
    public function index(Request $req)
    {
        if($req->id){
            $division = Division::find($req->id);
        }else{
            $division = new Division();
        }

        return view('division', compact('division'));
    }

    public function store(Request $req)
    {
        //Validar el formulario
        $validar = $req->validate([
            'codigo' => ['required', 'integer', 'numeric', 'min:0', 'max:100', 'unique:division,codigo'],
            'nombre' => ['required', 'string', 'alpha', 'min:1', 'regex:/^[^\d]+$/']
        ]);

        if($req->id !=0){
            $division= Division::find($req->id);
            

        }else{
            $division = new Division();
            Log::debug('Se está creando una nueva división.');
        }

        $division->codigo = $req->codigo;
        $division->nombre = $req->nombre;

        $division->save();//insert

        return redirect()->route('divisiones.lista');
    }

    public function list()
    {
        $divisiones = Division::all();

        return view('divisiones', compact('divisiones'));
    }

    public function delete($id){
        $division = Division::find($id);
        $division->delete();
 
        
        return redirect()->route('divisiones.lista');
    }
}
