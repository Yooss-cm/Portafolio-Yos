<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class CheckRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    /*
    public function handle(Request $request, Closure $next): Response
    {
        abort(403,'No tienes permitido acceder a esta página');
        
        return $next($request);
    }
    */

    public function handle(Request $request, Closure $next): Response
    {
        // obtenemos el usuario identificado
        $user = auth()->user();

        /*if(Auth::user()->rol == "Admin"){
            return $next($request);
        }*/
        if($user->rol == "Admin")
            return $next($request);
        
        abort(403,'No tienes permitido el acceso a esta página');
    }
}
