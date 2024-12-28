import React, { useState } from 'react';
import { Alert } from 'react-bootstrap';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import '../components/style.css'
import { FaRegUserCircle } from "react-icons/fa";
import { RiLockPasswordFill } from "react-icons/ri";
import { MdMarkEmailRead } from "react-icons/md";
import { Nav} from 'react-bootstrap'
import { Link } from "react-router-dom";

function Login({setIsLoggedIn}) {
    const [error, setError] = useState('');
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const navigate = useNavigate();

    const handleLogin = async (e) => {
        e.preventDefault();

        try {
            const response = await axios.post('http://127.0.0.1:8000/api/login', {
                email: username,
                password: password
            });

            if (response.data.acceso === "Ok") {
                localStorage.setItem("id_usuario", response.data.id_usuario)
                localStorage.setItem("token", response.data.token)
                setIsLoggedIn(true)
                navigate('/home');
            } else {
                setError(response.data.error);
            }
        } catch (error) {
            setError('Ocurrió un error de conexión');
        }
    };

    return (

        <div class="login template d-flex justify-content-center align-items-center vh-100 bg-secondary">
            <div className='form_container p-5 rounded bg-white'>
                <form onSubmit={handleLogin}>
                {error && <Alert variant="danger">{error}</Alert>}
                <center><FaRegUserCircle className='iconop'/></center>
                <h3 className='text-center'>I N I C I A R     S E S I Ó N</h3>
                <div className='mb-2 input-box'>
                    <label htmlFor='name'>EMAIL</label>
                    <input type='email' placeholder='Ingresa tu email' className='form-control' value={username} onChange={(e) => setUsername(e.target.value)} required/>
                    <MdMarkEmailRead className='icon'/>
                </div>

                <div className='mb-2 input-box'>
                    <label htmlFor='password'>PASSWORD</label>
                    <input type='password' placeholder='Ingresa tu contraseña' className='form-control input-box' value={password} onChange={(e) => setPassword(e.target.value)} required/>
                    <RiLockPasswordFill className='icon2'/>
                </div>
                        
                <div className='mb-2'>
                    <input type='checkbox' className='custom-control custom-checkbox' id='check'/>
                    <label htmlFor='check' className='custom-input-label ms-2'>
                        Recordarme
                    </label>
                </div>

                <div className='d-grid'>
                    {/* <button style={{ animation: 'fadeInUp'}} className='btn btn-primary' type="submit"> Iniciar sesión</button> */}
                    <button class="btn-neonlogin" type="submit">
                                <span id="span1"></span>
                                <span id="span2"></span>
                                <span id="span3"></span>
                                <span id="span4"></span>
                                Iniciar sesion</button>
                </div>

                <p className='text-right'>
                    ¿Olvidaste tu contraseña?<a href=''></a><a href=''> RECUPERAR</a>
                </p>
                <center>
                    <Nav.Link as={Link} to="/aviso"><a class="nav-link active text-primary" aria-current="page">Aviso de privacidad</a></Nav.Link>
                </center>
                </form>
            </div>
                    
        </div>
    );
}

export default Login;
