<?php

namespace App\Http\Controllers;

use App\Models\form;
use Illuminate\Http\Request;

class FormController extends Controller
{
    public function index()
    {
        return view('form');
    }

    public function store(Request $req)
    {
        $user = form::where('username','=', $req->username)
                      ->where('password','=', $req->password)
                      ->first();

        if($user)
        {
            return view('dashboard',compact('user'));
        }else{
            return redirect()->to('login');
        }
        
        return $user;
        
        return "Usuario: ". $req->username . "Contraseña: " . $req->password;
    }
}
