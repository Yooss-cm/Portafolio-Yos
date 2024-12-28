<?php


namespace App\Http\Controllers;

use App\Models\Permiso;
use App\Models\Profesor;
use Illuminate\Http\Request;
use Symfony\Component\HttpKernel\Event\ResponseEvent;

class PermisoController extends Controller
{
    public function modify(Request $req){
        $permiso = Permiso::find($req->id);

        $permiso->estado = $req->estado;
        $permiso->observaciones = $req->observaciones;

        $permiso->save();

        return 'Okey';
    }

    public function store(Request $req)
    {
        if($req->id != 0){
            $permiso = Permiso::find($req->id);
        }
        else{
            $profesor = Profesor::where('id_usuario',$req->id_usuario)->first();

            $permiso = new Permiso();
            $permiso->estado        = 'P';
            $permiso->id_profesor   = $profesor->id;
        }

        $permiso->fecha         = $req->fecha;
        $permiso->motivo        = $req->motivo;
        
        $permiso->save();

        return "Okey";
    }

    public function auto(){

        $permisos = Permiso::where('estado','=','P')->get();

        return view('permisos', compact('permisos'));

    }


    public function list(Request $req){
        $permisos = Permiso:: join('profesores','profesores.id','=','permisos.id_profesor')
                            ->where('profesores.id_usuario',$req->id_usuario)
                            ->select('permisos.*','profesores.nombre as nombre_profesor')
                            ->get();

        return $permisos;
    }


    public function index(Request $req){

        $permiso = Permiso::find($req->id);
        
        return $permiso;

    }
    
    public function autorizar(Request $req){
        $permiso = Permiso::find($req->id);

        $permiso->estado = $req->estado;
        $permiso->observaciones = $req->observaciones;
        
        return 'Okey';

    }

    public function delete(Request $req){
        $permiso = Permiso::find($req->id);
        $permiso->delete();
        
        return "Okey";
    }

    public function acep(Request $req){
        $permiso = Permiso::find($req->id);
        $permiso->estado = "A";
        $permiso->observaciones = $req->observaciones;

        $permiso->save();

        return view('aceptarPermiso', compact('permiso'));
    }

    public function rech(Request $req){
        $permiso = Permiso::find($req->id);
        $permiso->estado = 'R';
        $permiso->observaciones = $req->observaciones;

        $permiso->save();
        
        return view('rechazarPermiso', compact('permiso'));
    }
}
