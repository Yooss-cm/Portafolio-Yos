<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Auth;

class CheckRoleP
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, ...$roles)
    {
        // si no está identificado no le dejamos acceder
        if (!auth()->check())
            return redirect('login');

        // obtenemos el usuario identificado
        $user = Auth::user();

        // si el usuario es Editor le damos acceso a todo
        if ($user->role == "Editor")
            return $next($request);

        // si no es root y uno de los roles en las rutas es root no le dejamos acceder
        //if (in_array("root", $roles))
            //return redirect('dashboard');

        // si el usuario es admin le damos acceso, ya no es necesario permisos de root
        if($user->role == "Admin")
            return $next($request);

        // si no se cumple ninguna de las condiciones anteriores es que no tiene permisos
        abort(403,'No tienes permitido el acceso a esta página, pidele al administrador que te otorgue los permisos');
    }
}
