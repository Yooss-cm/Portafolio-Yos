<?php

namespace App\Http\Controllers;

use App\Models\Division;
use App\Models\Profesor;
use App\Models\Puesto;
use App\Models\User;
use Illuminate\Http\Request;

class ProfesorController extends Controller
{
    public function index(Request $req){

        $users = User::all();
        $puestos = Puesto::all();
        $divisiones = Division::all();

        if($req->id){
            $profesor = Profesor::find($req->id);
        }else{
            $profesor = new Profesor();
        }

        return view('profesor', compact('users','puestos','divisiones','profesor'));
    }

    public function store(Request $req)
    {
        //Validar el formulario
        /*
        $validar = $req->validate([
            'numero' => ['required', 'integer','numeric', 'min:1', 'unique:profesor,numero'],
            'nombre' => ['required', 'string', 'min:1', 'regex:/^[^\d]+$/'],
            'horas_asginadas' => ['required', 'integer','numeric', 'min:1', 'max:100'],
            'dias_economicos_correspondientes' => ['required', 'integer','numeric', 'min:1', 'max:10'],
            'id_usuario' => ['required'],
            'id_puesto' => ['required'],
            'id_division' => ['required']
        ]);
        */
        if($req->id !=0){
            $profesor = Profesor::find($req->id);
        }else{
            $profesor = new Profesor();
        }

        $profesor->numero = $req->numero;
        $profesor->nombre = $req->nombre;
        $profesor->horas_asignadas = $req->horas_asignadas;
        $profesor->dias_economicos_correspondientes = $req->dias_economicos_correspondientes;
        $profesor->id_usuario = $req->id_usuario;
        $profesor->id_puesto = $req->id_puesto;
        $profesor->id_division = $req->id_division;

        $profesor->save();//insert

        //return redirect()->to('/divisiones');
        return redirect()->route('profesores.lista');
    }

    public function list()
    {
        $profesores = Profesor::
                join('puesto','profesores.id_puesto','=','puesto.id')
                ->join('users','profesores.id_usuario','=','users.id')
                ->select('profesores.*','puesto.nombre as nombre_puesto', 'users.name as nombre_usuario') 
                ->get();

        return view('profesores', compact('profesores'));
    }

    public function delete($id){
        $profesor = Profesor::find($id);
        $profesor->delete();
        return redirect()->route('profesores.lista');
    }
}
