import { useParams } from 'react-router-dom';
import React, { useEffect, useState } from 'react';
import Menu from "./Menu";
import "./../styles/permisos.css";
import { Button, Form, FloatingLabel} from 'react-bootstrap';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import '../components/style.css'
import '../components/boton_nuevo.css'
import Swal from 'sweetalert2';

const NuevoPermiso = () => {
  const [fecha, setFecha] = useState('');
  const [motivo, setMotivo] = useState('');
  const [token, setToken] = useState('');
  const [id_usuario, setIdUsuario] = useState(0);
  const navigate = useNavigate();
  const { id } = useParams();

  const handleGuardar = async () => {
    Swal.fire({
        title: "Deseas guardar los cambios?",
        icon: 'warning',
        showDenyButton: true,
        showCancelButton: true,
        confirmButtonText: "Guardar",
        denyButtonText: `No guardar`
    }).then(async (result) => {
        if (result.isConfirmed) {
            try {
                const response = await axios.post('http://127.0.0.1:8000/api/permiso/guardar', {
                    id: id | 0,
                    id_usuario: id_usuario,
                    fecha: fecha,
                    motivo: motivo
                });
                console.log(response.data);
                navigate('/home');
                Swal.fire("Guardado!", "", "success");
            } catch (error) {
                console.log("Ocurrio un error", error);
            }
        } else if (result.isDenied) {
            Swal.fire("No se guardaran los cambios", "", "info");
        }
    });
};

  const fetchData = async () => {
    try {
        const response = await axios.get('http://127.0.0.1:8000/api/permiso?id=' + id,{
        params: {
          id: id
        },
        headers: {
          Authorization: 'Bearer ' + token
        }
      });
      console.log(response.data);
      setFecha(response.data.fecha);
      setMotivo(response.data.motivo);
    } catch (error) {
      console.log("Ocurrio un error", error);
    }
  };

  useEffect(() => {
    setIdUsuario(localStorage.getItem('id_usuario'))
    setToken(localStorage.getItem('token'));
    if(id !== undefined)
    {
      fetchData();
    }

  }, []);

  return (
    <div class="container mt-5">
      <Menu />
      <div>
        <br></br>
        <h2>Nuevo Permiso</h2>
        
        <Form>
        <br></br>
          <Form.Group controlId="formFecha">
            <Form.Label>FECHA</Form.Label>
            <Form.Control
              type="date"
              value={fecha}
              onChange={(e) => setFecha(e.target.value)}
            />
          </Form.Group>
          <br></br>

          <FloatingLabel
            controlId="formMotivo"
            label="MOTIVO"
            className="mb-3"
          >
          <Form.Control type="text"
                placeholder="Ingrese el motivo"
                value={motivo}
                onChange={(e) => setMotivo(e.target.value)} />
          </FloatingLabel>
          <center>
            {/* Si no aparecen los estilos, cambiar el "Button" por "button" */}
          <Button class="btn-neonnew" onClick={handleGuardar}>
                                <span id="span1"></span>
                                <span id="span2"></span>
                                <span id="span3"></span>
                                <span id="span4"></span>
                                GUARDAR</Button> 
            </center>
          {/* <Button variant="outline-info" className="mt-3" onClick={handleGuardar}>GUARDAR</Button> */}
        </Form>
      </div>
    </div>
  );
};

export default NuevoPermiso;
